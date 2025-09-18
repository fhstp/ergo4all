import 'dart:async';

import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/onboarding/pre_intro_screen.dart';
import 'package:ergo4all/onboarding/style.dart';
import 'package:flutter/material.dart';

const double _appBarHeight = 200;

/// Screen for displaying the privacy policy.
class PrivacyScreen extends StatelessWidget {
  ///
  const PrivacyScreen({super.key});

  /// The route name for this screen.
  static const String routeName = 'privacyOnboarding';

  /// Creates a [MaterialPageRoute] to navigate to this screen.
  static MaterialPageRoute<void> makeRoute() {
    return MaterialPageRoute(
      builder: (_) => const PrivacyScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    void goToPreIntro() {
      unawaited(
        Navigator.pushAndRemoveUntil(
          context,
          PreIntroScreen.makeRoute(),
          ModalRoute.withName(PreIntroScreen.routeName),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: largeSpace),
        child: Column(
          children: [
            SizedBox(
              height: _appBarHeight,
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Positioned(
                    top: 100,
                    child: Text(
                      localizations.onboarding_privacy_title,
                      style: h1Style.copyWith(color: cardinal),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: largeSpace),
                    Text(
                      localizations.onboarding_privacy_subtitle,
                      style: onboardingHeaderStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: largeSpace),
                    Text(
                      localizations.onboarding_privacy_description,
                      style: dynamicBodyStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: largeSpace),
                    ElevatedButton(
                      key: const Key('next'),
                      style: primaryTextButtonStyle,
                      onPressed: goToPreIntro,
                      child: Text(localizations.onboarding_label),
                    ),
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
