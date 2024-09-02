import 'package:ergo4all/io/video.dart';
import 'package:ergo4all/app/routes.dart';
import 'package:ergo4all/ui/widgets/screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/video_source.dart';
import '../../ui/widgets/session_start_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    void analyzeVideo(XFile videoFile) {
      Navigator.pushNamed(context, Routes.analysis.path);
    }

    void onSessionVideoSourceChosen(VideoSource source) async {
      if (source == VideoSource.live) {
        // TODO: Implement live video source
        throw Exception("Not impl");
      }

      final videoFile = await tryGetVideoFromGallery();
      if (videoFile == null) return;
      analyzeVideo(videoFile);
    }

    void showStartSessionDialog() {
      StartSessionDialog.show(context, onSessionVideoSourceChosen);
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
