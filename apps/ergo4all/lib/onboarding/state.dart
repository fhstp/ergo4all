import 'package:shared_preferences/shared_preferences.dart';

/// Access class for getting and setting whether onboarding was completed.
abstract class OnboardingState {
  /// Checks whether onboarding was completed.
  Future<bool> isCompleted();

  /// Sets the onboarding to be completed. There is currently no API
  /// for 'un-completing' the onboarding.
  Future<void> setCompleted();
}

/// Implementation of [OnboardingState] which stores the completion state
/// in user preferences.
class PrefsOnboardingState implements OnboardingState {
  ///
  PrefsOnboardingState();

  static const _key = 'onboarding-completed';

  final _prefs = SharedPreferencesAsync();

  @override
  Future<bool> isCompleted() {
    return _prefs.getBool(_key).then((it) => it ?? false);
  }

  @override
  Future<void> setCompleted() async {
    await _prefs.setBool(_key, true);
  }
}
