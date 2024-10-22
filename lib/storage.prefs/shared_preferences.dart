import 'package:ergo4all/storage.prefs/types.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
