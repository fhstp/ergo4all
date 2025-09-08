import 'package:ergo4all/common/rula_session.dart';
import 'package:pose/pose.dart';
import 'package:pose_analysis/pose_analysis.dart';
import 'package:pose_transforming/normalization.dart';
import 'package:pose_transforming/pose_2d.dart';
import 'package:rula/rula.dart';

/// Extensions for calculating rula sheet from pose.
extension ToSheetExt on Pose {
  /// Calculates the [RulaSheet] from the angles in this [Pose].
  RulaSheet toRulaSheet() {
    final normalized = normalizePose(this);
    final sagittal = make2dSagittalPose(normalized);
    final coronal = make2dCoronalPose(normalized);
    final transverse = make2dTransversePose(normalized);
    final angles = calculateAngles(this, coronal, sagittal, transverse);

    final sheet = rulaSheetFromAngles(angles);
    return sheet;
  }
}

/// process the extractedFrames signal to select the 5 most relevant peaks.
List<int> findTop5Peaks(List<KeyFrame> frames) {
  if (frames.isEmpty) return [];

  // remove first second keyframes as model can be unstable during this first second
  final firstKeyFrame = frames.first;
  final lastKeyFrame = frames.last;
  if (lastKeyFrame.timestamp - firstKeyFrame.timestamp > 1000) {
    frames.removeWhere((keyFrame) => keyFrame.timestamp <= firstKeyFrame.timestamp + 1000);
  }

  // Step 1: Smooth the signal
  final smoothed = <double>[];
  for (var i = 0; i < frames.length; i++) {
    final start = (i - 2).clamp(0, frames.length - 1);
    final end = (i + 2).clamp(0, frames.length - 1);

    final window = frames.sublist(start, end + 1).map((e) => e.score);
    smoothed.add(window.reduce((a, b) => a + b) / window.length);
  }

  // Step 2: Peak finding
  final peakIndices = <int>[];
  int? peakIndex;
  double? peakValue;
  final baseline = smoothed.reduce((a, b) => a + b) / smoothed.length;

  for (var i = 0; i < smoothed.length; i++) {
    final value = smoothed[i];

    if (value > baseline) {
      if (peakValue == null || value > peakValue) {
        peakIndex = i;
        peakValue = value;
      }
    } else if (value < baseline && peakIndex != null) {
      peakIndices.add(peakIndex);
      peakIndex = null;
      peakValue = null;
    }
  }

  if (peakIndex != null) {
    peakIndices.add(peakIndex);
  }

  // Ensure at least one peak (max absolute score) if list is empty
  if (peakIndices.isEmpty) {
    var maxIndex = 0;
    var maxAbsScore = frames[0].score.abs();
    for (var i = 1; i < frames.length; i++) {
      final absScore = frames[i].score.abs();
      if (absScore > maxAbsScore) {
        maxAbsScore = absScore;
        maxIndex = i;
      }
    }
    peakIndices.add(maxIndex);
  }

  // Step 3: Sort by score (absolute) and pick top 5
  peakIndices.sort(
    (a, b) => frames[b].score.abs().compareTo(frames[a].score.abs()),
  );

  return peakIndices.take(5).toList();
}
