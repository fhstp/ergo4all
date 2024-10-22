enum Routes {
  home("/home"),
  liveAnalysis('/analysis/live'),
  recordedAnalysis('/analysis/recorded'),
  results('/analysis/results'),
  preIntro('/intro/pre'),
  expertIntro('/intro/expert'),
  nonExpertIntro('/intro/non-expert'),
  preUserCreator('/users/new/pre'),
  userCreator('/users/new'),
  language('/language'),
  tou('/tou'),
  welcome('/welcome');

  final String path;

  const Routes(this.path);
}
