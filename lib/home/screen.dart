import 'package:ergo4all/common/app_bar.dart';
import 'package:ergo4all/common/header.dart';
import 'package:ergo4all/common/routes.dart';
import 'package:ergo4all/common/screen_content.dart';
import 'package:ergo4all/common/shimmer_box.dart';
import 'package:ergo4all/common/snack.dart';
import 'package:ergo4all/home/session_start_dialog.dart';
import 'package:ergo4all/home/show_tutorial_dialog.dart';
import 'package:ergo4all/home/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:user_management/user_management.dart';
import 'package:video_storage/types.dart';

class HomeScreen extends StatefulWidget {
  final VideoStorage videoStorage;
  final UserStorage userStorage;

  const HomeScreen(this.videoStorage, {super.key, required this.userStorage});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _currentUser;

  void _skipTutorial() async {
    final userIndex = await widget.userStorage.getCurrentUserIndex();
    if (userIndex == null) {
      throw StateError("Must have current user to skip tutorial.");
    }
    await widget.userStorage.updateUser(userIndex, skipTutorial);
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
    widget.userStorage.getCurrentUser().then((user) {
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
