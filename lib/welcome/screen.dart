import 'package:ergo4all/common/custom_images.dart';
import 'package:ergo4all/common/hook_ext.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/common/screen_content.dart';
import 'package:ergo4all/common/spacing.dart';
import 'package:ergo4all/welcome/timed_loading_bar.dart';
import 'package:ergo4all/welcome/types.dart';
import 'package:ergo4all/welcome/version_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:user_management/user_management.dart';

class WelcomeScreen extends HookWidget {
  final GetProjectVersion getProjectVersion;

  const WelcomeScreen({super.key, required this.getProjectVersion});

  @override
  Widget build(BuildContext context) {
    final (currentUser, setCurrentUser) = useState<User?>(null).split();
    final (projectVersion, setProjectVersion) = useState<String?>(null).split();

    navigateToNextScreen() async {
      final isFirstStart = currentUser == null;
      // Depending on whether this is the first time we start the app
      // we either go to onboarding or home.
      final nextRoute = isFirstStart ? Routes.language : Routes.home;

      await Navigator.of(context).pushReplacementNamed(nextRoute.path);
    }

    useEffect(() {
      loadCurrentUser().then(setCurrentUser);
      return null;
    }, [null]);

    useEffect(() {
      getProjectVersion().then(setProjectVersion);
      return null;
    }, [null]);

    return Scaffold(
      body: ScreenContent(
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
                  // TODO: Localize
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
                  // TODO: Localize
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
            VersionDisplay(version: projectVersion)
          ],
        ),
      ),
    );
  }
}
