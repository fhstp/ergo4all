import 'dart:async';

import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/red_circle_app_bar.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/profile/common.dart';
import 'package:ergo4all/profile/creation/dialog.dart';
import 'package:ergo4all/profile/management/common.dart';
import 'package:ergo4all/profile/management/list.dart';
import 'package:ergo4all/profile/storage/common.dart';
import 'package:ergo4all/session_storage/session_storage.dart';
import 'package:flutter/material.dart';
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

class _ProfileManagementScreenState extends State<ProfileManagementScreen> {
  List<ProfileListEntry> entries = List.empty();

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
        return ProfileListEntry(profile: profile, lastRecordedDate: lastDate);
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
    final localizations = AppLocalizations.of(context)!;

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
        SnackBar(
          content: Text(localizations.profile_deleted(profile.nickname)),
        ),
      );
    }

    return Scaffold(
      appBar: RedCircleAppBar(
        titleText: localizations.profile_choice_title,
        withBackButton: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: mediumSpace,
            vertical: largeSpace,
          ),
          child: Column(
            spacing: mediumSpace,
            children: [
              Text(localizations.delete_action_explanation),
              Expanded(
                child: ProfileList(
                  entries: entries,
                  onProfileDismissed: deleteProfile,
                ),
              ),
              ElevatedButton(
                onPressed: openProfileCreator,
                style: primaryTextButtonStyle,
                child: Text(localizations.profile_choice_new),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
