import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:custom_locale/custom_locale.dart';
import 'package:ergo4all/common/app_bar.dart';
import 'package:ergo4all/common/header.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/common/screen_content.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:flutter/material.dart';

class PickLanguageScreen extends StatelessWidget {
  const PickLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    Future<void> selectLocale(Locale locale) async {
      await setCustomLocale(locale);
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, Routes.preIntro.path);
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
      appBar: makeCustomAppBar(
        title: localizations.language_title,
      ),
      body: ScreenContent(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Header(localizations.language_header),
            const SizedBox(
              height: largeSpace,
            ),
            languageButtonFor('Deutsch', const Locale('de')),
            const SizedBox(
              height: mediumSpace,
            ),
            languageButtonFor('English', const Locale('en')),
            const SizedBox(
              height: mediumSpace,
            ),
            languageButtonFor('Bosansko-Hrvatsko-Srpski', const Locale('hbs')),
            const SizedBox(
              height: mediumSpace,
            ),
            languageButtonFor('Türkçe', const Locale('tr')),
          ],
        ),
      ),
    );
  }
}
