import 'package:flutter/material.dart';

import '../widgets/loading_indicator.dart';

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
              child: LoadingIndicator(),
            ),
            Text("It may take a few minutes, please do not close the app.")
          ],
        ),
      ),
    );
  }
}
