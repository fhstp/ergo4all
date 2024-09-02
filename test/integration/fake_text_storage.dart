import 'dart:convert';

import 'package:ergo4all/domain/user_config.dart';
import 'package:ergo4all/io/local_text_storage.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeTextStorage extends Fake implements LocalTextStorage {
  final Map<String, String> _files = {};

  FakeTextStorage put(String path, String content) {
    _files[path] = content;
    return this;
  }

  String? tryGet(String path) {
    return _files[path];
  }

  @override
  Future<String?> read(String localFilePath) async {
    return tryGet(localFilePath);
  }

  @override
  Future<Null> write(String localFilePath, String content) async {
    put(localFilePath, content);
  }
}

extension FakeUserConfigStorage on FakeTextStorage {
  FakeTextStorage putUserConfig(UserConfig config) {
    final json = config.toJson();
    final text = jsonEncode(json);
    put(userConfigFilePath, text);
    return this;
  }

  UserConfig? tryGetUserConfig() {
    final text = tryGet(userConfigFilePath);
    if (text == null) return null;
    final json = jsonDecode(text);
    return UserConfig.fromJson(json);
  }
}
