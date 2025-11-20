import 'dart:async';

import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
//import 'package:ergo4all/onboarding/pre_intro_screen.dart';
import 'package:ergo4all/onboarding/style.dart';
import 'package:ergo4all/onboarding/terms_of_use_screen.dart';
import 'package:flutter/material.dart';

//import 'package:flutter/gestures.dart';

const double _appBarHeight = 200;

/// Screen for displaying the privacy policy.
class PrivacyScreen extends StatefulWidget {//StatelessWidget {
  ///
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

  void goToPreIntro() {
    unawaited(
      Navigator.pushAndRemoveUntil(
        context,
        TermsOfUseScreen.makeRoute(),
        //PreIntroScreen.makeRoute(),
        ModalRoute.withName(TermsOfUseScreen.routeName), //(PreIntroScreen.routeName),
      ),
    );
  }


  // void goToErgonomicsInfo() {
  //   unawaited(
  //     Navigator.pushAndRemoveUntil(
  //       context,
  //       ErgonomicsInfoScreen.makeRoute(),
  //       ModalRoute.withName(ErgonomicsInfoScreen.routeName),
  //     ),
  //   );
  // }

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
                      localizations.onboarding_privacy_title.toUpperCase(),
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

                    const SizedBox(height: mediumSpace),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        //style: dynamicBodyStyle.copyWith(color: Colors.black),
                        children: [
                          TextSpan(
                            text: localizations.privacy_link,
                            style: dynamicBodyStyle.copyWith(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),                        
                        ],
                      //const SizedBox(height: mediumSpace),
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
                            localizations.onboarding_termsOfUse_accept,
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
                      onPressed: consetCheck ? goToPreIntro : null, 
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
