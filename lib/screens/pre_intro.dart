import 'package:ergo4all/screens/professional_intro.dart';
import 'package:ergo4all/screens/terms_of_use.dart';
import 'package:ergo4all/widgets/header.dart';
import 'package:ergo4all/widgets/screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PreIntroScreen extends StatelessWidget {
  const PreIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

    void skipIntroduction() {
      navigator
          .push(MaterialPageRoute(builder: (_) => const TermsOfUseScreen()));
    }

    void takeProfessionalIntroduction() {
      navigator
          .push(MaterialPageRoute(builder: (_) => const ProfessionalIntro()));
    }

    return Scaffold(
      body: ScreenContent(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage('assets/images/logos/LogoRed.png')),
            Header(localizations.preIntro_chooseProfile),
            ElevatedButton(
                key: const Key("professional"),
                onPressed: takeProfessionalIntroduction,
                child: Text(localizations.preInto_professional)),
            ElevatedButton(
                onPressed: () {}, child: Text(localizations.preInto_worker)),
            TextButton(
                key: const Key("skip"),
                onPressed: skipIntroduction,
                child: Text(localizations.preIntro_skip))
          ],
        ),
      ),
    );
  }
}
