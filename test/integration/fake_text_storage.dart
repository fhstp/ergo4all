import 'package:ergo4all/storage.text/types.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeTextStorage extends Fake implements LocalTextStorage {
  final Map<String, String> _files = {};

  FakeTextStorage put(String path, String content) {
    _files[path] = content;
    return this;
  }

  String? tryGet(String path) {
    return _files[path];
  }

  @override
  Future<String?> read(String localFilePath) async {
    return tryGet(localFilePath);
  }

  @override
  Future<Null> write(String localFilePath, String content) async {
    put(localFilePath, content);
  }
}
