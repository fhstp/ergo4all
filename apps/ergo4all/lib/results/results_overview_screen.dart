import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/results/common.dart';
import 'package:flutter/material.dart';

/// The screen for viewing an overview over the analysis results.
class ResultsOverviewScreen extends StatelessWidget {
  ///
  const ResultsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

    return ElevatedButton(
      onPressed: goToDetails,
      style: secondaryTextButtonStyle,
      child: const Text('Details'),
    );
  }
}
