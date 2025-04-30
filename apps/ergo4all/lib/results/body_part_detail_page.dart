import 'dart:math';

import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BodyPartDetailPage extends StatelessWidget {
  const BodyPartDetailPage({
    required this.bodyPart,
    required this.timelineColors,
    required this.timelineValues,
    required this.avgTimelineColors,
    required this.avgTimelineValues,
    required this.modeTimelineValues,
    // required this.rangeTimelineValues,
    // required this.avgRangeTimelineValues,
    super.key,
  });

  final String bodyPart;
  final List<Color> timelineColors;
  final List<double> timelineValues;
  final List<Color> avgTimelineColors;
  final List<double> avgTimelineValues;
  final List<double> modeTimelineValues;
  // final List<double> rangeTimelineValues;
  // final List<double> avgRangeTimelineValues;
  final Color color = cardinal;

  List<double> calculateDynamicWeightedScore(List<double> data, int windowSize) {
      if (data.length < windowSize) return data;
      
      final result = <double>[];
      
      for (var i = 0; i <= data.length - windowSize; i++) {
        final window = data.sublist(i, i + windowSize);
        final maxY = window.reduce(max);
        final minY = window.reduce(min);
        final range = maxY - minY;
        // Weight the score based on how dynamic the data is
        // The more dynamic, the lower the score
        final score = window[windowSize ~/ 2] * (1 - range);
        result.add(score);
      }
      
      return result;
    }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Unique text for each body part
    final bodyPartTexts = <String, Map<String, String>>{
      'Upper Arm': {
        'issue': 'The upper arm was often raised above shoulder level.',
        'risk': 'This increases the risk of rotator cuff injuries.',
        'fix': 'Try keeping your upper arm below shoulder height during tasks.',
      },
      'Lower Arm': {
        'issue':
            'The lower arm was flexed at an extreme angle for long periods.',
        'risk': 'This posture may lead to repetitive strain injuries.',
        'fix':
            'Adjust the workstation to keep your lower arms in a neutral position.',
      },
      'Trunk': {
        'issue': 'The trunk was bent forward excessively.',
        'risk': 'This posture can strain the lower back, causing disc issues.',
        'fix': 'Use a chair with lumbar support and avoid leaning forward.',
      },
      'Neck': {
        'issue': 'The neck was bent at a high angle for a prolonged time.',
        'risk': 'This can lead to ligament strain or disc herniation.',
        'fix':
            'Keep your neck aligned with your spine and avoid looking up or down.',
      },
      'Legs': {
        'issue': 'The legs were unsupported or in awkward postures.',
        'risk': 'This can cause fatigue or circulation problems.',
        'fix': 'Use a footrest to support your legs while seated.',
      },
    };

    final texts = bodyPartTexts[bodyPart] ??
        {
          'issue': 'No issue description available.',
          'risk': 'No risk description available.',
          'fix': 'No fix description available.',
        };

    final infoTextSmall = infoText.copyWith(fontSize: 14);
    final List<double> dynamicWeightedScores = calculateDynamicWeightedScore(
      avgTimelineValues,
      5,
    );

    return Scaffold(
      appBar: AppBar(
        title:
            Text('$bodyPart ${localizations.body_part_title}', style: h3Style),
        backgroundColor: white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Body Part
            Center(
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        bodyPart,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Timeline Visualization

            Text(
              localizations.body_part_timeline_plot_title,
              style: paragraphHeader,
            ),

            const SizedBox(height: 20),

            Text(
              'Raw Ergonomics Score:',
              style: infoText,
            ),

            const SizedBox(height: 20),

            // Timeline Chart
            SizedBox(
              height: 132,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      drawVerticalLine: false,
                      horizontalInterval: 0.5,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.withValues(alpha: 0.2),
                          strokeWidth: 3,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      rightTitles: const AxisTitles(),
                      topTitles: const AxisTitles(),
                      bottomTitles: const AxisTitles(),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 0.5,
                          reservedSize: 60,
                          getTitlesWidget: (value, meta) {
                            var text = '';
                            if (value == 0.0) {
                              text = localizations.results_score_low_short;
                            } else if (value == 1.0) {
                              text = localizations.results_score_high_short;
                            }
                            return Text(text, style: infoTextSmall,);
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: timelineValues.length.toDouble() - 1,
                    minY: 0 - 0.01, // Adjusted to fit the grid
                    maxY: 1 + 0.01, // Adjusted to fit the grid
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          timelineValues.length,
                          (i) => FlSpot(i.toDouble(), timelineValues[i]),
                        ),
                        gradient: LinearGradient(
                          colors: timelineColors,
                          stops: List.generate(
                            timelineColors.length,
                            (index) => index / (timelineColors.length - 1),
                          ),
                        ),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Averaged Ergonomics Score:',
              style: infoText,
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 132,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      drawVerticalLine: false,
                      horizontalInterval: 0.5,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.withValues(alpha: 0.2),
                          strokeWidth: 3,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      rightTitles: const AxisTitles(),
                      topTitles: const AxisTitles(),
                      bottomTitles: const AxisTitles(),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 0.5,
                          reservedSize: 60,
                          getTitlesWidget: (value, meta) {
                            var text = '';
                            if (value == 0.0) {
                              text = localizations.results_score_low_short;
                            } else if (value == 1.0) {
                              text = localizations.results_score_high_short;
                            }
                            return Text(text, style: infoTextSmall,);
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: avgTimelineValues.length.toDouble() - 1,
                    minY: 0 - 0.01, // Adjusted to fit the grid
                    maxY: 1 + 0.01, // Adjusted to fit the grid
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          avgTimelineValues.length,
                          (i) => FlSpot(i.toDouble(), avgTimelineValues[i]),
                        ),
                        gradient: LinearGradient(
                          colors: avgTimelineColors,
                          stops: List.generate(
                            avgTimelineColors.length,
                            (index) => index / (avgTimelineColors.length - 1),
                          ),
                        ),
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Static Load Score:',
              style: infoText,
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 132,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      drawVerticalLine: false,
                      horizontalInterval: 0.5,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.withValues(alpha: 0.2),
                          strokeWidth: 3,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      rightTitles: const AxisTitles(),
                      topTitles: const AxisTitles(),
                      bottomTitles: const AxisTitles(),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 0.5,
                          reservedSize: 60,
                          getTitlesWidget: (value, meta) {
                            var text = '';
                            if (value == 0.0) {
                              text = 'Low';
                            } else if (value == 1.0) {
                              text = 'High';
                            }
                            return Text(text, style: infoTextSmall,);
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: modeTimelineValues.length.toDouble() - 1,
                    minY: 0 - 0.01, // Adjusted to fit the grid
                    maxY: 1 + 0.01, // Adjusted to fit the grid
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          modeTimelineValues.length,
                          (i) => FlSpot(i.toDouble(), modeTimelineValues[i]),
                        ),
                        color: Colors.grey,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'Dynamically Weighted Load Score:',
              style: infoText,
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 132,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      drawVerticalLine: false,
                      horizontalInterval: 0.5,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey.withValues(alpha: 0.2),
                          strokeWidth: 3,
                        );
                      },
                    ),
                    titlesData: FlTitlesData(
                      rightTitles: const AxisTitles(),
                      topTitles: const AxisTitles(),
                      bottomTitles: const AxisTitles(),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 0.5,
                          reservedSize: 60,
                          getTitlesWidget: (value, meta) {
                            var text = '';
                            if (value == 0.0) {
                              text = 'Awk.';
                            } else if (value == 1.0) {
                              text = 'Neutral';
                            }
                            return Text(text, style: infoTextSmall,);
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    minX: 0,
                    maxX: dynamicWeightedScores.length.toDouble() - 1,
                    minY: 0 - 0.01, // Adjusted to fit the grid
                    maxY: 1 + 0.01, // Adjusted to fit the grid
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          dynamicWeightedScores.length,
                          (i) => FlSpot(i.toDouble(), dynamicWeightedScores[i]),
                        ),
                        color: Colors.grey,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Issue Section

            Text(
              'Issue:',
              style: paragraphHeader,
            ),

            const SizedBox(height: 8),

            Text(
              texts['issue']!,
              style: infoText,
            ),

            const SizedBox(height: 20),

            // Risk Section

            Text(
              'Risk:',
              style: paragraphHeader,
            ),

            const SizedBox(height: 8),

            Text(
              texts['risk']!,
              style: infoText,
            ),

            const SizedBox(height: 20),

            // Fix Section

            Text(
              'Fix:',
              style: paragraphHeader,
            ),

            const SizedBox(height: 8),

            Text(
              texts['fix']!,
              style: infoText,
            ),
          ],
        ),
      ),
    );
  }
}
