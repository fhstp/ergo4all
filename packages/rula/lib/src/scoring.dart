import 'dart:math';

import 'package:common/func_ext.dart';
import 'package:common/pair_utils.dart';
import 'package:rula/rula.dart';

// These angles are not specified by RULA. I chose 20, because 20 is also
// the "worst" angle which is scored for neck flexion.
const _minBadNeckTwistAngle = 20;
const _minBadNeckLateralFlexAngle = 20;

// These angles are also not in the RULA sheet. I just chose something
// arbitrarily.
const _minBadShoulderAbductionAngle = 60;
const _minBadTrunkTwistAngle = 10;
const _minBadTrunkLateralTwistAngle = 10;

/// This matches table A on the Rula sheet, except that we omit the wrist twist
/// score. Here we just always pick the value like it was 1.
const _tableA = [
  [
    [1, 2, 2, 3],
    [2, 2, 3, 3],
    [2, 3, 3, 4],
  ],
  [
    [2, 3, 3, 4],
    [3, 3, 3, 4],
    [3, 4, 4, 5],
  ],
  [
    [3, 4, 4, 5],
    [3, 4, 4, 5],
    [4, 4, 4, 5],
  ],
  [
    [4, 4, 4, 5],
    [4, 4, 4, 5],
    [4, 4, 5, 6],
  ],
  [
    [5, 5, 5, 6],
    [5, 6, 6, 7],
    [6, 6, 7, 7],
  ],
  [
    [7, 7, 7, 8],
    [8, 8, 8, 9],
    [9, 9, 9, 9],
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
    [7, 7],
  ],
  [
    [2, 3],
    [2, 3],
    [4, 5],
    [5, 5],
    [6, 7],
    [7, 7],
  ],
  [
    [3, 3],
    [3, 4],
    [4, 5],
    [5, 6],
    [6, 7],
    [7, 7],
  ],
  [
    [5, 5],
    [5, 6],
    [6, 7],
    [7, 7],
    [7, 7],
    [8, 8],
  ],
  [
    [7, 7],
    [7, 7],
    [7, 8],
    [8, 8],
    [8, 8],
    [8, 8],
  ],
  [
    [8, 8],
    [8, 8],
    [8, 8],
    [8, 9],
    [9, 9],
    [9, 9],
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
  [5, 5, 6, 7, 7, 7, 7],
];

/// Calculates the shoulder flexion score for the given [sheet]. Produces a
/// [RulaScore] in the range [1; 4].
RulaScore calcShoulderFlexionScore(RulaSheet sheet) => sheet.shoulderFlexion
    .pipe(
      Pair.map(
        (angle) => switch (angle.value) {
          < -20.0 => 2,
          <= 20.0 => 1,
          <= 45 => 2,
          <= 90 => 3,
          _ => 4,
        },
      ),
    )
    .pipe(Pair.reduce(max))
    .pipe(RulaScore.make);

/// Calculates the shoulder abduction score based on the given [sheet].
/// Produces a value in range [0; 1].
int calcShoulderAbductionBonus(RulaSheet sheet) => sheet.shoulderAbduction
    .pipe(
      Pair.map(
        (angle) => angle.value > _minBadShoulderAbductionAngle ? 1 : 0,
      ),
    )
    .pipe(Pair.reduce(max));

/// Calculates the upper arm score for the given [sheet]. Produces a
/// [RulaScore] in the range [1; 6].
RulaScore calcUpperArmScore(RulaSheet sheet) {
  final shoulderFlexionScore = calcShoulderFlexionScore(sheet).value;
  final shoulderAbductionBonus = calcShoulderAbductionBonus(sheet);
  final upperArmScore = shoulderFlexionScore + shoulderAbductionBonus;
  assert(
    upperArmScore >= 1 && upperArmScore <= 6,
    'Score must be in range [1, 6]',
  );
  return RulaScore.make(upperArmScore);
}

/// Calculates the elbow flexion score for the given [sheet]. Produces a
/// [RulaScore] in the range [1; 2].
RulaScore calcElbowFlexionScore(RulaSheet sheet) {
  return sheet.elbowFlexion
      .pipe(
        Pair.map(
          (angle) => switch (angle.value) {
            <= 60 => 2,
            <= 100 => 1,
            _ => 2,
          },
        ),
      )
      .pipe(Pair.reduce(max))
      .pipe(RulaScore.make);
}

/// Calculates the lower arm score for the given [sheet]. Produces a
/// [RulaScore] in the range [1; 3].
RulaScore calcLowerArmScore(RulaSheet sheet) {
  final elbowFlexionScore = calcElbowFlexionScore(sheet).value;
  final lowerArmScore = elbowFlexionScore;

  // NOTE:
  //  In theory you could get +1 here for lateral flexion but we don't track
  //  that. I still say the range is [1; 3].

  assert(
    lowerArmScore >= 1 && lowerArmScore <= 3,
    'Score must be in range [1, 3]',
  );
  return RulaScore.make(lowerArmScore);
}

/// Calculates the neck flexion score based on the given [sheet]. Produces a
/// [RulaScore] in range [1; 4].
RulaScore calcNeckFlexionScore(RulaSheet sheet) {
  final score = switch (sheet.neckFlexion.value) {
    < 0 => 4,
    < 10 => 1,
    < 20 => 2,
    _ => 3
  };
  assert(score >= 1 && score <= 4, 'Score must be in range [1, 4]');
  return RulaScore.make(score);
}

/// Calculates the neck lateral flexion score based on the given [sheet].
/// Produces a value in range [0; 1].
int calcLateralNeckFlexionBonus(RulaSheet sheet) {
  return sheet.neckLateralFlexion.value.abs() > _minBadNeckLateralFlexAngle
      ? 1
      : 0;
}

/// Calculates the neck twist score based on the given [sheet].
/// Produces a value in range [0; 1].
int calcNeckTwistBonus(RulaSheet sheet) {
  return sheet.neckRotation.value.abs() > _minBadNeckTwistAngle ? 1 : 0;
}

/// Calculates the neck score for the given [sheet]. Produces a [RulaScore] in
/// the range [1; 6].
RulaScore calcNeckScore(RulaSheet sheet) {
  final neckFlexionScore = calcNeckFlexionScore(sheet).value;
  final neckRotationBonus = calcNeckTwistBonus(sheet);
  final neckLateralFlexionBonus = calcLateralNeckFlexionBonus(sheet);
  final neckScore =
      neckFlexionScore + neckRotationBonus + neckLateralFlexionBonus;
  assert(neckScore >= 1 && neckScore <= 6, 'Score must be in range [1, 6]');
  return RulaScore.make(neckScore);
}

/// Calculates the hip flexion score for the given [sheet]. Produces a
/// [RulaScore] in the range [1; 4].
RulaScore calcHipFlexionScore(RulaSheet sheet) {
  final hipFlexionScore = switch (sheet.hipFlexion.value) {
    < 5 => 1,
    < 20 => 2,
    < 60 => 3,
    _ => 4
  };
  return RulaScore.make(hipFlexionScore);
}

/// Calculates the trunk twist score based on the given [sheet].
/// Produces a value in range [0; 1].
int calcTrunkTwistBonus(RulaSheet sheet) {
  return sheet.trunkRotation.value.abs() > _minBadTrunkTwistAngle ? 1 : 0;
}

/// Calculates the trunk lateral flexion score based on the given [sheet].
/// Produces a value in range [0; 1].
int calcTrunkLateralFlexionBonus(RulaSheet sheet) {
  return sheet.trunkLateralFlexion.value.abs() > _minBadTrunkLateralTwistAngle
      ? 1
      : 0;
}

/// Calculates the trunk score for the given [sheet]. Produces a [RulaScore] in
/// the range [1; 6].
RulaScore calcTrukScore(RulaSheet sheet) {
  final hipFlexionScore = calcHipFlexionScore(sheet).value;
  final trunkTwistBonus = calcTrunkTwistBonus(sheet);
  final trunkLateralFlexionBonus = calcTrunkLateralFlexionBonus(sheet);
  final trunkScore =
      hipFlexionScore + trunkTwistBonus + trunkLateralFlexionBonus;
  assert(trunkScore >= 1 && trunkScore <= 6, 'Score must be in range [1, 6]');
  return RulaScore.make(trunkScore);
}

/// Calculates the leg score for the given [sheet]. Produces a [RulaScore] in
/// the range [1; 2].
RulaScore calcLegScore(RulaSheet sheet) {
  final oneLeggedBonus = sheet.isStandingOnBothLegs ? 1 : 2;
  final legScore = oneLeggedBonus;
  assert(legScore >= 1 && legScore <= 2, 'Score must be in range [1, 2]');
  return RulaScore.make(legScore);
}

/// Calculates the wrist score for the given [sheet]. Produces a [RulaScore] in
/// the range [1; 4].
RulaScore calcWristScore(RulaSheet sheet) => sheet.wristFlexion
        .pipe(
          Pair.map(
            (angle) => switch (angle.value) { < -15 => 3, < 15 => 1, _ => 3 },
          ),
        )
        .pipe(Pair.reduce(max))
        .tap((score) {
      assert(score >= 1 && score <= 4, 'Score must be in range [1, 4]');
    }).pipe(RulaScore.make);

/// Does the full Rula calculation based on the given [sheet] and produces a
/// [RulaScore] in the range [0; 7].
RulaScore calcFullRulaScore(RulaSheet sheet) {
  final upperArmScore = calcUpperArmScore(sheet).value;
  final lowerArmScore = calcLowerArmScore(sheet).value;

  final wristScore = calcWristScore(sheet).value;

  final armHandScore =
      _tableA[upperArmScore - 1][lowerArmScore - 1][wristScore - 1];
  assert(
    armHandScore >= 1 && armHandScore <= 9,
    'Score must be in range [1, 9]',
  );

  final neckScore = calcNeckScore(sheet).value;
  final trunkScore = calcTrukScore(sheet).value;
  final legScore = calcLegScore(sheet).value;

  final neckTrunkLegScore =
      _tableB[neckScore - 1][trunkScore - 1][legScore - 1];
  assert(
    neckTrunkLegScore >= 1 && neckTrunkLegScore <= 9,
    'Score must be in range [1, 9]',
  );

  final finalScore =
      _tableC[min(armHandScore - 1, 7)][min(neckTrunkLegScore - 1, 6)];
  assert(finalScore >= 1 && finalScore <= 7, 'Score must be in range [1, 9]');

  return RulaScore.make(finalScore);
}
