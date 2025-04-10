import 'package:common_ui/widgets/red_circle_top_bar.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:flutter/material.dart';

class ScenarioChoiceScreen extends StatelessWidget {
  const ScenarioChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: Column(
        children: [
          RedCircleTopBar(
            titleText: localizations.scenario_choice_title,
          ),
        ],
      ),
    );
  }
}
