import 'package:ergo4all/common/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget testAppWith(AppBar appBar) {
    return MaterialApp(
      home: Scaffold(
        appBar: appBar,
      ),
    );
  }

  testWidgets('should have given title', (tester) async {
    const expectedTitle = 'wow';

    await tester
        .pumpWidget(testAppWith(makeCustomAppBar(title: expectedTitle)));

    expect(find.text(expectedTitle), findsOneWidget);
  });

  testWidgets('should have icon if requested', (tester) async {
    await tester.pumpWidget(
      testAppWith(makeCustomAppBar(title: 'title')),
    );

    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('should have no icon if requested', (tester) async {
    await tester.pumpWidget(
      testAppWith(makeCustomAppBar(title: 'title', withIcon: false)),
    );

    expect(find.byType(Image), findsNothing);
  });
}
