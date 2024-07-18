import 'package:ergo4all/screens/analysis.dart';
import 'package:ergo4all/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

import '../mock_app.dart';

void main() {
  testWidgets("should navigate to analysis after uploading video",
      (tester) async {
    Future<XFile?> mockGetVideo() async {
      return XFile("/some/video.mp4");
    }

    await tester.pumpWidget(makeMockAppFromWidget(
      HomeScreen(
        tryGetVideo: mockGetVideo,
      ),
    ));

    await tester.runAsync(() async {
      await tester.tap(find.byKey(const Key("upload")));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 10));
    });

    expect(find.byType(AnalysisScreen), findsOneWidget);
  });

  testWidgets("should not navigate to analysis after not selecting video",
      (tester) async {
    Future<XFile?> mockGetVideo() async {
      return null;
    }

    await tester.pumpWidget(makeMockAppFromWidget(
      HomeScreen(
        tryGetVideo: mockGetVideo,
      ),
    ));

    await tester.runAsync(() async {
      await tester.tap(find.byKey(const Key("upload")));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 10));
    });

    expect(find.byType(HomeScreen), findsOneWidget);
  });
}
