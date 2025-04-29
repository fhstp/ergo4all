import 'package:common_ui/theme/colors.dart';
import 'package:common_ui/theme/styles.dart';
import 'package:common_ui/widgets/red_circle_top_bar.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/common/screen_content.dart';
import 'package:ergo4all/common/shimmer_box.dart';
import 'package:ergo4all/common/snack.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/home/menu_dialog.dart';
import 'package:ergo4all/home/pick_video_dialog.dart';
import 'package:ergo4all/home/session_start_dialog.dart';
import 'package:ergo4all/home/types.dart';
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

    Future<void> showStartSessionDialog() async {
      final source = await StartSessionDialog.show(context);
      if (source == null) return;

      if (source == VideoSource.live) {
        if (!context.mounted) return;
        await Navigator.pushNamed(context, Routes.scenarioChoice.path);
        return;
      }

      final videoFile = await showVideoPickDialog();
      if (videoFile == null) return;

      if (!context.mounted) return;
      showNotImplementedSnackbar(context);
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
            titleText: 'HOME',
            menuButton: IconButton(
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
                uiState.user.match(
                  () => const ShimmerBox(width: 200, height: 24),
                  UserWelcomeHeader.new,
                ),
                Image.asset(
                  'assets/images/full_body_blue.png',
                  height: 240,
                ),
                ElevatedButton(
                  key: const Key('start'),
                  style: primaryTextButtonStyle,
                  onPressed: showStartSessionDialog,
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
