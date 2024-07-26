import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'intro.dart';

class ProfessionalIntro extends StatelessWidget {
  const ProfessionalIntro({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    var overviewPage = IntroPage(
        title: localizations.professionalIntro_overview_title,
        widget: Column(
          children: [
            Text(
              localizations.professionalIntro_overview_header,
              style: appTheme.textTheme.headlineLarge,
            ),
            Text(localizations.professionalIntro_overview_text),
          ],
        ));

    var privacyPage = IntroPage(
        title: localizations.professionalIntro_privacy_title,
        widget: Column(
          children: [
            Text(
              localizations.professionalIntro_privacy_header,
              style: appTheme.textTheme.headlineLarge,
            ),
            Text(localizations.professionalIntro_privacy_text),
          ],
        ));

    return Intro(pages: [overviewPage, privacyPage]);
  }
}
