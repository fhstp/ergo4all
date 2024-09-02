import 'package:ergo4all/app/screens/home.dart';
import 'package:ergo4all/domain/user.dart';
import 'package:ergo4all/domain/user_config.dart';
import 'package:ergo4all/ui/session_start_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../app_mock.dart';
import '../fake_text_storage.dart';
import '../fake_video_storage.dart';

void main() {
  testWidgets("should show session start dialog when pressing start button",
      (tester) async {
    final videoStorage = FakeVideoStorage();
    final textStorage = FakeTextStorage()
        .putUserConfig(UserConfig.forUser(const User.newFromName("Jane")));

    await tester.pumpWidget(
        makeMockAppFromWidget(HomeScreen(videoStorage, textStorage)));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    await tester.runAsync(() async {
      await tester.tap(find.byKey(const Key("start")));
      await tester.pump();
    });

    expect(find.byKey(StartSessionDialog.dialogKey), findsOneWidget);
  });

  testWidgets("should display name of current user", (tester) async {
    final videoStorage = FakeVideoStorage();
    const user = User.newFromName("Jane");
    final textStorage =
        FakeTextStorage().putUserConfig(UserConfig.forUser(user));

    await tester.pumpWidget(
        makeMockAppFromWidget(HomeScreen(videoStorage, textStorage)));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text(user.name), findsOne);
  });
}
