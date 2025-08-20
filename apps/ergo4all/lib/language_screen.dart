import 'dart:async';

import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:custom_locale/custom_locale.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/home/screen.dart';
import 'package:ergo4all/onboarding/pre_intro/screen.dart';
import 'package:flutter/material.dart';

/// What to do after a user has picked a language.
enum PostLanguagePickAction {
  /// Go to the [HomeScreen].
  goHome,

  /// Start the onboarding process by navigating to the [PreIntroScreen]
  startOnboarding
}

/// Screen for picking a language. Once a user has picked a language,
/// they will be navigated to the [HomeScreen].
class PickLanguageScreen extends StatelessWidget {
  /// Creates a [PickLanguageScreen].
  const PickLanguageScreen({required this.postLanguagePickAction, super.key});

  /// What to do after a user has picked a language.
  final PostLanguagePickAction postLanguagePickAction;

  /// The route name for this screen.
  static const String routeName = 'pick-language';

  /// Creates a [MaterialPageRoute] to navigate to this screen.
  static MaterialPageRoute<void> makeRoute(
    PostLanguagePickAction postLanguagePickAction,
  ) {
    return MaterialPageRoute(
      builder: (_) => PickLanguageScreen(
        postLanguagePickAction: postLanguagePickAction,
      ),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    Future<void> selectLocale(Locale locale) async {
      await setCustomLocale(locale);
      if (!context.mounted) return;

      final navigator = Navigator.of(context);
      if (postLanguagePickAction == PostLanguagePickAction.goHome) {
        // TODO: Check whether we are already 'on top' of home, and if so, simply pop
        unawaited(
          navigator.pushAndRemoveUntil(
            HomeScreen.makeRoute(),
            ModalRoute.withName(HomeScreen.routeName),
          ),
        );
      } else {
        unawaited(
          Navigator.push(
            context,
            PreIntroScreen.makeRoute(),
          ),
        );
      }
    }

    Widget languageButtonFor(String language, Locale locale) {
      return ElevatedButton(
        key: Key('lang_button_${locale.languageCode.toLowerCase()}'),
        style: paleTextButtonStyle,
        onPressed: () => selectLocale(locale),
        child: Text(language),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Align(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                localizations.language_header,
                style: h3Style,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: largeSpace),
              languageButtonFor('Deutsch', const Locale('de')),
              const SizedBox(height: largeSpace),
              languageButtonFor('English', const Locale('en')),
            ],
          ),
        ),
      ),
    );
  }
}
