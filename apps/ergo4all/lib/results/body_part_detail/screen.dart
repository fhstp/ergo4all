import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/body_part_detail/body_part_line_chart.dart';
import 'package:ergo4all/results/body_part_detail/view_model.dart';
import 'package:ergo4all/results/common.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BodyPartResultsScreen extends StatelessWidget {
  const BodyPartResultsScreen({
    required this.viewModel,
    super.key,
  });

  final BodyPartResultsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Need at least 15s of data to show the static load chart
    final showStaticLoad = viewModel.medianTimelineValues.length > 140;

    final bodyPartLabel =
        bodyPartGroupLabelFor(localizations, viewModel.bodyPartGroup);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$bodyPartLabel ${localizations.body_part_title}',
          style: h3Style,
        ),
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
                      color: cardinal.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        bodyPartLabel,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: cardinal,
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
              style: paragraphHeaderStyle,
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 132,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: BodyPartLineChart(
                  normalizedScores: viewModel.timelineValues.toIList(),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              localizations.body_part_static_plot_title,
              style: paragraphHeaderStyle,
            ),

            const SizedBox(height: 20),

            if (showStaticLoad)
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
                              return Text(
                                text,
                                style: infoText,
                              );
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      minX: 0,
                      maxX:
                          viewModel.medianTimelineValues.length.toDouble() - 1,
                      minY: 0 - 0.01, // Adjusted to fit the grid
                      maxY: 1 + 0.01, // Adjusted to fit the grid
                      lineBarsData: [
                        LineChartBarData(
                          spots: List.generate(
                            viewModel.medianTimelineValues.length,
                            (i) => FlSpot(
                              i.toDouble(),
                              viewModel.medianTimelineValues[i],
                            ),
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
              )
            else
              Text(
                localizations.body_part_static_plot_condition,
                style: infoText,
              ),

            const SizedBox(height: 20),

            Text(
              localizations.body_part_title,
              style: paragraphHeaderStyle,
            ),

            const SizedBox(height: 8),

            Text(
              viewModel.getLocalizedMessage(context),
              style: infoText,
            ),
          ],
        ),
      ),
    );
  }
}
