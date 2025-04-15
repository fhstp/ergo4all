import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/common/intro.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:flutter/material.dart';

class ExpertIntroScreen extends StatelessWidget {
  const ExpertIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final overviewPage = IntroPage(
      title: localizations.professionalIntro_overview_title,
      widget: Column(
        children: [
          Text(
            localizations.professionalIntro_overview_header,
            style: h3Style,
          ),
          Text(localizations.professionalIntro_overview_text),
        ],
      ),
    );

    final privacyPage = IntroPage(
      title: localizations.professionalIntro_privacy_title,
      widget: Column(
        children: [
          Text(
            localizations.professionalIntro_privacy_header,
            style: h3Style,
          ),
          Text(localizations.professionalIntro_privacy_text),
        ],
      ),
    );

    return Intro(pages: [overviewPage, privacyPage]);
  }
}
