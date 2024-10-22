import 'package:ergo4all/storage.prefs/types.dart';

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
