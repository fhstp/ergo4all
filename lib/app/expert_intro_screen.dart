import 'package:ergo4all/app/common/header.dart';
import 'package:ergo4all/app/common/intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExpertIntroScreen extends StatelessWidget {
  const ExpertIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    var overviewPage = IntroPage(
        title: localizations.professionalIntro_overview_title,
        widget: Column(
          children: [
            Header(
              localizations.professionalIntro_overview_header,
            ),
            Text(localizations.professionalIntro_overview_text),
          ],
        ));

    var privacyPage = IntroPage(
        title: localizations.professionalIntro_privacy_title,
        widget: Column(
          children: [
            Header(
              localizations.professionalIntro_privacy_header,
            ),
            Text(localizations.professionalIntro_privacy_text),
          ],
        ));

    return Intro(pages: [overviewPage, privacyPage]);
  }
}
