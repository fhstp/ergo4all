import 'dart:math';

import 'package:common/func_ext.dart';
import 'package:common/pair_utils.dart';
import 'package:ergo4all/common/utils.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/body_part_detail_view_model.dart';
import 'package:ergo4all/results/body_part_results_screen.dart';
import 'package:ergo4all/results/common.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:rula/rula.dart';

/// Manages colors for the RULA score visualization
@immutable
class ColorMapper {
  /// #BFD7EA
  static const rulaLow = Color(0xFFBFD7EA);

  /// #F9F9C4
  // Use for better visibility in the heatmap plot
  static const rulaLowMid = Color(0xFFF9F9C4);

  /// #DEDEA2
  // Use for better visibility in the line plot
  static const rulaLowMidDark = Color(0xFFE7E7B2);

  /// #FFE553
  static const rulaMid = Color(0xFFFFE553);

  /// #FFA259
  static const rulaMidHigh = Color(0xFFFFA259);

  /// #FF5A5F
  static const rulaHigh = Color(0xFFFF5A5F);

  /// Maps normalized RULA score values to colors
  static Color getColorForValue(double value, {bool dark = false}) {
    if (value < 0.20) {
      return rulaLow;
    } else if (value <= 0.40) {
      return dark ? rulaLowMidDark : rulaLowMid;
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
    String bodyPartTitle,
    BodyPart bodyPart,
    List<double> avgTimelineValues,
    List<double> medianTimelineValues,
  ) {

    final bodyPartDetailViewModel = BodyPartDetailPageViewModel(
        bodyPartName: bodyPartTitle,
        timelineValues: avgTimelineValues,
        medianTimelineValues: medianTimelineValues,
        bodyPart: bodyPart
    );

    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => BodyPartResultsScreen(
          viewModel: bodyPartDetailViewModel,
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

    final bodyParts = [
      BodyPart.upperArm,
      BodyPart.lowerArm,
      BodyPart.trunk,
      BodyPart.neck,
      BodyPart.legs
    ];

    final timeline =
        ModalRoute.of(context)!.settings.arguments as RulaTimeline?;

    if (timeline == null || timeline.isEmpty) {
      Navigator.of(context).pop();
      return Container();
    }

    List<double> transformData(
        int Function(RulaScores) selector,
        int maxValue,
    ) {
      return timeline.map((entry) {
        final score = selector(entry.scores);
        return normalizeScore(score, maxValue);
      }).toList();
    }

    List<double> getPaddedData(List<double> data, int windowSize) {
      final halfWindow = windowSize ~/ 2;
      return [
        ...List.filled(halfWindow, data.first),
        ...data,
        ...List.filled(halfWindow, data.last),
      ];
    }

    List<double> calculateRunningAverage(List<double> data, int windowSize) {
      if (data.length < windowSize) return data;
      
      final paddedData = getPaddedData(data, windowSize);
      final result = <double>[];
      
      for (var i = 0; i <= paddedData.length - windowSize; i++) {
        final window = paddedData.sublist(i, i + windowSize);
        final avgY = window.reduce((a, b) => a + b) / windowSize;
        result.add(avgY);
      }
      
      return result;
    }

    List<double> calculateRunningMedian(List<double> data, int windowSize) {
      if (data.length < windowSize) return data;
      
      final paddedData = getPaddedData(data, windowSize);
      final result = <double>[];
      
      for (var i = 0; i <= paddedData.length - windowSize; i++) {
        final window = paddedData.sublist(i, i + windowSize)..sort();
        
        final median = windowSize.isOdd
            ? window[windowSize ~/ 2]
            : (window[(windowSize - 1) ~/ 2] + window[windowSize ~/ 2]) / 2;
        
        result.add(median);
      }
      
      return result;
    }

    final lineChartData = IList([
      transformData(((RulaScores scores) => scores.upperArmScores)
          .compose(Pair.reduce(worse)), 6,),
      transformData(((RulaScores scores) => scores.lowerArmScores)
          .compose(Pair.reduce(worse)), 3,),
      transformData((RulaScores scores) => scores.trunkScore, 6),
      transformData((RulaScores scores) => scores.neckScore, 6),
      transformData((RulaScores scores) => scores.legScore, 2),
    ]);

    final avgLineChartValues = IList(
      lineChartData.map((spots) => calculateRunningAverage(spots, 20)).toList(),
    );

    final medianTimelineValues = IList(
      lineChartData.map((spots) => calculateRunningMedian(spots, 60)).toList(),
    );

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
                          bodyParts[rowIndex],
                          avgLineChartValues[rowIndex],
                          medianTimelineValues[rowIndex],
                        );
                      }
                    },
                    child: CustomPaint(
                      painter: HeatmapPainter(
                        data: avgLineChartValues,
                        rows: labels.length,
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
            const SizedBox(height: 40),
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
