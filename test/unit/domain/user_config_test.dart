import 'package:ergo4all/domain/user.dart';
import 'package:ergo4all/domain/user_config.dart';
import 'package:glados/glados.dart';

import 'user_data.dart';
import 'user_config_data.dart';

void main() {
  group("new config", () {
    Glados(any.user).test("should have first user as current user", (user) {
      final config = makeNewConfigForUser(user);

      expect(config.currentUserIndex, equals(0));
    });

    Glados(any.user).test("should have single entry with user information",
        (user) {
      final config = makeNewConfigForUser(user);

      expect(config.userEntries, equals([UserConfigEntry(name: user.name)]));
    });
  });

  group("append user to config", () {
    Glados2(any.userConfig, any.user).test("should increase user count by one",
        (config, user) {
      final updated = appendUserToConfig(config, user);

      expect(updated.userEntries.length, equals(config.userEntries.length + 1));
    });

    Glados2(any.userConfig, any.user).test("should append user to list",
        (config, user) {
      final updated = appendUserToConfig(config, user);

      expect(
          updated.userEntries.last, equals(UserConfigEntry(name: user.name)));
    });

    Glados2(any.userConfig, any.user)
        .test("should have current user be new user", (config, user) {
      final updated = appendUserToConfig(config, user);

      expect(updated.currentUserIndex, equals(updated.userEntries.length - 1));
    });
  });

  group("get user", () {
    test("should be null for config without current user", () {
      const config = UserConfig(currentUserIndex: null, userEntries: []);

      final user = tryGetCurrentUserFromConfig(config);

      expect(user, isNull);
    });

    test("should be user for configs with current user", () {
      final config = makeNewConfigForUser(const User(name: "John"));

      final user = tryGetCurrentUserFromConfig(config);

      expect(user!.name, equals("John"));
    });
  });
}
