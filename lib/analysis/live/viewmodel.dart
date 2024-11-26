// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:io';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:ergo4all/analysis/live/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pose/pose.dart';
import 'package:rula/rula.dart';

class LiveAnalysisViewModel {
  final _random = Random();
  CameraController? _controller;
  bool _isRecording = false;

  final uiState = ValueNotifier(UIState(null, null, false, false, null));

  Future<void> _closeCamera() async {
    uiState.value = UIState(null, null, false, false, null);

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

    uiState.value = uiState.value.copyWith(currentScore: finalScore);
  }

  _onImageCaptured(CameraDescription camera, DeviceOrientation orientation,
      CameraImage cameraImage) async {
    final pose = await detectPose(camera, orientation, cameraImage);

    if (pose == null) {
      uiState.value = uiState.value.copyWith(latestCapture: null);
      return;
    }

    final capture = Capture(
      timestamp: DateTime.now().millisecondsSinceEpoch,
      pose: pose,
    );

    uiState.value = uiState.value.copyWith(latestCapture: capture);

    if (_isRecording) _processCapture(capture);
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

    uiState.value = uiState.value.copyWith(cameraController: controller);
  }

  void toggleRecording() async {
    _isRecording = !_isRecording;
    uiState.value = uiState.value.copyWith(isRecording: _isRecording);

    if (!_isRecording) {
      await _closeCamera();
      uiState.value = uiState.value.copyWith(isDone: true);
    }
  }
}
