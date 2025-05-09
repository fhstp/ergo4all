import 'dart:async';

import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/red_circle_top_bar.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/common/screen_content.dart';
import 'package:ergo4all/common/shimmer_box.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/home/menu_dialog.dart';
import 'package:ergo4all/home/user_welcome_header.dart';
import 'package:ergo4all/home/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Top-level widget for home screen.
class HomeScreen extends HookWidget {
  /// Creates a [HomeScreen].
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = useMemoized(HomeViewModel.new);
    final uiState = useValueListenable(viewModel.uiState);
    final localizations = AppLocalizations.of(context)!;

    void startSession() {
      unawaited(Navigator.pushNamed(context, Routes.scenarioChoice.path));
    }

    Future<void> goToTips() async {
      await Navigator.of(context).pushNamed(Routes.tips.path);
    }

    useEffect(
      () {
        viewModel.initialize();
        return null;
      },
      [null],
    );

    return Scaffold(
      body: Column(
        children: [
          RedCircleTopBar(
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
          ScreenContent(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/puppet/full_body_blue.png',
                  height: 240,
                ),
                //const Spacer(flex: 2),
                uiState.user.match(
                  () => const ShimmerBox(width: 200, height: 24),
                  UserWelcomeHeader.new,
                ),
                ElevatedButton(
                  key: const Key('start'),
                  style: primaryTextButtonStyle,
                  onPressed: startSession,
                  child: Text(localizations.record_label),
                ),
                ElevatedButton(
                  key: const Key('tips'),
                  style: secondaryTextButtonStyle,
                  onPressed: goToTips,
                  child: Text(localizations.home_tips_label),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
