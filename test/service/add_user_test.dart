import 'dart:async';

import 'package:ergo4all/domain/user.dart';
import 'package:ergo4all/io/user_config.dart';
import 'package:ergo4all/service/add_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const someUser = User(name: "John");

  UpdateUserConfig makeMockUpdateUserConfig(
      UserConfig? initialConfig, void Function(UserConfig) onSave) {
    return (update) async {
      final updated = update(initialConfig);
      onSave(updated);
    };
  }

  test("should create config with user when there is not config yet", () async {
    final completer = Completer();
    final expected = UserConfig(
        currentUserIndex: 0,
        userEntries: [UserConfigEntry(name: someUser.name)]);
    final addUser =
        makeAddUserToUserConfig(makeMockUpdateUserConfig(null, (savedConfig) {
      expect(savedConfig, equals(expected));
      completer.complete();
    }));

    await addUser(someUser);

    expect(completer.isCompleted, isTrue);
  });

  test("should add user to empty config", () async {
    final completer = Completer();
    const initial = UserConfig(currentUserIndex: null, userEntries: []);
    final expected = UserConfig(
        currentUserIndex: 0,
        userEntries: [UserConfigEntry(name: someUser.name)]);
    final addUser = makeAddUserToUserConfig(
        makeMockUpdateUserConfig(initial, (savedConfig) {
      expect(savedConfig, equals(expected));
      completer.complete();
    }));

    await addUser(someUser);

    expect(completer.isCompleted, isTrue);
  });

  test("should addend user to existing config", () async {
    final completer = Completer();
    const initial = UserConfig(
        currentUserIndex: 0, userEntries: [UserConfigEntry(name: "Jane")]);
    final expected = UserConfig(currentUserIndex: 1, userEntries: [
      const UserConfigEntry(name: "Jane"),
      UserConfigEntry(name: someUser.name)
    ]);
    final addUser = makeAddUserToUserConfig(
        makeMockUpdateUserConfig(initial, (savedConfig) {
      expect(savedConfig, equals(expected));
      completer.complete();
    }));

    await addUser(someUser);

    expect(completer.isCompleted, isTrue);
  });
}
