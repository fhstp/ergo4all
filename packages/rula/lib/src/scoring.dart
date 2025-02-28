import 'dart:math';

import 'package:rula/src/score.dart';
import 'package:rula/src/sheet.dart';

// These angles are not specified by RULA. I chose 20, because 20 is also
// the "worst" angle which is scored for neck flexion.
const _minBadNeckTwistAngle = 20;
const _minBadNeckLateralFlexAngle = 20;

/// This matches table A on the Rula sheet, except that we omit the wrist twist score. Here we just always pick the value like it was 1.
const _tableA = [
  [
    [1, 2, 2, 3],
    [2, 2, 3, 3],
    [2, 3, 3, 4]
  ],
  [
    [2, 3, 3, 4],
    [3, 3, 3, 4],
    [3, 4, 4, 5]
  ],
  [
    [3, 4, 4, 5],
    [3, 4, 4, 5],
    [4, 4, 4, 5]
  ],
  [
    [4, 4, 4, 5],
    [4, 4, 4, 5],
    [4, 4, 5, 6]
  ],
  [
    [5, 5, 5, 6],
    [5, 6, 6, 7],
    [6, 6, 7, 7]
  ],
  [
    [7, 7, 7, 8],
    [8, 8, 8, 9],
    [9, 9, 9, 9]
  ]
];

/// This matches table B on the Rula sheet.
const _tableB = [
  [
    [1, 3],
    [2, 3],
    [3, 4],
    [5, 5],
    [6, 6],
    [7, 7]
  ],
  [
    [2, 3],
    [2, 3],
    [4, 5],
    [5, 5],
    [6, 7],
    [7, 7]
  ],
  [
    [3, 3],
    [3, 4],
    [4, 5],
    [5, 6],
    [6, 7],
    [7, 7]
  ],
  [
    [5, 5],
    [5, 6],
    [6, 7],
    [7, 7],
    [7, 7],
    [8, 8]
  ],
  [
    [7, 7],
    [7, 7],
    [7, 8],
    [8, 8],
    [8, 8],
    [8, 8]
  ],
  [
    [8, 8],
    [8, 8],
    [8, 8],
    [8, 9],
    [9, 9],
    [9, 9]
  ]
];

/// This matches table C on the Rula sheet.
const _tableC = [
  [1, 2, 3, 3, 4, 5, 5],
  [2, 2, 3, 4, 4, 5, 5],
  [3, 3, 3, 4, 4, 5, 6],
  [3, 3, 3, 4, 5, 6, 6],
  [4, 4, 4, 5, 6, 7, 7],
  [4, 4, 5, 6, 6, 7, 7],
  [5, 5, 6, 6, 7, 7, 7],
  [5, 5, 6, 7, 7, 7, 7]
];

/// Calculates the upper arm score for the given [sheet]. Produces a [RulaScore] in the range [1; 6].
RulaScore calcUpperArmScore(RulaSheet sheet) {
  final shoulderFlexionScore = switch (sheet.shoulderFlexion.value) {
    < -20.0 => 2,
    <= 20.0 => 1,
    <= 45 => 2,
    <= 90 => 3,
    _ => 4,
  };
  final shoulderAbductionBonus = sheet.shoulderAbduction.value > 60 ? 1 : 0;
  final upperArmScore = shoulderFlexionScore + shoulderAbductionBonus;
  assert(upperArmScore >= 1 && upperArmScore <= 6);
  return RulaScore.make(upperArmScore);
}

/// Calculates the lower arm score for the given [sheet]. Produces a [RulaScore] in the range [1; 3].
RulaScore calcLowerArmScore(RulaSheet sheet) {
  final elbowFlexionScore =
      switch (sheet.elbowFlexion.value) { <= 60 => 2, <= 100 => 1, _ => 2 };
  final lowerArmScore = elbowFlexionScore;
  assert(lowerArmScore >= 1 && lowerArmScore <= 3);
  return RulaScore.make(lowerArmScore);
}

/// Calculates the neck score for the given [sheet]. Produces a [RulaScore] in the range [1; 6].
RulaScore calcNeckScore(RulaSheet sheet) {
  final neckFlexionScore = switch (sheet.neckFlexion.value) {
    < 0 => 4,
    < 10 => 1,
    < 20 => 2,
    _ => 3
  };
  final neckRotationBonus =
      sheet.neckRotation.value.abs() > _minBadNeckTwistAngle ? 1 : 0;
  final neckLateralFlexionBonus =
      sheet.neckLateralFlexion.value.abs() > _minBadNeckLateralFlexAngle
          ? 1
          : 0;
  final neckScore =
      neckFlexionScore + neckRotationBonus + neckLateralFlexionBonus;
  assert(neckScore >= 1 && neckScore <= 6);
  return RulaScore.make(neckScore);
}

/// Calculates the trunk score for the given [sheet]. Produces a [RulaScore] in the range [1; 6].
RulaScore calcTrukScore(RulaSheet sheet) {
  final hipFlexionScore = switch (sheet.hipFlexion.value) {
    < 5 => 1,
    < 20 => 2,
    < 60 => 3,
    _ => 4
  };
  final trunkTwistBonus = sheet.trunkRotation.value.abs() > 5 ? 1 : 0;
  final trunkLateralFlexionBonus =
      sheet.trunkLateralFlexion.value.abs() > 5 ? 1 : 0;
  final trunkScore =
      hipFlexionScore + trunkTwistBonus + trunkLateralFlexionBonus;
  assert(trunkScore >= 1 && trunkScore <= 6);
  return RulaScore.make(trunkScore);
}

/// Calculates the leg score for the given [sheet]. Produces a [RulaScore] in the range [1; 2].
RulaScore calcLegScore(RulaSheet sheet) {
  final oneLeggedBonus = sheet.isStandingOnBothLegs ? 1 : 2;
  final legScore = oneLeggedBonus;
  assert(legScore >= 1 && legScore <= 2);
  return RulaScore.make(legScore);
}

/// Does the full Rula calculation based on the given [sheet] and produces a [RulaScore] in the range [0; 7].
RulaScore calcFullRulaScore(RulaSheet sheet) {
  final upperArmScore = calcUpperArmScore(sheet).value;
  final lowerArmScore = calcLowerArmScore(sheet).value;

  final wristFlexionScore =
      switch (sheet.wristFlexion.value) { < -15 => 3, < 15 => 1, _ => 3 };
  final wristScore = wristFlexionScore;
  assert(wristScore >= 1 && wristScore <= 4);

  final armHandScore =
      _tableA[upperArmScore - 1][lowerArmScore - 1][wristScore - 1];
  assert(armHandScore >= 1 && armHandScore <= 9);

  final neckScore = calcNeckScore(sheet).value;
  final trunkScore = calcTrukScore(sheet).value;
  final legScore = calcLegScore(sheet).value;

  final neckTrunkLegScore =
      _tableB[neckScore - 1][trunkScore - 1][legScore - 1];
  assert(neckTrunkLegScore >= 1 && neckTrunkLegScore <= 9);

  final finalScore =
      _tableC[min(armHandScore - 1, 7)][min(neckTrunkLegScore - 1, 6)];
  assert(finalScore >= 1 && finalScore <= 7);

  return RulaScore.make(finalScore);
}
