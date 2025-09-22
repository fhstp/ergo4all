import 'dart:async';

import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/icon_back_button.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/profile/common.dart';
import 'package:ergo4all/profile/storage/common.dart';
import 'package:ergo4all/results/screen.dart';
import 'package:ergo4all/scenario/common.dart';
import 'package:ergo4all/session_storage/session_storage.dart';
import 'package:ergo4all/session_storage/src/fs.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// Sessions screen that displays a list of all the user stored sessions
class SessionChoiceScreen extends StatefulWidget {
  ///
  const SessionChoiceScreen({super.key});

  /// The route name for this screen.
  static const String routeName = 'session-choice';

  /// Creates a [MaterialPageRoute] to navigate to this screen.
  static MaterialPageRoute<void> makeRoute() {
    return MaterialPageRoute(
      builder: (_) => const SessionChoiceScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  State<SessionChoiceScreen> createState() => _SessionChoiceScreenState();
}

final _dateFormat = DateFormat('dd MMM yyyy, HH:mm');

class _SessionEntry extends StatelessWidget {
  const _SessionEntry({
    required this.session,
    required this.profile,
    this.onTap,
    this.onDismissed,
  });

  final RulaSessionMeta session;
  final Profile profile;
  final void Function()? onTap;
  final void Function()? onDismissed;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final sessionTimestamp =
        DateTime.fromMillisecondsSinceEpoch(session.timestamp);
    final scenarioLabel = switch (session.scenario) {
      Scenario.liftAndCarry => localizations.scenario_lift_and_carry_label,
      Scenario.pull => localizations.scenario_pull_label,
      Scenario.seated => localizations.scenario_seated_label,
      Scenario.packaging => localizations.scenario_packaging_label,
      Scenario.standingCNC => localizations.scenario_CNC_label,
      Scenario.standingAssembly => localizations.scenario_assembly_label,
      Scenario.ceiling => localizations.scenario_ceiling_label,
      Scenario.lift25 => localizations.scenario_lift_label,
      Scenario.conveyorBelt => localizations.scenario_conveyor_label,
      null => localizations.scenario_freestyle_label,
    };
    final subTitle = '${profile.nickname} - $scenarioLabel';

    return Dismissible(
      key: Key(session.timestamp.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) {
        onDismissed?.call();
      },
      background: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [persimmon, spindle]),
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: ColoredBox(
          color: spindle,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _dateFormat.format(sessionTimestamp),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(subTitle),
                        ],
                      ),
                    ),
                    const Icon(Icons.delete_outline, color: blueChill),
                    const SizedBox(width: 20),
                    const Icon(Icons.chevron_right, color: blueChill),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: mediumSpace),
                child: Divider(color: blueChill),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionChoiceScreenState extends State<SessionChoiceScreen>
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    sessionRepository.getAll().then((it) {
      setState(() {
        sessions = it;
      });
    });

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

    Future<void> deleteSessionWith(int index) async {
      await sessionRepository.deleteByTimestamp(sessions[index].timestamp);
      if (!context.mounted) return;

      setState(() {
        sessions.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations.delete_session_message),
        ),
      );
    }

    final content = sessions.isEmpty
        ? Center(
            child: Text(
              localizations.no_sessions_placeholder,
              style: paragraphHeaderStyle,
            ),
          )
        : Padding(
          padding: const EdgeInsets.symmetric(vertical: largeSpace),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: ListView.builder(
              itemCount: sessions.length,
              shrinkWrap: true,
              itemExtent: 76,
              itemBuilder: (context, index) {
                final session = sessions[index];
                return _SessionEntry(
                  session: session,
                  profile: profilesById[session.profileId]!,
                  onDismissed: () {
                    deleteSessionWith(index);
                  },
                  onTap: () {
                    goToResultsFor(session);
                  },
                );
              },
            ),
          ),
        );

    return Scaffold(
      appBar: AppBar(
        leading: const IconBackButton(color: cardinal),
        title: Text(
          localizations.sessions_header,
          textAlign: TextAlign.center,
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: mediumSpace),
        child: Column(children: [Expanded(child: content)]),
      ),
    );
  }
}
