import 'package:cross_file/cross_file.dart';

/// Contains IO functions for interacting with video storage.
abstract class VideoStorage {
  /// Allows the user to pick a file from video storage using an external dialog.
  Future<XFile?> tryPick();
}
