import 'package:cross_file/cross_file.dart';
import 'package:ergo4all/app/io/video_storage.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeVideoStorage extends Fake implements VideoStorage {
  XFile? pickedFile;

  FakeVideoStorage setPickedFile(XFile pickedFile) {
    this.pickedFile = pickedFile;
    return this;
  }

  @override
  Future<XFile?> tryPick() async {
    return pickedFile;
  }
}
