import 'package:common/immutable_collection_ext.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/body_part_detail/screen.dart';
import 'package:ergo4all/results/common.dart';
import 'package:ergo4all/results/detail/heatmap_painter.dart';
import 'package:ergo4all/results/detail/utils.dart';
import 'package:ergo4all/results/rula_colors.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

/// Screen for displaying detailed information about a [RulaTimeline].
class ResultsDetailScreen extends StatefulWidget {
  ///
  const ResultsDetailScreen({super.key});

  @override
  State<ResultsDetailScreen> createState() => _ResultsDetailScreenState();
}

class _ResultsDetailScreenState extends State<ResultsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final timeline =
        ModalRoute.of(context)!.settings.arguments as RulaTimeline?;

    if (timeline == null || timeline.isEmpty) {
      Navigator.of(context).pop();
      return Container();
    }

    final normalizedScoresByGroup = IMap.fromKeys(
      keys: BodyPartGroup.values,
      valueMapper: (bodyPartGroup) => timeline
          .map((entry) => entry.scores)
          .map(
            (scores) => normalizedBodyPartGroupScoreOf(scores, bodyPartGroup),
          )
          .toIList(),
    );

    final averageScoresByGroup = normalizedScoresByGroup
        .mapValues((scores) => calculateRunningAverage(scores, 20));

    void navigateToBodyPartPage(BodyPartGroup bodyPart) {
      Navigator.push(
        context,
        BodyPartResultsScreen.makeRoute(
          bodyPartGroup: bodyPart,
          // We use the averaged scores on the detail screen
          normalizedScores: averageScoresByGroup[bodyPart]!,
          // We display the median values on the detail screen
          staticLoadScores:
              calculateRunningMedian(normalizedScoresByGroup[bodyPart]!, 20),
        ),
      );
    }

    final heatmapHeight = MediaQuery.of(context).size.width * 0.6;
    final heatmapWidth = MediaQuery.of(context).size.width * 0.85;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.results_title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // 'Normalized RULA Score Analysis',
              localizations.results_plot_title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            // Heatmap vis of the body parts
            Center(
              child: SizedBox(
                key: const Key('heatmap'),
                width: heatmapWidth,
                height: heatmapHeight,
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: BodyPartGroup.values
                      .map(
                        (part) => Expanded(
                          child: GestureDetector(
                            onTap: () {
                              navigateToBodyPartPage(part);
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: Text(
                                    bodyPartGroupLabelFor(
                                      localizations,
                                      part,
                                    ),
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
                      )
                      .toList(),
                ),
              ),
            ),

            const SizedBox(height: 40),

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
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          localizations.results_score_high,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
