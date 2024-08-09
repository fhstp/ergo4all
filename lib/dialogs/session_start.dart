import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../io/video.dart';
import '../screens/analysis.dart';

class StartSessionDialog extends StatelessWidget {
  static const dialogKey = Key("sessionStartDialog");
  final Future<XFile?> Function() tryGetVideo;

  const StartSessionDialog(
      {super.key, this.tryGetVideo = tryGetVideoFromGallery});

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);
    final navigator = Navigator.of(context);

    void analyzeVideo(XFile videoFile) {
      navigator.push(MaterialPageRoute(builder: (_) => const AnalysisScreen()));
    }

    void trySelectVideoForAnalysis() async {
      final videoFile = await tryGetVideo();
      if (videoFile == null) return;

      analyzeVideo(videoFile);
    }

    Widget makeSourceButton(
        Key key, IconData icon, String label, void Function() onPressed) {
      return Expanded(
        child: Column(
          children: [
            IconButton(
              key: key,
              onPressed: onPressed,
              icon: Icon(
                icon,
                color: appTheme.primaryColor,
              ),
              iconSize: 50,
            ),
            Text(
              label,
              textAlign: TextAlign.center,
            )
          ],
        ),
      );
    }

    return Dialog(
      key: dialogKey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Start new session",
                style: appTheme.textTheme.headlineLarge,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  makeSourceButton(
                      const Key("upload"),
                      Icons.upload,
                      "Use a video from your device.",
                      trySelectVideoForAnalysis),
                  makeSourceButton(const Key("new"), Icons.camera_alt,
                      "Take a new video.", () {})
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  static void show(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return const StartSessionDialog();
        });
  }
}
