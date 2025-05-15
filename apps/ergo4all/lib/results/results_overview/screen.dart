import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/common.dart';
import 'package:ergo4all/results/results_overview/body_score_display.dart';
import 'package:flutter/material.dart';

/// The screen for viewing an overview over the analysis results.
class ResultsOverviewScreen extends StatelessWidget {
  ///
  const ResultsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final timeline =
        ModalRoute.of(context)!.settings.arguments as RulaTimeline?;

    if (timeline == null || timeline.isEmpty) {
      Navigator.of(context).pop();
      return Container();
    }

    void goToDetails() {
      Navigator.of(context)
          .pushNamed(Routes.resultsDetail.path, arguments: timeline);
    }

    final aggregate = aggregateTimeline(timeline)!;

    return Scaffold(
      body: Column(
        children: [
          Text(
            '${localizations.results_ergo_score_header}:',
            style: h2Style,
            textAlign: TextAlign.center,
          ),
          BodyScoreDisplay(aggregate),
          Text(
            localizations.results_press_body_part,
            style: staticBodyStyle,
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            onPressed: goToDetails,
            style: secondaryTextButtonStyle,
            child: const Text('Details'),
          ),
        ],
      ),
    );
  }
}
