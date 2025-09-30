import 'dart:async';

import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/red_circle_app_bar.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/home/menu_dialog.dart';
import 'package:ergo4all/home/puppet_graphic.dart';
import 'package:ergo4all/scenario/scenario_choice_screen.dart';
import 'package:ergo4all/session_archive/screen.dart';
import 'package:ergo4all/tips/tip_choice_screen.dart';
import 'package:flutter/material.dart';

/// Top-level widget for home screen.
class HomeScreen extends StatelessWidget {
  /// Creates a [HomeScreen].
  const HomeScreen({super.key});

  /// The route name for this screen.
  static const String routeName = 'home';

  /// Creates a [MaterialPageRoute] to navigate to this screen.
  static MaterialPageRoute<void> makeRoute() {
    return MaterialPageRoute(
      builder: (_) => const HomeScreen(),
      settings: const RouteSettings(name: routeName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    void startSession() {
      unawaited(Navigator.push(context, ScenarioChoiceScreen.makeRoute()));
    }

    void goToTips() {
      unawaited(Navigator.push(context, TipChoiceScreen.makeRoute()));
    }

    void goToAllSessions() {
      unawaited(Navigator.of(context).push(SessionArchiveScreen.makeRoute()));
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
          child: ListView(
            children: [
              const SizedBox(height: largeSpace),
              const PuppetGraphic(),
              const SizedBox(height: mediumSpace),
              Text(
                localizations.home_welcome,
                style: h3Style,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: mediumSpace),
              Center(
                child: ElevatedButton(
                  key: const Key('start'),
                  style: primaryTextButtonStyle,
                  onPressed: startSession,
                  child: Text(localizations.home_start_label),
                ),
              ),
              const SizedBox(height: mediumSpace),
              Center(
                child: ElevatedButton(
                  key: const Key('tips'),
                  style: secondaryTextButtonStyle,
                  onPressed: goToTips,
                  child: Text(
                    localizations.home_tips_label,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: mediumSpace),
              Center(
                child: ElevatedButton(
                  style: secondaryTextButtonStyle,
                  onPressed: goToAllSessions,
                  child: Text(localizations.sessions_header),
                ),
              ),
              const SizedBox(height: largeSpace),
            ],
          ),
        ),
      ),
    );
  }
}
