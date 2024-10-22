import 'package:ergo4all/app/welcome/timed_loading_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("should not call completed callback before animation is complete",
      (tester) async {
    bool wasCalled = false;

    void onCompleted() {
      wasCalled = true;
    }

    await tester.pumpWidget(Directionality(
        textDirection: TextDirection.ltr,
        child: TimedLoadingBar(
          duration: const Duration(seconds: 2),
          completed: onCompleted,
        )));

    await tester.pump(const Duration(seconds: 1));

    expect(wasCalled, isFalse);
  });

  testWidgets(
      "should call completed callback exactly once when animation is complete",
      (tester) async {
    int callCount = 0;

    void onCompleted() {
      callCount++;
    }

    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: TimedLoadingBar(
        duration: const Duration(seconds: 2),
        completed: onCompleted,
      ),
    ));

    await tester.pumpAndSettle();

    expect(callCount, equals(1));
  });
}
