import 'package:pose/pose.dart';
import 'package:vector_math/vector_math.dart';

/// Projects the given [NormalizedPose], onto the coronal and sagittal planes. This is done by dropping (setting to 0) relevant coordinate components. For sagittal, we get rid of the x values. For coronal, we drop y.
(Pose coronal, Pose sagittal) projectOnAnatomicalPlanes(NormalizedPose pose3D) {
  final coronal = mapPosePositions(pose3D, (pos) => Vector3(pos.x, 0, pos.z));
  final sagittal = mapPosePositions(pose3D, (pos) => Vector3(0, pos.y, pos.z));

  return (coronal, sagittal);
}
