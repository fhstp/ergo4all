import 'dart:async';
import 'dart:collection';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:common/func_ext.dart';
import 'package:common/iterable_ext.dart';
import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/analysis/camera_utils.dart';
import 'package:ergo4all/analysis/recording_progress_indicator.dart';
import 'package:ergo4all/analysis/tutorial_dialog.dart';
import 'package:ergo4all/analysis/utils.dart';
import 'package:ergo4all/common/rula_session.dart';
import 'package:ergo4all/results/overview/screen.dart';
import 'package:ergo4all/scenario/common.dart';
import 'package:ergo4all/session_storage/session_storage.dart';
import 'package:ergo4all/subjects/common.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:pose/pose.dart';
import 'package:pose_detect/pose_detect.dart';
import 'package:pose_transforming/denoise.dart';
import 'package:pose_vis/pose_vis.dart';
import 'package:provider/provider.dart';
import 'package:rula/rula.dart';

/// Screen with a camera-view for analyzing live-recorded footage.
class LiveAnalysisScreen extends StatefulWidget {
  /// Creates an instance of the screen.
  const LiveAnalysisScreen({
    required this.scenario,
    required this.subject,
    super.key,
  });

  /// The route name for this screen.
  static const String routeName = 'live-analysis';

  /// Creates a [MaterialPageRoute] to navigate to this screen for analyzing
  /// a [subject] in a [scenario].
  static MaterialPageRoute<void> makeRoute(Scenario scenario, Subject subject) {
    return MaterialPageRoute(
      builder: (_) => LiveAnalysisScreen(scenario: scenario, subject: subject),
      settings: const RouteSettings(name: routeName),
    );
  }

  /// The scenario for which to make an analysis.
  final Scenario scenario;

  /// The subject who was recorded.
  final Subject subject;

  @override
  State<LiveAnalysisScreen> createState() => _LiveAnalysisScreenState();
}

@immutable
class _Frame {
  const _Frame(this.timestamp, this.pose, this.imageSize);

  final int timestamp;
  final Option<Pose> pose;
  final Size imageSize;
}

enum _AnalysisMode { none, poseOnly, full }

