import 'dart:async';

import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/icon_back_button.dart';
import 'package:ergo4all/analysis/common.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/storage/rula_session.dart';
import 'package:ergo4all/storage/rula_session_repository.dart';
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

  @override
  Widget build(BuildContext context) {

    final localizations = AppLocalizations.of(context)!;

    dataStorage = Provider.of<RulaSessionRepository>(context);

    final sessions = dataStorage.getAll();

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

    return
      Scaffold(
        appBar: AppBar(
          leading: const IconBackButton(color: cardinal),
          title: Text(
            localizations.sessions_header,
            textAlign: TextAlign.center,
          ),
        ),
        body:
        SafeArea(child:
        sessions.isEmpty
            ? Center(child:
        Text(localizations.no_sessions_placeholder, style: paragraphHeaderStyle))
            :
        ListView.builder(
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            final dateTime = DateTime.fromMillisecondsSinceEpoch(sessions[index].timestamp);
            final formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
            return Dismissible(
              key: Key(sessions[index].timestamp.toString()),
              onDismissed: (direction) {
                dataStorage.deleteSession(sessions[index].timestamp);
                setState(() {
                  sessions.removeAt(index);
                });

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  SnackBar(content: Text(localizations.delete_session_message)),
                );
              },
              child: ListTile(
                title: Text(formattedDate, style: paragraphHeaderStyle),
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
