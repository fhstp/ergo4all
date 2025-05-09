import 'package:common_ui/theme/colors.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/body_part_detail_view_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BodyPartDetailPage extends StatelessWidget {
  const BodyPartDetailPage({
    required this.viewModel,
    super.key,
  });

  final BodyPartDetailPageViewModel viewModel;
  final Color color = cardinal;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text('${viewModel.bodyPartName} ${localizations.body_part_title}', style: const TextStyle(color: white),),
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
                        viewModel.bodyPartName,
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
                    maxX: viewModel.timelineValues.length.toDouble() - 1,
                    minY: 0 - 0.01, // Adjusted to fit the grid
                    maxY: 1 + 0.01, // Adjusted to fit the grid
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          viewModel.timelineValues.length,
                          (i) => FlSpot(i.toDouble(), viewModel.timelineValues[i]),
                        ),
                        gradient: LinearGradient(
                          colors: viewModel.timelineColors,
                          stops: List.generate(
                            viewModel.timelineColors.length,
                            (index) => index / (viewModel.timelineColors.length - 1),
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
              viewModel.getLocalizedMessage(context),
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
