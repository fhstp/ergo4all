import 'package:shared_preferences/shared_preferences.dart';

final SharedPreferencesAsync _sharedPrefs = SharedPreferencesAsync();

/// Puts a [value] into shared preferences using the given [key].
Future<void> putStringIntoPrefs(String key, String value) async {
  await _sharedPrefs.setString(key, value);
}

/// Attempts to get a [String] value from shared preferences using the given
/// [key]. If no value is found, returns [Null].
Future<String?> tryGetString(String key) {
  return _sharedPrefs.getString(key);
}

/// Attempts to get a value from shared preferences using the given [key].
/// The value will be parsed using the given [parse] function. If no value
/// is found, returns [Null].
Future<T?> tryGetItemFromPrefs<T>(
  String key,
  T Function(String pref) parse,
) async {
  final unparsed = await tryGetString(key);
  return unparsed != null ? parse(unparsed) : null;
}
