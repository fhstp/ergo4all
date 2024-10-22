import 'dart:convert';

import 'package:user_storage/user_config.dart';
import 'package:user_storage/user_storage.dart';

import 'fake_text_storage.dart';

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
