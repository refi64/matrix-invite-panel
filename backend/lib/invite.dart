import 'dart:async';
import 'dart:math';

import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:random_string/random_string.dart';
import 'package:synchronized/synchronized.dart';

import 'config.dart';

part 'invite.g.dart';

/// An open invite a user can use to register with the home server.
@HiveType(typeId: 0)
class Invite extends HiveObject {
  @HiveField(0)
  String description;

  @HiveField(1)
  bool isAdmin;

  @HiveField(2)
  DateTime expiration;

  Invite();

  Invite._({this.description, this.isAdmin, this.expiration});

  factory Invite.create(
          {String description, bool isAdmin, Duration expiresAfter}) =>
      Invite._(
          description: description,
          isAdmin: isAdmin,
          expiration: DateTime.now().toUtc().add(expiresAfter));

  bool get isExpired => DateTime.now().isAfter(expiration);

  static void registerAdapter() => Hive.registerAdapter(InviteAdapter());
}

/// A Hive-backed invite database. An expired invite should never be returned.
/// Invites are GC'd every hour, but they are also checked and removed
/// instantly if expired on various queries.
@Singleton(dependsOn: [Config])
class InviteStore {
  static const _gcInterval = Duration(hours: 1);
  static const _boxName = 'invites';
  static const _keyLength = 32;

  static final _insertLock = Lock();

  final Box<Invite> _box;
  InviteStore._(this._box) {
    Timer.periodic(_gcInterval, (_) => _gcExpiredInvites());
  }

  void _gcExpiredInvites() {
    final expired = <String>{};

    for (var key in _box.keys.cast<String>()) {
      var invite = _box.get(key);
      if (invite == null) {
        // ??? Not sure how this would happen
        continue;
      }

      if (invite.isExpired) {
        expired.add(key);
      }
    }

    _box.deleteAll(expired);
  }

  Future<String> generate(Invite invite) async =>
      // This needs to be synchronized to ensure the IDs are fully unique.
      await _insertLock.synchronized(() async {
        String id;

        do {
          id = randomString(_keyLength,
              provider: CoreRandomProvider.from(Random.secure()));
        } while (_box.containsKey(id));

        await _box.put(id, invite);
        return id;
      });

  Invite find(String id) {
    var invite = _box.get(id);
    if (invite != null && invite.isExpired) {
      revoke(id);
      return null;
    }

    return invite;
  }

  void revoke(String id) => _box.delete(id);

  Iterable<MapEntry<String, Invite>> get invites =>
      _box.keys.cast<String>().map((key) {
        // Use find here so that expired invites are revoked.
        var invite = find(key);
        return invite != null ? MapEntry(key, invite) : null;
      }).where((entry) => entry != null);

  @factoryMethod
  static Future<InviteStore> create(Config config) async {
    Hive.init(config.databasePath);
    Invite.registerAdapter();

    var box = await Hive.openBox<Invite>(_boxName);
    return InviteStore._(box);
  }
}
