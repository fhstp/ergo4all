import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/red_circle_top_bar.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/scenario/domain.dart';
import 'package:flutter/material.dart';

/// Screen where users can choose which [Scenario] they want to record.
class ScenarioChoiceScreen extends StatelessWidget {
  ///
  const ScenarioChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    String titleFor(Scenario scenario) => switch (scenario) {
          Scenario.liftAndCarry => localizations.scenario_lift_and_carry_label,
          Scenario.pull => localizations.scenario_pull_label,
          Scenario.seated => localizations.scenario_seated_label,
          Scenario.packaging => localizations.scenario_packaging_label,
          Scenario.standingCNC => localizations.scenario_CNC_label,
          Scenario.standingAssembly => localizations.scenario_assembly_label,
          Scenario.ceiling => localizations.scenario_ceiling_label,
          Scenario.lift25 => localizations.scenario_lift_label,
          Scenario.conveyorBelt => localizations.scenario_conveyor_label,
        };

    // Added scenario passing
    Future<void> goToDetailScreen(Scenario scenario) async {
      await Navigator.of(context).pushNamed(
        Routes.scenarioDetail.path,
        arguments: scenario,
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
                          titleFor(scenario),
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
