import 'package:ergo4all/app/home/screen.dart';
import 'package:ergo4all/app/home/session_start_dialog.dart';
import 'package:ergo4all/app/home/show_tutorial_dialog.dart';
import 'package:ergo4all/common/user.dart';
import 'package:ergo4all/storage.user/user_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../app_mock.dart';
import '../fake_text_storage.dart';
import '../fake_user_storage.dart';
import '../fake_video_storage.dart';

void main() {
  testWidgets("should show session start dialog when pressing start button",
      (tester) async {
    final videoStorage = FakeVideoStorage();
    final textStorage = FakeTextStorage().putUserConfig(
        UserConfig.forUser(const User(name: "Jane", hasSeenTutorial: true)));

    await tester.pumpWidget(
        makeMockAppFromWidget(HomeScreen(videoStorage, textStorage)));
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.byKey(const Key("start")));
    await tester.pumpAndSettle();

    expect(find.byKey(StartSessionDialog.dialogKey), findsOneWidget);
  });

  testWidgets("should display name of current user", (tester) async {
    final videoStorage = FakeVideoStorage();
    const user = User.newFromName("Jane");
    final textStorage =
        FakeTextStorage().putUserConfig(UserConfig.forUser(user));

    await tester.pumpWidget(
        makeMockAppFromWidget(HomeScreen(videoStorage, textStorage)));
    await tester.pump(const Duration(seconds: 1));

    expect(find.textContaining(user.name), findsOne);
  });

  testWidgets("should show tutorial dialog if user has not seen it",
      (tester) async {
    final videoStorage = FakeVideoStorage();
    final textStorage = FakeTextStorage().putUserConfig(
        UserConfig.forUser(const User(name: "Jane", hasSeenTutorial: false)));

    await tester.pumpWidget(
        makeMockAppFromWidget(HomeScreen(videoStorage, textStorage)));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.byKey(ShowTutorialDialog.dialogKey), findsOneWidget);
  });

  testWidgets("should not show tutorial dialog if user has seen it",
      (tester) async {
    final videoStorage = FakeVideoStorage();
    final textStorage = FakeTextStorage().putUserConfig(
        UserConfig.forUser(const User(name: "Jane", hasSeenTutorial: true)));

    await tester.pumpWidget(
        makeMockAppFromWidget(HomeScreen(videoStorage, textStorage)));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.byKey(ShowTutorialDialog.dialogKey), findsNothing);
  });
}
