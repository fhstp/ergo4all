import 'package:image_picker/image_picker.dart';

import 'types.dart';

/// Implementation of [VideoStorage] that uses the users gallery as backing storage.
class GalleryVideoStorage extends VideoStorage {
  final ImagePicker imagePicker = ImagePicker();

  @override
  Future<XFile?> tryPick() {
    return imagePicker.pickVideo(source: ImageSource.gallery);
  }
}
