import 'package:common/immutable_collection_ext.dart';
import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/icon_back_button.dart';
import 'package:ergo4all/analysis/common.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/common.dart';
import 'package:ergo4all/results/detail/heatmap_painter.dart';
import 'package:ergo4all/results/detail/utils.dart';
import 'package:ergo4all/results/rula_colors.dart';
import 'package:ergo4all/results/score_group.dart';
import 'package:ergo4all/results/score_group_detail/screen.dart';
import 'package:ergo4all/scenario/common.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:rula/rula.dart';
import 'package:svg_flutter/svg_flutter.dart';

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

    final tips = switch (widget.analysisResult.scenario) {
      Scenario.liftAndCarry => localizations.scenario_lift_and_carry_tips,
      Scenario.pull => localizations.scenario_pull_tips,
      Scenario.seated => localizations.scenario_seated_tips,
      Scenario.packaging => localizations.scenario_packaging_tips,
      Scenario.standingCNC => localizations.scenario_CNC_tips,
      Scenario.standingAssembly => localizations.scenario_assembly_tips,
      Scenario.ceiling => localizations.scenario_ceiling_tips,
      Scenario.lift25 => localizations.scenario_lift_tips,
      Scenario.conveyorBelt => localizations.scenario_conveyor_tips,
    };

    final improvements = switch (widget.analysisResult.scenario) {
      Scenario.liftAndCarry => localizations.scenario_lift_and_carry_tools,
      Scenario.pull => localizations.scenario_pull_tools,
      Scenario.seated => localizations.scenario_seated_tools,
      Scenario.packaging => localizations.scenario_packaging_tools,
      Scenario.standingCNC => localizations.scenario_CNC_tools,
      Scenario.standingAssembly => localizations.scenario_assembly_tools,
      Scenario.ceiling => localizations.scenario_ceiling_tools,
      Scenario.lift25 => localizations.scenario_lift_tools,
      Scenario.conveyorBelt => localizations.scenario_conveyor_tools,
    };

    final graphicFileName = switch (widget.analysisResult.scenario) {
      Scenario.liftAndCarry || Scenario.lift25 => 'lifting',
      Scenario.pull => 'pushing',
      Scenario.seated => 'sitting',
      Scenario.packaging ||
      Scenario.standingCNC ||
      Scenario.standingAssembly ||
      Scenario.conveyorBelt =>
        'standing',
      Scenario.ceiling => 'overhead_work',
    };
    final graphicKey =
        'assets/images/puppets_good_bad/good_bad_$graphicFileName.svg';

    if (widget.analysisResult.timeline.isEmpty) {
      Navigator.of(context).pop();
      return Container();
    }

    final recordingDuration = Duration(
      milliseconds: widget.analysisResult.timeline.last.timestamp -
          widget.analysisResult.timeline.first.timestamp,
    ).inSeconds;

    final normalizedScoresByGroup = IMap.fromKeys(
      keys: ScoreGroup.valuesMerged,
      valueMapper: (group) => widget.analysisResult.timeline.map((entry) {
        final scores = entry.scores;
        final score = scores.scoreOfGroup(group, mergeScores: worse);
        return ScoreGroup.normalizeFor(group, score);
      }).toIList(),
    );

    final averageScoresByGroup = normalizedScoresByGroup
        .mapValues((scores) => calculateRunningAverage(scores, 20));

    void navigateToScoreGroupPage(ScoreGroup group) {
      Navigator.push(
        context,
        ScoreGroupResultsScreen.makeRoute(
          scoreGroup: group,
          // We use the averaged scores on the detail screen
          normalizedScores: averageScoresByGroup[group]!,
          // We display the median values on the detail screen
          staticLoadScores:
              calculateRunningMedian(normalizedScoresByGroup[group]!, 20),
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
                    ...ScoreGroup.valuesMerged.map(
                      (part) => Expanded(
                        child: GestureDetector(
                          onTap: () {
                            navigateToScoreGroupPage(part);
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(
                                width: labelSpaceWidth,
                                child: Text(
                                  scoreGroupLabelFor(
                                    localizations,
                                    part,
                                  ),
                                  style: bodyLabelStyle,
                                ),
                              ),
                              Expanded(
                                child: CustomPaint(
                                  painter: HeatmapPainter(
                                    normalizedScores:
                                        averageScoresByGroup[part]!,
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

                // New feature: show tips
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

                // New feature: show improvement solutions
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
                  child: SvgPicture.asset(graphicKey, height: 330),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
