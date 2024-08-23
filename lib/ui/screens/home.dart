import 'package:ergo4all/ui/screens/analysis.dart';
import 'package:ergo4all/ui/widgets/screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/session_start_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

    void analyzeVideo(XFile videoFile) {
      navigator.push(MaterialPageRoute(builder: (_) => const AnalysisScreen()));
    }

    void showStartSessionDialog() {
      StartSessionDialog.show(context, analyzeVideo);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.home_title),
        centerTitle: true,
      ),
      body: ScreenContent(
          child: Column(
        children: [
          Text(localizations.home_welcome("Max")),
          ElevatedButton(
              key: const Key("start"),
              onPressed: showStartSessionDialog,
              child: Text(localizations.home_firstSession))
        ],
      )),
    );
  }
}
