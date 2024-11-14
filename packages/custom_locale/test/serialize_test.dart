import 'package:custom_locale/src/serialize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("should serialize using language code", () {
    final locale = Locale("en");
    final actual = serializeLocale(locale);
    expect(actual, equals("en"));
  });

  test("should deserialize using language code", () {
    final actual = deserializeLocale("en");
    expect(actual, equals(Locale("en")));
  });
}
