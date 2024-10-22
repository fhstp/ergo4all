import 'package:ergo4all/app/common/custom_images.dart';
import 'package:ergo4all/app/common/routes.dart';
import 'package:ergo4all/app/common/screen_content.dart';
import 'package:ergo4all/app/common/spacing.dart';
import 'package:ergo4all/common/user.dart';
import 'package:ergo4all/app/welcome/types.dart';
import 'package:ergo4all/storage.text/types.dart';
import 'package:ergo4all/storage.user/user_storage.dart';
import 'package:ergo4all/app/welcome/timed_loading_bar.dart';
import 'package:ergo4all/app/welcome/version_display.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  final LocalTextStorage textStorage;
  final GetProjectVersion getProjectVersion;

  const WelcomeScreen(this.textStorage,
      {super.key, required this.getProjectVersion});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late Future<User?> _currentUser;
  late Future<String> _projectVersion;

  @override
  void initState() {
    super.initState();

    // We start getting the current user in the background
    _currentUser = getCurrentUser(widget.textStorage);
    _projectVersion = widget.getProjectVersion();
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    void navigateToNextScreen() async {
      final currentUser = await _currentUser;
      final isFirstStart = currentUser == null;
      // Depending on whether this is the first time we start the app
      // we either go to onboarding or home.
      final nextRoute = isFirstStart ? Routes.language : Routes.home;

      navigator.pushReplacementNamed(nextRoute.path);
    }

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
            FutureBuilder(
                future: _projectVersion,
                builder: (context, snapshot) => VersionDisplay(
                      version: snapshot.data,
                    ))
          ],
        ),
      ),
    );
  }
}
