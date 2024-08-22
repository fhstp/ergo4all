import 'package:ergo4all/dialogs/session_start.dart';
import 'package:ergo4all/screens/analysis.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

import '../app_mock.dart';
import '../navigation_observer_mock.dart';

void main() {
  Future<XFile?> mockGetVideo() async {
    return XFile("/some/video.mp4");
  }

  testWidgets(
      "should not navigate to analysis when not selecting video from gallery",
      (tester) async {
    final mockNavigationObserver = MockNavigationObserver();

    await tester.pumpWidget(makeMockAppFromWidget(
        StartSessionDialog(
          tryGetVideo: () async => null,
        ),
        mockNavigationObserver));

    await tester.runAsync(() async {
      await tester.tap(find.byKey(const Key("upload")));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 10));
    });

    expect(mockNavigationObserver.anyNavigationHappened, isFalse);
    expect(find.byKey(StartSessionDialog.dialogKey), findsOneWidget);
  });

  testWidgets(
      "should not navigate to analysis when selecting video from gallery",
      (tester) async {
    final mockNavigationObserver = MockNavigationObserver();

    await tester.pumpWidget(makeMockAppFromWidget(
        StartSessionDialog(
          tryGetVideo: mockGetVideo,
        ),
        mockNavigationObserver));

    await tester.runAsync(() async {
      await tester.tap(find.byKey(const Key("upload")));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 10));
    });

    expect(mockNavigationObserver.anyNavigationHappened, isTrue);
    expect(find.byType(AnalysisScreen), findsOneWidget);
  });
}
