enum Routes {
  home('/home'),
  scenarioChoice('/scenario/choice'),
  scenarioDetail('/scenario/detail'),
  liveAnalysis('/analysis/live'),

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

  /// The tips overview screen.
  tips('/tips');

  const Routes(this.path);

  final String path;
}
