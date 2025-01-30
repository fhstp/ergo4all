import 'package:pose/pose.dart';

/// Determines whether a person is standing on both legs based on their [angles]. A person is considered standing when both legs are close to being fully stretched out. You can configure the allowed deviation from a straight line using [angleThreshold].
bool calcIsStanding(PoseAngles angles, {double angleThreshold = 10}) {
  final left = angles[KeyAngles.kneeFlexionLeft]!;
  final right = angles[KeyAngles.kneeFlexionRight]!;

  return left.abs() <= angleThreshold && right.abs() <= angleThreshold;
}
