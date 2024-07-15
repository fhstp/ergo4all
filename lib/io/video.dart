import 'package:image_picker/image_picker.dart';

Future<XFile?> tryGetVideoFromGallery() {
  return ImagePicker().pickVideo(source: ImageSource.gallery);
}
