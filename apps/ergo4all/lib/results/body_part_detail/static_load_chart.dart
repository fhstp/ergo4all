import 'package:common_ui/theme/styles.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Chart that displays static load over time as a line.
class StaticLoadChart extends StatelessWidget {
  ///
  const StaticLoadChart({required this.staticLoadScores, super.key});

  /// The scores to display.
  final IList<double> staticLoadScores;

  @override
  Widget build(BuildContext context) {
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
      ),
    );
  }
}
