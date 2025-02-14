import 'dart:math';

import 'package:common/immutable_collection_ext.dart';
import 'package:common/math_utils.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:pose/pose.dart';
import 'package:pose_analysis/pose_analysis.dart';
import 'package:vector_math/vector_math_64.dart';

typedef Pose2d = IMap<KeyPoints, Vector2>;

Pose2d make2dCoronalPose(NormalizedPose pose, {double minVisibility = 0.9}) {
  final positions = pose.values.map(posOf).toList();

  final minX = positions.map((it) => it.x).reduce(min);
  final maxX = positions.map((it) => it.x).reduce(max);
  final minY = positions.map((it) => it.y).reduce(min);
  final maxY = positions.map((it) => it.y).reduce(max);

  return pose
      .where((_, landmark) => visibilityOf(landmark) >= minVisibility)
      .mapValues((landmark) => posOf(landmark))
      .mapValues((pos) =>
          Vector2(invLerp(minX, maxX, pos.x), invLerp(minY, maxY, pos.y)));
}

Pose2d make2dSagittalPose(NormalizedPose pose, {double minVisibility = 0.9}) {
  final positions = pose.values.map(posOf).toList();

  final minZ = positions.map((it) => it.z).reduce(min);
  final maxZ = positions.map((it) => it.z).reduce(max);
  final minY = positions.map((it) => it.y).reduce(min);
  final maxY = positions.map((it) => it.y).reduce(max);

  return pose
      .where((_, landmark) => visibilityOf(landmark) >= minVisibility)
      .mapValues((landmark) => posOf(landmark))
      .mapValues((pos) =>
          Vector2(invLerp(minZ, maxZ, pos.z), invLerp(minY, maxY, pos.y)));
}

Pose2d make2dTransversePose(NormalizedPose pose, {double minVisibility = 0.9}) {
  final positions = pose.values.map(posOf).toList();

  final minZ = positions.map((it) => it.z).reduce(min);
  final maxZ = positions.map((it) => it.z).reduce(max);
  final minX = positions.map((it) => it.x).reduce(min);
  final maxX = positions.map((it) => it.x).reduce(max);

  return pose
      .where((_, landmark) => visibilityOf(landmark) >= minVisibility)
      .mapValues((landmark) => posOf(landmark))
      .mapValues((pos) =>
          Vector2(invLerp(minX, maxX, pos.x), invLerp(minZ, maxZ, pos.z)));
}
