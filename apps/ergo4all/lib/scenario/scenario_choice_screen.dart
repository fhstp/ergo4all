import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/red_circle_top_bar.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/scenario/domain.dart';
import 'package:flutter/material.dart';

class ScenarioChoiceScreen extends StatelessWidget {
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
          Scenario.lift25 => localizations.scenario_lift_and_carry_label,
          Scenario.conveyorBelt => localizations.scenario_conveyor_label,
        };

    void goToDetailScreen(Scenario scenario) async {
      await Navigator.of(context)
          .pushNamed(Routes.scenarioDetail.path, arguments: scenario);
    }

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
                  onPressed: () {
                    goToDetailScreen(scenario);
                  },
                  child: Text(titleFor(scenario)),
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
