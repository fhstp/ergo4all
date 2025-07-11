import 'dart:async';

import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/red_circle_app_bar.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/home/menu_dialog.dart';
import 'package:ergo4all/results/rula_colors.dart';
import 'package:flutter/material.dart';

class _PuppetGraphic extends StatelessWidget {
  const _PuppetGraphic();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 309,
      height: 309,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Image.asset(
            'assets/images/puppet/full_body.png',
            color: RulaColors.low,
            fit: BoxFit.contain,
            colorBlendMode: BlendMode.modulate,
          ),
        ),
      ),
    );
  }
}

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

    Future<void> goToTips() async {
      await Navigator.of(context).pushNamed(Routes.tipChoice.path);
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
              const _PuppetGraphic(),
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
