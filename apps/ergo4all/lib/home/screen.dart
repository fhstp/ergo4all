import 'package:common_ui/theme/styles.dart';
import 'package:ergo4all/common/app_bar.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/common/screen_content.dart';
import 'package:ergo4all/common/shimmer_box.dart';
import 'package:ergo4all/common/snack.dart';
import 'package:ergo4all/gen/i18n/app_localizations.dart';
import 'package:ergo4all/home/pick_video_dialog.dart';
import 'package:ergo4all/home/session_start_dialog.dart';
import 'package:ergo4all/home/show_tutorial_dialog.dart';
import 'package:ergo4all/home/types.dart';
import 'package:ergo4all/home/user_welcome_header.dart';
import 'package:ergo4all/home/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:user_management/user_management.dart';

/// Top-level widget for home screen.
class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = useMemoized(HomeViewModel.new);
    final uiState = useValueListenable(viewModel.uiState);
    final localizations = AppLocalizations.of(context)!;

    void showStartSessionDialog() async {
      final source = await StartSessionDialog.show(context);
      if (source == null) return;

      if (source == VideoSource.live) {
        if (!context.mounted) return;
        await Navigator.pushNamed(context, Routes.liveAnalysis.path);
        return;
      }

      final videoFile = await showVideoPickDialog();
      if (videoFile == null) return;

      if (!context.mounted) return;
      showNotImplementedSnackbar(context);
    }

    void skipTutorial() async {
      final userIndex = await loadCurrentUserIndex();

      assert(userIndex != null);
      await updateUser(userIndex!, (it) => it.copyWith(hasSeenTutorial: true));
    }

    void showTutorial() {
      showNotImplementedSnackbar(context);
    }

    void showTutorialDialog() async {
      final takeTutorial = await ShowTutorialDialog.show(context);
      if (takeTutorial == null) return null;

      if (takeTutorial) {
        showTutorial();
      } else {
        skipTutorial();
      }
    }

    useEffect(() {
      final user = uiState.user.toNullable();
      if (user == null || user.hasSeenTutorial) return null;
      WidgetsBinding.instance.addPostFrameCallback((_) => showTutorialDialog());
      return null;
    }, [uiState.user]);

    useEffect(() {
      viewModel.initialize();
      return null;
    }, [null]);

    return Scaffold(
      appBar: makeCustomAppBar(title: localizations.home_title),
      body: ScreenContent(
          child: Column(
        children: [
          uiState.user.match(() => ShimmerBox(width: 200, height: 24),
              (it) => UserWelcomeHeader(it)),
          ElevatedButton(
              key: const Key("start"),
              style: primaryTextButtonStyle,
              onPressed: showStartSessionDialog,
              child: Text(localizations.home_firstSession))
        ],
      )),
    );
  }
}
