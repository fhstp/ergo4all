import 'dart:math';

import 'package:common/immutable_collection_ext.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/icon_back_button.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/body_part_detail/body_part_line_chart.dart';
import 'package:ergo4all/results/body_part_detail/static_load_chart.dart';
import 'package:ergo4all/results/body_part_group.dart';
import 'package:ergo4all/results/detail/utils.dart';
import 'package:ergo4all/results/rating.dart';
import 'package:ergo4all/results/variable_localizations.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
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

/// Screen display detailed score information about a specific [BodyPartGroup].
class BodyPartResultsScreen extends StatelessWidget {
  ///
  const BodyPartResultsScreen({
    required this.timelines,
    required this.bodyPartGroup,
    required this.recordingDuration,
    super.key,
  });

  /// The normalized scores over time. The displayed [Rating] will be
  /// calculated from these. They are also displayed in the ergonomic
  /// rating chart.
  /// For singular body parts this should be a single list, for
  /// paired body parts there should be two.
  final IList<IList<double>> timelines;

  /// The body to display.
  final BodyPartGroup bodyPartGroup;

  /// The duration of the recording in seconds.
  final int recordingDuration;

  /// Makes a [MaterialPageRoute] to navigate to this screen.
  static MaterialPageRoute<void> makeRoute({
    required BodyPartGroup bodyPartGroup,
    required IList<IList<double>> timelines,
    required int recordingDuration,
  }) {
    return MaterialPageRoute<void>(
      builder: (context) => BodyPartResultsScreen(
        bodyPartGroup: bodyPartGroup,
        timelines: timelines,
        recordingDuration: recordingDuration,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final averagedTimelines = timelines
        .map((scores) => calculateRunningAverage(scores, 20))
        .toIList();

    // Need at least 15s of data to show the static load chart
    final showStaticLoad = recordingDuration >= 15;
    final staticLoadScores = showStaticLoad
        ? calculateRunningMedian(timelines.reduce2d(max), 20)
        : const IList<double>.empty();

    final bodyPartLabel = localizations.bodyPartGroupLabel(bodyPartGroup);

    // Here we walk the two timelines for left/right body parts and
    // pick the worst score for each timestamp. Is this right?
    // Might be worth rethinking.
    final rating = calculateRating(averagedTimelines.reduce2d(max));
    final message =
        _localizationMap['${bodyPartGroup.name}${rating.name.capitalize()}']!(
      localizations,
    );

    return Scaffold(
      appBar: AppBar(
        leading: const IconBackButton(),
        title: Text(bodyPartLabel),
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
            const SizedBox(height: mediumSpace),
            SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: smallSpace),
                child: BodyPartLineChart(timelines: averagedTimelines),
              ),
            ),
            const SizedBox(height: largeSpace),
            Text(
              localizations.body_part_static_plot_title,
              style: paragraphHeaderStyle,
            ),
            const SizedBox(height: smallSpace),
            if (showStaticLoad)
              SizedBox(
                height: 132,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: smallSpace),
                  child: StaticLoadChart(staticLoadScores: staticLoadScores),
                ),
              )
            else
              Text(
                localizations.body_part_static_plot_condition,
                style: dynamicBodyStyle,
              ),
            const SizedBox(height: largeSpace),
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
