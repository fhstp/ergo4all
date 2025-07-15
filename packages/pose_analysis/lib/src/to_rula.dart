import 'package:pose_analysis/pose_analysis.dart';
import 'package:rula/rula.dart';

/// Creates a [RulaSheet] from [PoseAngles].
RulaSheet rulaSheetFromAngles(PoseAngles angles) {
  Degree angleOf(KeyAngles key) {
    final angle = angles[key]!;
    return Degree.makeFrom180(angle);
  }

  Degree angleDiff(KeyAngles a, KeyAngles b) {
    final angleA = angles[a]!;
    final angleB = angles[b]!;
    final diff = (angleA - angleB).abs();
    return Degree.makeFrom180(diff);
  }

  return RulaSheet(
    shoulderFlexion: (
      angleOf(KeyAngles.shoulderFlexionLeft),
      angleOf(KeyAngles.shoulderFlexionRight),
    ),
    shoulderAbduction: (
      angleOf(KeyAngles.shoulderAbductionLeft),
      angleOf(KeyAngles.shoulderAbductionRight),
    ),
    elbowFlexion: (
      angleOf(KeyAngles.elbowFlexionLeft),
      angleOf(KeyAngles.elbowFlexionRight),
    ),
    wristFlexion: (
      angleOf(KeyAngles.wristFlexionLeft),
      angleOf(KeyAngles.wristFlexionRight),
    ),
    neckFlexion: angleOf(KeyAngles.neckFlexion),
    neckRotation: angleOf(KeyAngles.neckTwist),
    neckLateralFlexion: angleOf(KeyAngles.neckSideBend),
    hipFlexion: angleOf(KeyAngles.trunkStoop),
    trunkRotation: angleOf(KeyAngles.trunkTwist),
    trunkLateralFlexion: angleOf(KeyAngles.trunkSideBend),
    legAngleDiff: (
      angleDiff(KeyAngles.kneeFlexionLeft, KeyAngles.legFlexionLeft),
      angleDiff(KeyAngles.kneeFlexionRight, KeyAngles.legFlexionRight),
    ),
  );
}
