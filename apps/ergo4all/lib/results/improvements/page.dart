import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/common/activity.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/improvements/scenario_good_bad_graphic.dart';
import 'package:ergo4all/results/screen.dart';
import 'package:ergo4all/results/variable_localizations.dart';
import 'package:ergo4all/scenario/common.dart';
import 'package:flutter/material.dart';

/// Gets the [Scenario] which includes most of the given [Activity] or
/// `null` if there is no clean match.
Scenario? _scenarioFor(Activity activity) {
  return switch (activity) {
    Activity.lifting ||
    Activity.carrying ||
    Activity.kneeling =>
      Scenario.liftAndCarry,
    Activity.overhead => Scenario.ceiling,
    Activity.sitting => Scenario.seated,
    Activity.standing =>
      Scenario.standingCNC, // or standingAssembly or packaging
    Activity.walking || Activity.background => null
  };
}

/// Page on the [ResultsScreen] for displaying feedback and improvements.
class ImprovementsPage extends StatelessWidget {
  ///
  const ImprovementsPage({
    required this.scenario,
    super.key,
    this.mostPopularActivity,
  });

  /// The recorded scenario or `null` if it was freestyle mode.
  final Scenario? scenario;

  /// Activity for which to display improvements in case the
  /// [ImprovementsPage.scenario] is `null`.
  final Activity? mostPopularActivity;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // In freestyle mode, determine tips and improvements based on selected
    // activity
    final textScenario = scenario ??
        (mostPopularActivity != null
            ? _scenarioFor(mostPopularActivity!)
            : null);

    final tips =
        textScenario != null ? localizations.scenarioTip(textScenario) : '';
    final improvements = textScenario != null
        ? localizations.scenarioImprovement(textScenario)
        : '';

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
          if (textScenario != null)
            Center(
              child: ScenarioGoodBadGraphic(textScenario, height: 330),
            ),
        ],
      ),
    );
  }
}
