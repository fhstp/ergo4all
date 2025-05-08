import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BodyPartResultsScreen extends StatelessWidget {
  const BodyPartResultsScreen({
    required this.bodyPart,
    required this.avgTimelineColors,
    required this.avgTimelineValues,
    required this.medianTimelineValues,
    super.key,
  });

  final String bodyPart;
  final List<Color> avgTimelineColors;
  final List<double> avgTimelineValues;
  final List<double> medianTimelineValues;
  final Color color = cardinal;

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

    // Need at least 15s of data to show the static load chart
    final showStaticLoad = medianTimelineValues.length > 140; 

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

            const SizedBox(height: 20),

            Text(
              localizations.body_part_score_plot_title,
              style: paragraphHeader,
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
              localizations.body_part_static_plot_title,
              style: paragraphHeader,
            ),

            const SizedBox(height: 20),

            if (showStaticLoad) SizedBox(
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
                      maxX: medianTimelineValues.length.toDouble() - 1,
                      minY: 0 - 0.01, // Adjusted to fit the grid
                      maxY: 1 + 0.01, // Adjusted to fit the grid
                      lineBarsData: [
                        LineChartBarData(
                          spots: List.generate(
                            medianTimelineValues.length,
                            (i) => FlSpot(i.toDouble(), medianTimelineValues[i]),
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
              ) else Text(
                localizations.body_part_static_plot_condition,
                style: infoText,
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
