import 'package:common_ui/theme/spacing.dart';
import 'package:ergo4all/common/custom_images.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/common/screen_content.dart';
import 'package:ergo4all/welcome/timed_loading_bar.dart';
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

    navigateToNextScreen() async {
      final nextRoute =
          uiState.shouldDoOnboarding ? Routes.language : Routes.home;

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
        ScreenContent(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Image(image: CustomImages.logoRed),
                    const SizedBox(
                      height: largeSpace,
                    ),
                    Text("Powered by"),
                    const SizedBox(
                      height: smallSpace,
                    ),
                    const Image(
                      image: CustomImages.logoAk,
                      height: 200,
                    ),
                    const SizedBox(
                      height: largeSpace,
                    ),
                    Text("Project partners"),
                    const SizedBox(
                      height: smallSpace,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Image(
                          image: CustomImages.logoTUWien,
                          height: 100,
                        ),
                        SizedBox(
                          width: largeSpace,
                        ),
                        const Image(
                          image: CustomImages.logoFhStp,
                          height: 100,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: largeSpace,
                    ),
                    TimedLoadingBar(
                      duration: const Duration(seconds: 3),
                      completed: navigateToNextScreen,
                    )
                  ],
                ),
              ),
              VersionDisplay(version: uiState.projectVersion)
            ],
          ),
        ),
      ]),
    );
  }
}
