import 'package:ergo4all/common/header.dart';
import 'package:ergo4all/common/loading_indicator.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/common/screen_content.dart';
import 'package:ergo4all/common/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RecordedAnalysisScreen extends HookWidget {
  const RecordedAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    navigateAfterDelay() async {
      await Future.delayed(const Duration(seconds: 3));

      if (!context.mounted) return;
      Navigator.pushReplacementNamed(context, Routes.results.path);
    }

    useEffect(() {
      navigateAfterDelay();
      return null;
    }, [null]);

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
