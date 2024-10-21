import 'package:ergo4all/app/app.dart';
import 'package:ergo4all/external/gallery.dart';
import 'package:ergo4all/external/local_document.dart';
import 'package:ergo4all/external/mlkit_pose.dart';
import 'package:ergo4all/external/package_info.dart';
import 'package:ergo4all/external/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(Ergo4AllApp(
    textStorage: LocalDocumentStorage(),
    videoStorage: GalleryVideoStorage(ImagePicker()),
    preferenceStorage: SharedPreferencesStorage(SharedPreferencesAsync()),
    getProjectVersion: getProjectVersionFromPackageInfo,
    poseDetector: MLkitPoseDetectorAdapter(),
  ));
}
