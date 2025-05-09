import 'dart:math';

import 'package:common/func_ext.dart';
import 'package:common/math_utils.dart';
import 'package:common/pair_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:rula/rula.dart';

void Function(int) _assertInRange(int min, int max, [String? message]) {
  return (i) {
    assert(i >= min && i <= max, message ?? '$i is not in range [$min, $max].');
  };
}

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
/// score. Here we just always pick the  like it was 1.
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

/// The result of scoring a [RulaSheet]. Contains all score values.
@immutable
class RulaScores {
  ///
  const RulaScores({
    required this.upperArmPositionScores,
    required this.upperArmAbductedAdjustments,
    required this.upperArmScores,
    required this.lowerArmPositionScores,
    required this.lowerArmScores,
    required this.wristScores,
    required this.neckPositionScore,
    required this.neckTwistAdjustment,
    required this.neckSideBendAdjustment,
    required this.neckScore,
    required this.trunkPositionScore,
    required this.trunkTwistAdjustment,
    required this.trunkSideBendAdjustment,
    required this.trunkScore,
    required this.legScore,
    required this.fullScore,
  });

  /// The scores for the upper arm position/angle.
  /// Corresponds to point 1.
  /// Expected range is [1; 6].
  final (int, int) upperArmPositionScores;

  /// The scores for the upper arm abduction adjustment.
  /// Corresponds to point 1a.
  /// Expected range is [0; 1].
  final (int, int) upperArmAbductedAdjustments;

  /// The full upper arm scores.
  /// Expected range is [1; 6].
  final (int, int) upperArmScores;

  /// The scores for the lower arm position/angle.
  /// Corresponds to point 2.
  /// Expected range is [1; 2].
  final (int, int) lowerArmPositionScores;

  /// The full lower arm scores.
  /// Expected range is [1; 3].
  final (int, int) lowerArmScores;

  /// Full scores for the wrist.
  /// Expected range is [1; 3].
  final (int, int) wristScores;

  /// The score for the neck position/angle.
  /// Corresponds to point 9.
  /// Expected range is [1; 4].
  final int neckPositionScore;

  /// The score for the neck twist adjustment.
  /// Corresponds to point 9a.
  /// Expected range is [0; 1].
  final int neckTwistAdjustment;

  /// The score for the neck side-bend adjustment.
  /// Corresponds to point 9a.
  /// Expected range is [0; 1].
  final int neckSideBendAdjustment;

  /// The full score for the neck.
  /// Expected range is [1; 6].
  final int neckScore;

  /// The score for the trunk position/angle.
  /// Corresponds to point 10.
  /// Expected range is [1; 4].
  final int trunkPositionScore;

  /// The score for the trunk twist adjustment.
  /// Corresponds to point 10a.
  /// Expected range is [0; 1].
  final int trunkTwistAdjustment;

  /// The score for the trunk side-bend adjustment.
  /// Corresponds to point 10a.
  /// Expected range is [0; 1].
  final int trunkSideBendAdjustment;

  /// The full score for the trunk.
  /// Expected range is [1; 6].
  final int trunkScore;

  /// The score for the legs.
  /// Expected range is [1; 2].
  final int legScore;

  /// The full rula score
  /// Expected range is [1; 7]
  final int fullScore;
}

/// Picks the worse of two scores.
const int Function(int, int) worse = max;

/// Pairwise addition.
final _addPair = Pair.pairwise(Math.add<int>);

