import 'package:ergo4all/app/impure_utils.dart';
import 'package:ergo4all/app/routes.dart';
import 'package:ergo4all/domain/user.dart';
import 'package:ergo4all/io/local_text_storage.dart';
import 'package:ergo4all/io/video_storage.dart';
import 'package:ergo4all/ui/loading_indicator.dart';
import 'package:ergo4all/ui/screen_content.dart';
import 'package:ergo4all/ui/show_tutorial_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/video_source.dart';
import '../../ui/session_start_dialog.dart';

class _HomeContent extends StatelessWidget {
  final User user;
  final void Function() onSessionStartPressed;

  const _HomeContent({required this.user, required this.onSessionStartPressed});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.home_title),
        centerTitle: true,
      ),
      body: ScreenContent(
          child: Column(
        children: [
          Text(localizations.home_welcome(user.name)),
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

  void _onUserLoaded(User user) async {
    if (!user.hasSeenTutorial) await ShowTutorialDialog.show(context);
  }

  void _analyzeVideo(XFile videoFile) {
    Navigator.pushNamed(context, Routes.analysis.path);
  }

  void _onSessionVideoSourceChosen(VideoSource source) async {
    if (source == VideoSource.live) {
      // TODO: Implement live video source
      throw Exception("Not impl");
    }

    final videoFile = await widget.videoStorage.tryPick();
    if (videoFile == null) return;
    _analyzeVideo(videoFile);
  }

  void _showStartSessionDialog() async {
    await StartSessionDialog.show(context, _onSessionVideoSourceChosen);
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
    void analyzeVideo(XFile videoFile) {
      // TODO: Pass file
      Navigator.pushNamed(context, Routes.recordedAnalysis.path);
    }

    void onSessionVideoSourceChosen(VideoSource source) async {
      if (source == VideoSource.live) {
        Navigator.pushNamed(context, Routes.liveAnalysis.path);
        return;
      }

      final videoFile = await widget.videoStorage.tryPick();
      if (videoFile == null) return;
      analyzeVideo(videoFile);
    }

    void showStartSessionDialog() {
      StartSessionDialog.show(context, onSessionVideoSourceChosen);
    }

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
