import 'package:ergo4all/users/common.dart';

/// Persistent store for [User]s.
abstract class UserStore {
  /// Creates a new user with the given data in the store and returns it.
  Future<User> createUser({required String name});

  /// Deletes the user with the given id. Returns a boolean indicating
  /// whether the user was found and deleted.
  Future<bool> deleteUserById(String id);

  /// Gets a user by their id. Returns `null` if no such user is found.
  Future<User?> tryGetUserById(String id);
}
