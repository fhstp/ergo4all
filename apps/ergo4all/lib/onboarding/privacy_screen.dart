import 'dart:async';

import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/onboarding/style.dart';
import 'package:ergo4all/onboarding/terms_of_use_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Screen for displaying the privacy policy.
class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();

  /// The route name for this screen.
  static const String routeName = 'privacyOnboarding';

  /// Creates a [MaterialPageRoute] to navigate to this screen.
  static MaterialPageRoute<void> makeRoute() {
    return MaterialPageRoute(
      builder: (_) => const PrivacyScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  bool consetCheck = false;

  void goToToS() {
    unawaited(
      Navigator.pushAndRemoveUntil(
        context,
        TermsOfUseScreen.makeRoute(),
        ModalRoute.withName(TermsOfUseScreen.routeName),
      ),
    );
  }

  Future<void> openPrivacyLink() async {
    final link = Uri.parse(
      'https://www.tuwien.at/mwbw/im/ie/mmi/forschung/ergo4a-ergonomics-for-all/datenschutzinformation-projekt-ergo4a',
    );
    await launchUrl(link, mode: LaunchMode.externalApplication);
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
                localizations.onboarding_privacy_title.toUpperCase(),
                textAlign: TextAlign.center,
                style: h1Style.copyWith(color: cardinal),
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
                    const SizedBox(height: mediumSpace),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = openPrivacyLink,
                        text: localizations.privacy_link,
                        style: dynamicBodyStyle.copyWith(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: mediumSpace),
                    Text(
                      localizations.onboarding_privacy_consent,
                      style: dynamicBodyStyle,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: largeSpace),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Text(
                            localizations.onboarding_consent_accept,
                            style: dynamicBodyStyle,
                          ),
                        ),
                        Checkbox(
                          value: consetCheck,
                          onChanged: (bool? newValue) {
                            setState(() {
                              consetCheck = newValue ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: largeSpace),
                    ElevatedButton(
                      key: const Key('next'),
                      style: primaryTextButtonStyle,
                      onPressed: consetCheck ? goToToS : null,
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
