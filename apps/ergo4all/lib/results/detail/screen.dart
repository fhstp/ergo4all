import 'dart:math';

import 'package:common/immutable_collection_ext.dart';
import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/icon_back_button.dart';
import 'package:ergo4all/analysis/common.dart';
import 'package:ergo4all/common/utils.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/body_part_detail/screen.dart';
import 'package:ergo4all/results/body_part_group.dart';
import 'package:ergo4all/results/common.dart';
import 'package:ergo4all/results/detail/heatmap_painter.dart';
import 'package:ergo4all/results/detail/scenario_good_bad_graphic.dart';
import 'package:ergo4all/results/detail/utils.dart';
import 'package:ergo4all/results/rula_colors.dart';
import 'package:ergo4all/results/variable_localizations.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

/// Screen for displaying detailed information about a [RulaTimeline].
class ResultsDetailScreen extends StatefulWidget {
  ///
  const ResultsDetailScreen({required this.analysisResult, super.key});

  /// The result for which to view details.
  final AnalysisResult analysisResult;

  @override
  State<ResultsDetailScreen> createState() => _ResultsDetailScreenState();
}

class _ResultsDetailScreenState extends State<ResultsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final tips = localizations.scenarioTip(widget.analysisResult.scenario);
    final improvements =
        localizations.scenarioImprovement(widget.analysisResult.scenario);

    if (widget.analysisResult.timeline.isEmpty) {
      Navigator.of(context).pop();
      return Container();
    }

    final recordingDuration = Duration(
      milliseconds: widget.analysisResult.timeline.last.timestamp -
          widget.analysisResult.timeline.first.timestamp,
    ).inSeconds;

    final normalizedScoresByGroup = IMap.fromKeys(
      keys: BodyPartGroup.values,
      valueMapper: (bodyPartGroup) => widget.analysisResult.timeline
          .map((entry) {
            final splitScores =
                bodyPartGroupScoreOf(entry.scores, bodyPartGroup);
            return splitScores
                .map(
                  (score) => normalizeScore(score, maxScoreOf(bodyPartGroup)),
                )
                .toIList();
          })
          .toIList()
          .columns()
          .toIList(),
    );

    final worstAveragesByGroup = normalizedScoresByGroup
        .mapValues(
          (splitScores) => splitScores
              .map((scores) => calculateRunningAverage(scores, 20))
              .toIList(),
        )
        .mapValues((splitScores) => splitScores.reduce2d(max));

    void navigateToBodyPartPage(BodyPartGroup bodyPart) {
      Navigator.push(
        context,
        BodyPartResultsScreen.makeRoute(
          bodyPartGroup: bodyPart,
          timelines: normalizedScoresByGroup[bodyPart]!,
          recordingDuration: recordingDuration,
        ),
      );
    }

    final heatmapHeight = MediaQuery.of(context).size.width * 0.65;
    final heatmapWidth = MediaQuery.of(context).size.width * 0.85;
    const labelSpaceWidth = 65.0;
    final bodyLabelStyle = infoText.copyWith(fontSize: 13);

    return Scaffold(
      appBar: AppBar(
        leading: const IconBackButton(),
        title: Text(localizations.results_title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // 'Normalized RULA Score Analysis',
              localizations.results_plot_title,
              style: paragraphHeaderStyle,
            ),

            const SizedBox(height: largeSpace),

            // Heatmap vis of the body parts
            Center(
              child: SizedBox(
                key: const Key('heatmap'),
                width: heatmapWidth,
                height: heatmapHeight,
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ...BodyPartGroup.values.map(
                      (part) => Expanded(
                        child: GestureDetector(
                          onTap: () {
                            navigateToBodyPartPage(part);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                width: labelSpaceWidth,
                                child: Text(
                                  localizations.bodyPartGroupLabel(part),
                                  style: bodyLabelStyle,
                                ),
                              ),
                              Expanded(
                                child: CustomPaint(
                                  painter: HeatmapPainter(
                                    normalizedScores:
                                        worstAveragesByGroup[part]!,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: labelSpaceWidth),
                      child: Column(
                        children: [
                          Container(
                            height: 2,
                            color: woodSmoke.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('0s', style: bodyLabelStyle),
                              Text(
                                '${recordingDuration}s',
                                style: bodyLabelStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: largeSpace),

            // Color legend
            Center(
              child: SizedBox(
                height: 50,
                width: heatmapWidth,
                child: Column(
                  children: [
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: const LinearGradient(
                          colors: [
                            RulaColors.low,
                            RulaColors.lowMid,
                            RulaColors.mid,
                            RulaColors.midHigh,
                            RulaColors.high,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          localizations.results_score_low,
                          style: infoText,
                        ),
                        Text(
                          localizations.results_score_high,
                          style: infoText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: largeSpace),
                Text(
                  localizations.ergonomics_tipps,
                  style: paragraphHeaderStyle,
                  textAlign: TextAlign.left,
                ),
                Text(
                  tips,
                  style: dynamicBodyStyle,
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: mediumSpace),
                Text(
                  localizations.improvements,
                  style: paragraphHeaderStyle,
                  textAlign: TextAlign.left,
                ),
                Text(
                  improvements,
                  style: dynamicBodyStyle,
                  textAlign: TextAlign.left,
                ),
                Center(
                  child: ScenarioGoodBadGraphic(
                    widget.analysisResult.scenario,
                    height: 330,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
