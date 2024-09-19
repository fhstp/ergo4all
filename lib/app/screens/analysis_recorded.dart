import 'package:ergo4all/app/routes.dart';
import 'package:ergo4all/ui/header.dart';
import 'package:ergo4all/ui/loading_indicator.dart';
import 'package:ergo4all/ui/screen_content.dart';
import 'package:ergo4all/ui/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RecordedAnalysisScreen extends StatefulWidget {
  const RecordedAnalysisScreen({super.key});

  @override
  State<RecordedAnalysisScreen> createState() => _RecordedAnalysisScreenState();
}

class _RecordedAnalysisScreenState extends State<RecordedAnalysisScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _navigateAfterDelay();
    });
  }

  _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      Navigator.pushReplacementNamed(context, Routes.results.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      body: ScreenContent(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Header(localizations.analysis_header),
            const FractionallySizedBox(
              widthFactor: 0.5,
              child: LoadingIndicator(),
            ),
            const SizedBox(
              height: largeSpace,
            ),
            Text(localizations.analysis_wait)
          ],
        ),
      ),
    );
  }
}
