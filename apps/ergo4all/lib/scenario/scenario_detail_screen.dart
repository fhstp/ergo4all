import 'dart:async';

import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/icon_back_button.dart';
import 'package:common_ui/widgets/red_circle_bottom_bar.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/home/screen.dart';
import 'package:ergo4all/scenario/common.dart';
import 'package:ergo4all/scenario/scenario_graphic.dart';
import 'package:ergo4all/scenario/variable_localizations.dart';
import 'package:flutter/material.dart';

/// Screen for viewing a detailed description of a [Scenario].
class ScenarioDetailScreen extends StatelessWidget {
  ///
  const ScenarioDetailScreen({required this.scenario, super.key});

  /// The scenario for which to view detail.
  final Scenario scenario;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    // Pass scenario context
    void goToRecordScreen() {
      unawaited(
        Navigator.of(context).pushNamedAndRemoveUntil(
          Routes.liveAnalysis.path,
          ModalRoute.withName(HomeScreen.routeName),
          arguments: scenario,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: const IconBackButton(color: cardinal),
        title: Text(localizations.scenario_detail_title),
      ),
      body: Stack(
        children: [
          const Align(
            alignment: Alignment.bottomCenter,
            child: RedCircleBottomBar(),
          ),
          SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: largeSpace),
            child: Align(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: mediumSpace),
                    Text(
                      localizations.scenarioSummary(scenario),
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
                          localizations.scenarioDescription(scenario),
                          style: dynamicBodyStyle,
                        ),
                        const SizedBox(height: mediumSpace),
                        Text(
                          localizations.common_expectation,
                          style: paragraphHeaderStyle,
                        ),
                        Text(
                          localizations.scenarioExpectation(scenario),
                          style: dynamicBodyStyle,
                        ),
                      ],
                    ),
                    const SizedBox(height: mediumSpace),
                    ScenarioGraphic(scenario, height: 330),
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
        ],
      ),
    );
  }
}
