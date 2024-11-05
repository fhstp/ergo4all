import 'serialize.dart';
import 'package:flutter/material.dart';
import 'package:prefs_storage/generic_ext.dart';
import 'package:prefs_storage/types.dart';

/// Contains extension methods for loading and storing custom locales in a [PreferenceStorage].
extension CustomLocalePrefStorage on PreferenceStorage {
  static const String prefKey = "custom-locale";

  /// Sets the users custom locale.
  Future<Null> setCustomLocale(Locale locale) async {
    await putString(prefKey, serializeLocale(locale));
  }

  /// Attempts to read custom locale. May return null if there is none.
  Future<Locale?> tryGetCustomLocale() async {
    return tryGetItem(prefKey, deserializeLocale);
  }
}
