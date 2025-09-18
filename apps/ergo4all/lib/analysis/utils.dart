import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:ergo4all/common/rula_session.dart';
import 'package:ergo4all/common/utils.dart';
import 'package:ergo4all/results/overview/body_score_display.dart';
import 'package:fpdart/fpdart.dart';
import 'package:image/image.dart' as img;
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
  OnlinePeakDetector({
    this.windowSize = 11,
    this.topK = 5,
    this.thresholdFactor = 1.05,
  });

  final int windowSize;
  final int topK;
  final double thresholdFactor; // e.g. 1.2 means 20% above baseline

  final List<KeyFrameTemp> _recentFrames = [];
  final List<KeyFrameTemp> _topPeaks = [];

  void addFrame(
    RulaScores scores,
    RawFrame screenshot,
    int timestamp,
    Option<Pose> pose,
  ) {
    final scoreList = bodyPartsInDisplayOrder.map((part) {
      return getNormalizedScoreForPart(part, scores);
    }).toList();

    final fullScoreNormalize = normalizeScore(scores.fullScore, 7);
    final finalScore = fullScoreNormalize * 0.7 + scoreList.reduce(max) * 0.3;

    final frame = KeyFrameTemp(finalScore, screenshot, timestamp, pose);

    _recentFrames.add(frame);
    if (_recentFrames.length > windowSize) {
      _recentFrames.removeAt(0);
    }

    if (_recentFrames.length == windowSize) {
      final windowScores = _recentFrames.map((f) => f.score).toList();
      final windowMax = windowScores.reduce((a, b) => a > b ? a : b);
      final baseline =
          windowScores.reduce((a, b) => a + b) / windowScores.length;

      if (windowMax > baseline * thresholdFactor) {
        // Get the frame corresponding to the max score
        final peakFrame = _recentFrames.firstWhere((f) => f.score == windowMax);
        _maybeStore(peakFrame);
      }
    }
  }

  void _maybeStore(KeyFrameTemp peak) {
    // Check if there’s a peak within 2.5 seconds (2500 ms)
    final nearby = _topPeaks.where(
      (p) => (peak.timestamp - p.timestamp).abs() < 2500,
    );

    if (nearby.isNotEmpty) {
      // Compare with the strongest nearby peak
      final strongestNearby = nearby.reduce(
        (a, b) => a.score.abs() >= b.score.abs() ? a : b,
      );

      if (peak.score.abs() > strongestNearby.score.abs()) {
        // Replace the weaker nearby peak with this stronger one
        _topPeaks
          ..remove(strongestNearby)
          ..add(peak);
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
      final image = convertFrame(fallback.frame, fallback.pose);
      return [KeyFrame(fallback.score, image, fallback.timestamp)];
    }
    _topPeaks.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final finalTopPeaks = _topPeaks.map(
      (peak) => KeyFrame(
        peak.score,
        convertFrame(peak.frame, peak.pose),
        peak.timestamp,
      ),
    );
    return List.unmodifiable(finalTopPeaks);
  }

  Uint8List convertFrame(RawFrame frame, Option<Pose> pose) {
    return switch (frame.format) {
      ImageFormatGroup.jpeg => frame.bytes,
      ImageFormatGroup.yuv420 => _yuv420ToJpeg(frame, pose, rotate90: true),
      ImageFormatGroup.bgra8888 => _bgra8888ToJpeg(frame, pose),
      ImageFormatGroup.nv21 => _nv21ToJpeg(frame, pose, rotate90: true),
      _ => throw UnsupportedError('Unsupported format: ${frame.format}')
    };
  }

  Uint8List _yuv420ToJpeg(
    RawFrame frame,
    Option<Pose> pose, {
    bool rotate90 = false,
  }) {
    final width = frame.width;
    final height = frame.height;

    final imgBuffer = img.Image(
      width: rotate90 ? height : width,
      height: rotate90 ? width : height,
    );

    final bytes = frame.bytes;
    final rowStride = frame.bytesPerRow;
    final pixelStride = frame.bytesPerPixel;

    // Split planes back from concatenated buffer
    var offset = 0;
    final yPlane = bytes.sublist(offset, offset += rowStride[0] * height);
    final uPlane =
        bytes.sublist(offset, offset += rowStride[1] * (height ~/ 2));
    final vPlane =
        bytes.sublist(offset, offset += rowStride[2] * (height ~/ 2));

    final uvRowStride = rowStride[1];
    final uvPixelStride = pixelStride[1]!;

    for (var y = 0; y < height; y++) {
      final uvRow = uvRowStride * (y >> 1);
      for (var x = 0; x < width; x++) {
        final uvIndex = uvRow + (x >> 1) * uvPixelStride;

        final yp = yPlane[y * rowStride[0] + x];
        final up = uPlane[uvIndex];
        final vp = vPlane[uvIndex];

        final r = (yp + (1.370705 * (vp - 128))).round();
        final g =
            (yp - (0.337633 * (up - 128)) - (0.698001 * (vp - 128))).round();
        final b = (yp + (1.732446 * (up - 128))).round();

        // Flip rotation direction
        final px = rotate90 ? (height - y - 1) : x;
        final py = rotate90 ? x : y;

        imgBuffer.setPixelRgba(
          px,
          py,
          r.clamp(0, 255),
          g.clamp(0, 255),
          b.clamp(0, 255),
          255,
        );
      }
    }

    paintSkeleton(imgBuffer, pose, width, height);

    return Uint8List.fromList(img.encodeJpg(imgBuffer));
  }

  Uint8List _bgra8888ToJpeg(
    RawFrame frame,
    Option<Pose> pose, {
    bool rotate90 = false,
  }) {
    final width = frame.width;
    final height = frame.height;

    final src = img.Image.fromBytes(
      width: width,
      height: height,
      bytes: frame.bytes.buffer,
      order: img.ChannelOrder.bgra,
    );

    final rotated = rotate90 ? img.copyRotate(src, angle: -90) : src;

    // Step 3: Draw a skeleton
    paintSkeleton(rotated, pose, width, height);

    return Uint8List.fromList(img.encodeJpg(rotated));
  }

  Uint8List _nv21ToJpeg(
    RawFrame frame,
    Option<Pose> pose, {
    bool rotate90 = false,
  }) {
    final width = frame.width;
    final height = frame.height;

    final imgBuffer = img.Image(
      width: rotate90 ? height : width,
      height: rotate90 ? width : height,
    );

    final yuv = frame.bytes;
    final frameSize = width * height;

    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        final yp = yuv[y * width + x] & 0xFF;
        final uvIndex = frameSize + (y >> 1) * width + (x & ~1);
        final v = yuv[uvIndex] & 0xFF;
        final u = yuv[uvIndex + 1] & 0xFF;

        final r = (yp + 1.370705 * (v - 128)).round();
        final g = (yp - 0.337633 * (u - 128) - 0.698001 * (v - 128)).round();
        final b = (yp + 1.732446 * (u - 128)).round();

        // Flip rotation direction
        final px = rotate90 ? (height - y - 1) : x;
        final py = rotate90 ? x : y;

        imgBuffer.setPixelRgba(
          px,
          py,
          r.clamp(0, 255),
          g.clamp(0, 255),
          b.clamp(0, 255),
          255,
        );
      }
    }

    paintSkeleton(imgBuffer, pose, width, height);

    return Uint8List.fromList(img.encodeJpg(imgBuffer));
  }

  void paintSkeleton(
    img.Image imgBuffer,
    Option<Pose> pose,
    int width,
    int height,
  ) {
    pose.match(
      () {},
      (pose) {
        (int, int) tryGetPosOf(KeyPoints keyPoint) {
          final landmark = pose[keyPoint]!;
          final position = posOf(landmark).xy;
          return (
            (width * (position.x / width)).round(),
            (height * (position.y / height)).round(),
          );
        }

        void drawBone((KeyPoints, KeyPoints) bone) {
          final (from, to) = bone;
          final fromPos = tryGetPosOf(from);
          final toPos = tryGetPosOf(to);

          final color = img.ColorRgb8(103, 146, 182);
          img.drawLine(
            imgBuffer,
            x1: fromPos.$1,
            y1: fromPos.$2,
            x2: toPos.$1,
            y2: toPos.$2,
            color: color,
            thickness: 5,
          );
        }

        [
          (KeyPoints.rightWrist, KeyPoints.rightElbow),
          (KeyPoints.leftWrist, KeyPoints.leftElbow),
          (KeyPoints.rightElbow, KeyPoints.rightShoulder),
          (KeyPoints.rightWrist, KeyPoints.rightPalm),
          (KeyPoints.leftElbow, KeyPoints.leftShoulder),
          (KeyPoints.leftWrist, KeyPoints.leftPalm),
          (KeyPoints.rightShoulder, KeyPoints.leftShoulder),
          (KeyPoints.rightShoulder, KeyPoints.rightHip),
          (KeyPoints.leftShoulder, KeyPoints.leftHip),
          (KeyPoints.rightHip, KeyPoints.leftHip),
          (KeyPoints.rightHip, KeyPoints.rightKnee),
          (KeyPoints.leftHip, KeyPoints.leftKnee),
          (KeyPoints.rightKnee, KeyPoints.rightAnkle),
          (KeyPoints.leftKnee, KeyPoints.leftAnkle),
          (KeyPoints.midNeck, KeyPoints.midPelvis),
          (KeyPoints.midNeck, KeyPoints.midHead),
          (KeyPoints.midHead, KeyPoints.nose),
          (KeyPoints.midHead, KeyPoints.leftEar),
          (KeyPoints.midHead, KeyPoints.rightEar),
        ].forEach(drawBone);
      },
    );
  }
}

class KeyFrameTemp {
  /// KeyFrame init
  const KeyFrameTemp(this.score, this.frame, this.timestamp, this.pose);

  /// KeyFrame full score
  final double score;

  /// keyFrame screenshot
  final RawFrame frame;

  /// KeyFrame timestamp (when it was recorded)
  final int timestamp;

  final Option<Pose> pose;
}

class RawFrame {
  RawFrame({
    required this.bytes,
    required this.width,
    required this.height,
    required this.format,
    required this.bytesPerRow,
    required this.bytesPerPixel,
  });

  final Uint8List bytes;
  final int width;
  final int height;
  final ImageFormatGroup format;
  final List<int> bytesPerRow;
  final List<int?> bytesPerPixel;
}
