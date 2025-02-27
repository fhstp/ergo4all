import 'package:image_picker/image_picker.dart';

/// Shows UI for a user to select a local video file from their gallery. Returns file videos [XFile] or `null` if none was selected.
Future<XFile?> showVideoPickDialog() {
  return ImagePicker().pickVideo(source: ImageSource.gallery);
}
