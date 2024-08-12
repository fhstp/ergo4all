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
}
