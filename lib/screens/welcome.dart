import 'package:ergo4all/providers/custom_locale.dart';
import 'package:ergo4all/screens/language.dart';
import 'package:ergo4all/spacing.dart';
import 'package:ergo4all/widgets/screen_content.dart';
import 'package:ergo4all/widgets/timed_loading_bar.dart';
import 'package:ergo4all/widgets/version_display.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final customLocale = Provider.of<CustomLocale>(context);
    customLocale.load();
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    void navigateToNextScreen() {
      navigator.pushReplacement(
          MaterialPageRoute(builder: (_) => const LanguageScreen()));
    }

    return Scaffold(
      body: ScreenContent(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                      image: AssetImage('assets/images/logos/LogoRed.png')),
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
