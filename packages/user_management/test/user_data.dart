import 'package:glados/glados.dart';
import 'package:user_management/src/types.dart';

extension AnyUser on Any {
  /// Generates a user with a random name
  Generator<User> get user => combine2(
        letters,
        any.bool,
        (name, hasSeenTutorial) =>
            User(name: name, hasSeenTutorial: hasSeenTutorial),
      );
}
