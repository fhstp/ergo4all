import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/icon_back_button.dart';
import 'package:common_ui/widgets/red_circle_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';


/// enum for the different explanations that can be shown in the [AboutScreen].
enum Explanations {
  model,
  rula
}

class AboutScreen extends StatelessWidget {    

  const AboutScreen({super.key});

  static const String routeName = 'explanation-with-image';

  static MaterialPageRoute<void> makeRoute(Explanations screen) {
    return MaterialPageRoute(
        builder: (_) => const AboutScreen(),
        settings: RouteSettings(name: routeName, arguments: screen),
      );
    }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;     

    final screen = ModalRoute.of(context)!.settings.arguments! as Explanations;


    final nav_button = switch (screen) {
      Explanations.model => localizations.sources_model_nav,
      Explanations.rula => localizations.sources_ergonomics_nav,
    };

    final text = switch (screen) {
      Explanations.model => localizations.sources_model,
      Explanations.rula => localizations.sources_ergonomics,
    };

    final imagePath = switch (screen) {
        Explanations.model => 'assets/images/puppet_explanations/pose_estimation.svg', 
        Explanations.rula => 'assets/images/puppet_explanations/rula_scoring.svg',
      };

    return Scaffold(
      appBar: AppBar(
        leading: const IconBackButton(color: cardinal),
        title: Text(
          nav_button,
          textAlign: TextAlign.center,
        ),
      ),

      body: Stack(
        children: [
          const Align(
            alignment: Alignment.bottomCenter,
            child: RedCircleBottomBar(),
          ),
          SafeArea(
            minimum: const EdgeInsets.symmetric(horizontal: largeSpace),
            child: Align(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: largeSpace),
                    Text(
                      text,
                      style: dynamicBodyStyle,
                      textAlign: TextAlign.start,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: SvgPicture.asset(imagePath, height: 300),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}