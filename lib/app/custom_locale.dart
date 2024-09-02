import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomLocale extends ChangeNotifier {
  final Future<Locale?> Function() _loadCustomLocale;
  final Future<void> Function(Locale) _storeCustomLocale;

  Locale? _customLocale;

  Locale? get customLocale => _customLocale;

  CustomLocale(this._loadCustomLocale, this._storeCustomLocale);

  static CustomLocale fromSharedPrefs() {
    SharedPreferencesAsync? prefs;

    return CustomLocale(() async {
      prefs ??= SharedPreferencesAsync();
      final localePref = await prefs!.getString("custom-locale");
      return localePref != null ? Locale(localePref) : null;
    }, (locale) async {
      prefs ??= SharedPreferencesAsync();
      await prefs!.setString("custom-locale", locale.languageCode);
    });
  }

  Future<void> load() async {
    _customLocale = await _loadCustomLocale();
    notifyListeners();
  }

  Future<void> store(Locale locale) async {
    await _storeCustomLocale(locale);
    _customLocale = locale;
    notifyListeners();
  }
}