RulaScores scoresOf(RulaSheet sheet) {
  final upperArmPositionScores = sheet.shoulderFlexion.pipe(
    Pair.map(
      (angle) => switch (angle.value) {
        < -20.0 => 2,
        <= 20.0 => 1,
        <= 45 => 2,
        <= 90 => 3,
        _ => 4,
      },
    ),
  );
  final upperArmAbductedAdjustments = sheet.shoulderAbduction
      .pipe(Pair.map((angle) => angle.value > _minBadShoulderAbductionAngle))
      .pipe(Pair.map((isBad) => isBad ? 1 : 0));
  final upperArmScores =
      _addPair(upperArmPositionScores, upperArmAbductedAdjustments)
        ..pipe(Pair.map(_assertInRange(1, 6)));

  final lowerArmPositionScores = sheet.elbowFlexion.pipe(
    Pair.map(
      (angle) => switch (angle.value) {
        <= 60 => 2,
        <= 100 => 1,
        _ => 2,
      },
    ),
  );
  final lowerArmScore = lowerArmPositionScores;
  final lowerArmScores = lowerArmScore..pipe(Pair.map(_assertInRange(1, 3)));

  final wristScores = sheet.wristFlexion.pipe(
    Pair.map((angle) => switch (angle.value) { < -15 => 3, < 15 => 1, _ => 3 }),
  )..pipe(Pair.map(_assertInRange(1, 4)));

  final neckPositionScore = switch (sheet.neckFlexion.value) {
    < 0 => 4,
    < 10 => 1,
    < 20 => 2,
    _ => 3
  }
    ..pipe(_assertInRange(1, 4));
  final neckTwistAdjustment =
      sheet.neckRotation.value.abs() > _minBadNeckTwistAngle ? 1 : 0;
  final neckSideBendAdjustment =
      sheet.neckLateralFlexion.value.abs() > _minBadNeckLateralFlexAngle
          ? 1
          : 0;
  _assertInRange(1, 6)(
    neckPositionScore + neckTwistAdjustment + neckSideBendAdjustment,
  );
  final neckScore =
      neckPositionScore + neckTwistAdjustment + neckSideBendAdjustment;

  final trunkPositionScore = switch (sheet.hipFlexion.value) {
    < 5 => 1,
    < 20 => 2,
    < 60 => 3,
    _ => 4
  };
  final trunkTwistAdjustment =
      sheet.trunkRotation.value.abs() > _minBadTrunkTwistAngle ? 1 : 0;
  final trunkSideBendAdjustment =
      sheet.trunkLateralFlexion.value.abs() > _minBadTrunkLateralTwistAngle
          ? 1
          : 0;
  final trunkScore =
      trunkPositionScore + trunkTwistAdjustment + trunkSideBendAdjustment;
  _assertInRange(1, 6)(trunkScore);

  final legScore = sheet.isStandingOnBothLegs ? 1 : 2;
  _assertInRange(1, 2)(legScore);

  final armHandScore = ((
    _tableA[upperArmScores.$1 - 1][lowerArmScores.$1 - 1][wristScores.$1 - 1],
    _tableA[upperArmScores.$2 - 1][lowerArmScores.$2 - 1][wristScores.$2 - 1]
  )..pipe(Pair.map(_assertInRange(1, 9))))
      .pipe(Pair.reduce(worse));
  final neckTrunkLegScore =
      _tableB[neckScore - 1][trunkScore - 1][legScore - 1];
  _assertInRange(1, 9)(neckTrunkLegScore);
  final fullScore =
      _tableC[min(armHandScore - 1, 7)][min(neckTrunkLegScore - 1, 6)];
  _assertInRange(1, 7)(fullScore);

  return RulaScores(
    upperArmPositionScores: upperArmPositionScores,
    upperArmAbductedAdjustments: upperArmAbductedAdjustments,
    upperArmScores: upperArmScores,
    lowerArmPositionScores: lowerArmPositionScores,
    lowerArmScores: lowerArmScores,
    wristScores: wristScores,
    neckPositionScore: neckPositionScore,
    neckTwistAdjustment: neckTwistAdjustment,
    neckSideBendAdjustment: neckSideBendAdjustment,
    neckScore: neckScore,
    trunkPositionScore: trunkPositionScore,
    trunkTwistAdjustment: trunkTwistAdjustment,
    trunkSideBendAdjustment: trunkSideBendAdjustment,
    trunkScore: trunkScore,
    legScore: legScore,
    fullScore: fullScore,
  );
}
