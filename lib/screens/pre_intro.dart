import 'package:ergo4all/screens/terms_of_use.dart';
import 'package:ergo4all/widgets/header.dart';
import 'package:ergo4all/widgets/tappable_text.dart';
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

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(image: AssetImage('assets/images/logos/LogoRed.png')),
          Header(localizations.preIntro_chooseProfile),
          TappableText(
              key: const Key("skip"),
              onTap: skipIntroduction,
              text: localizations.preIntro_skip)
        ],
      ),
    );
  }
}
