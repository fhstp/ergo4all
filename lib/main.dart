import 'package:ergo4all/app.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pose_detection/mlkit.dart';
import 'package:prefs_storage/shared_preferences.dart';
import 'package:user_management/user_management.dart';
import 'package:video_storage/gallery.dart';

void main() {
  runApp(Ergo4AllApp(
    userStorage: PersistentUserStorage(),
    videoStorage: GalleryVideoStorage(),
    preferenceStorage: SharedPreferencesStorage(),
    getProjectVersion: () =>
        PackageInfo.fromPlatform().then((info) => info.version),
    poseDetector: MLkitPoseDetectorAdapter(),
  ));
}
