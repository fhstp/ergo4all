import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pose/pose.dart';

@immutable
class Capture {
  const Capture({
    required this.timestamp,
    required this.pose,
    required this.imageSize,
  });

  final int timestamp;
  final Pose pose;
  final Size imageSize;
}

@immutable
class UIState {
  const UIState(
    this.cameraController,
    this.latestCapture, {
    required this.isDone,
    required this.isRecording,
  });

  final Option<CameraController> cameraController;
  final Option<Capture> latestCapture;
  final bool isRecording;
  final bool isDone;

  UIState copyWith({
    Option<CameraController>? cameraController,
    Option<Capture>? latestCapture,
    bool? isRecording,
    bool? isDone,
  }) {
    return UIState(
      cameraController ?? this.cameraController,
      latestCapture ?? this.latestCapture,
      isRecording: isRecording ?? this.isRecording,
      isDone: isDone ?? this.isDone,
    );
  }

  static const UIState initial =
      UIState(None(), None(), isRecording: false, isDone: false);
}
