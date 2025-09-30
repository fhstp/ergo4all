import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/profile/common.dart';
import 'package:ergo4all/scenario/common.dart';
import 'package:ergo4all/session_storage/src/fs.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final _dateFormat = DateFormat('dd MMM yyyy, HH:mm');

class _Entry extends StatelessWidget {
  const _Entry({
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

/// Displays a list of [RulaSessionMeta] and allows the user to tap
/// or dismiss them.
class SessionList extends StatelessWidget {
  ///
  const SessionList({
    required this.sessions,
    required this.profilesById,
    super.key,
    this.onSessionDismissed,
    this.onSessionTapped,
  });

  /// The sessions to display.
  final List<RulaSessionMeta> sessions;

  /// Look-up for getting profiles by id. Used for the list-item subtitles.
  final IMap<int, Profile> profilesById;

  /// Called when a session is dismissed.
  final void Function(RulaSessionMeta session)? onSessionDismissed;

  /// Called when a session is tapped.
  final void Function(RulaSessionMeta session)? onSessionTapped;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      child: ListView.builder(
        itemCount: sessions.length,
        shrinkWrap: true,
        itemExtent: 76,
        itemBuilder: (context, index) {
          final session = sessions[index];
          return _Entry(
            session: session,
            profile: profilesById[session.profileId]!,
            onDismissed: () {
              onSessionDismissed?.call(session);
            },
            onTap: () {
              onSessionTapped?.call(session);
            },
          );
        },
      ),
    );
  }
}
