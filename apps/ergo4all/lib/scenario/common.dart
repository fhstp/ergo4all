import 'package:ergo4all/gen/i18n/app_localizations.dart';

/// The different work scenarios we can evaluate
enum Scenario {
  /// Lifting and carrying heavy loads up to 25 kg
  liftAndCarry,

  /// Pushing and pulling material trolleys up to 150 kg
  pull,

  /// Working in a seated position
  seated,

  /// Packaging work with a high repetition rate
  packaging,

  /// Working in a standing position on a CNC machine
  standingCNC,

  /// Assembly standing at a table
  standingAssembly,

  /// Cable installation on the ceiling
  ceiling,

  /// Lifting a bag weighing up to 25 kg
  lift25,

  /// Working on a conveyor belt for long periods
  conveyorBelt;

  String title(AppLocalizations localizations) => switch (this) {
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
}
