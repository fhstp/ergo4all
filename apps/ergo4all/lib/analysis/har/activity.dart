import 'package:ergo4all/scenario/common.dart';

/// An generic movement activity.
enum Activity {
  background(0),
  carrying(1),
  kneeling(2),
  lifting(3),
  overhead(4),
  sitting(5),
  standing(6),
  walking(7);

  const Activity(this.value);
  final int value;

  static final Map<int, Activity> _valueToActivity = {
    for (Activity activity in Activity.values) activity.value: activity,
  };

  static Activity? fromValue(int value) => _valueToActivity[value];

  static Scenario? getScenario(Activity activity) {
    switch (activity) {
      case Activity.lifting:
      case Activity.carrying:
      case Activity.kneeling:
        return Scenario.liftAndCarry;
      case Activity.overhead:
        return Scenario.ceiling;
      case Activity.sitting:
        return Scenario.seated;
      case Activity.standing:
        return Scenario.standingCNC; // or standingAssembly or packaging
      case Activity.walking:
      case Activity.background:
        return null;
    }
  }
}
