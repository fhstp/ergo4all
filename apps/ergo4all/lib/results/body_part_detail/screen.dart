import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/icon_back_button.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/body_part_detail/body_part_line_chart.dart';
import 'package:ergo4all/results/body_part_group.dart';
import 'package:ergo4all/results/rating.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

final Map<String, String Function(AppLocalizations)> _localizationMap = {
  'upperArmGood': (l) => l.upperArmGood,
  'upperArmMedium': (l) => l.upperArmMedium,
  'upperArmLow': (l) => l.upperArmLow,
  'lowerArmGood': (l) => l.lowerArmGood,
  'lowerArmMedium': (l) => l.lowerArmMedium,
  'lowerArmLow': (l) => l.lowerArmLow,
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

/// Screen display detailed score information about a specific [BodyPartGroup].
class BodyPartResultsScreen extends StatelessWidget {
  ///
  const BodyPartResultsScreen({
    required this.staticLoadScores,
    required this.normalizedScores,
    required this.bodyPartGroup,
    super.key,
  });

  /// Time-line values to display in the static-load graph.
  /// These should be normalized to [0; 1].
  final IList<double> staticLoadScores;

  /// The normalized scores over time. The displayed [Rating] will be
  /// calculated from these. They are also displayed in the ergonomic
  /// rating chart.
  final IList<double> normalizedScores;

  /// The body to display.
  final BodyPartGroup bodyPartGroup;

  /// Makes a [MaterialPageRoute] to navigate to this screen.
  static MaterialPageRoute<void> makeRoute({
    required BodyPartGroup bodyPartGroup,
    required IList<double> normalizedScores,
    required IList<double> staticLoadScores,
  }) {
    return MaterialPageRoute<void>(
      builder: (context) => BodyPartResultsScreen(
        bodyPartGroup: bodyPartGroup,
        normalizedScores: normalizedScores,
        staticLoadScores: staticLoadScores,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Need at least 15s of data to show the static load chart
    final showStaticLoad = staticLoadScores.length > 140;

    final bodyPartLabel = bodyPartGroupLabelFor(localizations, bodyPartGroup);
    final rating = calculateRating(normalizedScores);
    final message =
        _localizationMap['${bodyPartGroup.name}${rating.name.capitalize()}']!(
      localizations,
    );

    return Scaffold(
      appBar: AppBar(
        leading: const IconBackButton(),
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
                child: BodyPartLineChart(normalizedScores: normalizedScores),
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
                style: infoText,
              ),

            const SizedBox(height: 20),

            Text(
              localizations.body_part_title,
              style: paragraphHeaderStyle,
            ),

            const SizedBox(height: 8),

            Text(message, style: infoText),
          ],
        ),
      ),
    );
  }
}
