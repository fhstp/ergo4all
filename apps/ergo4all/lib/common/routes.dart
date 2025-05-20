enum Routes {
  home('/home'),
  scenarioChoice('/scenario/choice'),
  scenarioDetail('/scenario/detail'),
  liveAnalysis('/analysis/live'),
  tipChoice('/tip/choice'),
  tipDetail('/tip/detail'),

  /// The results overview screen.
  resultsOverview('/analysis/results'),

  /// The results detail screen.
  resultsDetail('/analysis/results/detail'),
  preIntro('/intro/pre'),
  expertIntro('/intro/expert'),
  nonExpertIntro('/intro/non-expert'),
  preUserCreator('/users/new/pre'),
  userCreator('/users/new'),
  language('/language'),
  tou('/tou'),
  welcome('/welcome'),

  /// Screen for viewing imprint information.
  imprint('/imprint');

  const Routes(this.path);

  /// The path of this route. Use this as the name when navigating to this
  /// route.
  final String path;
}
