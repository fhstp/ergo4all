import 'package:common/immutable_collection_ext.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
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

/// Tuple containing data for a landmark. First element is the landmarks position in world-space. Second element is the elements visibility/confidence.
typedef Landmark = (Vector3, double);

/// Extract the world-space position from a [Landmark].
Vector3 posOf(Landmark landmark) => Vector3.copy(landmark.$1);

/// Extract the visibility from a [Landmark].
double visibilityOf(Landmark landmark) => landmark.$2;

/// A pose in 3d world-space. This is a map of [KeyPoints] with their
/// associated [Landmark]s.
typedef Pose = IMap<KeyPoints, Landmark>;

/// Maps the positions in a [Pose] by applying [map] to each.
Pose mapPosePositions(Pose pose, Vector3 Function(Vector3) map) {
  return pose.mapValues(
    (_, landmark) => (map(posOf(landmark)), visibilityOf(landmark)),
  );
}
