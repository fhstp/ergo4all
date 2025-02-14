import 'dart:math';

import 'package:pose/pose.dart';
import 'package:vector_math/vector_math.dart';

/// A [Pose] which was normalized using the [normalizePose] function. It
/// is has it's mid-hip point at the origin, it's hip line is aligned with the x-axis and it is scaled such that the hip line is one unit long.
extension type NormalizedPose(Pose it) implements Pose {}

/// Gets the offset from the origin to the[pose]s mid-hip point.
Vector3 _midHipOffset(Pose pose) {
  return posOf(pose[KeyPoints.midPelvis]!);
}

/// Translates a [pose] by a given [translation] vector.
Pose _translatePose(Pose pose, Vector3 translation) {
  return mapPosePositions(pose, (pos) => pos - translation);
}

/// Rotates the points in a [pose] using the given [rotation] matrix.
Pose _rotatePose(Pose pose, Matrix3 rotation) {
  return mapPosePositions(pose, rotation.transform);
}

Matrix3 _yRotationMatrixFor(Vector3 leftHip, Vector3 rightHip) {
  final angle = 0 - atan2(leftHip.z - rightHip.z, leftHip.x - rightHip.x);
  return Matrix3.rotationY(angle);
}

Matrix3 _zRotationMatrixFor(Vector3 leftHip, Vector3 rightHip) {
  final angle = pi + atan2(leftHip.y - rightHip.y, leftHip.x - rightHip.x);
  return Matrix3.rotationZ(angle);
}

/// Translate the given [pose] such that the mid-hip point is at the origin.
Pose _centerPose(Pose pose) {
  final translation = _midHipOffset(pose);
  return _translatePose(pose, translation);
}

/// Rotates the given [pose] such that it's hip line is in the XY plane.
Pose _alignHipWithXYPlane(Pose pose) {
  final leftHip = posOf(pose[KeyPoints.leftHip]!);
  final rightHip = posOf(pose[KeyPoints.rightHip]!);

  final yRotation = _yRotationMatrixFor(leftHip, rightHip);

  return _rotatePose(pose, yRotation);
}

/// Rotates the given [pose] such that it's hip line is in the XZ plane.
Pose _alignHipWithXZPlane(Pose pose) {
  final leftHip = posOf(pose[KeyPoints.leftHip]!);
  final rightHip = posOf(pose[KeyPoints.rightHip]!);

  final zRotation = _zRotationMatrixFor(leftHip, rightHip);

  return _rotatePose(pose, zRotation);
}

/// Flip the axis to align with the coordinate system
Pose _flipYAxis(Pose pose3D) {
  return mapPosePositions(pose3D, (pos) => Vector3(pos.x, -pos.y, pos.z));
}

/// Uniformly scales the given [pose] such that the hip line is one unit long. You can also apply additional scaling to the other axes using the [yMult] and [zMult] parameters.
Pose _normalizeScale(Pose pose, double yMult, double zMult) {
  final hipLength = 2 * posOf(pose[KeyPoints.leftHip]!).x.abs();
  final scalar = 1 / hipLength;
  return mapPosePositions(
      pose,
      (pos) => Vector3(
          pos.x * scalar, pos.y * scalar * yMult, pos.z * scalar * zMult));
}

NormalizedPose normalizePose(Pose pose) {
  // We first want to make sure, that the mid-hip point is at the origin.
  pose = _centerPose(pose);

  // Next we align the hip-line with the x-axis by rotating the pose accordingly.
  // Rotations must be handled separately, as the angle calculation is affected by each transformation (angle estimation cannot be multiplicative)
  pose = _alignHipWithXYPlane(pose);
  pose = _alignHipWithXZPlane(pose);

  // Flip the Y axis to get the correct direction, otherwise angle calculation could be potentially affected (e.g., 180 instead 0 degrees etc.)
  pose = _flipYAxis(pose);

  // Finally we normalize the pose scale. The axis multipliers here were
  // determined through experimentation.
  pose = _normalizeScale(pose, 4, 2);

  return NormalizedPose(pose);
}
