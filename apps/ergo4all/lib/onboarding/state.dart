/// Access class for getting and setting whether onboarding was completed.
abstract class OnboardingState {
  /// Checks whether onboarding was completed.
  Future<bool> isCompleted();

  /// Sets the onboarding to be completed. There is currently no API
  /// for 'un-completing' the onboarding.
  Future<void> setCompleted();
}

/// Implementation of [OnboardingState] which has a constant value for
/// [isCompleted]. Useful for testing.
class ConstantOnboardingState implements OnboardingState {
  ///
  const ConstantOnboardingState({required this.value});

  /// The constant value for this state.
  final bool value;

  @override
  Future<bool> isCompleted() async {
    return value;
  }

  @override
  Future<void> setCompleted() async {}
}
