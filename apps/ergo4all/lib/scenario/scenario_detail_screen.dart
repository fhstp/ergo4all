import 'dart:async';

import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/icon_back_button.dart';
import 'package:common_ui/widgets/red_circle_bottom_bar.dart';
import 'package:ergo4all/analysis/screen.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/home/screen.dart';
import 'package:ergo4all/scenario/common.dart';
import 'package:ergo4all/scenario/scenario_graphic.dart';
import 'package:ergo4all/scenario/variable_localizations.dart';
import 'package:ergo4all/subjects/common.dart';
import 'package:ergo4all/subjects/storage.dart';
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
  late final SubjectRepo subjectRepo;

  List<Subject> subjects = [];
  Subject? selectedSubject;

  @override
  void initState() {
    super.initState();

    subjectRepo = Provider.of(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    subjectRepo.getAll().then((subjects) {
      setState(() {
        assert(subjects.isNotEmpty, 'There must be at least 1 subject');

        this.subjects = subjects;
        selectedSubject = subjects.first;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    // Pass scenario context
    void goToRecordScreen() {
      assert(selectedSubject != null, 'Must have selected a subject');

      unawaited(
        Navigator.of(context).pushAndRemoveUntil(
          LiveAnalysisScreen.makeRoute(widget.scenario, selectedSubject!),
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
                    DropdownMenu(
                      // Having this unique key here fixes
                      // https://github.com/flutter/flutter/issues/120567
                      // where the dropdown would not resize after the subjects
                      // were loaded and be too small.
                      key: UniqueKey(),
                      // TODO: Localize
                      label: const Text('Subject'),
                      initialSelection: subjects.firstOrNull,
                      dropdownMenuEntries: subjects
                          .map(
                            (subject) => DropdownMenuEntry(
                              value: subject,
                              label: subject.nickname,
                            ),
                          )
                          .toList(),
                      onSelected: (subject) {
                        setState(() {
                          selectedSubject = subject;
                        });
                      },
                    ),
                    const SizedBox(height: mediumSpace),
                    ElevatedButton(
                      key: const Key('start'),
                      style: primaryTextButtonStyle,
                      onPressed:
                          selectedSubject != null ? goToRecordScreen : null,
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
