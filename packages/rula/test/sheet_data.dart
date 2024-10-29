import 'package:glados/glados.dart';
import 'package:rula/degree.dart';
import 'package:rula/sheet.dart';

import 'degree_data.dart';

Generator<Degree> _shoulderFlexion = any.degree;
Generator<Degree> _shoulderAbduction = any.degreeInRange(0, 180);
Generator<Degree> _elbowFlexion = any.degreeInRange(0, 180);
Generator<Degree> _wristFlexion = any.degree;
Generator<Degree> _neckFlexion = any.degreeInRange(-90, 90);
Generator<Degree> _neckRotation = any.degree;
Generator<Degree> _neckLateralFlexion = any.degreeInRange(-90, 90);
Generator<Degree> _hipFlexion = any.degreeInRange(0, 180);
Generator<Degree> _trunkRotation = any.degree;
Generator<Degree> _trunkLateralFlexion = any.degreeInRange(-90, 90);

Generator<(Degree, Degree)> _shoulderAngles =
    any.combine2(_shoulderFlexion, _shoulderAbduction, (a, b) => (a, b));

Generator<(Degree, Degree)> _armAngles =
    any.combine2(_elbowFlexion, _wristFlexion, (a, b) => (a, b));

Generator<(Degree, Degree, Degree)> _neckAngles = any.combine3(
    _neckFlexion, _neckRotation, _neckLateralFlexion, (a, b, c) => (a, b, c));

Generator<(Degree, Degree, Degree)> _trunkAngles = any.combine3(
    _hipFlexion, _trunkRotation, _trunkLateralFlexion, (a, b, c) => (a, b, c));

extension AnyRulaSheet on Any {
  /// Generates a valid [RulaSheet].
  Generator<RulaSheet> get rulaSheet => any.combine5(
      _shoulderAngles,
      _armAngles,
      _neckAngles,
      _trunkAngles,
      any.bool,
      (shoulderAngles, armAngles, neckAngles, trunkAngles,
              isStrandingOnBothLegs) =>
          RulaSheet(
              shoulderFlexion: shoulderAngles.$1,
              shoulderAbduction: shoulderAngles.$2,
              elbowFlexion: armAngles.$1,
              wristFlexion: armAngles.$2,
              neckFlexion: neckAngles.$1,
              neckRotation: neckAngles.$2,
              neckLateralFlexion: neckAngles.$3,
              hipFlexion: trunkAngles.$1,
              trunkRotation: trunkAngles.$2,
              trunkLateralFlexion: trunkAngles.$3,
              isStandingOnBothLegs: isStrandingOnBothLegs));
}
