import 'dart:math';
import 'dart:typed_data';

import 'package:ergo4all/common/rula_session.dart';
import 'package:ergo4all/common/utils.dart';
import 'package:ergo4all/results/overview/body_score_display.dart';
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

/// Helper class that has the logic to detect the peak keyframes online
class OnlinePeakDetector {
  final int windowSize;
  final int topK;
  final double thresholdFactor; // e.g. 1.2 means 20% above baseline

  final List<KeyFrame> _recentFrames = [];
  final List<KeyFrame> _topPeaks = [];

  OnlinePeakDetector({
    this.windowSize = 21,
    this.topK = 5,
    this.thresholdFactor = 1.05,
  });

  void addFrame(RulaScores scores, Uint8List screenshot, int timestamp) {

    final scoreList = bodyPartsInDisplayOrder.map((part) {
      return getNormalizedScoreForPart(part, scores);
    }).toList();

    final fullScoreNormalize = normalizeScore(scores.fullScore, 7);
    final finalScore = fullScoreNormalize * 0.7 + scoreList.reduce(max) * 0.3;

    final frame = KeyFrame(finalScore, screenshot, timestamp);

    _recentFrames.add(frame);
    if (_recentFrames.length > windowSize) {
      _recentFrames.removeAt(0);
    }

    if (_recentFrames.length == windowSize) {
      final midIndex = windowSize ~/ 2;
      final midFrame = _recentFrames[midIndex];
      final midScore = midFrame.score;

      final windowScores = _recentFrames.map((f) => f.score).toList();
      final windowMax = windowScores.reduce((a, b) => a > b ? a : b);
      final baseline = windowScores.reduce((a, b) => a + b) / windowScores.length;

      if (midScore == windowMax && midScore > baseline * thresholdFactor) {
        _maybeStore(midFrame);
      }
    }
  }

  void _maybeStore(KeyFrame peak) {
    // Check if there’s a peak within 3 seconds (3000 ms)
    final nearby = _topPeaks.where(
          (p) => (peak.timestamp - p.timestamp).abs() < 3000,
    );

    if (nearby.isNotEmpty) {
      // Compare with the strongest nearby peak
      final strongestNearby = nearby.reduce(
            (a, b) => a.score.abs() >= b.score.abs() ? a : b,
      );

      if (peak.score.abs() > strongestNearby.score.abs()) {
        // Replace the weaker nearby peak with this stronger one
        _topPeaks.remove(strongestNearby);
        _topPeaks.add(peak);
      }
    } else {
      // No nearby peak, just add it
      _topPeaks.add(peak);
    }

    // Always keep only topK globally
    _topPeaks.sort((a, b) => b.score.abs().compareTo(a.score.abs()));
    if (_topPeaks.length > topK) {
      _topPeaks.removeLast();
    }
  }

  List<KeyFrame> get topPeaks {
    if (_topPeaks.isEmpty && _recentFrames.isNotEmpty) {
      // fallback: return the max score frame from recent window
      final fallback = _recentFrames.reduce(
            (a, b) => a.score.abs() >= b.score.abs() ? a : b,
      );
      return [fallback];
    }
    return List.unmodifiable(_topPeaks);
  }
}

