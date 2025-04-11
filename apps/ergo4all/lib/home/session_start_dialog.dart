import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/home/types.dart';
import 'package:flutter/material.dart';

class StartSessionDialog extends StatelessWidget {
  const StartSessionDialog({super.key});

  static const name = '/start-session-dialog';

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
                key: const Key('new'),
                style: primaryTextButtonStyle,
                onPressed: () {
                  Navigator.of(context).pop(VideoSource.live);
                },
                child: const Text('Record'),
              ),
              const SizedBox(height: largeSpace),
              ElevatedButton(
                key: const Key('upload'),
                style: secondaryTextButtonStyle,
                onPressed: () {
                  Navigator.of(context).pop(VideoSource.gallery);
                },
                child: const Text('Upload from video'),
              ),
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
      routeSettings: const RouteSettings(name: name),
      builder: (context) => const StartSessionDialog(),
    );
  }
}
