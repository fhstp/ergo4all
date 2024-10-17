import 'package:ergo4all/domain/video_source.dart';
import 'package:ergo4all/app/ui/session_start_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget makeDialog(void Function(VideoSource) onVideoSourceChosen) {
    return MaterialApp(
      home: StartSessionDialog(
        videoSourceChosen: onVideoSourceChosen,
      ),
    );
  }

  testWidgets("should use live video source when pressing camera button",
      (tester) async {
    VideoSource? selectedSource;

    await tester.pumpWidget(makeDialog(
      (source) => selectedSource = source,
    ));

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

    await tester.pumpWidget(makeDialog(
      (source) => selectedSource = source,
    ));

    await tester.runAsync(() async {
      await tester.tap(find.byKey(const Key("upload")));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 10));
    });

    expect(selectedSource, equals(VideoSource.gallery));
  });
}
