import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:pose/pose.dart';
import 'package:rula/rula.dart';

@immutable
class Capture {
  final int timestamp;
  final Pose pose;
  final Size imageSize;

  const Capture(
      {required this.timestamp, required this.pose, required this.imageSize});
}

@immutable
class UIState {
  final CameraController? cameraController;
  final Capture? latestCapture;
  final bool isRecording;
  final bool isDone;
  final RulaScore? currentScore;

  const UIState(this.cameraController, this.latestCapture, this.isRecording,
      this.isDone, this.currentScore);

  UIState copyWith({
    CameraController? cameraController,
    Capture? latestCapture,
    bool? isRecording,
    bool? isDone,
    RulaScore? currentScore,
  }) {
    return UIState(
      cameraController ?? this.cameraController,
      latestCapture ?? this.latestCapture,
      isRecording ?? this.isRecording,
      isDone ?? this.isDone,
      currentScore ?? this.currentScore,
    );
  }
}
