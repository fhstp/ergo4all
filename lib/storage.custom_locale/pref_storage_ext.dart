import 'package:ergo4all/storage.custom_locale/serialize.dart';
import 'package:ergo4all/storage.prefs/generic_ext.dart';
import 'package:ergo4all/storage.prefs/types.dart';
import 'package:flutter/material.dart';

/// Contains extension methods for loading and storing custom locales in a
/// [PreferenceStorage].
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
