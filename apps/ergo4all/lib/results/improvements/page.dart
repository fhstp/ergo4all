import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/common/activity.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/results/improvements/scenario_good_bad_graphic.dart';
import 'package:ergo4all/results/screen.dart';
import 'package:ergo4all/results/variable_localizations.dart';
import 'package:ergo4all/scenario/common.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';

/// Gets the [Scenario] which includes most of the given [Activity] or
/// `null` if there is no clean match.
Scenario? _scenarioFor(Activity activity) {
  return switch (activity) {
    Activity.lifting ||
    Activity.carrying =>
      Scenario.liftAndCarry,
    Activity.overhead => Scenario.ceiling,
    Activity.sitting => Scenario.seated,
    Activity.standing =>
      Scenario.standingCNC, // or standingAssembly or packaging
    Activity.walking || Activity.background || Activity.kneeling => null
  };
}

String? _tipForActivity(Activity activity, AppLocalizations localizations) {
  return switch (activity) {
    Activity.lifting => localizations.activity_lift_tipps,
    Activity.carrying => localizations.activity_carry_tipps,
    Activity.overhead => localizations.activity_overhead_tipps,
    Activity.sitting => localizations.activity_sitting_tipps,
    Activity.standing => localizations.activity_standing_tipps,
    Activity.kneeling || Activity.walking || Activity.background => null,
  };
}

/// Page on the [ResultsScreen] for displaying feedback and improvements.
class ImprovementsPage extends StatelessWidget {
  ///
  const ImprovementsPage({
    required this.scenario,
    super.key,
    this.highestRulaActivity,
    this.highestRulaActivities,
  });

  /// The recorded scenario or `null` if it was freestyle mode.
  final Scenario? scenario;

  /// Activity for which to display improvements in case the
  /// [ImprovementsPage.scenario] is `null`.
  final Activity? highestRulaActivity;

  /// List of activities with highest RULA scores for freestyle mode.
  final IList<Activity>? highestRulaActivities;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    var tips = '';
    String? improvements;
    Scenario? textScenario;

    if (scenario == null) {
      // Freestyle mode - use tips for all highest RULA activities
      if (highestRulaActivities != null && highestRulaActivities!.isNotEmpty) {
        final allTips = highestRulaActivities!
            .map((activity) => _tipForActivity(activity, localizations))
            .where((tip) => tip != null)
            .join('\n\n');
        tips = allTips;
        
        // No improvements suggestions for freestyle mode activities
        textScenario = _scenarioFor(highestRulaActivities!.first);
        improvements = null;
      }
    } else {
      // Scenario mode
      textScenario = scenario;
      tips = localizations.scenarioTip(scenario!);
      improvements = localizations.scenarioImprovement(scenario!);
    }

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
          if (improvements != null && improvements.isNotEmpty) ...[
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
          ],
          if (textScenario != null)
            Center(
              child: ScenarioGoodBadGraphic(textScenario, height: 330),
            ),
        ],
      ),
    );
  }
}
