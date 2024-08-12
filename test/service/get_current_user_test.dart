import 'package:ergo4all/domain/user.dart';
import 'package:ergo4all/io/user_config.dart';
import 'package:ergo4all/service/get_current_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("should be null if there is no config", () async {
    final getCurrentUser = makeGetCurrentUserFromConfig(() async => null);

    final currentUser = await getCurrentUser();

    expect(currentUser, isNull);
  });

  test("should be null if there config has no current user", () async {
    final getCurrentUser = makeGetCurrentUserFromConfig(
        () async => const UserConfig(currentUserIndex: null, userEntries: []));

    final currentUser = await getCurrentUser();

    expect(currentUser, isNull);
  });

  test("should be user if config has current user", () async {
    const userName = "John";
    final getCurrentUser = makeGetCurrentUserFromConfig(() async =>
        const UserConfig(
            currentUserIndex: 0,
            userEntries: [UserConfigEntry(name: userName)]));

    final currentUser = await getCurrentUser();

    expect(currentUser, equals(const User(name: userName)));
  });
}
