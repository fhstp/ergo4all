import 'package:ergo4all/common/user.dart';
import 'package:glados/glados.dart';

extension AnyUser on Any {
  /// Generates a user with a random name
  Generator<User> get user => combine2(
      letters,
      any.bool,
      (name, hasSeenTutorial) =>
          User(name: name, hasSeenTutorial: hasSeenTutorial));
}
