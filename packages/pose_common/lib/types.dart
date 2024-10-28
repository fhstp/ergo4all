import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

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

  /// The normalized x coordinate of the landmark in the image.
  /// Will usually be in range [0; 1], through for landmarks which are estimated
  /// to be outside the image they might also be outside the [0; 1] range.
  final double x;

  /// The normalized y coordinate of the landmark in the image.
  /// Will usually be in range [0; 1], through for landmarks which are estimated
  /// to be outside the image they might also be outside the [0; 1] range.
  final double y;

  const Landmark2D(
      {required this.confidence, required this.x, required this.y});
}

typedef Pose2D = IMap<LandmarkTypes, Landmark2D>;
