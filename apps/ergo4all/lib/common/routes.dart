enum Routes {
  /// The results overview screen.
  resultsOverview('/analysis/results'),

  /// The results detail screen.
  resultsDetail('/analysis/results/detail'),
  language('/language'),
  welcome('/welcome'),

  /// Screen for viewing imprint information.
  imprint('/imprint'),

  /// Screen for viewing privacy information.
  privacy('/privacy'),

  /// Screen for viewing all the stored record sessions
  sessions('/sessions');

  const Routes(this.path);

  /// The path of this route. Use this as the name when navigating to this
  /// route.
  final String path;
}
