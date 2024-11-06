import 'package:camera/camera.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// The types of landmarks that are relevant for ergonomic pose analysis.
enum LandmarkTypes {
  leftHand,
  leftElbow,
  leftShoulder,
  leftHip,
  leftKnee,
  leftFoot,
  rightHand,
  rightElbow,
  rightShoulder,
  rightHip,
  rightKnee,
  rightFoot
}

/// Describes a pose landmark in 2D image space.
@immutable
class Landmark2D {
  /// The confidence of this landmark. Will be in range [0; 1].
  final double confidence;

  /// The normalized x coordinate of the landmark in the image. Will usually be in range [0; 1], through for landmarks which are estimated to be outside the image they might also be outside the [0; 1] range.
  final double x;

  /// The normalized y coordinate of the landmark in the image. Will usually be in range [0; 1], through for landmarks which are estimated to be outside the image they might also be outside the [0; 1] range.
  final double y;

  const Landmark2D(
      {required this.confidence, required this.x, required this.y});
}

typedef Pose2D = IMap<LandmarkTypes, Landmark2D>;

/// Class which contains output data for the [PoseDetector.detect] method. Specifically this contains pose data.
@immutable
class DetectResult {
  /// 2D Pose data.
  final Pose2D pose2d;

  const DetectResult({required this.pose2d});
}

/// Represents a connection to a native pose detection service.
abstract class PoseDetector {
  /// Whether the detector is ready to detect poses. Check this before calling [detect].
  Future<bool> isReady();

  /// Makes this detector ready for use. Call this before using [detect].
  Future<Null> start();

  /// Detects the pose in an input image. Might return `null` if no pose could be detected. Only call this when the detector [isReady]. The inputs are the [camera] which took the image, the [deviceOrientation] when the image was taken and the [image] itself.
  Future<DetectResult?> detect(CameraDescription camera,
      DeviceOrientation deviceOrientation, CameraImage image);

  /// Stops the detector to free up resources.
  Future<Null> stop();
}
