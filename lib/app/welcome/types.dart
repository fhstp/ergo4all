/// IO function for retrieving the projects version. The returned [String]
/// will probably be a semantic version, ie. "1.2.3".
typedef GetProjectVersion = Future<String> Function();
