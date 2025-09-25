import 'dart:async';
import 'package:ergo4all/common/activity.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:pose/pose.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

/// Configuration constants for Human Activity Recognition
class _HarConfig {
  static const stride = 15;
  static const minNumPoses = 45;
  static const temporalDisplacementStride = 5;
  static const onlineInputShape = [1, 40, 17, 4];
  static const onlineModelPath =
      'assets/har/har_tcn_online_inference_temporal_displacement.tflite';
  static const weightingFactors = [0.2, 0.5, 0.3];
}

/// Input data structure for Human Activity Recognition
class _HarPoseEntries {
  const _HarPoseEntries({
    required this.poses,
    required this.poseTimestamps,
  });

  final List<double> poses;
  final List<int> poseTimestamps;
}

/// A list of key-points which are relevant for human activity recognition
/// (HAR).
const IList<KeyPoints> _harKeyPoints = IListConst([
  KeyPoints.nose,
  KeyPoints.leftEar,
  KeyPoints.rightEar,
  KeyPoints.leftShoulder,
  KeyPoints.rightShoulder,
  KeyPoints.leftElbow,
  KeyPoints.rightElbow,
  KeyPoints.leftWrist,
  KeyPoints.rightWrist,
  KeyPoints.leftHip,
  KeyPoints.rightHip,
  KeyPoints.leftKnee,
  KeyPoints.rightKnee,
  KeyPoints.leftAnkle,
  KeyPoints.rightAnkle,
  KeyPoints.leftPalm,
  KeyPoints.rightPalm,
]);

class ActivityRecognitionManager {
  ActivityRecognitionManager() {
    _onlineInferenceInputController.stream
        .listen(_runOnlineActivityRecognitionModel);
  }
  // Stream controllers
  final _onlineInferenceInputController = StreamController<_HarPoseEntries>();
  final onlineInferenceOutputController = StreamController<Activity>();

  // Data storage
  final Map<int, List<List<double>>> _timestampProbabilities = {};
  final List<Pose> _poses = [];
  final List<int> _poseTimestamps = [];
  bool _active = false;

  /// Public API methods
  void activate() => _active = true;

  void addPose(Pose pose, int timestamp) {
    if (_active) {
      _poses.add(pose);
      _poseTimestamps.add(timestamp);
    }
  }

  void _clearStoredProbabilities() => _timestampProbabilities.clear();

  int _getProbabilityCount(int timestamp) =>
      _timestampProbabilities[timestamp]?.length ?? 0;

  /// Finds the index of the maximum value in a list
  int _findMaxIndex(List<double> list) {
    if (list.isEmpty) return 0;

    var maxValue = list[0];
    var maxIndex = 0;

    for (var i = 1; i < list.length; i++) {
      if (list[i] > maxValue) {
        maxValue = list[i];
        maxIndex = i;
      }
    }

    return maxIndex;
  }

  /// Runs online activity recognition model
  Future<void> _runOnlineActivityRecognitionModel(
    _HarPoseEntries harPoseEntries,
  ) async {
    final interpreter = await Interpreter.fromAsset(_HarConfig.onlineModelPath);

    try {
      final outputShape = interpreter.getOutputTensors()[0].shape;
      // ignore lint type warning, since specifying the type makes call fail
      // ignore: inference_failure_on_function_invocation
      final output = List.filled(outputShape.reduce((a, b) => a * b), 0)
          .reshape(outputShape);

      // ignore lint type warning, since specifying the type makes call fail
      // ignore: inference_failure_on_function_invocation
      final inputReshaped =
          harPoseEntries.poses.reshape(_HarConfig.onlineInputShape);
      interpreter.run(inputReshaped, output);

      final probabilityTensors = output[0] as List<double>;
      final currentActivity =
          Activity.values.getOrNull(_findMaxIndex(probabilityTensors));
      onlineInferenceOutputController
          .add(currentActivity ?? Activity.background);

      // Store probabilities for each timestamp
      for (final timestamp in harPoseEntries.poseTimestamps) {
        _timestampProbabilities
            .putIfAbsent(timestamp, () => [])
            .add(probabilityTensors);
      }
    } finally {
      interpreter.close();
    }
  }

  /// Transforms poses to model input format
  List<double> _transformPoses(List<Pose> poses) {
    final poseModelInput = <double>[];
    var maxAbsValue = 0.0;

    // Find maximum absolute value for normalization
    for (final pose in poses) {
      for (final keyPoint in _harKeyPoints) {
        if (pose.containsKey(keyPoint)) {
          final landmark = pose[keyPoint]!.$1;
          maxAbsValue = [maxAbsValue, landmark.y.abs(), landmark.z.abs()]
              .reduce((a, b) => a > b ? a : b);
        }
      }
    }

    if (maxAbsValue == 0.0) maxAbsValue = 1.0; // Avoid division by zero

    // Process poses with temporal displacement
    for (var i = _HarConfig.temporalDisplacementStride; i < poses.length; i++) {
      final currentPose = poses[i];
      final prevPose = poses[i - _HarConfig.temporalDisplacementStride];

      for (final keyPoint in _harKeyPoints) {
        if (currentPose.containsKey(keyPoint) &&
            prevPose.containsKey(keyPoint)) {
          final current = currentPose[keyPoint]!.$1;
          final prev = prevPose[keyPoint]!.$1;

          final normY = current.y / maxAbsValue;
          final normZ = current.z / maxAbsValue;
          final prevNormY = prev.y / maxAbsValue;
          final prevNormZ = prev.z / maxAbsValue;

          poseModelInput.addAll([
            normY,
            normZ,
            normY - prevNormY,
            normZ - prevNormZ,
          ]);
        } else {
          poseModelInput.addAll(List.filled(4, 0));
        }
      }
    }

    return poseModelInput;
  }

  /// Processes current frame of poses
  void processFrame() {
    if (_poses.length != _HarConfig.minNumPoses) return;

    final poseModelInput = _transformPoses(_poses);

    _onlineInferenceInputController.add(
      _HarPoseEntries(
        poses: poseModelInput,
        poseTimestamps: List.from(_poseTimestamps),
      ),
    );

    // Remove processed poses using stride
    _poses.removeRange(0, _HarConfig.stride);
    _poseTimestamps.removeRange(0, _HarConfig.stride);
  }

  /// Computes weighted activities from stored probabilities
  Map<int, Activity> computeWeightedActivities() {
    final weightedActivities = <int, Activity>{};

    for (final entry in _timestampProbabilities.entries) {
      final timestamp = entry.key;
      final probabilityTensors = entry.value;

      final weightingFactors = probabilityTensors.length >= 3
          ? _HarConfig.weightingFactors
          : List.filled(
              probabilityTensors.length,
              1.0 / probabilityTensors.length,
            );

      final numClasses = probabilityTensors[0].length;
      final weightedProbabilities = List<double>.filled(numClasses, 0);

      // Compute weighted sum
      for (var classIndex = 0; classIndex < numClasses; classIndex++) {
        for (var predictionIndex = 0;
            predictionIndex < weightingFactors.length;
            predictionIndex++) {
          weightedProbabilities[classIndex] +=
              weightingFactors[predictionIndex] *
                  probabilityTensors[predictionIndex][classIndex];
        }
      }

      final maxIndex = _findMaxIndex(weightedProbabilities);
      final activity = Activity.values.getOrNull(maxIndex);
      if (activity != null) {
        weightedActivities[timestamp] = activity;
      }
    }

    return weightedActivities;
  }
}
