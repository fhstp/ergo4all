import 'package:shared_preferences/shared_preferences.dart';

final SharedPreferencesAsync _sharedPrefs = SharedPreferencesAsync();

Future<Null> putStringIntoPrefs(String key, String value) async {
  await _sharedPrefs.setString(key, value);
}

Future<String?> tryGetString(String key) {
  return _sharedPrefs.getString(key);
}

Future<T?> tryGetItemFromPrefs<T>(
    String key, T Function(String pref) parse) async {
  final unparsed = await tryGetString(key);
  return unparsed != null ? parse(unparsed) : null;
}
