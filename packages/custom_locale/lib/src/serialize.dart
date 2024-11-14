import 'package:flutter/material.dart';

/// Deserializes a [Locale] that was serialized to a [String] using [serializeLocale].
Locale deserializeLocale(String s) {
  return Locale(s);
}

/// Serialized a [Locale] to a [String]. Can be deserialized using [deserializeLocale].
String serializeLocale(Locale locale) {
  return locale.languageCode;
}
