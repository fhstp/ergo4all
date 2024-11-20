import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:vector_math/vector_math.dart';

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

/// Describes a pose landmark in 3D space.
@immutable
class Landmark {
  /// The confidence in range [0, 1] of whether the landmark is currently in view.
  final double confidence;

  /// The position of the landmark in pseudo 3D space. Coordinates are normalized to be in a [0; 1[ range, though for landmarks which are outside the input image, they might also be out of that range.
  final Vector3 position;

  const Landmark({required this.confidence, required this.position});
}

/// The pose landmarks indexed by their type.
typedef Pose = IMap<LandmarkTypes, Landmark>;
