import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:vector_math/vector_math.dart';

/// The key-points which are relevant for RULA pose analysis.
enum KeyPoints {
  leftShoulder,
  midNeck,
  rightShoulder,
  leftElbow,
  rightElbow,
  leftWrist,
  rightWrist,
  leftPalm,
  rightPalm,
  leftHip,
  midPelvis,
  rightHip,
  leftKnee,
  rightKnee,
  leftAnkle,
  rightAnkle,
  leftEar,
  midHead,
  rightEar
}

/// Tuple containing data for a landmark. First element is the landmarks position in world-space. Second element is the elements visibility/confidence.
typedef Landmark = (Vector3, double);

/// Extract the world-space position from a [Landmark].
Vector3 worldPosOf(Landmark landmark) => landmark.$1;

/// Extract the visibility from a [Landmark].
double visibilityOf(Landmark landmark) => landmark.$2;

/// A pose in 3d world-space. This is a map of [KeyPoints] with their associated [Landmark]s.
typedef Pose = IMap<KeyPoints, Landmark>;
