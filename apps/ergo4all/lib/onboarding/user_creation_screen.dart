import 'dart:async';

import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/home/screen.dart';
import 'package:ergo4all/onboarding/state.dart';
import 'package:ergo4all/onboarding/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const double _appBarHeight = 200;

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

  final TextEditingController _nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    onboardingState = Provider.of(context, listen: false);
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

  void skip() {
    completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: largeSpace),
        child: Column(
          children: [
            SizedBox(
              height: _appBarHeight,
              child: Center(
                child: Text(
                  localizations.onboarding_userCreation_title,
                  style: h1Style.copyWith(
                    color: cardinal,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    TextField(
                      controller: _nicknameController,
                      decoration: InputDecoration(
                        hintText:
                            localizations.onboarding_userCreation_input_text,
                        filled: true,
                        fillColor: Colors.blueGrey.shade50,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(mediumSpace),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: mediumSpace,
                          horizontal: largeSpace,
                        ),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: mediumSpace),
            TextButton(
              onPressed: skip,
              key: const Key('skip'),
              child: Text(
                localizations.onboarding_skip_label,
                style: dynamicBodyStyle.copyWith(
                  color: Colors.black,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            const SizedBox(height: mediumSpace),
            ElevatedButton(
              key: const Key('next'),
              style: primaryTextButtonStyle,
              onPressed: completeOnboarding,
              child: Text(localizations.onboarding_label),
            ),
            const SizedBox(height: largeSpace),
          ],
        ),
      ),
    );
  }
}
