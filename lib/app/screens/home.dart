import 'package:ergo4all/app/io/local_text_storage.dart';
import 'package:ergo4all/app/io/user_storage.dart';
import 'package:ergo4all/app/io/video_storage.dart';
import 'package:ergo4all/app/routes.dart';
import 'package:ergo4all/app/ui/app_bar.dart';
import 'package:ergo4all/app/ui/header.dart';
import 'package:ergo4all/app/ui/screen_content.dart';
import 'package:ergo4all/app/ui/shimmer_box.dart';
import 'package:ergo4all/app/ui/show_tutorial_dialog.dart';
import 'package:ergo4all/app/ui/snack.dart';
import 'package:ergo4all/domain/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/video_source.dart';
import '../ui/session_start_dialog.dart';

class HomeScreen extends StatefulWidget {
  final VideoStorage videoStorage;
  final LocalTextStorage textStorage;

  const HomeScreen(this.videoStorage, this.textStorage, {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _currentUser;

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

  void _onUserLoaded(User user) async {
    setState(() {
      _currentUser = user;
    });

    if (user.hasSeenTutorial) return;

    final showTutorial = await ShowTutorialDialog.show(context);
    if (showTutorial == null) return;

    if (showTutorial) {
      _showTutorial();
    } else {
      _skipTutorial();
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
    getCurrentUser(widget.textStorage).then((user) {
      if (user == null) throw Exception("Must have user on home screen!");
      _onUserLoaded(user);
    });
  }

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
          _currentUser == null
              ? ShimmerBox(width: 200, height: 24)
              : Header(localizations.home_welcome(_currentUser!.name)),
          ElevatedButton(
              key: const Key("start"),
              onPressed: () {
                _showStartSessionDialog();
              },
              child: Text(localizations.home_firstSession))
        ],
      )),
    );
  }
}
