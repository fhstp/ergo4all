import 'package:ergo4all/app.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pose_detection/mlkit.dart';
import 'package:prefs_storage/shared_preferences.dart';
import 'package:text_storage/local_document.dart';
import 'package:video_storage/gallery.dart';

void main() {
  runApp(Ergo4AllApp(
    textStorage: LocalDocumentStorage(),
    videoStorage: GalleryVideoStorage(),
    preferenceStorage: SharedPreferencesStorage(),
    getProjectVersion: () =>
        PackageInfo.fromPlatform().then((info) => info.version),
    poseDetector: MLkitPoseDetectorAdapter(),
  ));
}
