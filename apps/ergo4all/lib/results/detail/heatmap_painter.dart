import 'package:ergo4all/results/color_mapper.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

/// Custom heatmap painter for body parts overview visualization
class HeatmapPainter extends CustomPainter {
  /// Creates a heatmap painter
  HeatmapPainter({
    required this.data,
    required this.rows,
    required this.labels,
  });

  /// The data for the heatmap, where each row represents a body part
  final IList<List<double>> data;

  /// The number of body parts / rows in the heatmap
  final int rows;

  /// The labels for each body part
  final List<String> labels;

  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 10.0; // Space between rows
    final availableHeight = size.height - (spacing * (rows - 1));
    final cellHeight = availableHeight / rows;
    final paint = Paint()..style = PaintingStyle.fill;
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );

    // Draw heatmap cells
    for (var row = 0; row < rows; row++) {
      final yOffset = row * (cellHeight + spacing);
      final cellWidth = size.width / data[row].length;

      for (var col = 0; col < data[row].length; col++) {
        final value = data[row][col];
        paint.color = ColorMapper.getColorForValue(value);

        canvas.drawRect(
          Rect.fromLTWH(
            col * cellWidth,
            yOffset,
            cellWidth,
            cellHeight,
          ),
          paint,
        );
      }

      // Add body part labels
      textPainter
        ..text = TextSpan(
          text: labels[row].replaceAll(' ', '\n'),
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        )
        ..layout(maxWidth: 60)
        ..paint(
          canvas,
          Offset(
            -textPainter.width - 8,
            yOffset + (cellHeight - textPainter.height) / 2,
          ),
        );
    }
  }

  @override
  bool shouldRepaint(HeatmapPainter oldDelegate) => false;
}
