/// Contains IO functions for interacting with user preferences.
abstract class PreferenceStorage {
  /// Attempts to get a string from preferences by key.
  Future<String?> tryGetString(String key);

  /// Attempts to store a string in preferences by key.
  Future<Null> putString(String key, String value);
}
