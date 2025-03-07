import 'package:glados/glados.dart';
import 'package:rula/src/degree.dart';
import 'package:rula/src/sheet.dart';

import 'degree_data.dart';

void main() {
  group('Creation', () {
    /// Makes a test [RulaSheet] where all values have defaults except the ones
    /// specified.
    RulaSheet makeTestSheet({
      Degree shoulderFlexion = Degree.zero,
      Degree shoulderAbduction = Degree.zero,
      Degree elbowFlexion = Degree.zero,
      Degree wristFlexion = Degree.zero,
      Degree neckFlexion = Degree.zero,
      Degree neckRotation = Degree.zero,
      Degree neckLateralFlexion = Degree.zero,
      Degree hipFlexion = Degree.zero,
      Degree trunkRotation = Degree.zero,
      Degree trunkLateralFlexion = Degree.zero,
      bool isStandingOnBothLegs = true,
    }) {
      return RulaSheet(
        shoulderFlexion: shoulderFlexion,
        shoulderAbduction: shoulderAbduction,
        elbowFlexion: elbowFlexion,
        wristFlexion: wristFlexion,
        neckFlexion: neckFlexion,
        neckRotation: neckRotation,
        neckLateralFlexion: neckLateralFlexion,
        hipFlexion: hipFlexion,
        trunkRotation: trunkRotation,
        trunkLateralFlexion: trunkLateralFlexion,
        isStandingOnBothLegs: isStandingOnBothLegs,
      );
    }

    Glados(any.degree).test('should clamp shoulder abduction to [0; 180[ range',
        (shoulderAbduction) {
      final sheet = makeTestSheet(shoulderAbduction: shoulderAbduction);

      expect(sheet.shoulderAbduction.value, greaterThanOrEqualTo(0));
      expect(sheet.shoulderAbduction.value, lessThan(180));
    });

    Glados(any.degree).test('should clamp elbow flexion to [0; 180[ range',
        (elbowFlexion) {
      final sheet = makeTestSheet(elbowFlexion: elbowFlexion);

      expect(sheet.elbowFlexion.value, greaterThanOrEqualTo(0));
      expect(sheet.elbowFlexion.value, lessThan(180));
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
