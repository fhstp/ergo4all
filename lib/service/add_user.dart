import 'package:ergo4all/domain/user.dart';
import 'package:ergo4all/domain/user_config.dart';
import 'package:ergo4all/io/user_config.dart';

/// Function for adding new users.
///
/// Adds a new user with the data specified in [user] to the app.
/// Also marks this user as the current user.
typedef AddUser = Future<Null> Function(User user);

/// Makes an [AddUser] function which adds the new user to the user config.
AddUser makeAddUserToUserConfig(UpdateUserConfig updateUserConfig) {
  return (user) async {
    await updateUserConfig((initial) {
      if (initial == null) {
        return makeNewConfigForUser(user);
      }

      return appendUserToConfig(initial, user);
    });
  };
}
