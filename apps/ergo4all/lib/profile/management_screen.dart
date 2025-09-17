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

class _ProfileEntry extends StatelessWidget {
  const _ProfileEntry(this.profile, {this.onDismissed});

  final Profile profile;
  final void Function()? onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(profile.id.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) {
        onDismissed?.call();
      },
      confirmDismiss: (_) async {
        final isDefaultUser = profile.id == ProfileRepo.defaultProfile.id;

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
                          profile.nickname,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const Text('[Datum]'),
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
  List<Profile> profiles = List.empty();

  late final ProfileRepo profileRepo;
  late final RulaSessionRepository sessionRepo;

  void refreshProfiles() {
    profileRepo.getAll().then((it) {
      setState(() {
        profiles = it;
      });
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
      refreshProfiles();
    }

    Future<void> deleteProfile(Profile profile) async {
      await profileRepo.deleteById(profile.id);
      await sessionRepo.deleteAllBy(profile.id);
      refreshProfiles();

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
        child: Align(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: ListView.builder(
                  itemBuilder: (context, i) => _ProfileEntry(
                    profiles[i],
                    onDismissed: () {
                      deleteProfile(profiles[i]);
                    },
                  ),
                  itemCount: profiles.length,
                  itemExtent: 76,
                  shrinkWrap: true,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: openProfileCreator,
                style: primaryTextButtonStyle,
                // TODO: Localize
                child: const Text('New Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
