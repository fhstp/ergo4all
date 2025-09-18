import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/body_part_group.dart';
import 'package:ergo4all/results/rating.dart';
import 'package:ergo4all/scenario/common.dart';

/// Extensions for getting variable localized texts.
extension VariableLocalizations on AppLocalizations {
  /// Get the localized label for the given [group].
  String bodyPartGroupLabel(BodyPartGroup group) => switch (group) {
        BodyPartGroup.shoulder => results_body_shoulder,
        BodyPartGroup.arm => results_body_arm,
        BodyPartGroup.trunk => results_body_trunk,
        BodyPartGroup.neck => results_body_neck,
        BodyPartGroup.legs => results_body_legs,
      };

  /// Gets a localized message to display to users which explains
  /// why the given [group] received the [rating] and what they should
  /// do about it.
  String ratedBodyPartMessage(BodyPartGroup group, Rating rating) =>
      switch ((group, rating)) {
        (BodyPartGroup.shoulder, Rating.good) => shoulderGood,
        (BodyPartGroup.shoulder, Rating.medium) => shoulderMedium,
        (BodyPartGroup.shoulder, Rating.low) => shoulderLow,
        (BodyPartGroup.arm, Rating.good) => armGood,
        (BodyPartGroup.arm, Rating.medium) => armMedium,
        (BodyPartGroup.arm, Rating.low) => armLow,
        (BodyPartGroup.trunk, Rating.good) => trunkGood,
        (BodyPartGroup.trunk, Rating.medium) => trunkMedium,
        (BodyPartGroup.trunk, Rating.low) => trunkLow,
        (BodyPartGroup.neck, Rating.good) => neckGood,
        (BodyPartGroup.neck, Rating.medium) => neckMedium,
        (BodyPartGroup.neck, Rating.low) => neckLow,
        (BodyPartGroup.legs, Rating.good) => legsGood,
        (BodyPartGroup.legs, Rating.medium) => legsMedium,
        (BodyPartGroup.legs, Rating.low) => legsLow,
      };

  /// Gets a localized tip for the given [scenario].
  String scenarioTip(Scenario scenario) => switch (scenario) {
        Scenario.liftAndCarry => scenario_lift_and_carry_tips,
        Scenario.pull => scenario_pull_tips,
        Scenario.seated => scenario_seated_tips,
        Scenario.packaging => scenario_packaging_tips,
        Scenario.standingCNC => scenario_CNC_tips,
        Scenario.standingAssembly => scenario_assembly_tips,
        Scenario.ceiling => scenario_ceiling_tips,
        Scenario.lift25 => scenario_lift_tips,
        Scenario.conveyorBelt => scenario_conveyor_tips,
        Scenario.freestyle => '',
      };

  /// Gets a localized improvement suggestion for the given [scenario].
  String scenarioImprovement(Scenario scenario) => switch (scenario) {
        Scenario.liftAndCarry => scenario_lift_and_carry_tools,
        Scenario.pull => scenario_pull_tools,
        Scenario.seated => scenario_seated_tools,
        Scenario.packaging => scenario_packaging_tools,
        Scenario.standingCNC => scenario_CNC_tools,
        Scenario.standingAssembly => scenario_assembly_tools,
        Scenario.ceiling => scenario_ceiling_tools,
        Scenario.lift25 => scenario_lift_tools,
        Scenario.conveyorBelt => scenario_conveyor_tools,
        Scenario.freestyle => '',
      };
}
