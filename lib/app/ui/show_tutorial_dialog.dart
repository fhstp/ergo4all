import 'package:flutter/material.dart';

/// Dialog asking the user whether they want to see the tutorial.
class ShowTutorialDialog extends StatelessWidget {
  static const dialogKey = Key("showTutorialDialog");

  const ShowTutorialDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    // TODO: Localize
    return Dialog(
      key: dialogKey,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text(
              "Would you like to take the tutorial on how to use this app?"),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    navigator.pop(true);
                  },
                  child: const Text("Yes")),
              ElevatedButton(
                  onPressed: () {
                    navigator.pop(false);
                  },
                  child: const Text("Skip"))
            ],
          )
        ]),
      ),
    );
  }

  /// Shows a [ShowTutorialDialog]. Returns a [bool] indicating whether the
  /// user wants to see the tutorial. If the user closes
  /// the dialog without making a choice `null` will be returned.
  static Future<bool?> show(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return ShowTutorialDialog();
        });
  }
}
