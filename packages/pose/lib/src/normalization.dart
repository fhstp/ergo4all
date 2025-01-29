import 'dart:math';

import 'package:common/immutable_collection_ext.dart';
import 'package:pose/pose.dart';
import 'package:vector_math/vector_math.dart';

/// A [Pose] which was normalized using the [normalizePose] function. It
/// is has it's mid-hip point at the origin, it's hip line is aligned with the x-axis and it is scaled such that the hip line is one unit long.
extension type NormalizedPose(Pose it) implements Pose {}

/// Gets the offset from the origin to the[pose]s mid-hip point.
Vector3 _midHipOffset(Pose pose) {
  return posOf(pose[KeyPoints.midPelvis]!);
}

Pose _mapPosePositions(Pose pose, Vector3 Function(Vector3) map) {
  return pose
      .mapValues((landmark) => (map(posOf(landmark)), visibilityOf(landmark)));
}

/// Translates a [pose] by a given [translation] vector.
Pose _translatePose(Pose pose, Vector3 translation) {
  return _mapPosePositions(pose, (pos) => pos - translation);
}

/// Rotates the points in a [pose] using the given [rotation] matrix.
Pose _rotatePose(Pose pose, Matrix3 rotation) {
  return _mapPosePositions(pose, (pos) => rotation.transform(pos));
}

Matrix3 _yRotationMatrixFor(Vector3 leftHip, Vector3 rightHip) {
  final angle = 0 - atan2(leftHip.z - rightHip.z, leftHip.x - rightHip.x);
  final c = cos(angle);
  final s = sin(angle);
  return Matrix3(
    c,
    0,
    s,
    0,
    1,
    0,
    -s,
    0,
    c,
  );
}

Matrix3 _zRotationMatrixFor(Vector3 leftHip, Vector3 rightHip) {
  final angle = pi + atan2(leftHip.y - rightHip.y, leftHip.x - rightHip.x);
  final c = cos(angle);
  final s = sin(angle);
  return Matrix3(
    c,
    -s,
    0,
    s,
    c,
    0,
    0,
    0,
    1,
  );
}

/// Translate the given [pose] such that the mid-hip point is at the origin.
Pose _centerPose(Pose pose) {
  final translation = _midHipOffset(pose);
  return _translatePose(pose, translation);
}

/// Rotates the given [pose] such that it's hip line is in parallel with the x-axis. For this to work properly you should first move it onto the x-axis using the [_centerPose] function.
Pose _alignHipWithXAxis(Pose pose) {
  final leftHip = posOf(pose[KeyPoints.leftHip]!);
  final rightHip = posOf(pose[KeyPoints.rightHip]!);

  final yRotation = _yRotationMatrixFor(leftHip, rightHip);
  final zRotation = _zRotationMatrixFor(leftHip, rightHip);
  final rotation = yRotation * zRotation;

  return _rotatePose(pose, rotation);
}

/// Uniformly scales the given [pose] such that the hip line is one unit long. You can also apply additional scaling to the other axes using the [yMult] and [zMult] parameters.
Pose _normalizeScale(Pose pose, double yMult, double zMult) {
  final hipLength = 2 * posOf(pose[KeyPoints.leftHip]!).x.abs();
  final scalar = 1 / hipLength;
  return _mapPosePositions(
      pose,
      (pos) => Vector3(
          pos.x * scalar, pos.y * scalar * yMult, pos.z * scalar * zMult));
}

NormalizedPose normalizePose(Pose pose) {
  // We first want to make sure, that the mid-hip point is at the origin.
  pose = _centerPose(pose);

  // Next we align the hip-line with the x-axis by rotating the pose accordingly.
  pose = _alignHipWithXAxis(pose);

  // Finally we normalize the pose scale. The axis multipliers here were
  // determined through experimentation.
  pose = _normalizeScale(pose, 4, 2);

  return NormalizedPose(pose);
}
