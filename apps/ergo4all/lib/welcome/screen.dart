import 'dart:async';

import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/common/custom_images.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/language_screen.dart';
import 'package:ergo4all/onboarding/state.dart';
import 'package:ergo4all/welcome/version_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

/// Top-level widget for the welcome screen.
class WelcomeScreen extends StatefulWidget {
  ///
  const WelcomeScreen({super.key});

  /// The route name for this screen.
  static const String routeName = 'welcome';

  /// Creates a [MaterialPageRoute] to navigate to this screen.
  static MaterialPageRoute<void> makeRoute() {
    return MaterialPageRoute(
      builder: (_) => const WelcomeScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late final OnboardingState onboardingState;

  Option<String> projectVersion = none();
  int tapCount = 0;

  Future<void> loadProjectVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      projectVersion = Some(info.version);
    });
  }

  @override
  void initState() {
    super.initState();

    onboardingState = Provider.of(context, listen: false);

    unawaited(loadProjectVersion());
  }

  Future<void> resetOnboarding() async {
    await onboardingState.reset();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      // TODO: Localize
      const SnackBar(content: Text('Onboarding state reset')),
    );
  }

  void incrementTapCount() {
    if (tapCount < 5) {
      tapCount++;

      if (tapCount == 5) {
        unawaited(resetOnboarding());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    Future<void> navigateToNextScreen() async {
      final hasCompletedOnboarding = await onboardingState.isCompleted();
      final afterLanguage = hasCompletedOnboarding
          ? PostLanguagePickAction.goHome
          : PostLanguagePickAction.startOnboarding;

      if (!context.mounted) return;

      unawaited(
        Navigator.of(context).pushReplacement(
          PickLanguageScreen.makeRoute(afterLanguage),
        ),
      );
    }

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        child: Column(
          children: [
            SizedBox(
              // The background graphic should fill 60% of the screen
              height: screenHeight * 0.6,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(
                    child: SvgPicture.asset(
                      'assets/images/top_circle_large.svg',
                      package: 'common_ui',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        localizations.welcome_header,
                        style: h3Style.copyWith(color: white),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(
                          xLargeSpace,
                          mediumSpace,
                          xLargeSpace,
                          0,
                        ),
                        child: SvgPicture(CustomImages.logoWhite, height: 100),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              key: const Key('start'),
              style: primaryTextButtonStyle,
              onPressed: navigateToNextScreen,
              child: Text(localizations.welcome_start),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: mediumSpace),
              child: SizedBox.fromSize(
                size: const Size.fromHeight(40),
                child: const Row(
                  children: [
                    Image(image: CustomImages.logoAk),
                    Spacer(),
                    Image(image: CustomImages.logoTUWien),
                    SizedBox(width: mediumSpace),
                    Image(image: CustomImages.logoUstp),
                  ],
                ),
              ),
            ),
            const SizedBox(height: mediumSpace),
            VersionDisplay(version: projectVersion, onTap: incrementTapCount),
          ],
        ),
      ),
    );
  }
}
