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


/// Helper to get  text for a recognised activity
String? _tipForActivity(Activity activity, AppLocalizations localizations) {
  return switch (activity) {
    Activity.lifting => localizations.activity_lift_tipps,
    Activity.carrying => localizations.activity_carry_tipps,
    Activity.overhead => localizations.activity_overhead_tipps,
    Activity.sitting => localizations.activity_sitting_tipps,
    Activity.standing => localizations.activity_standing_tipps,
    Activity.kneeling => localizations.activity_kneeling_tipps,
    Activity.walking => localizations.activity_standing_tipps,
    Activity.background => null
  };
}

/// Helper to merge ranking text with activity explanations
String? activityRanking(int index, AppLocalizations localizations) {
  switch (index) {
    case 0:
      return localizations.activity_first;
    case 1:
      return localizations.activity_second;
    case 2:
      return localizations.activity_third;
    default:
      return null;
  }
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

    final topThreeActivities = highestRulaActivities!.take(3).toList();

    if (scenario == null) {
      // Freestyle mode - use tips for three activities with highest RULA
      if (highestRulaActivities != null && highestRulaActivities!.isNotEmpty) {
        final activityTexts = <String>[];

        for (var i = 0; i < topThreeActivities.length; i++) {
          final activity = topThreeActivities[i];

          // We merge texts together          
          final tip = _tipForActivity(activity, localizations);
          final intro = activityRanking(i, localizations);
          
          if (intro != null && tip != null) {
            activityTexts.add('$intro $tip');
          }
        }
        
        tips = activityTexts.join('\n\n');
      }
    } else {
      // Scenario mode
      textScenario = scenario;
      tips = localizations.scenarioTip(scenario!);
      improvements = localizations.scenarioImprovement(scenario!);
    }


    // Header depends on scenario vs freestyle mode
    String tipsHeader = scenario == null
        ? localizations.activity_recognition_header
        : localizations.ergonomics_tipps;
        

    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            tipsHeader,
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
