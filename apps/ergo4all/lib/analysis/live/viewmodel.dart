import 'dart:collection';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:ergo4all/analysis/live/screen.dart';
import 'package:ergo4all/analysis/live/types.dart';
import 'package:ergo4all/results/results_screen.dart';
import 'package:ergo4all/common/value_notifier_ext.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pose_analysis/pose_analysis.dart';
import 'package:pose_detect/pose_detect.dart';
import 'package:pose_transforming/denoise.dart';
import 'package:pose_transforming/normalization.dart';
import 'package:pose_transforming/pose_2d.dart';

const _queueSize = 5;

/// Gets the size of a [CameraImage] but rotates it so width and height match
/// the device orientation.
Size _getRotatedImageSize(CameraImage image) {
  // For some reason, the width and height in the image are flipped in
  // portrait mode.
  // So in order for the math in following code to be correct, we need
  // to flip it back.
  // This might be an issue if we ever allow landscape mode. Then we
  // would need to use some dynamic logic to determine the image orientation.
  return Size(image.height.toDouble(), image.width.toDouble());
}

/// View-model for the [LiveAnalysisScreen].
class LiveAnalysisViewModel {
  CameraController? _controller;
  bool _isRecording = false;
  final _captureQueue = Queue<Capture>();
  final _uiState = ValueNotifier(UIState.initial);
  DateTime? _startTime;
  final List<TimelineEntry> _timeline = List.empty(growable: true);

  /// Observable reference to the current [UIState].
  ValueNotifier<UIState> get uiState => _uiState;

  /// The current score timeline.
  RulaTimeline get timeline => _timeline.toIList();

  Future<void> _closeCamera() async {
    _uiState.value = UIState.initial;

    await _controller?.stopImageStream();
    await _controller?.dispose();
    await stopPoseDetection();
    _controller = null;
  }

  void _processCapture(Capture capture) {
    final normalized = normalizePose(capture.pose);
    final sagittal = make2dSagittalPose(normalized);
    final coronal = make2dCoronalPose(normalized);
    final transverse = make2dTransversePose(normalized);
    final angles = calculateAngles(capture.pose, coronal, sagittal, transverse);

    final sheet = rulaSheetFromAngles(angles);
    final now = DateTime.now().millisecondsSinceEpoch;
    final timestamp = now - _startTime!.microsecondsSinceEpoch;
    _timeline.add(TimelineEntry(timestamp: timestamp, sheet: sheet));
  }

  void _enqueueCapture(Capture capture) {
    _captureQueue.add(capture);

    // Discard "old" captures
    while (_captureQueue.length > _queueSize) {
      _captureQueue.removeFirst();
    }

    // Check if we have enough captures to do the average
    if (_captureQueue.length != _queueSize) return;

    final averagePose = averagePoses(_captureQueue.map((it) => it.pose));
    final averageCapture = Capture(
      timestamp: capture.timestamp,
      pose: averagePose,
      imageSize: capture.imageSize,
    );

    if (_isRecording) _processCapture(averageCapture);
  }

  Future<void> _onImageCaptured(
    CameraDescription camera,
    DeviceOrientation orientation,
    CameraImage cameraImage,
  ) async {
    final input = poseDetectInputFromCamera(camera, orientation, cameraImage);
    final pose = await detectPose(input);

    if (pose == null) {
      _uiState.update((it) => it.copyWith(latestCapture: const None()));
      return;
    }

    final capture = Capture(
      timestamp: DateTime.now().millisecondsSinceEpoch,
      pose: pose,
      imageSize: _getRotatedImageSize(cameraImage),
    );
    _uiState.update((it) => it.copyWith(latestCapture: Some(capture)));

    _enqueueCapture(capture);
  }

  /// Configures and initializes the camera.
  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras
        .firstWhere((it) => it.lensDirection == CameraLensDirection.back);

    final controller = CameraController(
      frontCamera, ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21 // for Android
          : ImageFormatGroup.bgra8888, // for iOS
      fps: 15,
    );

    _controller = controller;

    await controller.initialize();
    await controller.startImageStream(
      (image) => _onImageCaptured(
        frontCamera,
        controller.value.deviceOrientation,
        image,
      ),
    );
    await startPoseDetection(PoseDetectMode.stream);

    _uiState.update((it) => it.copyWith(cameraController: Some(controller)));
    _startTime = DateTime.now();
    _timeline.clear();
  }

  /// Start recording
  void startRecording() {
    _isRecording = true;
    _uiState.update((it) => it.copyWith(isRecording: _isRecording));
  }

  ///  Stop recording
  Future<void> stopRecording() async {
    _isRecording = false;
    _uiState.update((it) => it.copyWith(isRecording: _isRecording));

    await _closeCamera();
    _startTime = null;
    _uiState.update((it) => it.copyWith(isDone: true));
  }
}
