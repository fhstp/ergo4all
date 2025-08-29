import 'package:ergo4all/profile/common.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

/// A persistent storage for [Profile]s.
abstract class ProfileRepo {
  /// The default profile which will always exist and cannot be deleted.
  /// It has the reserved id **1**.
  static const Profile defaultProfile = Profile(id: 1, nickname: 'Ergo-fan');

  /// Gets all [Profile]s from this repo.
  Future<List<Profile>> getAll();

  /// Get a specific [Profile] by their id.
  Future<Profile?> getById(int id);

  /// Creates a new [Profile] with the given data.
  Future<void> createNew(String nickname);

  /// Deletes the [Profile] with the given [id]
  Future<void> deleteById(int id);
}

/// Utility extensions for [ProfileRepo].
extension Utils on ProfileRepo {
  /// Gets all profiles from this store and organizes them in a map, keyed
  /// by their id.
  Future<IMap<int, Profile>> getAllAsMap() async {
    final profiles = await getAll();
    return IMap.fromValues(
      values: profiles,
      keyMapper: (it) => it.id,
    );
  }
}
