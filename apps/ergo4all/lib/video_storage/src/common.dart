import 'package:cross_file/cross_file.dart';

/// Represents a persistent store in which recorded video files can be stored.
// ignore: one_member_abstracts
abstract class VideoStore {
  /// Stores the video in the given [file] in this store. This is useful if the
  /// video already exists in the file-system, but is, for example, a
  /// temp file.
  /// Returns the name of the stored video, by which it can be retrieved again.
  Future<String> putFromFile(XFile file);
}
