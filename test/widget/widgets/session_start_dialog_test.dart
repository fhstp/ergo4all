import 'package:ergo4all/ui/widgets/session_start_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';

import '../../../lib/domain/video_source.dart';
import '../../integration/ui/app_mock.dart';

void main() {
  Future<XFile?> mockGetVideo() async {
    return XFile("/some/video.mp4");
  }

  testWidgets("should use live video source when pressing camera button",
      (tester) async {
    VideoSource? selectedSource;

    await tester.pumpWidget(makeMockAppFromWidget(StartSessionDialog(
      videoSourceChosen: (source) => selectedSource = source,
    )));

    await tester.runAsync(() async {
      await tester.tap(find.byKey(const Key("new")));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 10));
    });

    expect(selectedSource, equals(VideoSource.live));
  });

  testWidgets("should use gallery video source when pressing upload button",
      (tester) async {
    VideoSource? selectedSource;

    await tester.pumpWidget(makeMockAppFromWidget(StartSessionDialog(
      videoSourceChosen: (source) => selectedSource = source,
    )));

    await tester.runAsync(() async {
      await tester.tap(find.byKey(const Key("upload")));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 10));
    });

    expect(selectedSource, equals(VideoSource.gallery));
  });
}
