import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:ergo4all/analysis/live/types.dart';
import 'package:ergo4all/common/value_notifier_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pose/pose.dart';
import 'package:rula/rula.dart';

const _queueSize = 5;

/// Gets the size of a [CameraImage] but rotates it so width and height match  the device orientation.
Size _getRotatedImageSize(CameraImage image) {
  // For some reason, the width and height in the image are flipped in
  // portrait mode.
  // So in order for the math in following code to be correct, we need
  // to flip it back.
  // This might be an issue if we ever allow landscape mode. Then we
  // would need to use some dynamic logic to determine the image orientation.
  return Size(image.height.toDouble(), image.width.toDouble());
}

class LiveAnalysisViewModel {
  final _random = Random();
  CameraController? _controller;
  bool _isRecording = false;
  final _captureQueue = Queue<Capture>();
  final _uiState = ValueNotifier(UIState.initial);

  ValueNotifier<UIState> get uiState => _uiState;

  Future<void> _closeCamera() async {
    _uiState.value = UIState.initial;

    await _controller?.stopImageStream();
    await _controller?.dispose();
    await stopPoseDetection();
    _controller = null;
  }

  Degree _randomAngle(double min, double max) {
    return Degree.makeFrom180(min + _random.nextDouble() * (max - min));
  }

  bool _randomBool() {
    return _random.nextDouble() > 0.5;
  }

  _processCapture(Capture capture) async {
    final (coronal, sagittal) = projectOnAnatomicalPlanes(capture.pose);
    final angles = calculateAngles(capture.pose, coronal, sagittal);

    _uiState.update((it) => it.copyWith(angles: angles));

    // TODO: Calculate real rula sheet
    final sheet = RulaSheet(
        shoulderFlexion: _randomAngle(-180, 180),
        shoulderAbduction: _randomAngle(0, 180),
        elbowFlexion: _randomAngle(0, 180),
        wristFlexion: _randomAngle(-180, 180),
        neckFlexion: _randomAngle(-90, 90),
        neckRotation: _randomAngle(-180, 180),
        neckLateralFlexion: _randomAngle(-90, 90),
        hipFlexion: _randomAngle(0, 180),
        trunkRotation: _randomAngle(-180, 180),
        trunkLateralFlexion: _randomAngle(-90, 90),
        isStandingOnBothLegs: _randomBool());
    final finalScore = calcFullRulaScore(sheet);

    _uiState.update((it) => it.copyWith(currentScore: Some(finalScore)));
  }

  _enqueueCapture(Capture capture) {
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
        imageSize: capture.imageSize);

    if (_isRecording) _processCapture(averageCapture);
  }

  _onImageCaptured(CameraDescription camera, DeviceOrientation orientation,
      CameraImage cameraImage) async {
    final pose = await detectPose(camera, orientation, cameraImage);

    if (pose == null) {
      _uiState.update((it) => it.copyWith(latestCapture: None()));
      return;
    }

    final capture = Capture(
        timestamp: DateTime.now().millisecondsSinceEpoch,
        pose: pose,
        imageSize: _getRotatedImageSize(cameraImage));
    _uiState.update((it) => it.copyWith(latestCapture: Some(capture)));

    _enqueueCapture(capture);
  }

  void initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras
        .firstWhere((it) => it.lensDirection == CameraLensDirection.back);

    final controller = CameraController(frontCamera, ResolutionPreset.low,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21 // for Android
            : ImageFormatGroup.bgra8888, // for iOS
        fps: 15);

    _controller = controller;

    await controller.initialize();
    await controller.startImageStream((image) => _onImageCaptured(
        frontCamera, controller.value.deviceOrientation, image));
    await startPoseDetection();

    _uiState.update((it) => it.copyWith(cameraController: Some(controller)));
  }

  void toggleRecording() async {
    _isRecording = !_isRecording;
    _uiState.update((it) => it.copyWith(isRecording: _isRecording));

    if (!_isRecording) {
      await _closeCamera();
      _uiState.update((it) => it.copyWith(isDone: true));
    }
  }
}
