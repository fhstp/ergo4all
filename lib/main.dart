import 'package:ergo4all/app/app.dart';
import 'package:ergo4all/pose.detection/mlkit.dart';
import 'package:ergo4all/storage.prefs/shared_preferences.dart';
import 'package:ergo4all/storage.text/local_document.dart';
import 'package:ergo4all/storage.video/gallery.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(Ergo4AllApp(
    textStorage: LocalDocumentStorage(),
    videoStorage: GalleryVideoStorage(ImagePicker()),
    preferenceStorage: SharedPreferencesStorage(SharedPreferencesAsync()),
    getProjectVersion: () =>
        PackageInfo.fromPlatform().then((info) => info.version),
    poseDetector: MLkitPoseDetectorAdapter(),
  ));
}
