import 'package:ergo4all/users/common.dart';

/// Persistent store for [User]s.
abstract class UserStore {
  /// Creates a new user with the given data in the store and returns it.
  Future<User> createUser({required String name});

  /// Deletes the user with the given id. Returns a boolean indicating
  /// whether the user was found and deleted.
  ///
  /// This will also deselect the current user if it is the deleted one.
  Future<bool> deleteUserById(String id);

  /// Gets a user by their id. Returns `null` if no such user is found.
  Future<User?> tryGetUserById(String id);

  /// Gets the id of the current user. Returns `null` if there is no current
  /// user.
  Future<String?> getCurrentUserId();

  /// Set the current user.
  Future<void> setCurrentUserId(String id);
}

/// Utility extensions for interacting with the current user in a [UserStore].
extension CurrentUserUtil on UserStore {
  /// Gets the current user. Returns `null` if no user is selected.
  /// This is a shorthand for calling [getCurrentUserId] and then using
  /// that id with [tryGetUserById].
  Future<User?> tryGetCurrentUser() async {
    final id = await getCurrentUserId();
    if (id == null) return null;

    final user = await tryGetUserById(id);
    if (user == null) {
      throw AssertionError(
        'The current user specified in the meta file was not found',
      );
    }

    return user;
  }
}
