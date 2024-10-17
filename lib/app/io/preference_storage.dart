/// Contains IO functions for interacting with user preferences.
abstract class PreferenceStorage {
  /// Attempts to get a string from preferences by key.
  Future<String?> tryGetString(String key);

  /// Attempts to store a string in preferences by key.
  Future<Null> putString(String key, String value);
}

extension GenericPreferenceStorage on PreferenceStorage {
  /// Attempts to get an item from the preference store. The item is expected
  /// to be stored as a [String] that can be parsed by passing it through the
  /// given [parse] function.
  /// Returns `null` if the key was not found.
  Future<T?> tryGetItem<T>(String key, T Function(String pref) parse) async {
    final unparsed = await tryGetString(key);
    return unparsed != null ? parse(unparsed) : null;
  }
}
