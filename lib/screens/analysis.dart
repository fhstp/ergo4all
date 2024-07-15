import 'package:flutter/material.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Analyzing your ergonomics"),
            FractionallySizedBox(
              widthFactor: 0.5,
              child: AspectRatio(
                aspectRatio: 1,
                child: Stack(children: [
                  Center(
                    child: FractionallySizedBox(
                        widthFactor: 0.5,
                        heightFactor: 0.5,
                        child: Image(
                            image:
                                AssetImage('assets/images/logos/IconRed.png'))),
                  ),
                  SizedBox.expand(child: CircularProgressIndicator())
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
