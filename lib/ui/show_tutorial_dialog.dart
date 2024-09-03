import 'package:flutter/material.dart';

class ShowTutorialDialog extends StatelessWidget {
  static const dialogKey = Key("showTutorialDialog");

  const ShowTutorialDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Dialog(key: dialogKey, child: Placeholder());
  }

  static Future<Null> show(
    BuildContext context,
  ) async {
    await showDialog(
        context: context,
        builder: (context) {
          return const ShowTutorialDialog();
        });
  }
}
