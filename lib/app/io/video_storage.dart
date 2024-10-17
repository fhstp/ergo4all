import 'package:image_picker/image_picker.dart';

/// Contains IO functions for interacting with video storage.
abstract class VideoStorage {
  /// Allows the user to pick a file from video storage using an external
  /// dialog.
  Future<XFile?> tryPick();
}
