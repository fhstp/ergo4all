import 'package:common_ui/widgets/red_circle_top_bar.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:flutter/material.dart';

/// Screen for displaying information about project partners and contributors.
class ImprintScreen extends StatelessWidget {
  ///
  const ImprintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: RedCircleAppBar(
        titleText: localizations.imprint,
        withBackButton: true,
      ),
    );
  }
}
