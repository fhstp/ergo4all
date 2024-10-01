import 'package:flutter/material.dart';

import '../domain/video_source.dart';

class StartSessionDialog extends StatelessWidget {
  static const dialogKey = Key("sessionStartDialog");
  final void Function(VideoSource source) videoSourceChosen;

  const StartSessionDialog({super.key, required this.videoSourceChosen});

  @override
  Widget build(BuildContext context) {
    final appTheme = Theme.of(context);

    Widget makeSourceButton(
        Key key, IconData icon, String label, VideoSource source) {
      return Expanded(
        child: Column(
          children: [
            IconButton(
              key: key,
              onPressed: () {
                Navigator.of(context).pop();
                videoSourceChosen(source);
              },
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
                  makeSourceButton(const Key("upload"), Icons.upload,
                      "Use a video from your device.", VideoSource.gallery),
                  makeSourceButton(const Key("new"), Icons.camera_alt,
                      "Take a new video.", VideoSource.live)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  static Future<Null> show(BuildContext context,
      void Function(VideoSource source) sourceChosen) async {
    await showDialog(
        context: context,
        builder: (context) {
          return StartSessionDialog(
            videoSourceChosen: sourceChosen,
          );
        });
  }
}
