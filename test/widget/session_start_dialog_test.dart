import 'package:ergo4all/home/session_start_dialog.dart';
import 'package:ergo4all/home/types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../integration/app_mock.dart';

void main() {
  late MockNavigator navigator;

  setUpAll(() {});

  setUp(() {
    navigator = MockNavigator();

    when(() => navigator.canPop()).thenReturn(true);
  });

  testWidgets("should use live video source when pressing camera button",
      (tester) async {
    await tester
        .pumpWidget(makeMockAppFromWidget(StartSessionDialog(), navigator));

    await tester.runAsync(() async {
      await tester.tap(find.byKey(const Key("new")));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 10));
    });

    verify(() => navigator.pop(VideoSource.live)).called(1);
  });

  testWidgets("should use gallery video source when pressing upload button",
      (tester) async {
    await tester
        .pumpWidget(makeMockAppFromWidget(StartSessionDialog(), navigator));

    await tester.runAsync(() async {
      await tester.tap(find.byKey(const Key("upload")));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 10));
    });

    verify(() => navigator.pop(VideoSource.gallery)).called(1);
  });
}
