import 'package:common/immutable_collection_ext.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:pose/pose.dart';
import 'package:pose_analysis/pose_analysis.dart';
import 'package:vector_math/vector_math.dart';

/// A 2d pose represented as a mapping from [KeyPoints] to [Vector2].
typedef Pose2d = IMap<KeyPoints, Vector2>;

Pose2d _make2dPose(
  NormalizedPose pose,
  Vector2 Function(Vector3 pos3d) makePoint2d, {
  required double minVisibility,
}) =>
    pose
        .where((_, landmark) => visibilityOf(landmark) >= minVisibility)
        .mapValues(posOf)
        .mapValues(makePoint2d);

/// Projects the given pose onto the coronal plane in order to make it 2d.
/// Landmarks with visibility < [minVisibility] will be discarded.
Pose2d make2dCoronalPose(NormalizedPose pose, {double minVisibility = 0.9}) =>
    _make2dPose(
      pose,
      (pos3d) => Vector2(pos3d.x, pos3d.y),
      minVisibility: minVisibility,
    );

/// Projects the given pose onto the sagittal plane in order to make it 2d.
/// Landmarks with visibility < [minVisibility] will be discarded.
Pose2d make2dSagittalPose(NormalizedPose pose, {double minVisibility = 0.9}) =>
    _make2dPose(
      pose,
      (pos3d) => Vector2(pos3d.z, pos3d.y),
      minVisibility: minVisibility,
    );

/// Projects the given pose onto the transverse plane in order to make it 2d.
/// Landmarks with visibility < [minVisibility] will be discarded.
Pose2d make2dTransversePose(
  NormalizedPose pose, {
  double minVisibility = 0.9,
}) =>
    _make2dPose(
      pose,
      (pos3d) => Vector2(pos3d.x, pos3d.z),
      minVisibility: minVisibility,
    );
