import 'dart:async';

import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/red_circle_app_bar.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/scenario/common.dart';
import 'package:ergo4all/scenario/scenario_detail_screen.dart';
import 'package:ergo4all/scenario/variable_localizations.dart';
import 'package:flutter/material.dart';

/// Screen where users can choose which [Scenario] they want to record.
class ScenarioChoiceScreen extends StatelessWidget {
  ///
  const ScenarioChoiceScreen({super.key});

  /// The route name for this screen.
  static const String routeName = 'scenario-choice';

  /// Creates a [MaterialPageRoute] to navigate to this screen.
  static MaterialPageRoute<void> makeRoute() {
    return MaterialPageRoute(
      builder: (_) => const ScenarioChoiceScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Added scenario passing
    void goToDetailScreen(Scenario scenario) {
      unawaited(
        Navigator.of(context).push(ScenarioDetailScreen.makeRoute(scenario)),
      );
    }

    return Scaffold(
      appBar: RedCircleAppBar(
        titleText: localizations.choice_title,
        withBackButton: true,
      ),
      body: SafeArea(
        child: Align(
          child: Column(
            children: [
              const SizedBox(height: largeSpace),
              Expanded(
                child: SizedBox(
                  width: 275,
                  child: ListView.separated(
                    itemCount: Scenario.values.length,
                    itemBuilder: (ctx, i) {
                      final scenario = Scenario.values[i];
                      return ElevatedButton(
                        key: Key('scenario_button_${scenario.name}'),
                        style: paleTextButtonStyle,
                        onPressed: () {
                          goToDetailScreen(scenario);
                        },
                        child: Text(
                          localizations.scenarioLabel(scenario),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                    separatorBuilder: (ctx, i) =>
                        const SizedBox(height: largeSpace),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
