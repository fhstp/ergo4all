import 'package:ergo4all/app/screens/home.dart';
import 'package:ergo4all/ui/session_start_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../app_mock.dart';
import '../fake_video_storage.dart';

void main() {
  testWidgets("should show session start dialog when pressing start button",
      (tester) async {
    final videoStorage = FakeVideoStorage();

    await tester.pumpWidget(makeMockAppFromWidget(HomeScreen(videoStorage)));

    await tester.runAsync(() async {
      await tester.tap(find.byKey(const Key("start")));
      await tester.pump();
    });

    expect(find.byKey(StartSessionDialog.dialogKey), findsOneWidget);
  });
}
