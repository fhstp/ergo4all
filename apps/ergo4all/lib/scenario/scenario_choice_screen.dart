import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/red_circle_top_bar.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/scenario/domain.dart';
import 'package:flutter/material.dart';

class ScenarioChoiceScreen extends StatelessWidget {
  const ScenarioChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

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
                  child: Text(scenario.name),
                  onPressed: () {},
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
