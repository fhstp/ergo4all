import 'package:common_ui/theme/spacing.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Small banner widget wich shows who funded the project.
class PoweredByBanner extends StatelessWidget {
  ///
  const PoweredByBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: smallSpace,
      children: [
        Text(localizations.funded_by, style: theme.textTheme.bodyLarge),
        Image.asset(height: 48, 'assets/images/logos/ak.jpg'),
      ],
    );
  }
}
