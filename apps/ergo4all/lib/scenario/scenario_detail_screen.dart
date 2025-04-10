import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/scenario/domain.dart';
import 'package:flutter/material.dart';

class ScenarioDetailScreen extends StatelessWidget {
  const ScenarioDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final scenario = ModalRoute.of(context)!.settings.arguments as Scenario;

    final summary = switch (scenario) {
      Scenario.liftAndCarry => localizations.scenario_lift_and_carry_summary,
      Scenario.pull => localizations.scenario_pull_summary,
      Scenario.seated => localizations.scenario_seated_summary,
      Scenario.packaging => localizations.scenario_packaging_summary,
      Scenario.standingCNC => localizations.scenario_CNC_summary,
      Scenario.standingAssembly => localizations.scenario_assembly_summary,
      Scenario.ceiling => localizations.scenario_ceiling_summary,
      Scenario.lift25 => localizations.scenario_lift_and_carry_summary,
      Scenario.conveyorBelt => localizations.scenario_conveyor_summary,
    };

    final description = switch (scenario) {
      Scenario.liftAndCarry =>
        localizations.scenario_lift_and_carry_description,
      Scenario.pull => localizations.scenario_pull_description,
      Scenario.seated => localizations.scenario_seated_description,
      Scenario.packaging => localizations.scenario_packaging_description,
      Scenario.standingCNC => localizations.scenario_CNC_description,
      Scenario.standingAssembly => localizations.scenario_assembly_description,
      Scenario.ceiling => localizations.scenario_ceiling_description,
      Scenario.lift25 => localizations.scenario_lift_and_carry_description,
      Scenario.conveyorBelt => localizations.scenario_conveyor_description,
    };

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            summary,
            style: h4Style.copyWith(color: cardinal),
            textAlign: TextAlign.center,
          ),
          Text(
            localizations.common_description,
            style: paragraphHeader,
            textAlign: TextAlign.start,
          ),
          Text(
            description,
            textAlign: TextAlign.start,
          )
        ],
      ),
    );
  }
}
