import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:meta/meta.dart';
import 'package:vector_math/vector_math.dart';

/// The key-points which are relevant for RULA pose analysis.
enum KeyPoints {
  /// The joint where the left shoulder meets the arm.
  leftShoulder,

  /// The mid-point between [leftShoulder] and [rightShoulder].
  midNeck,

  /// The joint where the right shoulder meets the arm.
  rightShoulder,

  /// The left elbow joint.
  leftElbow,

  /// The right elbow joint.
  rightElbow,

  /// The left wrist joint
  leftWrist,

  /// The right wrist joint
  rightWrist,

  /// Point roughly in the palm of the left hand.
  leftPalm,

  /// Point roughly in the palm of the right hand.
  rightPalm,

  /// Joint where the left leg meets the hip.
  leftHip,

  /// Mid-point between [leftHip] and [rightHip].
  midPelvis,

  /// Joint where the right leg meets the hip.
  rightHip,

  /// The left knee joint.
  leftKnee,

  /// The right knee joint.
  rightKnee,

  /// The left ankle joint.
  leftAnkle,

  /// The right ankle joint.
  rightAnkle,

  /// The left ear.
  leftEar,

  /// Mid-point between [leftEar] and [rightEar].
  midHead,

  /// The right ear.
  rightEar,

  /// The tip of the nose.
  nose
}

/// A detected feature or point in a pose.
///
/// This concept is called 'landmark' here to mirror the
/// [Google MLKit](https://developers.google.com/ml-kit/vision/pose-detection)
/// vocabulary.
@immutable
class Landmark {
  /// Creates a landmark.
  const Landmark(this.position, this.confidence);

  /// The position of the landmark in world-space.
  final Vector3 position;

  /// Confidence in the accuracy of this landmark.
  final double confidence;
}

/// A pose in 3d world-space which can be evaluated using RULA.
@immutable
class Pose {
  /// Create a pose from the given key points.
  ///
  /// The given map must contain an entry for every [KeyPoints]. Throws
  /// an [AssertionError] if this is not the case.
  Pose(this.landmarks)
      : assert(
          KeyPoints.values.every(landmarks.containsKey),
          'Pose must contain all key points!',
        );

  /// The poses landmarks keyed by their [KeyPoints] identifier.
  ///
  /// The map is guaranteed to contain all [KeyPoints.values].
  /// If you want to access landmarks by key-points, consider using
  /// the indexer operator on [Pose] itself.
  final IMap<KeyPoints, Landmark> landmarks;

  /// Get the landmark for a specific [KeyPoints].
  Landmark operator [](KeyPoints point) => landmarks[point]!;
}
