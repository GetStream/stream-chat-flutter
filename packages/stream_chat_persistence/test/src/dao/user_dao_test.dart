import 'dart:math' as math;

import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/dao/dao.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/mapper/user_mapper.dart';

import '../../stream_chat_persistence_client_test.dart';

void main() {
  late UserDao userDao;
  late DriftChatDatabase database;

  setUp(() {
    database = testDatabaseProvider('testUserId');
    userDao = database.userDao;
  });

  Future<List<User>> _prepareUserData({int count = 3}) async {
    final users = List.generate(
      count,
      (index) => User(
        id: 'testUserId$index',
        role: 'testRole',
        language: 'hi',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        lastActive: DateTime.now(),
        online: math.Random().nextBool(),
        banned: math.Random().nextBool(),
        teamsRole: const {'teamId': 'role', 'teamId2': 'role2'},
      ),
    );
    await userDao.updateUsers(users);
    return users;
  }

  Future<List<User>> _readPersistedUsers() => (database.select(database.users)
        ..orderBy([(u) => OrderingTerm(expression: u.createdAt)]))
      .map((it) => it.toUser())
      .get();

  test('updateUsers persists new users', () async {
    expect(await _readPersistedUsers(), isEmpty);

    final insertedUsers = await _prepareUserData();

    final fetchedUsers = await _readPersistedUsers();
    expect(fetchedUsers.length, insertedUsers.length);
    for (final user in insertedUsers) {
      expect(fetchedUsers.any((it) => it.id == user.id), isTrue);
    }
  });

  test('updateUsers upserts existing users and inserts new ones', () async {
    // Preparing test data
    final insertedUsers = await _prepareUserData();

    // Modifying one of the users and also adding one new
    final copyUser =
        insertedUsers.first.copyWith(online: !insertedUsers.first.online);
    final newUser = User(
      id: 'testUserId3',
      role: 'testRole',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      online: math.Random().nextBool(),
      banned: math.Random().nextBool(),
      teamsRole: const {'teamId': 'role', 'teamId2': 'role2'},
    );
    await userDao.updateUsers([copyUser, newUser]);

    // Fetched users length should be one more than inserted users.
    // copyUser `online` should match the toggled value.
    // Fetched users should contain the newUser.
    final fetchedUsers = await _readPersistedUsers();
    expect(fetchedUsers.length, insertedUsers.length + 1);
    expect(
      fetchedUsers.firstWhere((it) => it.id == copyUser.id).online,
      copyUser.online,
    );
    expect(fetchedUsers.any((it) => it.id == newUser.id), isTrue);
  });

  tearDown(() async {
    await database.disconnect();
  });
}
