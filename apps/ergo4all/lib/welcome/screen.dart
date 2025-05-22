import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/common/custom_images.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/welcome/version_display.dart';
import 'package:ergo4all/welcome/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

/// Top-level widget for the welcome screen.
class WelcomeScreen extends HookWidget {
  ///
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = useMemoized(WelcomeViewModel.new);
    final uiState = useValueListenable(viewModel.uiState);
    final localizations = AppLocalizations.of(context)!;

    Future<void> navigateToNextScreen() async {
      await Navigator.of(context).pushReplacementNamed(Routes.language.path);
    }

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        child: Column(
          children: [
            SizedBox(
              // The background graphic should fill 60% of the screen
              height: screenHeight * 0.6,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.expand(
                    child: SvgPicture.asset(
                      'assets/images/top_circle_large.svg',
                      package: 'common_ui',
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        localizations.welcome_header,
                        style: h3Style.copyWith(color: white),
                      ),
                      const Padding(
                        padding: EdgeInsets.fromLTRB(
                          xLargeSpace,
                          mediumSpace,
                          xLargeSpace,
                          0,
                        ),
                        child: Image(image: CustomImages.logoWhite),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              key: const Key('start'),
              style: primaryTextButtonStyle,
              onPressed: navigateToNextScreen,
              child: Text(localizations.welcome_start),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: mediumSpace),
              child: SizedBox.fromSize(
                size: const Size.fromHeight(50),
                child: const Row(
                  children: [
                    Image(image: CustomImages.logoAk),
                    Spacer(),
                    Image(image: CustomImages.logoTUWien),
                    SizedBox(width: mediumSpace),
                    Image(image: CustomImages.logoFhStp),
                  ],
                ),
              ),
            ),
            VersionDisplay(version: uiState.projectVersion),
          ],
        ),
      ),
    );
  }
}
