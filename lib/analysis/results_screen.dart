import 'package:ergo4all/common/app_bar.dart';
import 'package:ergo4all/common/screen_content.dart';
import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Localize
    return Scaffold(
      appBar: makeCustomAppBar(title: "Results"),
      body: ScreenContent(child: Text("[Results will go here]")),
    );
  }
}
