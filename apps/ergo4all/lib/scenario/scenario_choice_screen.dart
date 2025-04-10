import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/red_circle_top_bar.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/scenario/domain.dart';
import 'package:flutter/material.dart';

class ScenarioChoiceScreen extends StatelessWidget {
  const ScenarioChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    String titleFor(Scenario scenario) => switch (scenario) {
          Scenario.liftAndCarry25 =>
            localizations.scenario_lift_and_carry_summary,
          Scenario.pull150 => localizations.scenario_pull_summary,
          Scenario.seated => localizations.scenario_seated_summary,
          Scenario.packaging => localizations.scenario_packaging_summary,
          Scenario.standingCNC => localizations.scenario_CNC_summary,
          Scenario.standingAssembly => localizations.scenario_assembly_summary,
          Scenario.ceiling => localizations.scenario_ceiling_summary,
          Scenario.lift25 => localizations.scenario_lift_and_carry_summary,
          Scenario.conveyorBelt => localizations.scenario_conveyor_summary,
        };

    return Scaffold(
      body: Column(
        children: [
          RedCircleTopBar(
            titleText: localizations.scenario_choice_title,
          ),
          SizedBox(
            height: largeSpace,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: Scenario.values.length,
              itemBuilder: (ctx, i) {
                final scenario = Scenario.values[i];
                return ElevatedButton(
                  style: paleTextButtonStyle,
                  child: Text(titleFor(scenario)),
                  onPressed: () {},
                );
              },
              separatorBuilder: (ctx, i) => SizedBox(
                height: largeSpace,
              ),
            ),
          ),
          SizedBox(
            height: largeSpace,
          ),
        ],
      ),
    );
  }
}
