import 'package:ergo4all/app/routes.dart';
import 'package:ergo4all/ui/spacing.dart';
import 'package:ergo4all/ui/header.dart';
import 'package:ergo4all/ui/screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../ui/loading_indicator.dart';

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
