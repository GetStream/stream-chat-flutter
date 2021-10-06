import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/dao/dao.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';

import '../../stream_chat_persistence_client_test.dart';

void main() {
  late UserDao userDao;
  late MoorChatDatabase database;

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
      ),
    );
    await userDao.updateUsers(users);
    return users;
  }

  test('updateUsers', () async {
    // Preparing test data
    final insertedUsers = await _prepareUserData();

    // Modifying one of the user and also adding one new
    final copyUser = insertedUsers.first.copyWith(online: false);
    final newUser = User(
      id: 'testUserId3',
      role: 'testRole',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      lastActive: DateTime.now(),
      online: math.Random().nextBool(),
      banned: math.Random().nextBool(),
    );
    await userDao.updateUsers([copyUser, newUser]);

    // Fetched users length should be one more than inserted users.
    // copyUser `online` modified field should be `false`.
    // Fetched users should contain the newUser.
    final fetchedUsers = await userDao.getUsers();
    expect(fetchedUsers.length, insertedUsers.length + 1);
    expect(fetchedUsers.firstWhere((it) => it.id == copyUser.id).online, false);
    expect(fetchedUsers.contains(newUser), true);
  });

  test('getUsers', () async {
    // Should be empty initially
    final users = await userDao.getUsers();
    expect(users, isEmpty);

    // Preparing test data
    final insertedUsers = await _prepareUserData();
    expect(insertedUsers, isNotEmpty);

    // Fetched user list should match inserted user list length
    final fetchedUsers = await userDao.getUsers();
    expect(fetchedUsers.length, insertedUsers.length);
  });

  tearDown(() async {
    await database.disconnect();
  });
}
