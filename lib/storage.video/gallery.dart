import 'package:ergo4all/storage.video/types.dart';
import 'package:image_picker/image_picker.dart';

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
