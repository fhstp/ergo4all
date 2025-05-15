import 'package:ergo4all/results/color_mapper.dart';
import 'package:flutter/material.dart';

/// Custom heatmap painter for body parts overview visualization
class HeatmapPainter extends CustomPainter {
  /// Creates a heatmap painter
  HeatmapPainter({
    required this.normalizedScores,
  });

  /// Normalized scores to be displayed. These are expected to be in the range
  /// [0; 1].
  final List<double> normalizedScores;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    final cellWidth = size.width / normalizedScores.length;

    for (var i = 0; i < normalizedScores.length; i++) {
      final value = normalizedScores[i];
      paint.color = ColorMapper.getColorForValue(value);

      canvas.drawRect(
        Rect.fromLTWH(i * cellWidth, 0, cellWidth, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(HeatmapPainter oldDelegate) => false;
}
