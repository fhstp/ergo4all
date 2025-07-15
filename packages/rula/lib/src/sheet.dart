import 'package:common/pair_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:rula/src/degree.dart';

final _clampRightAngle = clampDegree(-90, 90);

final _clampStraightLine = clampDegree(0, 179);

/// A pair of [Degree] used for body parts of which there are two.
typedef DegreePair = (Degree, Degree);

/// Contains input data for filling out a Rula Sheet. Each field on this class
/// corresponds to a point on the sheet.
///
/// The following points are currently not included.
///
///  - Whether the person is leaning on something (1)
///  - Elbow varus-valgus angle (2a)
///  - Wrist ulnar-radial deviation (3a)
///  - Forearm pronation-supination (4)
///
/// We do track point 8 (stable standing), but use our own heuristic, since
/// the Rula sheet does not provide one.
@immutable
class RulaSheet {
  /// Creates an instance of the [RulaSheet] class with th given parameters.
  /// Angles will be clamped into sensible ranges.
  RulaSheet({
    required this.shoulderFlexion,
    required DegreePair shoulderAbduction,
    required DegreePair elbowFlexion,
    required this.wristFlexion,
    required Degree neckFlexion,
    required this.neckRotation,
    required Degree neckLateralFlexion,
    required Degree hipFlexion,
    required this.trunkRotation,
    required Degree trunkLateralFlexion,
    required this.legAngleDiff,
  })  : shoulderAbduction = Pair.map(_clampStraightLine)(shoulderAbduction),
        elbowFlexion = Pair.map(_clampStraightLine)(elbowFlexion),
        neckFlexion = _clampRightAngle(neckFlexion),
        neckLateralFlexion = _clampRightAngle(neckLateralFlexion),
        hipFlexion = _clampStraightLine(hipFlexion),
        trunkLateralFlexion = _clampRightAngle(trunkLateralFlexion);

  /// The flexion angle of the upper arm. 0 is considered pointing straight
  /// down. Negative values indicate hyperextension, while positive ones
  /// indicate flexion. Corresponds to point 1.
  final DegreePair shoulderFlexion;

  /// The  abduction angle of the upper arm. 0 is considered pointing straight
  /// down. Positive values indicate abduction. Range is [0, 180[. Corresponds
  /// to point 1a.
  final DegreePair shoulderAbduction;

  /// The flexion angle of the lower arm. 0 is considered pointing in parallel
  /// with the upper arm. Positive values indicate flexion. Range is [0, 180[.
  /// Corresponds to point 2.
  final DegreePair elbowFlexion;

  /// The flexion angle of the wrist. 0 indicates a wrist in parallel with the
  /// lower arm. Negative values indicate extension while positive ones
  /// indicate flexion. Corresponds to point 3.
  final DegreePair wristFlexion;

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

  /// The difference between the inner angle of the knee and the angle between
  /// trunk and upper leg. We use the difference between these angles to
  /// score how 'stably' a person is standing.
  final DegreePair legAngleDiff;
}
