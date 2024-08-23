import 'package:ergo4all/ui/widgets/session_start_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

import '../app_mock.dart';

void main() {
  Future<XFile?> mockGetVideo() async {
    return XFile("/some/video.mp4");
  }

  testWidgets(
      "should not invoke video selected callback when recording new video",
      (tester) async {
    bool calledVideoSelected = false;

    await tester.pumpWidget(makeMockAppFromWidget(StartSessionDialog(
      tryGetVideo: () async => null,
      videoSelected: (_) => calledVideoSelected = true,
    )));

    await tester.runAsync(() async {
      await tester.tap(find.byKey(const Key("new")));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 10));
    });

    expect(calledVideoSelected, isFalse);
  });

  testWidgets(
      "should invoke video selected callback when selecting video from gallery",
      (tester) async {
    bool calledVideoSelected = false;

    await tester.pumpWidget(makeMockAppFromWidget(
      StartSessionDialog(
        tryGetVideo: mockGetVideo,
        videoSelected: (_) => calledVideoSelected = true,
      ),
    ));

    await tester.runAsync(() async {
      await tester.tap(find.byKey(const Key("upload")));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 10));
    });

    expect(calledVideoSelected, isTrue);
  });
}
