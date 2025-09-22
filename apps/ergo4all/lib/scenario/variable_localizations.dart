import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/scenario/common.dart';

/// Extensions for getting variable localized texts.
extension VariableLocalizations on AppLocalizations {
  /// Gets the localized label of a [Scenario].
  /// Also accepts `null` for freestyle scenarios.
  String scenarioLabel(Scenario? scenario) => switch (scenario) {
        Scenario.liftAndCarry => scenario_lift_and_carry_label,
        Scenario.pull => scenario_pull_label,
        Scenario.seated => scenario_seated_label,
        Scenario.packaging => scenario_packaging_label,
        Scenario.standingCNC => scenario_CNC_label,
        Scenario.standingAssembly => scenario_assembly_label,
        Scenario.ceiling => scenario_ceiling_label,
        Scenario.lift25 => scenario_lift_label,
        Scenario.conveyorBelt => scenario_conveyor_label,
        null => scenario_freestyle_label,
      };

  /// Gets the localized summary of a [Scenario].
  /// Also accepts `null` for freestyle scenarios.
  String scenarioSummary(Scenario? scenario) => switch (scenario) {
        Scenario.liftAndCarry => scenario_lift_and_carry_summary,
        Scenario.pull => scenario_pull_summary,
        Scenario.seated => scenario_seated_summary,
        Scenario.packaging => scenario_packaging_summary,
        Scenario.standingCNC => scenario_CNC_summary,
        Scenario.standingAssembly => scenario_assembly_summary,
        Scenario.ceiling => scenario_ceiling_summary,
        Scenario.lift25 => scenario_lift_and_carry_summary,
        Scenario.conveyorBelt => scenario_conveyor_summary,
        null => scenario_freestyle_summary,
      };

  /// Gets the localized description of a [Scenario].
  /// Also accepts `null` for freestyle scenarios.
  String scenarioDescription(Scenario? scenario) => switch (scenario) {
        Scenario.liftAndCarry => scenario_lift_and_carry_description,
        Scenario.pull => scenario_pull_description,
        Scenario.seated => scenario_seated_description,
        Scenario.packaging => scenario_packaging_description,
        Scenario.standingCNC => scenario_CNC_description,
        Scenario.standingAssembly => scenario_assembly_description,
        Scenario.ceiling => scenario_ceiling_description,
        Scenario.lift25 => scenario_lift_description,
        Scenario.conveyorBelt => scenario_conveyor_description,
        null => scenario_freestyle_description,
      };

  /// Gets the localized expectation text for a [Scenario].
  /// Also accepts `null` for freestyle scenarios.
  String scenarioExpectation(Scenario? scenario) => switch (scenario) {
        Scenario.liftAndCarry => scenario_lift_and_carry_expectation,
        Scenario.pull => scenario_pull_expectation,
        Scenario.seated => scenario_seated_expectation,
        Scenario.packaging => scenario_packaging_expectation,
        Scenario.standingCNC => scenario_CNC_expectation,
        Scenario.standingAssembly => scenario_assembly_expectation,
        Scenario.ceiling => scenario_ceiling_expectation,
        Scenario.lift25 => scenario_lift_expectation,
        Scenario.conveyorBelt => scenario_conveyor_expectation,
        null => scenario_freestyle_expectation,
      };
}
