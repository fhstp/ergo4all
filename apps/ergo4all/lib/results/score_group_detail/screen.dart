import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/icon_back_button.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/score_group_detail/score_group_line_chart.dart';
import 'package:ergo4all/results/score_group.dart';
import 'package:ergo4all/results/rating.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

final Map<String, String Function(AppLocalizations)> _localizationMap = {
  'shoulderGood': (l) => l.shoulderGood,
  'shoulderMedium': (l) => l.shoulderMedium,
  'shoulderLow': (l) => l.shoulderLow,
  'armGood': (l) => l.armGood,
  'armMedium': (l) => l.armMedium,
  'armLow': (l) => l.armLow,
  'trunkGood': (l) => l.trunkGood,
  'trunkMedium': (l) => l.trunkMedium,
  'trunkLow': (l) => l.trunkLow,
  'neckGood': (l) => l.neckGood,
  'neckMedium': (l) => l.neckMedium,
  'neckLow': (l) => l.neckLow,
  'legsGood': (l) => l.legsGood,
  'legsMedium': (l) => l.legsMedium,
  'legsLow': (l) => l.legsLow,
};

extension on String {
  String capitalize() => this[0].toUpperCase() + substring(1);
}

/// Screen display detailed score information about a specific [ScoreGroup].
class ScoreGroupResultsScreen extends StatelessWidget {
  ///
  const ScoreGroupResultsScreen({
    required this.staticLoadScores,
    required this.normalizedScores,
    required this.scoreGroup,
    required this.recordingDuration,
    super.key,
  });

  /// Time-line values to display in the static-load graph.
  /// These should be normalized to [0; 1].
  final IList<double> staticLoadScores;

  /// The normalized scores over time. The displayed [Rating] will be
  /// calculated from these. They are also displayed in the ergonomic
  /// rating chart.
  final IList<double> normalizedScores;

  /// The group to display.
  final ScoreGroup scoreGroup;

  /// The duration of the recording in seconds.
  final int recordingDuration;

  /// Makes a [MaterialPageRoute] to navigate to this screen.
  static MaterialPageRoute<void> makeRoute({
    required ScoreGroup scoreGroup,
    required IList<double> normalizedScores,
    required IList<double> staticLoadScores,
    required int recordingDuration,
  }) {
    return MaterialPageRoute<void>(
      builder: (context) => ScoreGroupResultsScreen(
        scoreGroup: scoreGroup,
        normalizedScores: normalizedScores,
        staticLoadScores: staticLoadScores,
        recordingDuration: recordingDuration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Need at least 15s of data to show the static load chart
    final showStaticLoad = recordingDuration >= 15;

    final groupLabel = scoreGroupLabelFor(localizations, scoreGroup);
    final rating = calculateRating(normalizedScores);
    final groupName = ScoreGroup.nameOf(scoreGroup);
    final message = _localizationMap['$groupName${rating.name.capitalize()}']!(
      localizations,
    );

    return Scaffold(
      appBar: AppBar(
        leading: const IconBackButton(),
        title: Text(groupLabel),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.body_part_score_plot_title,
              style: paragraphHeaderStyle,
            ),
            const SizedBox(height: largeSpace),
            SizedBox(
              height: 132,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: ScoreGroupLineChart(
                    timelines: [normalizedScores].toIList()),
              ),
            ),
            const SizedBox(height: largeSpace),
            Text(
              localizations.body_part_static_plot_title,
              style: paragraphHeaderStyle,
            ),
            const SizedBox(height: mediumSpace),
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
                  ),
                ),
              )
            else
              Text(
                localizations.body_part_static_plot_condition,
                style: dynamicBodyStyle,
              ),
            const SizedBox(height: mediumSpace),
            Text(
              localizations.analysis,
              style: paragraphHeaderStyle,
            ),
            const SizedBox(height: smallSpace),
            Text(message, style: dynamicBodyStyle),
          ],
        ),
      ),
    );
  }
}
