import 'package:camera/camera.dart';
import 'package:ergo4all/pose.common/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Class which contains input data for the [PoseDetector.detect] method.
/// Specifically this contains image data for the image that should be
/// analyzed.
@immutable
class DetectInput {
  /// The camera which took the image.
  final CameraDescription camera;

  /// The orientation of the device when the image was taken.
  final DeviceOrientation deviceOrientation;

  /// The image.
  final CameraImage image;

  const DetectInput(
      {required this.camera,
      required this.deviceOrientation,
      required this.image});
}

/// Class which contains output data for the [PoseDetector.detect] method.
/// Specifically this contains pose data.
@immutable
class DetectResult {
  /// 2D Pose data.
  final Pose2D pose2d;

  const DetectResult({required this.pose2d});
}

/// Represents a connection to a native pose detection service.
abstract class PoseDetector {
  /// Whether the detector is ready to detect poses.
  /// Check this before calling [detect].
  Future<bool> isReady();

  /// Makes this detector ready for use. Call this before using [detect].
  Future<Null> start();

  /// Detects the pose in an input image. Might return `null` if no pose
  /// could be detected. Only call this when the detector [isReady].
  Future<DetectResult?> detect(DetectInput input);

  /// Stops the detector to free up resources.
  Future<Null> stop();
}
