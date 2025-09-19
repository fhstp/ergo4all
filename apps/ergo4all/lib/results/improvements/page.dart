import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/analysis/har/activity.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/improvements/scenario_good_bad_graphic.dart';
import 'package:ergo4all/results/screen.dart';
import 'package:ergo4all/results/variable_localizations.dart';
import 'package:ergo4all/scenario/common.dart';
import 'package:flutter/material.dart';

/// Page on the [ResultsScreen] for displaying feedback and improvements.
class ImprovementsPage extends StatelessWidget {
  ///
  const ImprovementsPage({
    required this.scenario,
    super.key,
    this.mostPopularActivity,
  });

  /// The recorded scenario.
  final Scenario scenario;

  /// Activity for which to display improvements in case the
  /// [ImprovementsPage.scenario] is [Scenario.freestyle].
  final Activity? mostPopularActivity;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // In freestyle mode, determine tips and improvements based on selected
    // activity
    final textScenario = scenario == Scenario.freestyle
        ? (mostPopularActivity != null
            ? Activity.getScenario(mostPopularActivity!) ?? Scenario.freestyle
            : Scenario.freestyle)
        : scenario;

    final tips = localizations.scenarioTip(textScenario);
    final improvements = localizations.scenarioImprovement(textScenario);

    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            localizations.ergonomics_tipps,
            style: paragraphHeaderStyle,
            textAlign: TextAlign.left,
          ),
          Text(
            tips,
            style: dynamicBodyStyle,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: mediumSpace),
          Text(
            localizations.improvements,
            style: paragraphHeaderStyle,
            textAlign: TextAlign.left,
          ),
          Text(
            improvements,
            style: dynamicBodyStyle,
            textAlign: TextAlign.left,
          ),
          Center(
            child: ScenarioGoodBadGraphic(textScenario, height: 330),
          ),
        ],
      ),
    );
  }
}
