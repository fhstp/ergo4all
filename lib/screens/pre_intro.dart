import 'package:ergo4all/screens/expert_intro.dart';
import 'package:ergo4all/screens/terms_of_use.dart';
import 'package:ergo4all/screens/non_expert_intro.dart';
import 'package:ergo4all/spacing.dart';
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
      navigator.push(MaterialPageRoute(builder: (_) => const ExpertIntro()));
    }

    void takeWorkerIntroduction() {
      navigator.push(MaterialPageRoute(builder: (_) => const NonExpertIntro()));
    }

    return Scaffold(
      body: ScreenContent(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(image: AssetImage('assets/images/logos/LogoRed.png')),
              const SizedBox(
                height: largeSpace,
              ),
              Header(localizations.preIntro_chooseProfile),
              ElevatedButton(
                  key: const Key("expert"),
                  onPressed: takeProfessionalIntroduction,
                  child: Text(localizations.preInto_expert)),
              const SizedBox(
                height: mediumSpace,
              ),
              ElevatedButton(
                  key: const Key("non-expert"),
                  onPressed: takeWorkerIntroduction,
                  child: Text(localizations.preInto_non_expert)),
              const SizedBox(
                height: largeSpace,
              ),
              TextButton(
                  key: const Key("skip"),
                  onPressed: skipIntroduction,
                  child: Text(localizations.preIntro_skip))
            ],
          ),
        ),
      ),
    );
  }
}
