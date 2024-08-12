import 'package:ergo4all/domain/user.dart';
import 'package:ergo4all/io/user_config.dart';

/// Function for adding new users.
///
/// Adds a new user with the data specified in [user] to the app.
/// Also marks this user as the current user.
typedef AddUser = Future<Null> Function(User user);

UserConfig _makeNewConfigForUser(User user) {
  return UserConfig(
      currentUserIndex: 0, userEntries: [UserConfigEntry(name: user.name)]);
}

UserConfig _appendUserToConfig(UserConfig config, User user) {
  return UserConfig(
      currentUserIndex: config.userEntries.length,
      userEntries: [...config.userEntries, UserConfigEntry(name: user.name)]);
}

/// Makes an [AddUser] function which adds the new user to the user config.
AddUser makeAddUserToUserConfig(UpdateUserConfig updateUserConfig) {
  return (user) async {
    await updateUserConfig((initial) {
      if (initial == null) {
        return _makeNewConfigForUser(user);
      }

      return _appendUserToConfig(initial, user);
    });
  };
}
