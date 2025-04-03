import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/home/types.dart';
import 'package:flutter/material.dart';

class StartSessionDialog extends StatelessWidget {
  static const name = "/start-session-dialog";

  const StartSessionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: spindle,
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.all(largeSpace),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  key: Key("new"),
                  style: primaryTextButtonStyle,
                  onPressed: () {
                    Navigator.of(context).pop(VideoSource.live);
                  },
                  child: Text("Record")),
              SizedBox(height: largeSpace),
              ElevatedButton(
                  key: Key("upload"),
                  style: secondaryTextButtonStyle,
                  onPressed: () {
                    Navigator.of(context).pop(VideoSource.gallery);
                  },
                  child: Text("Upload from video"))
            ],
          ),
        ),
      ),
    );
  }

  static Future<VideoSource?> show(BuildContext context) {
    return showDialog(
        context: context,
        useRootNavigator: false,
        routeSettings: RouteSettings(name: name),
        builder: (context) => StartSessionDialog());
  }
}
