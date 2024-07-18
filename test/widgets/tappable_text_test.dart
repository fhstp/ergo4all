import 'package:ergo4all/widgets/tappable_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("should display input text", (tester) async {
    const text = "Some text";

    await tester.pumpWidget(const Directionality(
        textDirection: TextDirection.ltr, child: TappableText(text: text)));

    expect(find.text(text), findsOneWidget);
  });

  testWidgets("should call callback when tapped", (tester) async {
    bool wasTapped = false;
    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: TappableText(
        text: "Some text",
        onTap: () {
          wasTapped = true;
        },
      ),
    ));

    await tester.tap(find.byType(TappableText));

    expect(wasTapped, isTrue);
  });
}
