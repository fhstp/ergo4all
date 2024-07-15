import 'package:ergo4all/screens/results.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../widgets/loading_indicator.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _navigateAfterDelay();
    });
  }

  _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ResultsScreen()),
    );
  }

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
