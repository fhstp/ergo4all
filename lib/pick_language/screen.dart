import 'package:custom_locale_storage/pref_storage_ext.dart';
import 'package:ergo4all/common/app_bar.dart';
import 'package:ergo4all/common/header.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/common/screen_content.dart';
import 'package:ergo4all/common/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:prefs_storage/types.dart';

class PickLanguageScreen extends StatefulWidget {
  final PreferenceStorage preferenceStorage;

  const PickLanguageScreen(this.preferenceStorage, {super.key});

  @override
  State<PickLanguageScreen> createState() => _PickLanguageScreenState();
}

class _PickLanguageScreenState extends State<PickLanguageScreen> {
  void _selectLocale(Locale locale) async {
    await widget.preferenceStorage.setCustomLocale(locale);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, Routes.preIntro.path);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    Widget languageButtonFor(String language, Locale locale) {
      return ElevatedButton(
        key: Key("lang_button_${locale.languageCode.toLowerCase()}"),
        onPressed: () => _selectLocale(locale),
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
