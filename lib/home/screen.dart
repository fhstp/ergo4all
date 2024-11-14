import 'package:ergo4all/common/app_bar.dart';
import 'package:ergo4all/common/hook_ext.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/common/screen_content.dart';
import 'package:ergo4all/common/shimmer_box.dart';
import 'package:ergo4all/common/snack.dart';
import 'package:ergo4all/home/pick_video_dialog.dart';
import 'package:ergo4all/home/session_start_dialog.dart';
import 'package:ergo4all/home/show_tutorial_dialog.dart';
import 'package:ergo4all/home/types.dart';
import 'package:ergo4all/home/user_welcome_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:user_management/user_management.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    final (currentUser, setCurrentUser) = useState<User?>(null).split();

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
      final userIndex = await loadCurrentUserIndex();

      assert(userIndex != null);
      await updateUser(userIndex!, (it) => it.copyWith(hasSeenTutorial: true));
    }

    void showTutorial() {
      showNotImplementedSnackbar(context);
    }

    void onUserLoaded(User user) async {
      setCurrentUser(user);

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
      loadCurrentUser().then((user) {
        assert(user != null);
        onUserLoaded(user!);
      });
      return null;
    }, [null]);

    return Scaffold(
      appBar: makeCustomAppBar(title: localizations.home_title),
      body: ScreenContent(
          child: Column(
        children: [
          currentUser == null
              ? ShimmerBox(width: 200, height: 24)
              : UserWelcomeHeader(currentUser),
          ElevatedButton(
              key: const Key("start"),
              onPressed: showStartSessionDialog,
              child: Text(localizations.home_firstSession))
        ],
      )),
    );
  }
}
