import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:common/func_ext.dart';
import 'package:common/iterable_ext.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:ergo4all/analysis/live/camera_utils.dart';
import 'package:ergo4all/analysis/live/record_button.dart';
import 'package:ergo4all/analysis/live/recording_progress_indicator.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/results/common.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:path/path.dart' as p;
import 'package:pose/pose.dart';
import 'package:pose_analysis/pose_analysis.dart';
import 'package:pose_detect/pose_detect.dart';
import 'package:pose_transforming/denoise.dart';
import 'package:pose_transforming/normalization.dart';
import 'package:pose_transforming/pose_2d.dart';
import 'package:pose_vis/pose_vis.dart';
import 'package:rula/rula.dart';

/// Screen with a camera-view for analyzing live-recorded footage.
class LiveAnalysisScreen extends StatefulWidget {
  /// Creates an instance of the screen.
  const LiveAnalysisScreen({super.key});

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

// TODO: Move to own package for video storage
Future<void> _saveRecording(XFile tempFile) async {
  final recordingsDir = Directory(
    '/storage/emulated/0/Android/media/at.ac.fhstp.ergo4all/Ergo4All Recordings',
  );
  await recordingsDir.create(recursive: true);

  final recordingPath = p.join(recordingsDir.path, tempFile.name);
  await tempFile.saveTo(recordingPath);
}

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

  void goToResults() {
    if (!context.mounted) return;
    unawaited(
      Navigator.of(context).pushReplacementNamed(
        Routes.resultsOverview.path,
        arguments: timeline.toIList(),
      ),
    );
  }

  void _analyzePose(int timestamp, Pose pose) {
    final normalized = normalizePose(pose);
    final sagittal = make2dSagittalPose(normalized);
    final coronal = make2dCoronalPose(normalized);
    final transverse = make2dTransversePose(normalized);
    final angles = calculateAngles(pose, coronal, sagittal, transverse);

    final sheet = rulaSheetFromAngles(angles);
    timeline.add(TimelineEntry(timestamp: timestamp, scores: scoresOf(sheet)));
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
    _analyzePose(frame.timestamp, averagePose);
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

    final outputFile = await cameraController.stopVideoRecording();
    await _saveRecording(outputFile);

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

    final cameraController =
        this.cameraController.expect('Must have a camera controller.');

    setState(() {
      analysisMode = _AnalysisMode.full;
    });

    await cameraController.stopImageStream();
    await cameraController.startVideoRecording(
      onAvailable: (image) {
        onCameraImage(cameraController.value, image);
      },
    );

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

    openPoseDetectionCamera().then((controller) {
      setState(() {
        cameraController = Some(controller);
      });

      tryStartPoseOnlyAnalysis();
    });
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
                  ),
                ),
              ),
            )
            .toNullable(),
      ),
    );

    return Scaffold(
      body: SizedBox.expand(
        child: Column(
          children: [
            cameraPreview,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: largeSpace),
              child: RecordingProgressIndicator(
                remainingTime: progressAnimationController.value,
                criticalTime: 5,
                initialTime: 30,
              ),
            ),
            const SizedBox(
              height: mediumSpace,
            ),
            RecordButton(
              key: const Key('record'),
              isRecording: analysisMode == _AnalysisMode.full,
              onTap: onRecordButtonPressed,
            ),
          ],
        ),
      ),
    );
  }
}
