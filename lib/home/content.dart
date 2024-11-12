import 'package:ergo4all/common/app_bar.dart';
import 'package:ergo4all/common/header.dart';
import 'package:ergo4all/common/screen_content.dart';
import 'package:ergo4all/common/shimmer_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// The content displayed on the home screen.
class HomeContent extends StatelessWidget {
  final String? currentUserName;
  final void Function()? onSessionRequested;

  const HomeContent({super.key, this.currentUserName, this.onSessionRequested});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: makeCustomAppBar(title: localizations.home_title),
      body: ScreenContent(
          child: Column(
        children: [
          currentUserName == null
              ? ShimmerBox(width: 200, height: 24)
              : Header(localizations.home_welcome(currentUserName!)),
          ElevatedButton(
              key: const Key("start"),
              onPressed: () => onSessionRequested?.call(),
              child: Text(localizations.home_firstSession))
        ],
      )),
    );
  }
}
