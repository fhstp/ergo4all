import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:pose/pose.dart';
import 'package:vector_math/vector_math.dart';

enum KeyAngles {
  shoulderFlexionLeft,
  shoulderAbductionLeft,
  shoulderFlexionRight,
  shoulderAbductionRight,
  elbowFlexionLeft,
  elbowFlexionRight,
  wristFlexionLeft,
  wristFlexionRight,
  kneeFlexionLeft,
  kneeFlexionRight,
  trunkStoop,
  trunkTwist,
  trunkSideBend,
  neckFlexion,
  neckSideBend,
  neckTwist
}

typedef PoseAngles = IMap<KeyAngles, double>;

double _angle2d(Vector2 a, Vector2 b) {
  final rads = atan2(a.x * b.y - a.y * b.x, a.x * b.x + a.y * b.y);
  return degrees(rads);
}

/// Calculates the angle in degrees between two directional vectors.
double _angle(Vector3 a, Vector3 b) {
  assert(a.length2 > 0, "a must have non 0 length");
  assert(b.length2 > 0, "b must have non 0 length");

  final cosineAngle = a.dot(b) / (a.length * b.length);
  final angle = acos(cosineAngle);
  return degrees(angle);
}

/// Calculates the angle in degrees between the lines from [pointB] to [pointA] and [pointB] to [pointC].
double _jointAngle(
    Pose pose, KeyPoints pointA, KeyPoints pointB, KeyPoints pointC) {
  final a = posOf(pose[pointA]!);
  final b = posOf(pose[pointB]!);
  final c = posOf(pose[pointC]!);

  final ba = a - b;
  final bc = c - b;

  return _angle(ba, bc);
}

/// Calculates the angle in degrees between the lines from [pointB] to [pointA] and the z-axis.
double _zAngle(Pose pose, KeyPoints pointA, KeyPoints pointB) {
  final a = posOf(pose[pointA]!);
  final b = posOf(pose[pointB]!);

  final ba = a - b;
  final bc = Vector3(0, 0, 1);

  return _angle(ba, bc);
}

/// Calculates the angle in degrees between the lines from [pointA] to [pointB] and [pointC] to [pointD].
double _crossAngle(Pose pose, KeyPoints pointA, KeyPoints pointB,
    KeyPoints pointC, KeyPoints pointD) {
  final a = posOf(pose[pointA]!);
  final b = posOf(pose[pointB]!);
  final c = posOf(pose[pointC]!);
  final d = posOf(pose[pointD]!);

  final ba = a - b;
  final dc = c - d;

  return _angle(ba, dc);
}

Vector2 _down = Vector2(0, 1);

Vector2 _up = Vector2(0, -1);

Vector2 _line(Pose2d pose, KeyPoints a, KeyPoints b) {
  return (pose[b]! - pose[a]!).normalized();
}

PoseAngles calculateAngles(Pose worldPose, Pose2d coronal, Pose2d sagittal) {
  double calcKeyAngle(KeyAngles keyAngle) => switch (keyAngle) {
        KeyAngles.shoulderFlexionLeft => _angle2d(
            _line(sagittal, KeyPoints.leftShoulder, KeyPoints.leftHip),
            _line(sagittal, KeyPoints.leftShoulder, KeyPoints.leftElbow),
          ),
        KeyAngles.shoulderAbductionLeft => _angle2d(
            _line(coronal, KeyPoints.leftShoulder, KeyPoints.leftElbow),
            _line(coronal, KeyPoints.leftShoulder, KeyPoints.leftHip),
          ),
        KeyAngles.shoulderFlexionRight => _angle2d(
            _line(sagittal, KeyPoints.rightShoulder, KeyPoints.rightHip),
            _line(sagittal, KeyPoints.rightShoulder, KeyPoints.rightElbow),
          ),
        KeyAngles.shoulderAbductionRight => _angle2d(
            _line(coronal, KeyPoints.rightShoulder, KeyPoints.rightHip),
            _line(coronal, KeyPoints.rightShoulder, KeyPoints.rightElbow),
          ),
        KeyAngles.elbowFlexionLeft => 180 -
            _jointAngle(worldPose, KeyPoints.leftWrist, KeyPoints.leftElbow,
                KeyPoints.leftShoulder),
        KeyAngles.elbowFlexionRight => 180 -
            _jointAngle(worldPose, KeyPoints.rightWrist, KeyPoints.rightElbow,
                KeyPoints.rightShoulder),
        KeyAngles.wristFlexionLeft => 180 -
            _jointAngle(worldPose, KeyPoints.leftElbow, KeyPoints.leftWrist,
                KeyPoints.leftPalm),
        KeyAngles.wristFlexionRight => 180 -
            _jointAngle(worldPose, KeyPoints.rightElbow, KeyPoints.rightWrist,
                KeyPoints.rightPalm),
        KeyAngles.kneeFlexionLeft => _angle2d(
            _line(sagittal, KeyPoints.leftKnee, KeyPoints.leftAnkle),
            _line(sagittal, KeyPoints.leftHip, KeyPoints.leftKnee),
          ),
        KeyAngles.kneeFlexionRight => _angle2d(
            _line(sagittal, KeyPoints.rightKnee, KeyPoints.rightAnkle),
            _line(sagittal, KeyPoints.rightHip, KeyPoints.rightKnee),
          ),
        KeyAngles.trunkStoop => _angle2d(
            _line(sagittal, KeyPoints.midPelvis, KeyPoints.midNeck),
            _up,
          ),
        KeyAngles.trunkTwist => (180 -
                _crossAngle(worldPose, KeyPoints.rightHip, KeyPoints.leftHip,
                    KeyPoints.leftShoulder, KeyPoints.rightShoulder))
            .abs(),
        KeyAngles.trunkSideBend => (90 -
                _crossAngle(worldPose, KeyPoints.leftHip, KeyPoints.rightHip,
                    KeyPoints.midPelvis, KeyPoints.midNeck))
            .abs(),
        KeyAngles.neckFlexion => _angle2d(
            _line(sagittal, KeyPoints.midNeck, KeyPoints.midHead),
            _line(sagittal, KeyPoints.midPelvis, KeyPoints.midNeck),
          ),
        KeyAngles.neckSideBend => (90 -
                _crossAngle(
                    worldPose, // TODO: Should this be coronal?
                    KeyPoints.leftShoulder,
                    KeyPoints.rightShoulder,
                    KeyPoints.midNeck,
                    KeyPoints.midHead))
            .abs(),
        KeyAngles.neckTwist => (180 -
                _crossAngle(
                    worldPose,
                    KeyPoints.rightShoulder,
                    KeyPoints.leftShoulder,
                    KeyPoints.leftEar,
                    KeyPoints.rightEar))
            .abs(),
      };

  return IMap.fromKeys(keys: KeyAngles.values, valueMapper: calcKeyAngle);
}
