import 'package:flutter/material.dart';

/// Dialog asking the user whether they want to see the tutorial.
class ShowTutorialDialog extends StatelessWidget {
  static const dialogKey = Key("showTutorialDialog");
  final void Function(bool wantsToSeeTutorial) onOptionChosen;

  const ShowTutorialDialog({
    super.key,
    required this.onOptionChosen,
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
                    onOptionChosen(true);
                    navigator.pop();
                  },
                  child: const Text("Yes")),
              ElevatedButton(
                  onPressed: () {
                    onOptionChosen(false);
                    navigator.pop();
                  },
                  child: const Text("Skip"))
            ],
          )
        ]),
      ),
    );
  }

  /// Shows a [ShowTutorialDialog]. [onOptionChosen] will be called with a [bool]
  /// indicating whether the user wants to see the tutorial. If the user closes
  /// the dialog without making a choice [onOptionChosen] will not be called.
  static Future<Null> show(BuildContext context,
      void Function(bool wantsToSeeTutorial) onOptionChosen) async {
    await showDialog(
        context: context,
        builder: (context) {
          return ShowTutorialDialog(onOptionChosen: onOptionChosen);
        });
  }
}
