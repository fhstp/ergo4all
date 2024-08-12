import 'package:ergo4all/widgets/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'intro.dart';

class ExpertIntro extends StatelessWidget {
  const ExpertIntro({super.key});

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
