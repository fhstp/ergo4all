/// Determines whether a person is standing stably, by comparing their inner
/// knee angle and the angle between the torso and upper leg. If these
/// angles are similar (<= [angleThreshold]) then the person is standing well.
bool calcIsStanding(
  double kneeAngle,
  double hipAngle, {
  required double angleThreshold,
}) {
  final leftDiff = (hipAngle - kneeAngle).abs();
  return leftDiff <= angleThreshold;
}
