import 'package:ergo4all/common/header.dart';
import 'package:ergo4all/common/intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NonExpertIntroScreen extends StatelessWidget {
  const NonExpertIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;
    final boldStyle =
        appTheme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold);

    final welcomePage = IntroPage(
        title: localizations.workerIntro_welcome_title,
        widget: Column(
          children: [
            Header(
              localizations.workerIntro_welcome_header,
            ),
            Text(localizations.workerIntro_welcome_text),
          ],
        ));

    final overview1Page = IntroPage(
        title: localizations.workerIntro_overview_title,
        widget: Header(
          localizations.workerIntro_overview1_text,
        ));

    final overview2Page = IntroPage(
        title: localizations.workerIntro_overview_title,
        widget: Column(
          children: [
            Header(
              localizations.workerIntro_overview2_header,
            ),
            Text(localizations.workerIntro_overview2_text1),
            Text(
              localizations.workerIntro_overview2_text2,
              style: boldStyle,
            ),
          ],
        ));

    final privacyPage = IntroPage(
        title: localizations.workerIntro_privacy_title,
        widget: Column(
          children: [
            Header(
              localizations.workerIntro_privacy_header,
            ),
            Text(localizations.workerIntro_privacy_text1),
            Text(localizations.workerIntro_privacy_text2, style: boldStyle),
          ],
        ));

    return Intro(
        pages: [welcomePage, overview1Page, overview2Page, privacyPage]);
  }
}
