import 'package:ergo4all/app/impure_utils.dart';
import 'package:ergo4all/app/routes.dart';
import 'package:ergo4all/io/preference_storage.dart';
import 'package:ergo4all/ui/app_bar.dart';
import 'package:ergo4all/ui/header.dart';
import 'package:ergo4all/ui/screen_content.dart';
import 'package:ergo4all/ui/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageScreen extends StatelessWidget {
  final PreferenceStorage preferenceStorage;

  const LanguageScreen(this.preferenceStorage, {super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    void onLanguageChosen(Locale locale) async {
      await setCustomLocale(preferenceStorage, locale);
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, Routes.preIntro.path);
      }
    }

    Widget languageButtonFor(String language, Locale locale) {
      return ElevatedButton(
        key: Key("lang_button_${locale.languageCode.toLowerCase()}"),
        onPressed: () => onLanguageChosen(locale),
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
            languageButtonFor("Deutsch", const Locale("de")),
            const SizedBox(
              height: mediumSpace,
            ),
            languageButtonFor("English", const Locale("en")),
            const SizedBox(
              height: mediumSpace,
            ),
            languageButtonFor("Bosansko-Hrvatsko-Srpski", const Locale("hbs")),
            const SizedBox(
              height: mediumSpace,
            ),
            languageButtonFor("Türkçe", const Locale("tr")),
          ],
        ),
      ),
    );
  }
}
