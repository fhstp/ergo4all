import 'package:ergo4all/providers/custom_locale.dart';
import 'package:ergo4all/screens/pre_intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final customLocale = Provider.of<CustomLocale>(context);
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

    void onLanguageChosen(Locale locale) async {
      await customLocale.store(locale);
      navigator.pushReplacement(
          MaterialPageRoute(builder: (_) => const PreIntroScreen()));
    }

    Widget languageButtonFor(String language, Locale locale) {
      return ElevatedButton(
        key: Key("lang_button_${language.toLowerCase()}"),
        onPressed: () => onLanguageChosen(locale),
        child: Text(language),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.language_title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text(localizations.language_header),
          languageButtonFor("Deutsch", const Locale("de")),
          languageButtonFor("English", const Locale("en")),
          languageButtonFor("BHS", const Locale("hbs")),
          languageButtonFor("Türkçe", const Locale("tr")),
        ],
      ),
    );
  }
}
