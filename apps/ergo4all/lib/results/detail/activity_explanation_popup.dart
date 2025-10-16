import 'package:common_ui/theme/spacing.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Popup which displays information about activity selection on the
/// result detail page.
class ActivityExplanationPopup extends StatelessWidget {
  ///
  const ActivityExplanationPopup({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    void close() {
      Navigator.of(context).pop();
    }

    return SimpleDialog(
      title: Text(localizations.activity_filter),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: mediumSpace),
          child: Text(localizations.activity_filter_explanation),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            mediumSpace,
            mediumSpace,
            mediumSpace,
            0,
          ),
          child: TextButton(onPressed: close, child: const Text('Ok')),
        ),
      ],
    );
  }
}
