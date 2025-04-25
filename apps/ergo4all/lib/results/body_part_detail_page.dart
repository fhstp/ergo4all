import 'package:common_ui/theme/colors.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BodyPartDetailPage extends StatelessWidget {
  const BodyPartDetailPage({
    required this.bodyPart,
    required this.timelineColors,
    required this.timelineValues,
    super.key,
  });

  final String bodyPart;
  final List<Color> timelineColors;
  final List<double> timelineValues;
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

    return Scaffold(
      appBar: AppBar(
        title: Text('$bodyPart ${localizations.body_part_title}', style: const TextStyle(color: white)),
        backgroundColor: color,
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      // bottomTitles: AxisTitles(
                      //   axisNameWidget: const Text(
                      //     'time',
                      //     style: TextStyle(fontSize: 14),
                      //   ),
                      //   sideTitles: SideTitles(showTitles: false),
                      // ),
                      bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 0.5,
                          reservedSize: 60,
                          getTitlesWidget: (value, meta) {
                            var text = '';
                            if (value == 0.0) { text = localizations.results_score_low_short; } 
                            else if (value == 1.0) { text = localizations.results_score_high_short; }
                            return Text(
                                text,
                                style: const TextStyle(fontSize: 14),
                            );
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

            // Issue Section

            const Text(
              'Issue:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              texts['issue']!,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            // Risk Section

            const Text(
              'Risk:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              texts['risk']!,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            // Fix Section

            const Text(
              'Fix:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              texts['fix']!,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
