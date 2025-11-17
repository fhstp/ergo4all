import 'package:common/immutable_collection_ext.dart';
import 'package:common/iterable_ext.dart';
import 'package:pose/pose.dart';

Landmark _addLandmarks(Landmark a, Landmark b) {
  return Landmark(a.position + b.position, a.confidence + b.confidence);
}

Pose _addPoses(Pose a, Pose b) {
  return Pose(
    a.landmarks.map(
      (keyPoint, landmarkA) =>
          MapEntry(keyPoint, _addLandmarks(landmarkA, b[keyPoint])),
    ),
  );
}

Landmark _divideLandmark(Landmark landmark, int i) {
  return Landmark(
    landmark.position / i.toDouble(),
    landmark.confidence / i.toDouble(),
  );
}

Pose _dividePose(Pose pose, int i) {
  return Pose(
    pose.landmarks.mapValues((_, landmark) => _divideLandmark(landmark, i)),
  );
}

/// Averages a collection of poses in order to get a more denoised pose.
Pose averagePoses(Iterable<Pose> poses) {
  return poses.averageUsing(_addPoses, _dividePose);
}
