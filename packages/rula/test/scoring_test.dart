import 'package:common/pair_utils.dart';
import 'package:glados/glados.dart';
import 'package:rula/src/degree.dart';
import 'package:rula/src/scoring.dart';
import 'package:rula/src/sheet.dart';

import 'sheet_data.dart';

void main() {
  Glados(any.rulaSheet).test('should have output in range [1; 7]', (sheet) {
    final scores = scoresOf(sheet);
    expect(scores.fullScore, greaterThanOrEqualTo(1));
    expect(scores.fullScore, lessThanOrEqualTo(7));
  });

  test('should have correct score for person standing straight', () {
    final sheet = RulaSheet(
      shoulderFlexion: Pair.of(Degree.zero),
      shoulderAbduction: Pair.of(Degree.zero),
      elbowFlexion: Pair.of(Degree.zero),
      wristFlexion: Pair.of(Degree.zero),
      neckFlexion: Degree.zero,
      neckRotation: Degree.zero,
      neckLateralFlexion: Degree.zero,
      hipFlexion: Degree.zero,
      trunkRotation: Degree.zero,
      trunkLateralFlexion: Degree.zero,
      isStandingOnBothLegs: true,
    );

    final scores = scoresOf(sheet);

    expect(scores.fullScore, equals(2));
  });

  test('should have correct score for person picking something off ground', () {
    final sheet = RulaSheet(
      shoulderFlexion: (
        const Degree.makeFrom180(80),
        const Degree.makeFrom180(60)
      ),
      shoulderAbduction: Pair.of(Degree.zero),
      elbowFlexion: Pair.of(Degree.zero),
      wristFlexion: Pair.of(Degree.zero),
      neckFlexion: const Degree.makeFrom180(15),
      neckRotation: Degree.zero,
      neckLateralFlexion: Degree.zero,
      hipFlexion: const Degree.makeFrom180(65),
      trunkRotation: Degree.zero,
      trunkLateralFlexion: Degree.zero,
      isStandingOnBothLegs: true,
    );

    final scores = scoresOf(sheet);

    expect(scores.fullScore, equals(4));
  });

  test('should have correct score for person lifting something above head', () {
    final sheet = RulaSheet(
      shoulderFlexion: (
        const Degree.makeFrom180(120),
        const Degree.makeFrom180(110)
      ),
      shoulderAbduction: Pair.of(Degree.zero),
      elbowFlexion: (
        const Degree.makeFrom180(80),
        const Degree.makeFrom180(70)
      ),
      wristFlexion: Pair.of(Degree.zero),
      neckFlexion: const Degree.makeFrom180(-30),
      neckRotation: Degree.zero,
      neckLateralFlexion: Degree.zero,
      hipFlexion: Degree.zero,
      trunkRotation: Degree.zero,
      trunkLateralFlexion: Degree.zero,
      isStandingOnBothLegs: true,
    );

    final scores = scoresOf(sheet);

    expect(scores.fullScore, equals(5));
  });
}
