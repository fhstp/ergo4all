import 'package:ergo4all/app/io/local_text_storage.dart';
import 'package:ergo4all/app/io/user_storage.dart';
import 'package:ergo4all/app/io/video_storage.dart';
import 'package:ergo4all/app/routes.dart';
import 'package:ergo4all/app/ui/app_bar.dart';
import 'package:ergo4all/app/ui/header.dart';
import 'package:ergo4all/app/ui/loading_indicator.dart';
import 'package:ergo4all/app/ui/screen_content.dart';
import 'package:ergo4all/app/ui/show_tutorial_dialog.dart';
import 'package:ergo4all/app/ui/snack.dart';
import 'package:ergo4all/domain/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/video_source.dart';
import '../ui/session_start_dialog.dart';

class _HomeContent extends StatelessWidget {
  final User user;
  final void Function() onSessionStartPressed;

  const _HomeContent({required this.user, required this.onSessionStartPressed});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: makeCustomAppBar(
        title: localizations.home_title,
      ),
      body: ScreenContent(
          child: Column(
        children: [
          Header(localizations.home_welcome(user.name)),
          ElevatedButton(
              key: const Key("start"),
              onPressed: () {
                onSessionStartPressed();
              },
              child: Text(localizations.home_firstSession))
        ],
      )),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final VideoStorage videoStorage;
  final LocalTextStorage textStorage;

  const HomeScreen(this.videoStorage, this.textStorage, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<User> loadedUser;

  void _skipTutorial() async {
    final userIndex = await getCurrentUserIndex(widget.textStorage);
    if (userIndex == null) {
      throw StateError("Must have current user to skip tutorial.");
    }
    await updateUser(widget.textStorage, userIndex, skipTutorial);
  }

  void _showTutorial() {
    showNotImplementedSnackbar(context);
  }

  void _onTakeTutorialChoiceMade(bool showTutorial) {
    if (showTutorial) {
      _showTutorial();
    } else {
      _skipTutorial();
    }
  }

  void _onUserLoaded(User user) async {
    if (!user.hasSeenTutorial) {
      await ShowTutorialDialog.show(context, _onTakeTutorialChoiceMade);
    }
  }

  void _showStartSessionDialog() async {
    final source = await StartSessionDialog.show(
      context,
    );
    if (source == null) return;

    if (source == VideoSource.live) {
      if (!mounted) return;
      await Navigator.pushNamed(context, Routes.liveAnalysis.path);
      return;
    }

    final videoFile = await widget.videoStorage.tryPick();
    if (videoFile == null) return;

    if (!mounted) return;
    await Navigator.pushNamed(context, Routes.recordedAnalysis.path);
  }

  @override
  void initState() {
    super.initState();
    loadedUser = getCurrentUser(widget.textStorage).then((user) {
      if (user == null) throw Exception("Must have user on home screen!");
      _onUserLoaded(user);
      return user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadedUser,
      builder: (context, snapshot) => snapshot.hasData
          ? _HomeContent(
              user: snapshot.data!,
              onSessionStartPressed: _showStartSessionDialog,
            )
          : const LoadingIndicator(),
    );
  }
}
