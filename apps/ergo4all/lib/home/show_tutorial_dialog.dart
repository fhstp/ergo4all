import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Dialog asking the user whether they want to see the tutorial.
class ShowTutorialDialog extends StatelessWidget {
  const ShowTutorialDialog({super.key});

  static const name = '/show-tutorial-dialog';

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              localizations.preIntro_question,
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    navigator.pop(true);
                  },
                  style: primaryTextButtonStyle,
                  child: Text(localizations.preIntro_start),
                ),
                ElevatedButton(
                  key: const Key('skip'),
                  style: secondaryTextButtonStyle,
                  onPressed: () {
                    navigator.pop(false);
                  },
                  child: Text(localizations.preIntro_skip),
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
