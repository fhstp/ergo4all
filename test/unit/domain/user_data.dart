import 'package:ergo4all/domain/user.dart';
import 'package:glados/glados.dart';

extension AnyUser on Any {
  /// Generates a user with a random name
  Generator<User> get user => letters.map((name) => User(name: name));
}
