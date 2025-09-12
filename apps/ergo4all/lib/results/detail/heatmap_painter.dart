import 'package:ergo4all/common/rula_color.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

/// Custom heatmap painter for body parts overview visualization
class HeatmapPainter extends CustomPainter {
  /// Creates a heatmap painter
  HeatmapPainter({
    required this.normalizedScores,
    this.activityFilter,
  });

  /// Normalized scores to be displayed. These are expected to be in the range
  /// [0; 1].
  final IList<double> normalizedScores;

  /// Optional activity filter mask. If provided, scores at indices where
  /// the filter is false will be rendered with reduced opacity.
  final IList<bool>? activityFilter;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final cellWidth = size.width / normalizedScores.length;

    for (var i = 0; i < normalizedScores.length; i++) {
      final value = normalizedScores[i];
      final baseColor = RulaColor.forScore(value);
      
      // Apply opacity based on activity filter
      final shouldMute = activityFilter != null && 
                        i < activityFilter!.length && 
                        !activityFilter![i];
      
      paint.color = shouldMute 
          ? baseColor.withValues(alpha: 0.15) 
          : baseColor; 
          
      canvas.drawRect(
        Rect.fromLTWH(i * cellWidth, 0, cellWidth, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(HeatmapPainter oldDelegate) => false;
}
