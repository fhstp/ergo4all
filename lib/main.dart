import 'dart:io';

import 'package:ergo4all/app/app.dart';
import 'package:ergo4all/app/io/local_text_storage.dart';
import 'package:ergo4all/app/io/preference_storage.dart';
import 'package:ergo4all/app/io/video_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Implementation of [VideoStorage] that uses the users gallery as backing
/// storage.
class _GalleryVideoStorage extends VideoStorage {
  final ImagePicker imagePicker;

  _GalleryVideoStorage(this.imagePicker);

  @override
  Future<XFile?> tryPick() {
    return imagePicker.pickVideo(source: ImageSource.gallery);
  }
}

/// Implementation of [PreferenceStorage] which uses shared preferences.
class _SharedPreferencesStorage implements PreferenceStorage {
  final SharedPreferencesAsync sharedPrefs;

  _SharedPreferencesStorage(this.sharedPrefs);

  @override
  Future<Null> putString(String key, String value) async {
    await sharedPrefs.setString(key, value);
  }

  @override
  Future<String?> tryGetString(String key) {
    return sharedPrefs.getString(key);
  }
}

/// Implementation of [LocalTextStorage] witch uses the local documents
/// directory for storage.
class _LocalDocumentStorage extends LocalTextStorage {
  @override
  Future<String?> read(String localFilePath) async {
    final documentDir = await getApplicationDocumentsDirectory();
    final file = File(join(documentDir.path, localFilePath));
    final fileExists = await file.exists();

    if (!fileExists) return null;

    return await file.readAsString();
  }

  @override
  Future<Null> write(String localFilePath, String content) async {
    final documentDir = await getApplicationDocumentsDirectory();
    final file = File(join(documentDir.path, localFilePath));

    await file.writeAsString(content);
  }
}

/// Gets the projects version using the [PackageInfo] package.
Future<String> _getProjectVersion() {
  return PackageInfo.fromPlatform().then((info) => info.version);
}

void main() {
  runApp(Ergo4AllApp(
    textStorage: _LocalDocumentStorage(),
    videoStorage: _GalleryVideoStorage(ImagePicker()),
    preferenceStorage: _SharedPreferencesStorage(SharedPreferencesAsync()),
    getProjectVersion: _getProjectVersion,
  ));
}
