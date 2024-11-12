import 'package:ergo4all/common/hook_ext.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/common/snack.dart';
import 'package:ergo4all/home/content.dart';
import 'package:ergo4all/home/pick_video_dialog.dart';
import 'package:ergo4all/home/session_start_dialog.dart';
import 'package:ergo4all/home/show_tutorial_dialog.dart';
import 'package:ergo4all/home/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:user_management/user_management.dart';

class HomeScreen extends HookWidget {
  final UserStorage userStorage;

  const HomeScreen({super.key, required this.userStorage});

  @override
  Widget build(BuildContext context) {
    final (currentUserName, setCurrentUserName) =
        useState<String?>(null).split();

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
      await Navigator.pushNamed(context, Routes.recordedAnalysis.path);
    }

    void skipTutorial() async {
      final userIndex = await userStorage.getCurrentUserIndex();
      assert(userIndex != null);
      await userStorage.updateUser(
          userIndex!, (it) => it.copyWith(hasSeenTutorial: true));
    }

    void showTutorial() {
      showNotImplementedSnackbar(context);
    }

    void onUserLoaded(User user) async {
      setCurrentUserName(user.name);

      if (user.hasSeenTutorial) return;

      final takeTutorial = await ShowTutorialDialog.show(context);
      if (takeTutorial == null) return;

      if (takeTutorial) {
        showTutorial();
      } else {
        skipTutorial();
      }
    }

    useEffect(() {
      userStorage.getCurrentUser().then((user) {
        assert(user != null);
        onUserLoaded(user!);
      });
      return null;
    }, [null]);

    return HomeContent(
      currentUserName: currentUserName,
      onSessionRequested: showStartSessionDialog,
    );
  }
}
