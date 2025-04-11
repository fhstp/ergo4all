import 'package:common_ui/theme/styles.dart';
import 'package:flutter/material.dart';

/// Dialog asking the user whether they want to see the tutorial.
class ShowTutorialDialog extends StatelessWidget {
  const ShowTutorialDialog({super.key});

  static const name = '/show-tutorial-dialog';

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Would you like to take the tutorial on how to use this app?',
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    navigator.pop(true);
                  },
                  style: primaryTextButtonStyle,
                  child: const Text('Yes'),
                ),
                ElevatedButton(
                  key: const Key('skip'),
                  style: secondaryTextButtonStyle,
                  onPressed: () {
                    navigator.pop(false);
                  },
                  child: const Text('Skip'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Shows a [ShowTutorialDialog]. Returns a [bool] indicating whether the
  /// user wants to see the tutorial. If the user closes the dialog without
  /// making a choice `null` will be returned.
  static Future<bool?> show(BuildContext context) {
    return showDialog(
      context: context,
      useRootNavigator: false,
      routeSettings: const RouteSettings(name: name),
      builder: (context) => const ShowTutorialDialog(),
    );
  }
}
