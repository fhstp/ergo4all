import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

/// Function for loading the contents of a local text file.
///
/// [localFilePath] is the files path relative to the application directory.
/// The function will return the files content or null if the file was not
/// found.
typedef ReadLocalTextFile = Future<String?> Function(String localFilePath);

/// [ReadLocalTextFile] function which reads the content of a local text
/// document.
ReadLocalTextFile readLocalDocument = (localFilePath) async {
  final documentDir = await getApplicationDocumentsDirectory();
  final file = File(join(documentDir.path, localFilePath));
  final fileExists = await file.exists();

  if (!fileExists) return null;

  return await file.readAsString();
};

/// Function for overwriting the contents of a local text file.
///
/// [localFilePath] is the files path relative to the application directory.
/// The function will overwrite the files content. It will also create the
/// file if it does not exist yet.
typedef WriteLocalTextFile = Future<Null> Function(
    String localFilePath, String content);

/// [WriteLocalTextFile] function which writes the content of a local text
/// document.
WriteLocalTextFile writeLocalDocument = (localFilePath, content) async {
  final documentDir = await getApplicationDocumentsDirectory();
  final file = File(join(documentDir.path, localFilePath));

  await file.writeAsString(content);
};
