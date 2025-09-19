import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/analysis/har/activity.dart';
import 'package:ergo4all/analysis/har/variable_localizations.dart';
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
    required this.activities,
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

  /// The activities corresponding to each value in the timelines.
  /// There is only one activity independently from the number of timelines.
  final IList<Activity?> activities;

  @override
  State<BodyPartLineChart> createState() => _BodyPartLineChartState();
}

class _BodyPartLineChartState extends State<BodyPartLineChart> {
  int highlightedTimelineIndex = 0;

  /// Generates tooltip items for the line chart touch interactions.
  List<LineTooltipItem> _getTooltipItems(List<LineBarSpot> touchedSpots) {
    final localizations = AppLocalizations.of(context)!;

    if (widget.timelines.length == 1) {
      return _getSingleTimelineTooltips(touchedSpots, localizations);
    }

    return _getMultipleTimelineTooltips(touchedSpots, localizations);
  }

  /// Creates tooltips for single timeline charts.
  List<LineTooltipItem> _getSingleTimelineTooltips(
    List<LineBarSpot> touchedSpots,
    AppLocalizations localizations,
  ) {
    return touchedSpots.map((spot) {
      final activity = widget.activities[spot.x.toInt()];
      final activityName = activity != null
          ? localizations.activityDisplayName(activity)
          : localizations.har_class_no_selection;

      final score = spot.y.toStringAsFixed(2);
      final touchLabel =
          '$activityName\n${localizations.chart_tooltip_score}: $score';

      return LineTooltipItem(
        touchLabel,
        const TextStyle(color: white),
      );
    }).toList();
  }

  /// Creates tooltips for multiple timeline charts (left/right).
  List<LineTooltipItem> _getMultipleTimelineTooltips(
    List<LineBarSpot> touchedSpots,
    AppLocalizations localizations,
  ) {
    final activityBarIndices = _getHighestSpotPerX(touchedSpots);

    return touchedSpots.map((spot) {
      final shouldShowActivity = activityBarIndices[spot.x] == spot;
      final activity = shouldShowActivity
          ? (widget.activities[spot.x.toInt()] ?? Activity.background)
          : null;
      final activityName = activity != null
          ? '${localizations.activityDisplayName(activity)}\n'
          : '';

      final sideLabel = spot.barIndex == 0
          ? localizations.common_left
          : localizations.common_right;

      final score = spot.y.toStringAsFixed(2);
      final touchLabel = '$activityName${localizations.chart_tooltip_score}'
          '($sideLabel): $score';

      return LineTooltipItem(
        touchLabel,
        const TextStyle(color: white),
      );
    }).toList();
  }

  /// Gets the highest spot for each x-coordinate to avoid duplicate activity
  /// labels.
  Map<double, LineBarSpot> _getHighestSpotPerX(List<LineBarSpot> touchedSpots) {
    final activityBarIndices = <double, LineBarSpot>{};

    for (final spot in touchedSpots) {
      final existingSpot = activityBarIndices[spot.x];
      if (existingSpot == null || spot.y > existingSpot.y) {
        activityBarIndices[spot.x] = spot;
      }
    }

    return activityBarIndices;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final valueCount = widget.timelines[0].length;
    final hasMultipleTimelines = widget.timelines.length == 2;

    final graphLines = widget.timelines.mapWithIndex((timeline, timelineIndex) {
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
              // Reverse list depending on which line we want to render
              // on top
              lineBarsData: highlightedTimelineIndex == 1
                  ? graphLines
                  : graphLines.reversedView,
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: _getTooltipItems,
                ),
              ),
            ),
            // Disable animations
            duration: Duration.zero,
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
