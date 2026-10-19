import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/mapper/user_mapper.dart';

import '../utils/date_matcher.dart';

void main() {
  test('toUser should map entity into User', () {
    final entity = UserEntity(
      id: 'testUserId',
      role: 'testType',
      language: 'hi',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      lastActive: DateTime.now(),
      online: math.Random().nextBool(),
      banned: math.Random().nextBool(),
      teamsRole: const {'teamId': 'role', 'teamId2': 'role2'},
      avgResponseTime: 120,
      custom: {'test_extra_data': 'extraData'},
      name: 'Test User',
      image: 'https://example.com/test.png',
      deactivatedAt: DateTime.now(),
      deletedAt: DateTime.now(),
      shadowBanned: math.Random().nextBool(),
      blockedUserIds: const ['blocked-user'],
    );
    final user = entity.toUser();
    expect(user, isA<User>());
    expect(user.id, entity.id);
    expect(user.role, entity.role);
    expect(user.language, entity.language);
    expect(user.createdAt, isSameDateAs(entity.createdAt));
    expect(user.updatedAt, isSameDateAs(entity.updatedAt));
    expect(user.lastActive, isSameDateAs(entity.lastActive));
    expect(user.online, entity.online);
    expect(user.banned, entity.banned);
    expect(user.teamsRole, entity.teamsRole);
    expect(user.avgResponseTime, entity.avgResponseTime);
    expect(user.custom, entity.custom);
    expect(user.name, entity.name);
    expect(user.image, entity.image);
    expect(user.deactivatedAt, isSameDateAs(entity.deactivatedAt));
    expect(user.deletedAt, isSameDateAs(entity.deletedAt));
    expect(user.shadowBanned, entity.shadowBanned);
    expect(user.blockedUserIds, entity.blockedUserIds);
  });

  test('toEntity should map user into UserEntity', () {
    final user = User(
      id: 'testUserId',
      role: 'testType',
      language: 'hi',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      lastActive: DateTime.now(),
      online: math.Random().nextBool(),
      banned: math.Random().nextBool(),
      teamsRole: const {'teamId': 'role', 'teamId2': 'role2'},
      avgResponseTime: 120,
      custom: const {'test_extra_data': 'extraData'},
      name: 'Test User',
      image: 'https://example.com/test.png',
      deactivatedAt: DateTime.now(),
      deletedAt: DateTime.now(),
      shadowBanned: math.Random().nextBool(),
      blockedUserIds: const ['blocked-user'],
    );
    final entity = user.toEntity();
    expect(entity, isA<UserEntity>());
    expect(entity.id, user.id);
    expect(entity.role, user.role);
    expect(entity.language, user.language);
    expect(entity.createdAt, isSameDateAs(user.createdAt));
    expect(entity.updatedAt, isSameDateAs(user.updatedAt));
    expect(entity.lastActive, isSameDateAs(user.lastActive));
    expect(entity.online, user.online);
    expect(entity.banned, user.banned);
    expect(entity.teamsRole, user.teamsRole);
    expect(entity.avgResponseTime, user.avgResponseTime);
    expect(entity.custom, user.custom);
    expect(entity.name, user.name);
    expect(entity.image, user.image);
    expect(entity.deactivatedAt, isSameDateAs(user.deactivatedAt));
    expect(entity.deletedAt, isSameDateAs(user.deletedAt));
    expect(entity.shadowBanned, user.shadowBanned);
    expect(entity.blockedUserIds, user.blockedUserIds);
  });
}
