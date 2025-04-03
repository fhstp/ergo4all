import 'package:common/pair_utils.dart';
import 'package:glados/glados.dart';
import 'package:rula/src/degree.dart';
import 'package:rula/src/sheet.dart';

import 'degree_data.dart';
import 'sheet_data.dart';

void main() {
  group('Creation', () {
    /// Makes a test [RulaSheet] where all values have defaults except the ones
    /// specified.
    RulaSheet makeTestSheet({
      (Degree, Degree)? shoulderFlexion,
      (Degree, Degree)? shoulderAbduction,
      (Degree, Degree)? elbowFlexion,
      (Degree, Degree)? wristFlexion,
      Degree neckFlexion = Degree.zero,
      Degree neckRotation = Degree.zero,
      Degree neckLateralFlexion = Degree.zero,
      Degree hipFlexion = Degree.zero,
      Degree trunkRotation = Degree.zero,
      Degree trunkLateralFlexion = Degree.zero,
      bool isStandingOnBothLegs = true,
    }) {
      return RulaSheet(
        shoulderFlexion: shoulderFlexion ?? Pair.of(Degree.zero),
        shoulderAbduction: shoulderAbduction ?? Pair.of(Degree.zero),
        elbowFlexion: elbowFlexion ?? Pair.of(Degree.zero),
        wristFlexion: wristFlexion ?? Pair.of(Degree.zero),
        neckFlexion: neckFlexion,
        neckRotation: neckRotation,
        neckLateralFlexion: neckLateralFlexion,
        hipFlexion: hipFlexion,
        trunkRotation: trunkRotation,
        trunkLateralFlexion: trunkLateralFlexion,
        isStandingOnBothLegs: isStandingOnBothLegs,
      );
    }

    Glados(any.pairOf(any.degree))
        .test('should clamp shoulder abduction to [0; 180[ range',
            (shoulderAbduction) {
      final sheet = makeTestSheet(shoulderAbduction: shoulderAbduction);

      expect(sheet.shoulderAbduction.$1.value, greaterThanOrEqualTo(0));
      expect(sheet.shoulderAbduction.$1.value, lessThan(180));

      expect(sheet.shoulderAbduction.$2.value, greaterThanOrEqualTo(0));
      expect(sheet.shoulderAbduction.$2.value, lessThan(180));
    });

    Glados(any.pairOf(any.degree))
        .test('should clamp elbow flexion to [0; 180[ range', (elbowFlexion) {
      final sheet = makeTestSheet(elbowFlexion: elbowFlexion);

      expect(sheet.elbowFlexion.$1.value, greaterThanOrEqualTo(0));
      expect(sheet.elbowFlexion.$1.value, lessThan(180));

      expect(sheet.elbowFlexion.$2.value, greaterThanOrEqualTo(0));
      expect(sheet.elbowFlexion.$2.value, lessThan(180));
    });

    Glados(any.degree).test('should clamp neck flexion to [-90; 90[ range',
        (neckFlexion) {
      final sheet = makeTestSheet(neckFlexion: neckFlexion);

      expect(sheet.neckFlexion.value, greaterThanOrEqualTo(-90));
      expect(sheet.neckFlexion.value, lessThanOrEqualTo(90));
    });

    Glados(any.degree)
        .test('should clamp neck lateral flexion to [-90; 90[ range',
            (neckLateralFlexion) {
      final sheet = makeTestSheet(neckLateralFlexion: neckLateralFlexion);

      expect(sheet.neckLateralFlexion.value, greaterThanOrEqualTo(-90));
      expect(sheet.neckLateralFlexion.value, lessThanOrEqualTo(90));
    });

    Glados(any.degree).test('should clamp hip flexion to [0; 180[ range',
        (hipFlexion) {
      final sheet = makeTestSheet(hipFlexion: hipFlexion);

      expect(sheet.hipFlexion.value, greaterThanOrEqualTo(0));
      expect(sheet.hipFlexion.value, lessThan(180));
    });

    Glados(any.degree)
        .test('should clamp trunk lateral flexion to [-90; 90[ range',
            (trunkLateralFlexion) {
      final sheet = makeTestSheet(trunkLateralFlexion: trunkLateralFlexion);

      expect(sheet.trunkLateralFlexion.value, greaterThanOrEqualTo(-90));
      expect(sheet.trunkLateralFlexion.value, lessThanOrEqualTo(90));
    });
  });
}
