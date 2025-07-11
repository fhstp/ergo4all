import 'package:pose_analysis/pose_analysis.dart';

/// Determines whether a person is standing on both legs based on their
/// [angles]. A person is considered standing when the angle between body
/// and upper leg and the knee angle are roughly the same for both legs.
/// How similar angles need to be is controlled using [angleThreshold].
bool calcIsStanding(PoseAngles angles, {required double angleThreshold}) {
  final leftLeg = angles[KeyAngles.legFlexionLeft]!;
  final leftKnee = angles[KeyAngles.kneeFlexionLeft]!;
  final leftDiff = (leftLeg - leftKnee).abs();

  final rightLeg = angles[KeyAngles.legFlexionRight]!;
  final rightKnee = angles[KeyAngles.kneeFlexionRight]!;
  final rightDiff = (rightLeg - rightKnee).abs();

  final leftOk = leftDiff <= angleThreshold;
  final rightOk = rightDiff <= angleThreshold;

  return leftOk && rightOk;
}
