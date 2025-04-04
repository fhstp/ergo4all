import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/common/custom_images.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/welcome/version_display.dart';
import 'package:ergo4all/welcome/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/svg.dart';

/// Top-level widget for the welcome screen.
class WelcomeScreen extends HookWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = useMemoized(WelcomeViewModel.new);
    final uiState = useValueListenable(viewModel.uiState);

    void navigateToNextScreen(bool doOnboarding) async {
      final nextRoute = doOnboarding ? Routes.language : Routes.home;
      await Navigator.of(context).pushReplacementNamed(nextRoute.path);
    }

    useEffect(() {
      viewModel.checkOnboarding();
      return null;
    }, [null]);

    return Scaffold(
      body: Stack(children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: FittedBox(
            fit: BoxFit.cover,
            child: SvgPicture.asset(
              'assets/images/top_circle_large.svg',
              package: "common_ui",
            ),
          ),
        ),
        Column(
          children: [
            Spacer(flex: 2),
            Text(
              "Welcome!",
              style: h3Style.copyWith(color: white),
            ),
            const Image(image: CustomImages.logoWhite),
            Spacer(flex: 3),
            ElevatedButton(
              key: Key("start"),
              style: primaryTextButtonStyle,
              onPressed: uiState.shouldDoOnboarding.match(() => null,
                  (doOnboarding) => () => navigateToNextScreen(doOnboarding)),
              child: Text("Start"),
            ),
            Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: mediumSpace),
              child: SizedBox.fromSize(
                size: Size.fromHeight(50),
                child: Row(children: [
                  const Image(image: CustomImages.logoAk),
                  Spacer(),
                  const Image(image: CustomImages.logoTUWien),
                  SizedBox(width: mediumSpace),
                  const Image(image: CustomImages.logoFhStp),
                ]),
              ),
            ),
            VersionDisplay(version: uiState.projectVersion),
          ],
        ),
      ]),
    );
  }
}
