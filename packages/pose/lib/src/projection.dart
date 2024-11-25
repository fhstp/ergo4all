import 'package:common/immutable_collection_ext.dart';
import 'package:pose/src/types.dart';
import 'package:vector_math/vector_math.dart';

Landmark Function(Landmark) _projectLandmarkUsing(Matrix4 matrix) {
  return (landmark) {
    final worldPos = worldPosOf(landmark);
    final projectedPos = Vector3.copy(worldPos);
    Matrix4.solve3(matrix, worldPos, projectedPos);
    return (projectedPos, visibilityOf(landmark));
  };
}

/// Projects the given [Pose], which is assumed to be in 3D world-space, onto the coronal and sagittal planes.
(Pose coronal, Pose sagittal) projectOnAnatomicalPlanes(Pose pose3D) {
  // Extract key points from pose
  final neck = worldPosOf(pose3D[KeyPoints.midNeck]!);
  final leftHip = worldPosOf(pose3D[KeyPoints.leftHip]!);
  final rightHip = worldPosOf(pose3D[KeyPoints.rightHip]!);
  final midHip = worldPosOf(pose3D[KeyPoints.midPelvis]!);

  // Define the coronal plane by calculating 2 vectors from the neck key-point to each hip
  final neckToLeftHip = leftHip - neck;
  final neckToRightHip = rightHip - neck;
  // Calculate cross product between the vectors to get the normal of the coronal plane (person forward vector)
  final forward = neckToLeftHip.cross(neckToRightHip).normalized();

  final coronalProjection = makePlaneProjection(forward, neck);
  final coronal = pose3D.mapValues(_projectLandmarkUsing(coronalProjection));

  // Calculate vector connecting mid hip and neck
  final up = neck - midHip;

  // We can now define the normal of the sagittal plane by a cross product of these vectors
  final right = up.cross(forward).normalized();

  final sagittalProjection = makePlaneProjection(right, neck);
  final sagittal = pose3D.mapValues(_projectLandmarkUsing(sagittalProjection));

  return (coronal, sagittal);
}
