import 'package:common/func_ext.dart';
import 'package:common/pair_utils.dart';
import 'package:ergo4all/common/utils.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/body_part_detail/screen.dart';
import 'package:ergo4all/results/body_part_detail/view_model.dart';
import 'package:ergo4all/results/color_mapper.dart';
import 'package:ergo4all/results/common.dart';
import 'package:ergo4all/results/detail/heatmap_painter.dart';
import 'package:ergo4all/results/detail/utils.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:rula/rula.dart';

class ResultsDetailScreen extends StatefulWidget {
  const ResultsDetailScreen({super.key});

  @override
  State<ResultsDetailScreen> createState() => _ResultsDetailScreenState();
}

class _ResultsDetailScreenState extends State<ResultsDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final labels = [
      localizations.results_body_upper_arms,
      localizations.results_body_lower_arms,
      localizations.results_body_trunk,
      localizations.results_body_neck,
      localizations.results_body_legs,
    ];

    final timeline =
        ModalRoute.of(context)!.settings.arguments as RulaTimeline?;

    if (timeline == null || timeline.isEmpty) {
      Navigator.of(context).pop();
      return Container();
    }

    List<double> transformData(
      int Function(RulaScores) selector,
      int maxValue,
    ) {
      return timeline.map((entry) {
        final score = selector(entry.scores);
        return normalizeScore(score, maxValue);
      }).toList();
    }

    final lineChartData = IList([
      transformData(
        ((RulaScores scores) => scores.upperArmScores)
            .compose(Pair.reduce(worse)),
        6,
      ),
      transformData(
        ((RulaScores scores) => scores.lowerArmScores)
            .compose(Pair.reduce(worse)),
        3,
      ),
      transformData((RulaScores scores) => scores.trunkScore, 6),
      transformData((RulaScores scores) => scores.neckScore, 6),
      transformData((RulaScores scores) => scores.legScore, 2),
    ]);

    final avgLineChartValues = IList(
      lineChartData.map((spots) => calculateRunningAverage(spots, 20)).toList(),
    );

    final medianTimelineValues = IList(
      lineChartData.map((spots) => calculateRunningMedian(spots, 60)).toList(),
    );

    void navigateToBodyPartPage(BodyPartGroup bodyPart) {
      final bodyPartDetailViewModel = BodyPartResultsViewModel(
        bodyPartName: labels[bodyPart.index],
        timelineValues: avgLineChartValues[bodyPart.index],
        medianTimelineValues: medianTimelineValues[bodyPart.index],
        bodyPartGroup: bodyPart,
      );

      Navigator.push(
        context,
        MaterialPageRoute<void>(
          builder: (context) => BodyPartResultsScreen(
            viewModel: bodyPartDetailViewModel,
          ),
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
                                  child: Text(labels[part.index]),
                                ),
                                Expanded(
                                  child: CustomPaint(
                                    painter: HeatmapPainter(
                                      normalizedScores:
                                          avgLineChartValues[part.index],
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
                            ColorMapper.rulaLow,
                            ColorMapper.rulaLowMid,
                            ColorMapper.rulaMid,
                            ColorMapper.rulaMidHigh,
                            ColorMapper.rulaHigh,
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
