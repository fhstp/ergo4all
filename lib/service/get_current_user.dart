import 'package:ergo4all/domain/user.dart';
import 'package:ergo4all/io/user_config.dart';

/// Function for getting the current user. May return `null` if no user was
/// created yet.
typedef GetCurrentUser = Future<User?> Function();

/// [GetCurrentUser] function which gets the current user from the
/// apps user config.
GetCurrentUser makeGetCurrentUserFromConfig(GetUserConfig getUserConfig) {
  return () async {
    final config = await getUserConfig();
    if (config == null) return null;

    final userIndex = config.currentUserIndex;
    if (userIndex == null) return null;

    final userEntry = config.userEntries[userIndex];
    // TODO: Extract entry -> domain conversion logic
    return User(name: userEntry.name);
  };
}
