import 'package:image_picker/image_picker.dart';

/// Contains IO functions for interacting with video storage.
abstract class VideoStorage {
  /// Allows the user to pick a file from video storage using an external
  /// dialog.
  Future<XFile?> tryPick();
}

/// Implementation of [VideoStorage] that uses the users gallery as backing
/// storage.
class GalleryVideoStorage extends VideoStorage {
  final ImagePicker imagePicker;

  GalleryVideoStorage(this.imagePicker);

  @override
  Future<XFile?> tryPick() {
    return imagePicker.pickVideo(source: ImageSource.gallery);
  }
}
