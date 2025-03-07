import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart'
    as mlkit;
import 'package:pose/src/types.dart';
import 'package:vector_math/vector_math.dart';

/// Converts an [mlkit.Pose] to a domain [Pose].
Pose convertMlkitPose(mlkit.Pose pose) {
  Landmark single(mlkit.PoseLandmarkType type) {
    final landmark = pose.landmarks[type]!;
    return (Vector3(landmark.x, landmark.y, landmark.z), landmark.likelihood);
  }

  Landmark average(Iterable<mlkit.PoseLandmarkType> types) {
    final landmarks = types.map(single).toISet();
    final sum = landmarks.reduce(
      (acc, it) =>
          (posOf(acc) + posOf(it), visibilityOf(acc) + visibilityOf(it)),
    );
    return (
      posOf(sum) / landmarks.length.toDouble(),
      visibilityOf(sum) / landmarks.length
    );
  }

  return IMap.fromKeys(
    keys: KeyPoints.values,
    valueMapper: (keyPoint) {
      return switch (keyPoint) {
        KeyPoints.leftShoulder => single(mlkit.PoseLandmarkType.leftShoulder),
        KeyPoints.midNeck => average([
            mlkit.PoseLandmarkType.leftShoulder,
            mlkit.PoseLandmarkType.rightShoulder,
          ]),
        KeyPoints.rightShoulder => single(mlkit.PoseLandmarkType.rightShoulder),
        KeyPoints.leftElbow => single(mlkit.PoseLandmarkType.leftElbow),
        KeyPoints.rightElbow => single(mlkit.PoseLandmarkType.rightElbow),
        KeyPoints.leftWrist => single(mlkit.PoseLandmarkType.leftWrist),
        KeyPoints.rightWrist => single(mlkit.PoseLandmarkType.rightWrist),
        KeyPoints.leftPalm => average([
            mlkit.PoseLandmarkType.leftPinky,
            mlkit.PoseLandmarkType.leftIndex,
          ]),
        KeyPoints.rightPalm => average([
            mlkit.PoseLandmarkType.rightPinky,
            mlkit.PoseLandmarkType.rightIndex,
          ]),
        KeyPoints.leftHip => single(mlkit.PoseLandmarkType.leftHip),
        KeyPoints.midPelvis => average([
            mlkit.PoseLandmarkType.leftHip,
            mlkit.PoseLandmarkType.rightHip,
          ]),
        KeyPoints.rightHip => single(mlkit.PoseLandmarkType.rightHip),
        KeyPoints.leftKnee => single(mlkit.PoseLandmarkType.leftKnee),
        KeyPoints.rightKnee => single(mlkit.PoseLandmarkType.rightKnee),
        KeyPoints.leftAnkle => single(mlkit.PoseLandmarkType.leftAnkle),
        KeyPoints.rightAnkle => single(mlkit.PoseLandmarkType.rightAnkle),
        KeyPoints.leftEar => single(mlkit.PoseLandmarkType.leftEar),
        KeyPoints.midHead => average([
            mlkit.PoseLandmarkType.leftEar,
            mlkit.PoseLandmarkType.rightEar,
          ]),
        KeyPoints.rightEar => single(mlkit.PoseLandmarkType.rightEar),
        KeyPoints.nose => single(mlkit.PoseLandmarkType.nose)
      };
    },
  );
}
