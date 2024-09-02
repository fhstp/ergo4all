import 'package:ergo4all/providers/custom_locale.dart';
import 'package:ergo4all/routes.dart';
import 'package:ergo4all/ui/spacing.dart';
import 'package:ergo4all/ui/widgets/header.dart';
import 'package:ergo4all/ui/widgets/screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customLocale = Provider.of<CustomLocale>(context);
    final localizations = AppLocalizations.of(context)!;

    void onLanguageChosen(Locale locale) async {
      await customLocale.store(locale);
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
      appBar: AppBar(
        title: Text(localizations.language_title),
        centerTitle: true,
      ),
      body: ScreenContent(
        child: Column(
          children: [
            Header(localizations.language_header),
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
