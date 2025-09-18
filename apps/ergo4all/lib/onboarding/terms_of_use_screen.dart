import 'dart:async';

import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/onboarding/ergonomics_info_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const double _appBarHeight = 200;

/// Screen for displaying the terms of use.
class TermsOfUseScreen extends StatefulWidget {
  ///
  const TermsOfUseScreen({super.key});

  @override
  State<TermsOfUseScreen> createState() => _TermsOfUseScreenState();

  /// The route name for this screen.
  static const String routeName = 'termsOfUseOnboarding';

  /// Creates a [MaterialPageRoute] to navigate to this screen.
  static MaterialPageRoute<void> makeRoute() {
    return MaterialPageRoute(
      builder: (_) => const TermsOfUseScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }
}

class _TermsOfUseScreenState extends State<TermsOfUseScreen> {
  bool checkBoxValue = false;

  void goToErgonomicsInfo() {
    unawaited(
      Navigator.pushAndRemoveUntil(
        context,
        ErgonomicsInfoScreen.makeRoute(),
        ModalRoute.withName(ErgonomicsInfoScreen.routeName),
      ),
    );
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
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  Positioned(
                    top: 100,
                    child: Text(
                      localizations.onboarding_termsOfUse_title,
                      style: h1Style.copyWith(color: cardinal),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: dynamicBodyStyle.copyWith(color: Colors.black),
                        children: [
                          TextSpan(
                            text:
                                '${localizations.onboarding_termsOfUse_description}\n',
                          ),
                          TextSpan(
                            text: localizations.onboarding_termsOfUse_link,
                            style: dynamicBodyStyle.copyWith(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    localizations.onboarding_termsOfUse_accept,
                    style: dynamicBodyStyle,
                  ),
                ),
                Checkbox(
                  value: checkBoxValue,
                  onChanged: (bool? newValue) {
                    setState(() {
                      checkBoxValue = newValue ?? false;
                    });
                  },
                ),
              ],
            ),
            Center(
              child: ElevatedButton(
                key: const Key('next'),
                style: primaryTextButtonStyle,
                onPressed: checkBoxValue ? goToErgonomicsInfo : null,
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
