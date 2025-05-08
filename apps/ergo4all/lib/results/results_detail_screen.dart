import 'dart:math';

import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/body_part_results_screen.dart';
import 'package:ergo4all/results/common.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rula/rula.dart';

/// Manages colors for the RULA score visualization
@immutable
class ColorMapper {
  /// #BFD7EA
  static const rulaLow = Color(0xFFBFD7EA);

  /// #F9F9C4
  static const rulaLowMid = Color(0xFFF9F9C4);

  /// #FFE553
  static const rulaMid = Color(0xFFFFE553);

  /// #FFA259
  static const rulaMidHigh = Color(0xFFFFA259);

  /// #FF5A5F
  static const rulaHigh = Color(0xFFFF5A5F);

  /// Maps normalized RULA score values to colors
  static Color getColorForValue(double value) {
    if (value < 0.20) {
      return rulaLow;
    } else if (value <= 0.40) {
      return rulaLowMid;
    } else if (value <= 0.60) {
      return rulaMid;
    } else if (value <= 0.80) {
      return rulaMidHigh;
    }
    return rulaHigh;
  }
}

class ResultsDetailScreen extends StatefulWidget {
  const ResultsDetailScreen({super.key});

  @override
  State<ResultsDetailScreen> createState() => _ResultsDetailScreenState();
}

class _ResultsDetailScreenState extends State<ResultsDetailScreen> {
  final Random random = Random();

  void _navigateToBodyPartPage(
    String bodyPart,
    List<FlSpot> timelineData,
  ) {
    final timelineColors = timelineData.map((spot) {
      return ColorMapper.getColorForValue(spot.y);
    }).toList();

    final timelineValues = timelineData.map((spot) {
      return spot.y;
    }).toList();

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => BodyPartResultsScreen(
          bodyPart: bodyPart,
          timelineColors: timelineColors,
          timelineValues: timelineValues,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final labels = [
      localizations.results_body_upper_arms,
      localizations.results_body_lower_arms,
      localizations.results_body_trunk,
      localizations.results_body_neck,
      localizations.results_body_legs,
    ];

    final timeline =
        ModalRoute.of(context)!.settings.arguments as RulaTimeline?;

    if (timeline == null || timeline.isEmpty) {
      Navigator.of(context).pop();
      return Container();
    }

    final firstTimestamp = timeline.first.timestamp;
    final lastTimestamp = timeline.last.timestamp;
    final timeRange = lastTimestamp - firstTimestamp;

    double graphXFor(int timestamp) {
      return (timestamp - firstTimestamp) / timeRange;
    }

    List<FlSpot> graphLineFor(
      RulaScore Function(RulaSheet) selector,
      int maxValue,
    ) {
      return timeline.map((entry) {
        final score = selector(entry.sheet);
        final x = graphXFor(entry.timestamp);
        final y = score.normalize(maxValue);
        return FlSpot(x, y);
      }).toList();
    }

    final lineChartData = IList([
      graphLineFor(calcUpperArmScore, 6),
      graphLineFor(calcLowerArmScore, 3),
      graphLineFor(calcTrukScore, 6),
      graphLineFor(calcNeckScore, 6),
      graphLineFor(calcLegScore, 2),
    ]);

    final heatmapHeight = MediaQuery.of(context).size.width * 0.6;
    final heatmapWidth = MediaQuery.of(context).size.width * 0.85;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.results_title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // 'Normalized RULA Score Analysis',
              localizations.results_plot_title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            // Heatmap vis of the body parts
            Center(
              child: SizedBox(
                key: const Key('heatmap'),
                width: heatmapWidth,
                height: heatmapHeight,
                child: Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: GestureDetector(
                    onTapDown: (details) {
                      // Find row of the bar that was tapped
                      final rowHeight = heatmapHeight / labels.length;
                      final rowIndex =
                          (details.localPosition.dy / rowHeight).floor();
                      if (rowIndex >= 0 && rowIndex < labels.length) {
                        _navigateToBodyPartPage(
                          labels[rowIndex],
                          lineChartData[rowIndex],
                        );
                      }
                    },
                    child: CustomPaint(
                      painter: HeatmapPainter(
                        data: lineChartData.map((spots) {
                          return spots.map((spot) => spot.y).toList();
                        }).toList(),
                        rows: labels.length,
                        timestamps:
                            timeline.map((entry) => entry.timestamp).toList(),
                        labels: labels,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Color legend
            Center(
              child: SizedBox(
                height: 50,
                width: heatmapWidth,
                child: Column(
                  children: [
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: const LinearGradient(
                          colors: [
                            ColorMapper.rulaLow,
                            ColorMapper.rulaLowMid,
                            ColorMapper.rulaMid,
                            ColorMapper.rulaMidHigh,
                            ColorMapper.rulaHigh,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(localizations.results_score_low,
                            style: const TextStyle(fontSize: 14)),
                        Text(localizations.results_score_high,
                            style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom heatmap painter for body parts overview visualization
class HeatmapPainter extends CustomPainter {
  /// Creates a heatmap painter
  HeatmapPainter({
    required this.data,
    required this.rows,
    required this.timestamps,
    required this.labels,
  });

  /// The data for the heatmap, where each row represents a body part
  final List<List<double>> data;

  /// The number of body parts / rows in the heatmap
  final int rows;

  /// The timestamps for the x-axis of the heatmap
  final List<int> timestamps;

  /// The labels for each body part
  final List<String> labels;

  @override
  void paint(Canvas canvas, Size size) {
    const spacing = 10.0; // Space between rows
    final cellWidth = size.width / timestamps.length;
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

      for (var col = 0; col < timestamps.length; col++) {
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
