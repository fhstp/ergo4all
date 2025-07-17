import 'dart:async';

import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/red_circle_app_bar.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/home/menu_dialog.dart';
import 'package:ergo4all/home/puppet_graphic.dart';
import 'package:flutter/material.dart';

/// Top-level widget for home screen.
class HomeScreen extends StatelessWidget {
  /// Creates a [HomeScreen].
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    void startSession() {
      unawaited(Navigator.pushNamed(context, Routes.scenarioChoice.path));
    }

    void goToTips() {
      unawaited(Navigator.pushNamed(context, Routes.tipChoice.path));
    }

    return Scaffold(
      appBar: RedCircleAppBar(
        titleText: localizations.home_title,
        menuButton: IconButton(
          key: const Key('burger'),
          onPressed: () {
            showHomeMenuDialog(context);
          },
          icon: const Icon(Icons.menu),
          color: white,
          iconSize: 48,
        ),
      ),
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              const SizedBox(height: largeSpace),
              const PuppetGraphic(),
              const SizedBox(height: mediumSpace),
              Text(
                localizations.home_welcome_break('Ergo-fan'),
                style: h3Style,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              ElevatedButton(
                key: const Key('start'),
                style: primaryTextButtonStyle,
                onPressed: startSession,
                child: Text(localizations.home_start_label),
              ),
              const SizedBox(height: mediumSpace),
              ElevatedButton(
                key: const Key('tips'),
                style: secondaryTextButtonStyle,
                onPressed: goToTips,
                child: Text(localizations.home_tips_label),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
