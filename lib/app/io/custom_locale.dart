import 'package:ergo4all/app/io/preference_storage.dart';
import 'package:ergo4all/app/io/pref_keys.dart';
import 'package:flutter/material.dart';

/// Serialized a [Locale] to a [String]. Can be deserialized using
/// [deserializeLocale].
String serializeLocale(Locale locale) {
  return locale.languageCode;
}

/// Deserializes a [Locale] that was serialized to a [String] using
/// [serializeLocale].
Locale deserializeLocale(String s) {
  return Locale(s);
}

/// Attempts to read custom locale from a [PreferenceStorage]. May return null
/// if there is no custom locale.
Future<Locale?> tryGetCustomLocale(PreferenceStorage storage) async {
  return storage.tryGetItem(PrefKeys.customLocale, deserializeLocale);
}

/// Sets the users custom locale in a [PreferenceStorage].
Future<Null> setCustomLocale(PreferenceStorage storage, Locale locale) async {
  await storage.putString(PrefKeys.customLocale, serializeLocale(locale));
}
