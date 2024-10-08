import 'package:ergo4all/app/impure_utils.dart';
import 'package:ergo4all/app/routes.dart';
import 'package:ergo4all/domain/user.dart';
import 'package:ergo4all/io/local_text_storage.dart';
import 'package:ergo4all/ui/custom_images.dart';
import 'package:ergo4all/ui/screen_content.dart';
import 'package:ergo4all/ui/spacing.dart';
import 'package:ergo4all/ui/timed_loading_bar.dart';
import 'package:ergo4all/ui/version_display.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  final LocalTextStorage textStorage;

  const WelcomeScreen(this.textStorage, {super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late Future<User?> _currentUser;

  @override
  void initState() {
    super.initState();

    // We start getting the current user in the background
    _currentUser = getCurrentUser(widget.textStorage);
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
                  // TODO: Localize
                  Text("Powered by"),
                  const Image(
                    image: CustomImages.logoAk,
                    height: 200,
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
            const VersionDisplay()
          ],
        ),
      ),
    );
  }
}
