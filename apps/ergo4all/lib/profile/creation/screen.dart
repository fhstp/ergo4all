import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/widgets/red_circle_app_bar.dart';
import 'package:ergo4all/profile/common.dart';
import 'package:ergo4all/profile/creation/form.dart';
import 'package:ergo4all/profile/storage/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Screen where users can add new [Profile]s.
class ProfileCreationScreen extends StatefulWidget {
  ///
  const ProfileCreationScreen({super.key});

  /// The route name for this screen.
  static const String routeName = 'profile-creation';

  /// Creates a [MaterialPageRoute] to navigate to this screen.
  static MaterialPageRoute<void> makeRoute() {
    return MaterialPageRoute(
      builder: (_) => const ProfileCreationScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  State<ProfileCreationScreen> createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  late final ProfileRepo profileRepo;

  @override
  void initState() {
    super.initState();

    profileRepo = Provider.of(context, listen: false);
  }

  Future<void> submitProfile(NewProfile profile) async {
    await profileRepo.createNew(profile.nickName);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const RedCircleAppBar(
        // TODO: Localize
        titleText: 'New Profile',
        withBackButton: true,
      ),
      body: SafeArea(
        child: Align(
          child: Padding(
            padding: const EdgeInsets.all(largeSpace),
            child: NewProfileForm(
              onSubmit: submitProfile,
            ),
          ),
        ),
      ),
    );
  }
}
