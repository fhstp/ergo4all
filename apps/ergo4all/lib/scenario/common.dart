/// The different work scenarios we can evaluate
enum Scenario {
    /// Freestyle mode with no time limit
  freestyle,

  /// Lifting and carrying heavy loads up to 25 kg
  liftAndCarry,

  /// Pushing and pulling material trolleys up to 150 kg
  pull,

  /// Working in a seated position
  seated,

  /// Packaging work with a high repetition rate
  packaging,

  /// Working in a standing position on a CNC machine
  standingCNC,

  /// Assembly standing at a table
  standingAssembly,

  /// Cable installation on the ceiling
  ceiling,

  /// Lifting a bag weighing up to 25 kg
  lift25,

  /// Working on a conveyor belt for long periods
  conveyorBelt,

}
