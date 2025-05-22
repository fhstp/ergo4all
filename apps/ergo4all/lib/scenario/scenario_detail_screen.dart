import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/icon_back_button.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/scenario/domain.dart';
import 'package:flutter/material.dart';
import 'package:svg_flutter/svg_flutter.dart';

/// Screen for viewing a detailed description of a [Scenario].
class ScenarioDetailScreen extends StatelessWidget {
  ///
  const ScenarioDetailScreen({required this.scenario, super.key});

  /// The scenario for which to view detail.
  final Scenario scenario;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

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
      Scenario.lift25 => localizations.scenario_lift_description,
      Scenario.conveyorBelt => localizations.scenario_conveyor_description,
    };

    final expectation = switch (scenario) {
      Scenario.liftAndCarry =>
        localizations.scenario_lift_and_carry_expectation,
      Scenario.pull => localizations.scenario_pull_expectation,
      Scenario.seated => localizations.scenario_seated_expectation,
      Scenario.packaging => localizations.scenario_packaging_expectation,
      Scenario.standingCNC => localizations.scenario_CNC_expectation,
      Scenario.standingAssembly => localizations.scenario_assembly_expectation,
      Scenario.ceiling => localizations.scenario_ceiling_expectation,
      Scenario.lift25 => localizations.scenario_lift_expectation,
      Scenario.conveyorBelt => localizations.scenario_conveyor_expectation,
    };

    final graphicFileName = switch (scenario) {
      Scenario.liftAndCarry || Scenario.lift25 => 'lifting',
      Scenario.pull => 'pushing',
      Scenario.seated => 'sitting',
      Scenario.packaging ||
      Scenario.standingCNC ||
      Scenario.standingAssembly ||
      Scenario.conveyorBelt =>
        'standing',
      Scenario.ceiling => 'overhead_work',
    };
    final graphicKey = 'assets/images/puppet_scenario/$graphicFileName.svg';

    // Pass scenario context
    Future<void> goToRecordScreen() async {
      await Navigator.of(context).pushNamedAndRemoveUntil(
        Routes.liveAnalysis.path,
        ModalRoute.withName(Routes.home.path),
        arguments: scenario,
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: const IconBackButton(color: cardinal),
        title: Text(localizations.scenario_detail_title),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: largeSpace),
        child: Align(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: mediumSpace),
                Text(
                  summary,
                  style: h4Style.copyWith(color: cardinal),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: mediumSpace),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.common_description,
                      style: paragraphHeaderStyle,
                    ),
                    Text(
                      description,
                      style: dynamicBodyStyle,
                    ),
                    const SizedBox(height: mediumSpace),
                    Text(
                      localizations.common_expectation,
                      style: paragraphHeaderStyle,
                    ),
                    Text(
                      expectation,
                      style: dynamicBodyStyle,
                    ),
                  ],
                ),
                const SizedBox(height: mediumSpace),
                SvgPicture.asset(graphicKey, height: 330),
                const SizedBox(height: mediumSpace),
                ElevatedButton(
                  key: const Key('start'),
                  style: primaryTextButtonStyle,
                  onPressed: goToRecordScreen,
                  child: Text(localizations.record_label),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
