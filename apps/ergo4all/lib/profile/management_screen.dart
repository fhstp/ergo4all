import 'dart:async';

import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/red_circle_app_bar.dart';
import 'package:ergo4all/profile/common.dart';
import 'package:ergo4all/profile/creation/dialog.dart';
import 'package:ergo4all/profile/storage/common.dart';
import 'package:ergo4all/session_storage/session_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// Screen where users can manage the [Profile]s filmed by the app.
class ProfileManagementScreen extends StatefulWidget {
  ///
  const ProfileManagementScreen({super.key});

  /// The route name for this screen.
  static const String routeName = 'profile-management';

  /// Creates a [MaterialPageRoute] to navigate to this screen.
  static MaterialPageRoute<void> makeRoute() {
    return MaterialPageRoute(
      builder: (_) => const ProfileManagementScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  State<ProfileManagementScreen> createState() =>
      _ProfileManagementScreenState();
}

final _dateFormat = DateFormat.yMd();

@immutable
class _EntryData {
  const _EntryData({required this.profile, required this.lastRecordedDate});

  final Profile profile;
  final DateTime? lastRecordedDate;
}

class _ProfileEntry extends StatelessWidget {
  const _ProfileEntry(this.data, {this.onDismissed});

  final _EntryData data;
  final void Function()? onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(data.profile.id.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) {
        onDismissed?.call();
      },
      confirmDismiss: (_) async {
        final isDefaultUser = data.profile.id == ProfileRepo.defaultProfile.id;

        // TODO: Localize
        if (isDefaultUser) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Can't delete default default")),
          );
        }

        return !isDefaultUser;
      },
      background: Container(color: cardinal),
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
                          data.profile.nickname,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          data.lastRecordedDate != null
                              ? _dateFormat.format(data.lastRecordedDate!)
                              // TODO: Localize
                              : 'Noch keine Aufnahme',
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.delete_outline, color: blueChill),
                  const SizedBox(width: 20),
                  const Icon(Icons.chevron_right, color: blueChill),
                ],
              ),
            ),
            const Divider(color: blueChill),
          ],
        ),
      ),
    );
  }
}

class _ProfileManagementScreenState extends State<ProfileManagementScreen> {
  List<_EntryData> entries = List.empty();

  late final ProfileRepo profileRepo;
  late final RulaSessionRepository sessionRepo;

  Future<void> refreshProfiles() async {
    final profiles = await profileRepo.getAll();
    final entries = await Future.wait(
      profiles.map((profile) async {
        final lastMeta = await sessionRepo.getLatestMetaFor(profile.id);
        final lastTimestamp = lastMeta?.timestamp;
        final lastDate = lastTimestamp != null
            ? DateTime.fromMillisecondsSinceEpoch(lastTimestamp)
            : null;
        return _EntryData(profile: profile, lastRecordedDate: lastDate);
      }),
    );
    setState(() {
      this.entries = entries;
    });
  }

  @override
  void initState() {
    super.initState();

    profileRepo = Provider.of(context, listen: false);
    sessionRepo = Provider.of(context, listen: false);

    refreshProfiles();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> openProfileCreator() async {
      await showDialog<void>(
        context: context,
        builder: (_) => const ProfileCreationDialog(),
      );
      unawaited(refreshProfiles());
    }

    Future<void> deleteProfile(Profile profile) async {
      await profileRepo.deleteById(profile.id);
      await sessionRepo.deleteAllBy(profile.id);
      unawaited(refreshProfiles());

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Deleted ${profile.nickname}')),
      );
    }

    return Scaffold(
      appBar: const RedCircleAppBar(
        // TODO: Localize
        titleText: 'Profiles',
        withBackButton: true,
      ),
      body: SafeArea(
        minimum: const EdgeInsets.fromLTRB(
          mediumSpace,
          largeSpace,
          mediumSpace,
          mediumSpace,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: entries
                        .map(
                          (entry) => _ProfileEntry(
                            entry,
                            onDismissed: () => deleteProfile(entry.profile),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: mediumSpace),
            ElevatedButton(
              onPressed: openProfileCreator,
              style: primaryTextButtonStyle,
              // TODO: Localize
              child: const Text('New Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
