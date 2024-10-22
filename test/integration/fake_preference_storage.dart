import 'package:ergo4all/storage.prefs/types.dart';
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
