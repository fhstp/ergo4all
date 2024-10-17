import 'package:ergo4all/app/pref_keys.dart';
import 'package:ergo4all/io/preference_storage.dart';
import 'package:flutter/material.dart';
import 'package:mockingjay/mockingjay.dart';

class FakePreferenceStorage extends Fake implements PreferenceStorage {
  final Map<String, String> _strings = {};

  FakePreferenceStorage putStringSync(String key, String value) {
    _strings[key] = value;
    return this;
  }

  String? tryGetStringSync(String key) {
    return _strings[key];
  }

  @override
  Future<String?> tryGetString(String key) async {
    return tryGetStringSync(key);
  }

  @override
  Future<Null> putString(String key, String value) async {
    putStringSync(key, value);
  }
}

extension CustomLocaleStorage on FakePreferenceStorage {
  FakePreferenceStorage putCustomLocale(Locale locale) {
    return putStringSync(PrefKeys.customLocale, locale.languageCode);
  }

  Locale? tryGetCustomLocale() {
    final localePref = tryGetStringSync(PrefKeys.customLocale);
    return localePref != null ? Locale(localePref) : null;
  }
}
