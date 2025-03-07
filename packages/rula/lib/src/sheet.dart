import 'package:flutter/foundation.dart';
import 'package:rula/src/degree.dart';

/// Contains input data for filling out a Rula Sheet. Each field on this class
/// corresponds to a point on the sheet.
///
/// The following points are currently not included.
///
///  - Whether the person is leaning on something (1)
///  - Elbow varus-valgus angle (2a)
///  - Wrist ulnar-radial deviation (3a)
///  - Forearm pronation-supination (4)
@immutable
class RulaSheet {
  /// Creates an instance of the [RulaSheet] class with th given parameters.
  /// Angles will be clamped into sensible ranges.
  ///
  /// For points where there are two input values (such as for the arms), you
  /// should always provide the bigger one.
  RulaSheet({
    required this.shoulderFlexion,
    required Degree shoulderAbduction,
    required Degree elbowFlexion,
    required this.wristFlexion,
    required Degree neckFlexion,
    required this.neckRotation,
    required Degree neckLateralFlexion,
    required Degree hipFlexion,
    required this.trunkRotation,
    required Degree trunkLateralFlexion,
    required this.isStandingOnBothLegs,
  })  : shoulderAbduction = shoulderAbduction.clamp(0, 179),
        elbowFlexion = elbowFlexion.clamp(0, 179),
        neckFlexion = neckFlexion.clamp(-90, 90),
        neckLateralFlexion = neckLateralFlexion.clamp(-90, 90),
        hipFlexion = hipFlexion.clamp(0, 179),
        trunkLateralFlexion = trunkLateralFlexion.clamp(-90, 90);

  /// The flexion angle of the upper arm. 0 is considered pointing straight
  /// down. Negative values indicate hyperextension, while positive ones
  /// indicate flexion. Corresponds to point 1.
  final Degree shoulderFlexion;

  /// The  abduction angle of the upper arm. 0 is considered pointing straight
  /// down. Positive values indicate abduction. Range is [0, 180[. Corresponds
  /// to point 1a.
  final Degree shoulderAbduction;

  /// The flexion angle of the lower arm. 0 is considered pointing in parallel
  /// with the upper arm. Positive values indicate flexion. Range is [0, 180[.
  /// Corresponds to point 2.
  final Degree elbowFlexion;

  /// The flexion angle of the wrist. 0 indicates a wrist in parallel with the
  /// lower arm. Negative values indicate extension while positive ones
  /// indicate flexion. Corresponds to point 3.
  final Degree wristFlexion;

  /// The flexion angle of the neck. 0 indicates a neck in parallel with the
  /// torso. Positive values indicate flexion while negative ones indicate
  /// extension. Range is [-90, 90] Corresponds to point 6.
  final Degree neckFlexion;

  /// The twisting angle of the neck. 0 indicates looking straight ahead.
  /// Positive values indicate twisting left and negative ones right.
  /// Corresponds to point 6a.
  final Degree neckRotation;

  /// The side-to-side flexion angle of the neck. 0 flexion to the left and
  /// negative to the right. Range is [-90, 90]. Corresponds to point 6a.
  final Degree neckLateralFlexion;

  /// The flexion angle of the torso. 0 indicates a torso in line with the
  /// legs. Positive values indicate bending forward. Range is [0, 180[.
  /// Corresponds to point 7.
  final Degree hipFlexion;

  /// The twisting angle of the trunk. 0 indicates facing straight ahead.
  /// Positive values indicate twisting left and negative ones right.
  /// Corresponds to point 7a.
  final Degree trunkRotation;

  /// The side-to-side flexion angle of the trunk. 0 indicates being in
  /// parallel with the legs. Positive values indicate bending to the left,
  /// while negative ones to the right. Range is [-90, 90]. Corresponds to
  /// point 7a.
  final Degree trunkLateralFlexion;

  /// Indicates whether the person is standing on both legs and distributing
  /// their weight equally. Corresponds to point 8.
  final bool isStandingOnBothLegs;
}
