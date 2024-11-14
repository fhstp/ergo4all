import 'package:custom_locale/custom_locale.dart';
import 'package:ergo4all/common/app_bar.dart';
import 'package:ergo4all/common/header.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/common/screen_content.dart';
import 'package:ergo4all/common/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PickLanguageScreen extends HookWidget {
  const PickLanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    void selectLocale(Locale locale) async {
      await setCustomLocale(locale);
      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, Routes.preIntro.path);
    }

    Widget languageButtonFor(String language, Locale locale) {
      return ElevatedButton(
        key: Key("lang_button_${locale.languageCode.toLowerCase()}"),
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
