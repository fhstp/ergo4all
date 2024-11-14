import 'package:glados/glados.dart';
import 'package:rula/src/degree.dart';
import 'package:rula/src/scoring.dart';
import 'package:rula/src/sheet.dart';

import 'sheet_data.dart';

void main() {
  Glados(any.rulaSheet).test("should have output in range [1; 7]", (sheet) {
    final finalScore = calcFullRulaScore(sheet);
    expect(finalScore.value, greaterThanOrEqualTo(1));
    expect(finalScore.value, lessThanOrEqualTo(7));
  });

  test("should have correct score for person standing straight", () {
    final sheet = RulaSheet(
        shoulderFlexion: Degree.zero,
        shoulderAbduction: Degree.zero,
        elbowFlexion: Degree.zero,
        wristFlexion: Degree.zero,
        neckFlexion: Degree.zero,
        neckRotation: Degree.zero,
        neckLateralFlexion: Degree.zero,
        hipFlexion: Degree.zero,
        trunkRotation: Degree.zero,
        trunkLateralFlexion: Degree.zero,
        isStandingOnBothLegs: true);

    final finalScore = calcFullRulaScore(sheet);

    expect(finalScore.value, equals(2));
  });

  test("should have correct score for person picking something off ground", () {
    final sheet = RulaSheet(
        shoulderFlexion: Degree.makeFrom180(80),
        shoulderAbduction: Degree.zero,
        elbowFlexion: Degree.zero,
        wristFlexion: Degree.zero,
        neckFlexion: Degree.makeFrom180(15),
        neckRotation: Degree.zero,
        neckLateralFlexion: Degree.zero,
        hipFlexion: Degree.makeFrom180(65),
        trunkRotation: Degree.zero,
        trunkLateralFlexion: Degree.zero,
        isStandingOnBothLegs: true);

    final finalScore = calcFullRulaScore(sheet);

    expect(finalScore.value, equals(4));
  });

  test("should have correct score for person lifting something above head", () {
    final sheet = RulaSheet(
        shoulderFlexion: Degree.makeFrom180(120),
        shoulderAbduction: Degree.zero,
        elbowFlexion: Degree.makeFrom180(80),
        wristFlexion: Degree.zero,
        neckFlexion: Degree.makeFrom180(-30),
        neckRotation: Degree.zero,
        neckLateralFlexion: Degree.zero,
        hipFlexion: Degree.zero,
        trunkRotation: Degree.zero,
        trunkLateralFlexion: Degree.zero,
        isStandingOnBothLegs: true);

    final finalScore = calcFullRulaScore(sheet);

    expect(finalScore.value, equals(5));
  });
}
