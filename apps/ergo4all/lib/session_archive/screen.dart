import 'dart:async';

import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/icon_back_button.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/profile/common.dart';
import 'package:ergo4all/profile/storage/common.dart';
import 'package:ergo4all/results/screen.dart';
import 'package:ergo4all/session_archive/list.dart';
import 'package:ergo4all/session_storage/session_storage.dart';
import 'package:ergo4all/session_storage/src/fs.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Sessions screen that displays a list of all the user stored sessions
class SessionArchiveScreen extends StatefulWidget {
  ///
  const SessionArchiveScreen({super.key});

  /// The route name for this screen.
  static const String routeName = 'session-archive';

  /// Creates a [MaterialPageRoute] to navigate to this screen.
  static MaterialPageRoute<void> makeRoute() {
    return MaterialPageRoute(
      builder: (_) => const SessionArchiveScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  State<SessionArchiveScreen> createState() => _SessionArchiveScreenState();
}

class _SessionArchiveScreenState extends State<SessionArchiveScreen>
    with SingleTickerProviderStateMixin {
  late final RulaSessionRepository sessionRepository;
  late final ProfileRepo profileRepo;

  List<RulaSessionMeta> sessions = List.empty();
  IMap<int, Profile> profilesById = const IMap.empty();

  @override
  void initState() {
    super.initState();

    sessionRepository = Provider.of(context, listen: false);
    profileRepo = Provider.of(context, listen: false);
  }

  void reloadSessions() {
    sessionRepository.getAll().then((it) {
      setState(() {
        sessions = it;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    reloadSessions();

    profileRepo.getAllAsMap().then((it) {
      setState(() {
        profilesById = it;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    Future<void> goToResultsFor(RulaSessionMeta sessionMeta) async {
      final profile = profilesById[sessionMeta.profileId];
      assert(profile != null, 'Profile for session must exist');

      final session =
          await sessionRepository.getByTimestamp(sessionMeta.timestamp);
      assert(
        session != null,
        'Session should exist since we just got it from storage',
      );

      if (!context.mounted) return;
      unawaited(
        Navigator.of(context).pushReplacement(
          ResultsScreen.makeRoute(session!, profile!),
        ),
      );
    }

    Future<void> deleteSession(RulaSessionMeta session) async {
      await sessionRepository.deleteByTimestamp(session.timestamp);
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.delete_session_message),
        ),
      );

      reloadSessions();
    }

    return Scaffold(
      appBar: AppBar(
        leading: const IconBackButton(color: cardinal),
        title: Text(
          localizations.sessions_header,
          textAlign: TextAlign.center,
        ),
      ),
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (sessions.isEmpty) {
              return Center(
                child: Text(
                  localizations.no_sessions_placeholder,
                  style: paragraphHeaderStyle,
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: mediumSpace,
                vertical: largeSpace,
              ),
              child: Column(
                spacing: mediumSpace,
                children: [
                  Text(localizations.delete_action_explanation),
                  SessionList(
                    sessions: sessions,
                    profilesById: profilesById,
                    onSessionDismissed: deleteSession,
                    onSessionTapped: goToResultsFor,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