class _LiveAnalysisScreenState extends State<LiveAnalysisScreen>
    with SingleTickerProviderStateMixin {
  Option<CameraController> cameraController = none();
  Queue<_Frame> frameQueue = Queue();
  _AnalysisMode analysisMode = _AnalysisMode.none;
  List<TimelineEntry> timeline = List.empty(growable: true);

  List<KeyFrame> maxKeyFrames = List.empty(growable: true);

  List<KeyFrame> extractedFrames = List.empty(growable: true);

  final GlobalKey _previewContainerKey = GlobalKey();

  int _lastProcessTime = 0;

  late final AnimationController progressAnimationController =
      AnimationController(
    value: 30,
    duration: const Duration(seconds: 30),
    upperBound: 30,
    vsync: this,
  );

  /// Session store into which to store the session
  late final RulaSessionRepository sessionRepository;

  void goToResults() {
    if (!context.mounted) return;

    final session = RulaSession(
      timestamp: DateTime.now().millisecondsSinceEpoch,
      subjectId: widget.subject.id,
      scenario: widget.scenario,
      timeline: timeline.toIList(),
      keyFrames: maxKeyFrames,
    );

    sessionRepository.put(session);

    unawaited(
      Navigator.of(context).pushReplacement(
        ResultsOverviewScreen.makeRoute(
          session,
          widget.subject,
        ),
      ),
    );
  }

  void onFrame(_Frame frame) {
    if (analysisMode == _AnalysisMode.none || !mounted) return;

    final targetQueueCount = analysisMode == _AnalysisMode.full ? 5 : 1;
    while (frameQueue.length >= targetQueueCount) {
      frameQueue.removeFirst();
    }

    setState(() {
      frameQueue.add(frame);
    });

    if (analysisMode != _AnalysisMode.full) return;

    // Here we discard all frames where there is no pose
    // This would be the place where we, for example, replace missing poses
    // with interpolated or repeated poses.
    final poses = frameQueue.filterMap((it) => it.pose).toIList();

    // Check if we have enough captures to do the average
    if (poses.length < 5) return;

    final averagePose = averagePoses(poses);

    final rulaSheet = averagePose.toRulaSheet();
    final scores = scoresOf(rulaSheet);

    // take a screenshot every 250 ms
    if (frame.timestamp-_lastProcessTime >= 250) {
      _lastProcessTime = frame.timestamp;
      captureWidgetScreenshot(scores.fullScore, frame.timestamp);
    }

    timeline.add(TimelineEntry(timestamp: frame.timestamp, scores: scores));
  }

  /// take screenshot of current image stream with pose overlay, do noting if fails.
  Future<void> captureWidgetScreenshot(int score, int timestamp) async {
    try {
      final boundary = _previewContainerKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      final image = await boundary?.toImage();
      final byteData = await image?.toByteData(format: ui.ImageByteFormat.png);
      final pngBytes = byteData?.buffer.asUint8List();

      extractedFrames.add(KeyFrame(score, pngBytes!, timestamp));
    } catch (e) {
      print("Screenshot error: $e");
      return null;
    }
  }

  /// selects the peak keyframes
  void _selectMaxKeyframes() {
    List<int> topPeaks = _findTop3Peaks(extractedFrames);
    topPeaks.sort();

    List<KeyFrame> topKeyFrames =
    topPeaks.map((index) => extractedFrames[index]).toList();
    maxKeyFrames = topKeyFrames;
  }

  /// process the extractedFrames signal to select the 3 most relevant peaks.
  List<int> _findTop3Peaks(List<KeyFrame> frames) {
    if (frames.isEmpty) return [];

    // Step 1: Smooth the signal
    List<double> smoothed = [];
    for (int i = 0; i < frames.length; i++) {
      int start = (i - 2).clamp(0, frames.length - 1);
      int end = (i + 2).clamp(0, frames.length - 1);

      var window = frames.sublist(start, end + 1).map((e) => e.score);
      smoothed.add(window.reduce((a, b) => a + b) / window.length);
    }

    // Step 2: Peak finding
    List<int> peakIndices = [];
    int? peakIndex;
    double? peakValue;
    double baseline = smoothed.reduce((a, b) => a + b) / smoothed.length;

    for (int i = 0; i < smoothed.length; i++) {
      double value = smoothed[i];

      if (value > baseline) {
        if (peakValue == null || value > peakValue) {
          peakIndex = i;
          peakValue = value;
        }
      } else if (value < baseline && peakIndex != null) {
        peakIndices.add(peakIndex);
        peakIndex = null;
        peakValue = null;
      }
    }

    if (peakIndex != null) {
      peakIndices.add(peakIndex);
    }

    // Ensure at least one peak (max absolute score) if list is empty
    if (peakIndices.isEmpty) {
      int maxIndex = 0;
      int maxAbsScore = frames[0].score.abs();
      for (int i = 1; i < frames.length; i++) {
        int absScore = frames[i].score.abs();
        if (absScore > maxAbsScore) {
          maxAbsScore = absScore;
          maxIndex = i;
        }
      }
      peakIndices.add(maxIndex);
    }

    // Step 3: Sort by score (absolute) and pick top 3
    peakIndices.sort((a, b) =>
        frames[b].score.abs().compareTo(frames[a].score.abs()),
    );

    return peakIndices.take(3).toList();
  }

  void onPoseInput(PoseDetectInput input) {
    if (analysisMode == _AnalysisMode.none) return;

    // For some reason, the width and height in the image are flipped in
    // portrait mode.
    // So in order for the math in following code to be correct, we need
    // to flip it back.
    // This might be an issue if we ever allow landscape mode. Then we
    // would need to use some dynamic logic to determine the image orientation.
    final imageSize = input.metadata!.size.flipped;

    final timestamp = DateTime.now().millisecondsSinceEpoch;

    detectPose(input).then((pose) {
      final frame = _Frame(timestamp, Option.fromNullable(pose), imageSize);
      onFrame(frame);
    });
  }

  void onCameraImage(CameraValue camera, CameraImage image) {
    final input = poseDetectInputFromCamera(camera, image);
    onPoseInput(input);
  }

  Future<void> tryCompleteAnalysis() async {
    assert(
      analysisMode == _AnalysisMode.full,
      'Should only complete analysis from full analysis.',
    );

    final cameraController =
        this.cameraController.expect('Must have a camera controller.');
    assert(
      cameraController.value.isInitialized,
      'Camera controller must be initialized.',
    );

    // select keyframes
    _selectMaxKeyframes();

    await cameraController.stopImageStream();
    await cameraController.dispose();
    await stopPoseDetection();

    goToResults();

    setState(() {
      this.cameraController = none();
    });
  }

  Future<void> tryStartFullAnalysis() async {
    if (!mounted) return;

    assert(
      analysisMode == _AnalysisMode.poseOnly,
      'Should only switch to full analysis from pose-only analysis.',
    );

    setState(() {
      analysisMode = _AnalysisMode.full;
    });

    unawaited(
      progressAnimationController.reverse().then((_) {
        tryCompleteAnalysis();
      }),
    );
  }

  Future<void> tryStartPoseOnlyAnalysis() async {
    if (!mounted) return;

    assert(
      analysisMode == _AnalysisMode.none,
      'Should only switch to pose-only analysis from no analysis.',
    );

    final cameraController =
        this.cameraController.expect('Must have a camera controller.');

    setState(() {
      analysisMode = _AnalysisMode.poseOnly;
    });

    await startPoseDetection(PoseDetectMode.stream);
    await cameraController.startImageStream((image) {
      onCameraImage(cameraController.value, image);
    });
  }

  void onRecordButtonPressed() {
    switch (analysisMode) {
      case _AnalysisMode.none:
        break;
      case _AnalysisMode.poseOnly:
        unawaited(tryStartFullAnalysis());
      case _AnalysisMode.full:
        unawaited(tryCompleteAnalysis());
    }
  }

  @override
  void initState() {
    super.initState();

    sessionRepository = Provider.of(context, listen: false);

    openPoseDetectionCamera().then((controller) {
      setState(() {
        cameraController = Some(controller);
      });

      tryStartPoseOnlyAnalysis();
    });

    SchedulerBinding.instance
        .addPostFrameCallback((_) => unawaited(showTutorialDialog(context)));
  }

  @override
  void dispose() {
    progressAnimationController.dispose();
    cameraController.expect('camera should exist').dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cameraPreview = cameraController.match(
      Container.new,
      (cameraController) => CameraPreview(
        cameraController,
        child: frameQueue.lastOption
            .flatMap(
              (frame) => frame.pose.map(
                (pose) => CustomPaint(
                  willChange: true,
                  painter: Pose3dPainter(
                    pose: pose,
                    imageSize: frame.imageSize,
                    color: hippieBlue,
                  ),
                ),
              ),
            )
            .toNullable(),
      ),
    );

    final isRecording = analysisMode == _AnalysisMode.full;

    return Scaffold(
      backgroundColor: woodSmoke,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  RepaintBoundary(
                    key: _previewContainerKey,
                    child: cameraPreview,
                  ),
                  Positioned(
                    left: largeSpace,
                    right: largeSpace,
                    bottom: largeSpace,
                    child: RecordingProgressIndicator(
                      remainingTime: progressAnimationController.value,
                      criticalTime: 5,
                      initialTime: 30,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: smallSpace),
            Center(
              child: ElevatedButton(
                key: const Key('record'),
                onPressed: onRecordButtonPressed,
                style: elevatedButtonStyle.copyWith(
                  backgroundColor: WidgetStatePropertyAll(
                    isRecording ? cardinal : blueChill,
                  ),
                  foregroundColor: const WidgetStatePropertyAll(white),
                ),
                child: Text(isRecording ? 'Stop' : 'Start'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
