import 'package:pose_analysis/pose_analysis.dart';

/// Determines whether a person is standing on both legs based on their
/// [angles]. A person is considered standing when both legs are close to being
/// fully stretched out. You can configure the allowed deviation from a
/// straight line using [angleThreshold].
bool calcIsStanding(PoseAngles angles, {required double angleThreshold}) {
  final left = angles[KeyAngles.kneeFlexionLeft]!;
  final right = angles[KeyAngles.kneeFlexionRight]!;

  return left.abs() <= angleThreshold && right.abs() <= angleThreshold;
}
