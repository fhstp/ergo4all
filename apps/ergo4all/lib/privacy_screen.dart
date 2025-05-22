import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/red_circle_app_bar.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:flutter/material.dart';

/// A screen where users can view privacy information.
class PrivacyScreen extends StatelessWidget {
  ///
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: RedCircleAppBar(
        titleText: localizations.privacy_title,
        withBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: largeSpace,
          vertical: largeSpace,
        ),
        child: Column(
          children: [
            Text(
              localizations.privacy_important,
              style: h3Style,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: largeSpace),
            Text(
              localizations.privacy_content,
              style: staticBodyStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
