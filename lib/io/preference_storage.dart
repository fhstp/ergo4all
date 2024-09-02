import 'package:shared_preferences/shared_preferences.dart';

/// Contains IO functions for interacting with user preferences.
abstract class PreferenceStorage {
  /// Attempts to get a string from preferences by key.
  Future<String?> tryGetString(String key);

  /// Attempts to store a string in prefrences by key.
  Future<Null> putString(String key, String value);
}

/// Implementation of [PreferenceStorage] which uses shared preferences.
class SharedPreferencesStorage implements PreferenceStorage {
  final SharedPreferencesAsync sharedPrefs;

  SharedPreferencesStorage(this.sharedPrefs);

  @override
  Future<Null> putString(String key, String value) async {
    await sharedPrefs.setString(key, value);
  }

  @override
  Future<String?> tryGetString(String key) {
    return sharedPrefs.getString(key);
  }
}
