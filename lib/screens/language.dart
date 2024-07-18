import 'package:ergo4all/screens/pre_intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

    void onLanguageChosen() {
      navigator.pushReplacement(
          MaterialPageRoute(builder: (_) => const PreIntroScreen()));
    }

    Widget languageButtonFor(String language) {
      return ElevatedButton(
        key: Key("lang_button_${language.toLowerCase()}"),
        onPressed: onLanguageChosen,
        child: Text(language),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(localizations.language_title)),
      body: Column(
        children: [
          Text(localizations.language_header),
          languageButtonFor("Deutsch"),
          languageButtonFor("English"),
          languageButtonFor("BHS"),
          languageButtonFor("Türkçe"),
        ],
      ),
    );
  }
}
