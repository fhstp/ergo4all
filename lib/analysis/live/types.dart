// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pose/pose.dart';

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
  final Option<CameraController> cameraController;
  final Option<Capture> latestCapture;
  final bool isRecording;
  final bool isDone;

  const UIState(
    this.cameraController,
    this.latestCapture,
    this.isRecording,
    this.isDone,
  );

  UIState copyWith({
    Option<CameraController>? cameraController,
    Option<Capture>? latestCapture,
    bool? isRecording,
    bool? isDone,
  }) {
    return UIState(
      cameraController ?? this.cameraController,
      latestCapture ?? this.latestCapture,
      isRecording ?? this.isRecording,
      isDone ?? this.isDone,
    );
  }

  static const UIState initial = UIState(None(), None(), false, false);
}
