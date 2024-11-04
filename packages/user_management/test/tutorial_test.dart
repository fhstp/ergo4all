import 'package:glados/glados.dart';
import 'package:user_management/src/tutorial.dart';

import 'user_data.dart';

main() {
  group("skip tutorial", () {
    Glados(any.user).test("should mark tutorial as being seen", (user) {
      final updated = skipTutorial(user);
      expect(updated.hasSeenTutorial, isTrue);
    });
  });
}
