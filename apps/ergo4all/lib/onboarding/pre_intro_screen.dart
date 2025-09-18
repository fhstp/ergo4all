import 'dart:async';

import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/onboarding/style.dart';
import 'package:ergo4all/onboarding/terms_of_use_screen.dart';
import 'package:flutter/material.dart';

const double _appBarHeight = 200;

/// Screen for displaying the pre-introductory content before the main
/// onboarding flow.
class PreIntroScreen extends StatelessWidget {
  ///
  const PreIntroScreen({super.key});

  /// The route name for this screen.
  static const String routeName = 'preIntroOnboarding';

  /// Creates a [MaterialPageRoute] to navigate to this screen.
  static MaterialPageRoute<void> makeRoute() {
    return MaterialPageRoute(
      builder: (_) => const PreIntroScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    void goToTermsOfUse() {
      unawaited(
        Navigator.pushAndRemoveUntil(
          context,
          TermsOfUseScreen.makeRoute(),
          ModalRoute.withName(TermsOfUseScreen.routeName),
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
                      localizations.onboarding_preIntro_title,
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
                      localizations.onboarding_preIntro_subtitle,
                      style: onboardingHeaderStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: largeSpace),
                    Text(
                      localizations.onboarding_preIntro_description,
                      style: dynamicBodyStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: largeSpace),
                  ],
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                key: const Key('next'),
                style: primaryTextButtonStyle,
                onPressed: goToTermsOfUse,
                child: Text(localizations.onboarding_label),
              ),
            ),
            const SizedBox(height: largeSpace),
          ],
        ),
      ),
    );
  }
}
