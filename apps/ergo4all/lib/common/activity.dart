/// An generic movement activity.
enum Activity {
  /// No specific activity detected
  background,

  /// The person is carrying an object while standing or walking
  carrying,

  /// The person is kneeling on the ground
  kneeling,

  /// The person is in the process of lifting an object up from the ground
  lifting,

  /// The person is lifting their arms over their head
  overhead,

  /// The person is sitting in a chair or similar
  sitting,

  /// The person is stationary and standing upright
  standing,

  /// The person is walking
  walking;
}
