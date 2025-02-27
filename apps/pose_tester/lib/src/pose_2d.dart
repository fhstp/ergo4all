import 'package:common/immutable_collection_ext.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:pose/pose.dart';
import 'package:pose_analysis/pose_analysis.dart';
import 'package:vector_math/vector_math.dart';

typedef Pose2d = IMap<KeyPoints, Vector2>;

Pose2d _make2dPose(
        NormalizedPose pose, Vector2 Function(Vector3 pos3d) makePoint2d,
        {required double minVisibility}) =>
    pose
        .where((_, landmark) => visibilityOf(landmark) >= minVisibility)
        .mapValues((landmark) => posOf(landmark))
        .mapValues(makePoint2d);

Pose2d make2dCoronalPose(NormalizedPose pose, {double minVisibility = 0.9}) =>
    _make2dPose(pose, (pos3d) => Vector2(pos3d.x, pos3d.y),
        minVisibility: minVisibility);

Pose2d make2dSagittalPose(NormalizedPose pose, {double minVisibility = 0.9}) =>
    _make2dPose(pose, (pos3d) => Vector2(pos3d.z, pos3d.y),
        minVisibility: minVisibility);

Pose2d make2dTransversePose(NormalizedPose pose,
        {double minVisibility = 0.9}) =>
    _make2dPose(pose, (pos3d) => Vector2(pos3d.x, pos3d.z),
        minVisibility: minVisibility);
