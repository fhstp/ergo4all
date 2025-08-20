import 'dart:async';
import 'dart:collection';

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
    timeline.add(TimelineEntry(timestamp: frame.timestamp, scores: scores));
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
            Expanded(child: Container()),
            Stack(
              children: [
                cameraPreview,
                Positioned(
                  bottom: largeSpace,
                  left: largeSpace,
                  right: largeSpace,
                  child: RecordingProgressIndicator(
                    remainingTime: progressAnimationController.value,
                    criticalTime: 5,
                    initialTime: 30,
                  ),
                ),
              ],
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
            const SizedBox(height: mediumSpace),
          ],
        ),
      ),
    );
  }
}
