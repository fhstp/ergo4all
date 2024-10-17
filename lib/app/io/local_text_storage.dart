/// Contains IO functions for interacting with local text files.
abstract class LocalTextStorage {
  /// Function for loading the contents of a local text file.
  ///
  /// [localFilePath] is the files path relative to the application directory.
  /// The function will return the files content or null if the file was not
  /// found.
  Future<String?> read(String localFilePath);

  /// Function for overwriting the contents of a local text file.
  ///
  /// [localFilePath] is the files path relative to the application directory.
  /// The function will overwrite the files content. It will also create the
  /// file if it does not exist yet.
  Future<Null> write(String localFilePath, String content);
}
