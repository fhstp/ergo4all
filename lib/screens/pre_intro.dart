import 'package:ergo4all/screens/terms_of_use.dart';
import 'package:ergo4all/widgets/tappable_text.dart';
import 'package:flutter/material.dart';

class PreIntroScreen extends StatelessWidget {
  const PreIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    void skipIntroduction() {
      navigator
          .push(MaterialPageRoute(builder: (_) => const TermsOfUseScreen()));
    }

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(image: AssetImage('assets/images/logos/LogoRed.png')),
          const Text("Choose your profile"),
          TappableText(
              key: const Key("skip"),
              onTap: skipIntroduction,
              text: "Skip introduction")
        ],
      ),
    );
  }
}
