import 'dart:io';
import 'package:ergo4all/app/io/local_text_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

/// Implementation of [LocalTextStorage] witch uses the local documents
/// directory for storage.
class LocalDocumentStorage extends LocalTextStorage {
  @override
  Future<String?> read(String localFilePath) async {
    final documentDir = await getApplicationDocumentsDirectory();
    final file = File(join(documentDir.path, localFilePath));
    final fileExists = await file.exists();

    if (!fileExists) return null;

    return await file.readAsString();
  }

  @override
  Future<Null> write(String localFilePath, String content) async {
    final documentDir = await getApplicationDocumentsDirectory();
    final file = File(join(documentDir.path, localFilePath));

    await file.writeAsString(content);
  }
}
