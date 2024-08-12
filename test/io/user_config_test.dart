import 'dart:async';

import 'package:ergo4all/io/local_file.dart';
import 'package:ergo4all/io/user_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("get config from storage", () {
    test("should be null if there is no config file", () async {
      final getUserConfig = makeGetUserConfigFromStorage((_) async => null);

      final config = await getUserConfig();

      expect(config, isNull);
    });

    test("should be parsed file if present", () async {
      final getUserConfig = makeGetUserConfigFromStorage((_) async => """
{
  "currentUserIndex": 1,
  "userEntries": [
    { "name": "John" },
    { "name": "Jane" }
  ]
}""");

      final config = await getUserConfig();

      expect(
          config,
          const UserConfig(currentUserIndex: 1, userEntries: [
            UserConfigEntry(name: "John"),
            UserConfigEntry(name: "Jane")
          ]));
    });
  });

  group("update stored config", () {
    GetUserConfig getConstantConfig(UserConfig? config) => () async => config;

    GetUserConfig getNullConfig = getConstantConfig(null);

    // ignore: prefer_function_declarations_over_variables
    WriteLocalTextFile noopTextWrite = (_, __) async => null;

    test("should pass null to update if there is no config file", () async {
      final updateUserConfig =
          makeUpdateStoredUserConfig(getNullConfig, noopTextWrite);
      final completer = Completer();

      await updateUserConfig((config) {
        expect(config, isNull);
        completer.complete();
        return const UserConfig(currentUserIndex: 0, userEntries: []);
      });

      expect(completer.isCompleted, isTrue);
    });

    test("should pass config to update if config file is present", () async {
      const expectedConfig =
          UserConfig(currentUserIndex: null, userEntries: []);
      final updateUserConfig = makeUpdateStoredUserConfig(
          getConstantConfig(expectedConfig), noopTextWrite);
      final completer = Completer();

      await updateUserConfig((config) {
        expect(config, equals(expectedConfig));
        completer.complete();
        return const UserConfig(currentUserIndex: 0, userEntries: []);
      });

      expect(completer.isCompleted, isTrue);
    });

    test("should save updated config", () async {
      final completer = Completer();
      final updateUserConfig =
          makeUpdateStoredUserConfig(getNullConfig, (_, content) async {
        expect(content, equals('{"currentUserIndex":null,"userEntries":[]}'));
        completer.complete();
      });

      await updateUserConfig((config) =>
          const UserConfig(currentUserIndex: null, userEntries: []));

      expect(completer.isCompleted, isTrue);
    });
  });
}
