import 'dart:async';

import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/icon_back_button.dart';
import 'package:common_ui/widgets/red_circle_bottom_bar.dart';
import 'package:ergo4all/analysis/screen.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/home/screen.dart';
import 'package:ergo4all/profile/common.dart';
import 'package:ergo4all/profile/storage/common.dart';
import 'package:ergo4all/scenario/common.dart';
import 'package:ergo4all/scenario/detail/profile_selector.dart';
import 'package:ergo4all/scenario/scenario_graphic.dart';
import 'package:ergo4all/scenario/variable_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Screen for viewing a detailed description of a [Scenario].
class ScenarioDetailScreen extends StatefulWidget {
  ///
  const ScenarioDetailScreen({required this.scenario, super.key});

  /// The route name for this screen.
  static const String routeName = 'scenario-detail';

  /// Creates a [MaterialPageRoute] to navigate to this screen in order to
  /// view the given [scenario].
  static MaterialPageRoute<void> makeRoute(Scenario scenario) {
    return MaterialPageRoute(
      builder: (_) => ScenarioDetailScreen(scenario: scenario),
      settings: const RouteSettings(name: routeName),
    );
  }

  /// The scenario for which to view detail.
  final Scenario scenario;

  @override
  State<ScenarioDetailScreen> createState() => _ScenarioDetailScreenState();
}

class _ScenarioDetailScreenState extends State<ScenarioDetailScreen> {
  late final ProfileRepo profileRepo;

  List<Profile> profiles = [];
  Profile? selectedProfile;

  @override
  void initState() {
    super.initState();

    profileRepo = Provider.of(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    profileRepo.getAll().then((it) {
      setState(() {
        assert(it.isNotEmpty, 'There must be at least 1 profile');

        profiles = it;
        selectedProfile = profiles.first;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    // Pass scenario context
    void goToRecordScreen() {
      assert(selectedProfile != null, 'Must have selected a profile');

      unawaited(
        Navigator.of(context).pushAndRemoveUntil(
          LiveAnalysisScreen.makeRoute(widget.scenario, selectedProfile!),
          ModalRoute.withName(HomeScreen.routeName),
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
                    Text(
                      localizations.scenarioSummary(widget.scenario),
                      style: h4Style.copyWith(color: cardinal),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: mediumSpace),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        localizations.common_description,
                        style: paragraphHeaderStyle,
                      ),
                    ),
                    Text(
                      localizations.scenarioDescription(widget.scenario),
                      style: dynamicBodyStyle,
                    ),
                    const SizedBox(height: mediumSpace),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        textAlign: TextAlign.start,
                        localizations.common_expectation,
                        style: paragraphHeaderStyle,
                      ),
                    ),
                    Text(
                      localizations.scenarioExpectation(widget.scenario),
                      style: dynamicBodyStyle,
                    ),
                    const SizedBox(height: mediumSpace),
                    ScenarioGraphic(widget.scenario, height: 330),
                    const SizedBox(height: mediumSpace),
                    ProfileSelector(
                      profiles: profiles,
                      selected: selectedProfile,
                      onSelected: (it) {
                        setState(() {
                          selectedProfile = it;
                        });
                      },
                    ),
                    const SizedBox(height: mediumSpace),
                    ElevatedButton(
                      key: const Key('start'),
                      style: primaryTextButtonStyle,
                      onPressed:
                          selectedProfile != null ? goToRecordScreen : null,
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
