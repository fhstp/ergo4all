
import 'package:ergo4all/objectbox.g.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// ObjectBox database class initialization
class ObjectBox {

  ObjectBox._create(this.store) {}
  /// The Store of this app.
  late final Store store;

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final store = await openStore(directory: p.join(docsDir.path, 'rulaSessions-db'));
    return ObjectBox._create(store);
  }
}
