import 'dart:async';

import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/home/screen.dart';
import 'package:ergo4all/onboarding/state.dart';
import 'package:ergo4all/onboarding/style.dart';
import 'package:ergo4all/profile/creation/form.dart';
import 'package:ergo4all/profile/storage/common.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Screen for define the nickname.
class UserCreationScreen extends StatefulWidget {
  ///
  const UserCreationScreen({super.key});

  /// The route name for this screen.
  static const String routeName = 'userCreationOnboarding';

  /// Creates a [MaterialPageRoute] to navigate to this screen.
  static MaterialPageRoute<void> makeRoute() {
    return MaterialPageRoute(
      builder: (_) => const UserCreationScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  State<UserCreationScreen> createState() => _UserCreationScreenState();
}

class _UserCreationScreenState extends State<UserCreationScreen> {
  late final OnboardingState onboardingState;
  late final ProfileRepo profileRepo;

  @override
  void initState() {
    super.initState();

    onboardingState = Provider.of(context, listen: false);
    profileRepo = Provider.of(context, listen: false);
  }

  Future<void> completeOnboarding() async {
    await onboardingState.setCompleted();
    if (!mounted) return;

    unawaited(
      Navigator.pushAndRemoveUntil(
        context,
        HomeScreen.makeRoute(),
        // Remove all routes, ie. place the home-screen at the root
        (_) => false,
      ),
    );
  }

  Future<void> completeOnboardingWith(NewProfile profile) async {
    await profileRepo.createNew(profile.nickName);
    await completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: largeSpace),
        child: Column(
          children: [
            const SizedBox(height: largeSpace),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                localizations.onboarding_userCreation_title.toUpperCase(),
                style: h1Style,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: largeSpace),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      localizations.onboarding_userCreation_subtitle,
                      style: onboardingHeaderStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: mediumSpace),
                    Text(
                      localizations.onboarding_userCreation_description,
                      style: dynamicBodyStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: largeSpace),
                    NewProfileForm(onSubmit: completeOnboardingWith),
                    const SizedBox(height: largeSpace),
                    SizedBox(
                      width: 275,
                      child: ElevatedButton(
                        onPressed: completeOnboarding,
                        style: primaryTextButtonStyle,
                        child: Text(localizations.onboarding_skip_label),
                      ),
                    ),
                    const SizedBox(height: largeSpace),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
