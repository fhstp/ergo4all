import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:flutter/material.dart';
 
/// Dialog which informs users that not enough poses were detected.
class NotEnoughDataDialog extends StatelessWidget {
  ///
  const NotEnoughDataDialog({super.key});
 
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    void close() {
      Navigator.of(context).pop();
    }
 
    return Dialog(
      backgroundColor: tarawera.withAlpha(230),
      child: IntrinsicHeight(
        child: Padding(
          padding: const EdgeInsets.all(largeSpace),
          child: Column(
            children: [
              Text(
                localizations.not_enough_data,
                textAlign: TextAlign.center,
                style: staticBodyStyle.copyWith(color: white),
              ),
              const SizedBox(height: largeSpace),
              ElevatedButton(
                onPressed: close,
                style: primaryTextButtonStyle,
                child: Text(localizations.common_next),
              ),
            ],
          ),
        ),
      ),
    );
  }
}