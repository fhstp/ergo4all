import 'package:ergo4all/screens/home.dart';
import 'package:ergo4all/widgets/tappable_text.dart';
import 'package:flutter/material.dart';

const explanationText =
    "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";

class PreUserCreatorScreen extends StatelessWidget {
  const PreUserCreatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    void navigateToHome() {
      navigator.pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Creating user"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Creating a user profile"),
            const Text(explanationText),
            TappableText(
              key: const Key("default-values"),
              text: "Use default values",
              onTap: navigateToHome,
            )
          ],
        ),
      ),
    );
  }
}
