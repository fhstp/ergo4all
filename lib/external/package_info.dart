import 'package:package_info_plus/package_info_plus.dart';

/// Gets the projects version using the [PackageInfo] package.
Future<String> getProjectVersionFromPackageInfo() {
  return PackageInfo.fromPlatform().then((info) => info.version);
}
