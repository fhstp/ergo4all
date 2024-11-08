import 'package:ergo4all/app.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pose/mlkit.dart';
import 'package:prefs_storage/shared_preferences.dart';
import 'package:user_management/user_management.dart';

void main() {
  runApp(Ergo4AllApp(
    userStorage: PersistentUserStorage(),
    preferenceStorage: SharedPreferencesStorage(),
    getProjectVersion: () =>
        PackageInfo.fromPlatform().then((info) => info.version),
    poseDetector: MLkitPoseDetectorAdapter(),
  ));
}
