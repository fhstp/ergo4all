import 'package:ergo4all/home/types.dart';
import 'package:flutter/material.dart';

class StartSessionDialog extends StatelessWidget {
  static const dialogKey = Key("sessionStartDialog");

  const StartSessionDialog({
    super.key,
  });

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
                Navigator.of(context).pop(source);
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

  static Future<VideoSource?> show(
    BuildContext context,
  ) {
    return showDialog(
        context: context, builder: (context) => StartSessionDialog());
  }
}
