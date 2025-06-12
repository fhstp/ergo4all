import 'dart:async';

import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/icon_back_button.dart';
import 'package:ergo4all/analysis/common.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/scenario/common.dart';
import 'package:ergo4all/session_storage/session_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// Sessions screen that displays a list of all the user stored sessions
class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen>
    with SingleTickerProviderStateMixin {
  late RulaSessionRepository dataStorage;

  List<RulaSession> sessions = List.empty();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    dataStorage = Provider.of<RulaSessionRepository>(context);
    dataStorage.getAll().then((it) {
      setState(() {
        sessions = it;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    void goToResults(RulaSession session) {
      if (!context.mounted) return;
      unawaited(
        Navigator.of(context).pushReplacementNamed(
          Routes.resultsOverview.path,
          arguments: AnalysisResult(
            scenario: session.scenario,
            timeline: session.timeline,
          ),
        ),
      );
    }

    String titleFor(Scenario scenario) => switch (scenario) {
          Scenario.liftAndCarry => localizations.scenario_lift_and_carry_label,
          Scenario.pull => localizations.scenario_pull_label,
          Scenario.seated => localizations.scenario_seated_label,
          Scenario.packaging => localizations.scenario_packaging_label,
          Scenario.standingCNC => localizations.scenario_CNC_label,
          Scenario.standingAssembly => localizations.scenario_assembly_label,
          Scenario.ceiling => localizations.scenario_ceiling_label,
          Scenario.lift25 => localizations.scenario_lift_label,
          Scenario.conveyorBelt => localizations.scenario_conveyor_label,
        };

    return Scaffold(
      appBar: AppBar(
        leading: const IconBackButton(color: cardinal),
        title: Text(
          localizations.sessions_header,
          textAlign: TextAlign.center,
        ),
      ),
      body: SafeArea(
        child: sessions.isEmpty
            ? Center(
                child: Text(localizations.no_sessions_placeholder,
                    style: paragraphHeaderStyle))
            : ListView.builder(
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final dateTime = DateTime.fromMillisecondsSinceEpoch(
                      sessions[index].timestamp);
                  final scenario = sessions[index].scenario;
                  final scenarioLabel = titleFor(scenario);
                  final formattedDate =
                      DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
                  return Dismissible(
                    key: Key(sessions[index].timestamp.toString()),
                    onDismissed: (direction) async {
                      await dataStorage
                          .deleteByTimestamp(sessions[index].timestamp);
                      if (!context.mounted) return;

                      setState(() {
                        sessions.removeAt(index);
                      });

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(
                        SnackBar(
                            content:
                                Text(localizations.delete_session_message)),
                      );
                    },
                    child: ListTile(
                      title: Text('$scenarioLabel ($formattedDate)',
                          style: paragraphHeaderStyle),
                      onTap: () {
                        goToResults(sessions[index]);
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
