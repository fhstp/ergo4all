import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/common/custom_images.dart';
import 'package:ergo4all/common/header.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/common/screen_content.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:flutter/material.dart';

class PreIntroScreen extends StatelessWidget {
  const PreIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

    void skipIntroduction() {
      navigator.pushNamed(Routes.tou.path);
    }

    void takeProfessionalIntroduction() {
      navigator.pushNamed(Routes.expertIntro.path);
    }

    void takeWorkerIntroduction() {
      navigator.pushNamed(Routes.nonExpertIntro.path);
    }

    return Scaffold(
      body: ScreenContent(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(image: CustomImages.logoRed),
              const SizedBox(
                height: largeSpace,
              ),
              Header(localizations.preIntro_chooseProfile),
              ElevatedButton(
                  key: const Key("expert"),
                  style: paleTextButtonStyle,
                  onPressed: takeProfessionalIntroduction,
                  child: Text(localizations.preInto_expert)),
              const SizedBox(
                height: mediumSpace,
              ),
              ElevatedButton(
                  key: const Key("non-expert"),
                  style: paleTextButtonStyle,
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
