import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/common/rula_color.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:toggle_switch/toggle_switch.dart';

final _lineGray = Colors.grey.withValues(alpha: 0.2);

final _hLine = FlLine(
  color: _lineGray,
  strokeWidth: 3,
);

const _noTitles = AxisTitles();

Color _grayscale(Color c) {
  final i = (c.r + c.g + c.b) / 3;
  return Color.from(alpha: c.a, red: i, green: i, blue: i);
}

/// Displays the normalized scores of a body-part over time using a
/// 2D line-chart.
class BodyPartLineChart extends StatefulWidget {
  ///
  const BodyPartLineChart({
    required this.timelines,
    super.key,
  }) : assert(
          timelines.length == 1 || timelines.length == 2,
          'Either provide 1 or 2 timelines',
        );

  /// The scores to display. A list of timelines. Each timeline will
  /// be rendered as a graph.
  /// It is expected to either provide 1 or 2 timelines.
  /// The values in each timeline are expected to be [0; 1].
  final IList<IList<double>> timelines;

  @override
  State<BodyPartLineChart> createState() => _BodyPartLineChartState();
}

class _BodyPartLineChartState extends State<BodyPartLineChart> {
  int highlightedTimelineIndex = 0;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final valueCount = widget.timelines[0].length;
    final hasMultipleTimelines = widget.timelines.length == 2;

    final graphLines = widget.timelines
        .mapWithIndex((IList<double> timeline, int timelineIndex) {
      final isSelectedTimeline = timelineIndex == highlightedTimelineIndex;

      final rulaColors =
          timeline.map((score) => RulaColor.forScore(score, dark: true));

      final colors = isSelectedTimeline
          ? rulaColors.toList()
          : rulaColors.map(_grayscale).toList();

      final spots = timeline
          .mapWithIndex((score, i) => FlSpot(i.toDouble(), score))
          .toList();

      return LineChartBarData(
        spots: spots,
        gradient: LinearGradient(colors: colors),
        barWidth: 3,
        isStrokeCapRound: true,
        dotData: const FlDotData(show: false),
      );
    }).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                drawVerticalLine: false,
                horizontalInterval: 0.5,
                getDrawingHorizontalLine: (value) => _hLine,
              ),
              titlesData: FlTitlesData(
                rightTitles: _noTitles,
                topTitles: _noTitles,
                bottomTitles: _noTitles,
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
              maxX: valueCount - 1,
              minY: 0,
              maxY: 1,
              lineBarsData: graphLines,
            ),
          ),
        ),
        if (hasMultipleTimelines) ...[
          const SizedBox(height: smallSpace),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ToggleSwitch(
                initialLabelIndex: highlightedTimelineIndex,
                totalSwitches: 2,
                labels: [localizations.common_left, localizations.common_right],
                onToggle: (index) {
                  setState(() {
                    highlightedTimelineIndex = index!;
                  });
                },
              ),
            ],
          ),
        ],
      ],
    );
  }
}
