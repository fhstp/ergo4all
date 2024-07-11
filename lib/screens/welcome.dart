import 'package:ergo4all/screens/language.dart';
import 'package:ergo4all/widgets/timed_loading_bar.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    void navigateToNextScreen() {
      navigator.pushReplacement(
          MaterialPageRoute(builder: (_) => const LanguageScreen()));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(image: AssetImage('assets/images/logos/LogoRed.png')),
          const SizedBox(
            height: 20,
          ),
          TimedLoadingBar(
            duration: const Duration(seconds: 3),
            completed: navigateToNextScreen,
          )
        ],
      ),
    );
  }
}
