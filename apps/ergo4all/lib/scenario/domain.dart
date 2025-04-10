/// The different work scenarios we can evaluate
enum Scenario {
  /// Lifting and carrying heavy loads up to 25 kg
  liftAndCarry25,

  /// Pushing and pulling material trolleys up to 150 kg
  pull150,

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
  conveyorBelt
}
