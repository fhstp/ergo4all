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

Vector2 _up = Vector2(0, -1);

Vector2 _line2d(Pose2d pose, KeyPoints a, KeyPoints b) {
  return (pose[b]! - pose[a]!).normalized();
}

Vector3 _line(Pose pose, KeyPoints a, KeyPoints b) {
  return (posOf(pose[b]!) - posOf(pose[a]!)).normalized();
}

PoseAngles calculateAngles(
    Pose world, Pose2d coronal, Pose2d sagittal, Pose2d transverse) {
  double calcKeyAngle(KeyAngles keyAngle) => switch (keyAngle) {
        KeyAngles.shoulderFlexionLeft => _angle2d(
            _line2d(sagittal, KeyPoints.leftShoulder, KeyPoints.leftHip),
            _line2d(sagittal, KeyPoints.leftShoulder, KeyPoints.leftElbow),
          ),
        KeyAngles.shoulderAbductionLeft => _angle2d(
            _line2d(coronal, KeyPoints.leftShoulder, KeyPoints.leftElbow),
            _line2d(coronal, KeyPoints.leftShoulder, KeyPoints.leftHip),
          ),
        KeyAngles.shoulderFlexionRight => _angle2d(
            _line2d(sagittal, KeyPoints.rightShoulder, KeyPoints.rightHip),
            _line2d(sagittal, KeyPoints.rightShoulder, KeyPoints.rightElbow),
          ),
        KeyAngles.shoulderAbductionRight => _angle2d(
            _line2d(coronal, KeyPoints.rightShoulder, KeyPoints.rightHip),
            _line2d(coronal, KeyPoints.rightShoulder, KeyPoints.rightElbow),
          ),
        KeyAngles.elbowFlexionLeft => _angle(
            _line(world, KeyPoints.leftElbow, KeyPoints.leftWrist),
            _line(world, KeyPoints.leftShoulder, KeyPoints.leftElbow),
          ),
        KeyAngles.elbowFlexionRight => _angle(
            _line(world, KeyPoints.rightElbow, KeyPoints.rightWrist),
            _line(world, KeyPoints.rightShoulder, KeyPoints.rightElbow),
          ),
        KeyAngles.wristFlexionLeft => _angle(
            _line(world, KeyPoints.leftWrist, KeyPoints.leftPalm),
            _line(world, KeyPoints.leftElbow, KeyPoints.leftWrist),
          ),
        KeyAngles.wristFlexionRight => _angle(
            _line(world, KeyPoints.rightWrist, KeyPoints.rightPalm),
            _line(world, KeyPoints.rightElbow, KeyPoints.rightWrist),
          ),
        KeyAngles.kneeFlexionLeft => _angle2d(
            _line2d(sagittal, KeyPoints.leftKnee, KeyPoints.leftAnkle),
            _line2d(sagittal, KeyPoints.leftHip, KeyPoints.leftKnee),
          ),
        KeyAngles.kneeFlexionRight => _angle2d(
            _line2d(sagittal, KeyPoints.rightKnee, KeyPoints.rightAnkle),
            _line2d(sagittal, KeyPoints.rightHip, KeyPoints.rightKnee),
          ),
        KeyAngles.trunkStoop => _angle2d(
            _line2d(sagittal, KeyPoints.midPelvis, KeyPoints.midNeck),
            _up,
          ),
        KeyAngles.trunkTwist => _angle2d(
            _line2d(
                transverse, KeyPoints.leftShoulder, KeyPoints.rightShoulder),
            _line2d(transverse, KeyPoints.leftHip, KeyPoints.rightHip),
          ).abs(),
        KeyAngles.trunkSideBend => (90 -
                _angle2d(
                  _line2d(coronal, KeyPoints.midPelvis, KeyPoints.midNeck),
                  _line2d(coronal, KeyPoints.rightHip, KeyPoints.leftHip),
                ))
            .abs(),
        KeyAngles.neckFlexion => _angle2d(
            _line2d(sagittal, KeyPoints.midNeck, KeyPoints.midHead),
            _line2d(sagittal, KeyPoints.midPelvis, KeyPoints.midNeck),
          ),
        KeyAngles.neckSideBend => (90 -
                _angle2d(
                  _line2d(coronal, KeyPoints.midNeck, KeyPoints.midHead),
                  _line2d(
                      coronal, KeyPoints.rightShoulder, KeyPoints.leftShoulder),
                ))
            .abs(),
        KeyAngles.neckTwist => _angle2d(
            _line2d(
                transverse, KeyPoints.leftShoulder, KeyPoints.rightShoulder),
            _line2d(transverse, KeyPoints.leftEar, KeyPoints.rightEar),
          ).abs(),
      };

  return IMap.fromKeys(keys: KeyAngles.values, valueMapper: calcKeyAngle);
}
