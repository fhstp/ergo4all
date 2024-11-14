import 'dart:ui';

import 'src/serialize.dart';
import 'src/storage.dart';

const String _prefKey = "custom-locale";

/// Sets the users custom locale.
Future<Null> setCustomLocale(Locale locale) async {
  await putStringIntoPrefs(_prefKey, serializeLocale(locale));
}

/// Attempts to read custom locale. May return null if there is none.
Future<Locale?> tryGetCustomLocale() async {
  return tryGetItemFromPrefs(_prefKey, deserializeLocale);
}
