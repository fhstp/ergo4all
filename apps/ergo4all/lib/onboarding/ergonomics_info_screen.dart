import 'dart:async';

import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/onboarding/style.dart';
import 'package:ergo4all/onboarding/user_creation_screen.dart';
import 'package:ergo4all/tips/tip_choice_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const double _appBarHeight = 200;

/// Screen for displaying the privacy policy.
class ErgonomicsInfoScreen extends StatelessWidget {
  ///
  const ErgonomicsInfoScreen({super.key});

  /// The route name for this screen.
  static const String routeName = 'ergonomicsInfoOnboarding';

  /// Creates a [MaterialPageRoute] to navigate to this screen.
  static MaterialPageRoute<void> makeRoute() {
    return MaterialPageRoute(
      builder: (_) => const ErgonomicsInfoScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    void goToUserCreation() {
      unawaited(
        Navigator.pushAndRemoveUntil(
          context,
          UserCreationScreen.makeRoute(),
          ModalRoute.withName(UserCreationScreen.routeName),
        ),
      );
    }

    void goToTippsScreen() {
      unawaited(
        Navigator.pushAndRemoveUntil(
          context,
          TipChoiceScreen.makeRoute(),
          ModalRoute.withName(UserCreationScreen.routeName),
        ),
      );
    }

    const graphicKey = 'assets/images/puppets_good_bad/good_bad_lifting.svg';

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
                      localizations.onboarding_ergonomicsInfo_title,
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
                      localizations.onboarding_ergonomicsInfo_subtitle,
                      style: onboardingHeaderStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: largeSpace),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: dynamicBodyStyle.copyWith(color: Colors.black),
                        children: [
                          TextSpan(
                            text: localizations
                                .onboarding_ergonomicsInfo_description,
                          ),
                          TextSpan(
                            text: localizations
                                .onboarding_ergonomicsInfo_description_link,
                            style: dynamicBodyStyle.copyWith(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = goToTippsScreen,
                          ),
                          const TextSpan(
                            text: '.',
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: SvgPicture.asset(graphicKey, height: 300),
                    ),
                  ],
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                key: const Key('next'),
                style: primaryTextButtonStyle,
                onPressed: goToUserCreation,
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
