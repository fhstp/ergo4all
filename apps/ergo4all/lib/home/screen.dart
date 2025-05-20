import 'dart:async';

import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/spacing.dart';
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
      await Navigator.of(context).pushNamed(Routes.tipChoice.path);
    }

    useEffect(
      () {
        viewModel.initialize();
        return null;
      },
      [null],
    );

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
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
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
                        'assets/images/puppet/full_body_blue.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                //const SizedBox(height: mediumSpace),
                uiState.user.match(
                  () => const ShimmerBox(width: 200, height: 24),
                  UserWelcomeHeader.new,
                ),
                const SizedBox(height: mediumSpace),
                ElevatedButton(
                  key: const Key('start'),
                  style: primaryTextButtonStyle,
                  onPressed: startSession,
                  child: Text(localizations.record_label),
                ),
                const SizedBox(height: mediumSpace),
                ElevatedButton(
                  key: const Key('tips'),
                  style: secondaryTextButtonStyle,
                  onPressed: goToTips,
                  child: Text(localizations.home_tips_label),
                ),
                const SizedBox(height: mediumSpace),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
