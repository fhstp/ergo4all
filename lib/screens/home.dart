import 'package:ergo4all/io/video.dart';
import 'package:ergo4all/screens/analysis.dart';
import 'package:ergo4all/widgets/screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatelessWidget {
  final Future<XFile?> Function() tryGetVideo;

  const HomeScreen({super.key, this.tryGetVideo = tryGetVideoFromGallery});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final navigator = Navigator.of(context);

    void analyzeVideo(XFile videoFile) {
      navigator.push(MaterialPageRoute(builder: (_) => const AnalysisScreen()));
    }

    void trySelectVideoForAnalysis() async {
      final videoFile = await tryGetVideo();
      if (videoFile == null) return;

      analyzeVideo(videoFile);
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
        ],
      )),
    );
  }
}
