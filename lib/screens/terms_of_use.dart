import 'package:flutter/material.dart';

const tosText =
    "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.";

class TermsOfUseScreen extends StatefulWidget {
  const TermsOfUseScreen({super.key});

  @override
  State<TermsOfUseScreen> createState() => _TermsOfUseScreenState();
}

class _TermsOfUseScreenState extends State<TermsOfUseScreen> {
  bool hasAccepted = false;

  void toggleHasAccepted() {
    setState(() {
      hasAccepted = !hasAccepted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms of use"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(tosText),
            Row(
              children: [
                const Text("I accept"),
                Checkbox(
                    value: hasAccepted,
                    onChanged: (isChecked) {
                      toggleHasAccepted();
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
