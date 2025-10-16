import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/common/activity.dart';
import 'package:ergo4all/common/variable_localizations.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Chart that displays static load over time as a line.
class StaticLoadChart extends StatelessWidget {
  ///
  const StaticLoadChart({
    required this.staticLoadScores,
    required this.activities,
    super.key,
  });

  /// The scores to display.
  final IList<double> staticLoadScores;

  /// The activities corresponding to each value in the timelines.
  /// There is only one activity independently from the number of timelines.
  final IList<Activity?> activities;

  /// Generates tooltip items for the static load chart touch interactions.
  List<LineTooltipItem> _getTooltipItems(
    List<LineBarSpot> touchedSpots,
    BuildContext context,
  ) {
    final localizations = AppLocalizations.of(context)!;

    final spot = touchedSpots.single;

    final activity = activities[spot.x.toInt()];
    final activityName = activity != null
        ? localizations.activityDisplayName(activity)
        : localizations.all_activities;
    final score = spot.y.toStringAsFixed(2);
    final touchLabel =
        '$activityName\n${localizations.chart_tooltip_score}: $score';

    final tooltip = LineTooltipItem(
      touchLabel,
      const TextStyle(color: white),
    );
    return [tooltip];
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return LineChart(
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
              reservedSize: 80,
              getTitlesWidget: (value, meta) => Text(
                switch (value) {
                  0.0 => localizations.results_score_low_short,
                  1.0 => localizations.results_score_high_short,
                  _ => ''
                },
                style: infoText,
              ),
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: staticLoadScores.length.toDouble() - 1,
        minY: 0 - 0.01, // Adjusted to fit the grid
        maxY: 1 + 0.01, // Adjusted to fit the grid
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              staticLoadScores.length,
              (i) => FlSpot(
                i.toDouble(),
                staticLoadScores[i],
              ),
            ),
            color: Colors.grey,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) =>
                _getTooltipItems(touchedSpots, context),
            fitInsideHorizontally: true,
            fitInsideVertically: true,
          ),
        ),
      ),
    );
  }
}
