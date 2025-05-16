import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/rula_colors.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Displays the normalized scores of a body-part over time using a
/// 2D line-chart.
class BodyPartLineChart extends StatelessWidget {
  ///
  const BodyPartLineChart({
    required this.normalizedScores,
    super.key,
  });

  /// The scores to display. The values in this list are expected to be [0; 1].
  final IList<double> normalizedScores;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final colors = normalizedScores
        .map((score) => rulaColorFor(score, dark: true))
        .toList();

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
              reservedSize: 60,
              getTitlesWidget: (value, meta) {
                return Text(
                  value == 0.0
                      ? localizations.results_score_low_short
                      : value == 1.0
                          ? localizations.results_score_high_short
                          : '',
                  style: infoText,
                );
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: normalizedScores.length.toDouble() - 1,
        minY: 0 - 0.01, // Adjusted to fit the grid
        maxY: 1 + 0.01, // Adjusted to fit the grid
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              normalizedScores.length,
              (i) => FlSpot(i.toDouble(), normalizedScores[i]),
            ),
            gradient: LinearGradient(
              colors: colors,
              stops: List.generate(
                colors.length,
                (index) => index / (colors.length - 1),
              ),
            ),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
          ),
        ],
      ),
    );
  }
}
