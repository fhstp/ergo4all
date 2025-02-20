import 'package:pose_analysis/pose_analysis.dart';
import 'package:rula/rula.dart';

/// Creates a [RulaSheet] from [PoseAngles].
RulaSheet rulaSheetFromAngles(PoseAngles angles) {
  Degree angleOf(KeyAngles key) {
    final angle = angles[key]!;
    return Degree.makeFrom180(angle);
  }

  Degree largerAngleOf(KeyAngles keyA, KeyAngles keyB) {
    final angleA = angles[keyA]!;
    final angleB = angles[keyB]!;
    final larger = angleA.abs() > angleB.abs() ? angleA : angleB;
    return Degree.makeFrom180(larger);
  }

  final isStanding = calcIsStanding(angles, angleThreshold: 45);

  return RulaSheet(
      shoulderFlexion: largerAngleOf(
          KeyAngles.shoulderFlexionLeft, KeyAngles.shoulderFlexionRight),
      shoulderAbduction: largerAngleOf(
          KeyAngles.shoulderAbductionLeft, KeyAngles.shoulderAbductionRight),
      elbowFlexion: largerAngleOf(
          KeyAngles.elbowFlexionLeft, KeyAngles.elbowFlexionRight),
      wristFlexion: largerAngleOf(
          KeyAngles.wristFlexionLeft, KeyAngles.wristFlexionRight),
      neckFlexion: angleOf(KeyAngles.neckFlexion),
      neckRotation: angleOf(KeyAngles.neckTwist),
      neckLateralFlexion: angleOf(KeyAngles.neckSideBend),
      hipFlexion: angleOf(KeyAngles.trunkStoop),
      trunkRotation: angleOf(KeyAngles.trunkTwist),
      trunkLateralFlexion: angleOf(KeyAngles.trunkSideBend),
      isStandingOnBothLegs: isStanding);
}
