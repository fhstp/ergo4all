import 'package:common/list_ext.dart';
import 'package:common/types.dart';
import 'package:user_management/src/types.dart';

class FakeUserStorage implements UserStorage {
  int? _currentUserIndex;
  List<User> _users = List.empty();

  @override
  Future<Null> addUser(User user) async {
    _users.add(user);
    _currentUserIndex = _users.length;
  }

  @override
  Future<User?> getCurrentUser() async {
    return _currentUserIndex != null ? _users[_currentUserIndex!] : null;
  }

  @override
  Future<int?> getCurrentUserIndex() async {
    return _currentUserIndex;
  }

  @override
  Future<Null> updateUser(int userIndex, Update<User> update) async {
    _users = _users.mapAt(userIndex, update);
  }
}
