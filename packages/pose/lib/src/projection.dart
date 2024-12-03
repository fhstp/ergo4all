import 'package:common/immutable_collection_ext.dart';
import 'package:pose/src/types.dart';
import 'package:vector_math/vector_math.dart';

Landmark Function(Landmark) _projectLandmarkUsingPlane(
    Vector3 pointOnPlane, Vector3 planeNormal) {
  return (landmark) {
    final point = posOf(landmark);
    final pointToPlane = point - pointOnPlane;
    final dotProduct = pointToPlane.dot(planeNormal);
    final projection = point - planeNormal * dotProduct;
    return (projection, visibilityOf(landmark));
  };
}

/// Projects the given [Pose], which is assumed to be in 3D world-space, onto the coronal and sagittal planes.
(Pose coronal, Pose sagittal) projectOnAnatomicalPlanes(Pose pose3D) {
  // Extract key points from pose
  final neck = posOf(pose3D[KeyPoints.midNeck]!);
  final leftHip = posOf(pose3D[KeyPoints.leftHip]!);
  final rightHip = posOf(pose3D[KeyPoints.rightHip]!);
  final midHip = posOf(pose3D[KeyPoints.midPelvis]!);

  // Define the coronal plane by calculating 2 vectors from the neck key-point to each hip
  final neckToLeftHip = leftHip - neck;
  final neckToRightHip = rightHip - neck;
  // Calculate cross product between the vectors to get the normal of the coronal plane (person forward vector)
  final forward = neckToLeftHip.cross(neckToRightHip).normalized();

  final coronal = pose3D.mapValues(_projectLandmarkUsingPlane(neck, forward));

  // Calculate vector connecting mid hip and neck
  final up = neck - midHip;

  // We can now define the normal of the sagittal plane by a cross product of these vectors
  final right = up.cross(forward).normalized();

  final sagittal = pose3D.mapValues(_projectLandmarkUsingPlane(neck, right));

  return (coronal, sagittal);
}
