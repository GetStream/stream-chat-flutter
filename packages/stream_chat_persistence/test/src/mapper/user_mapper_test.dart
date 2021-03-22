import 'dart:math' as math;
import 'package:test/test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';
import 'package:stream_chat_persistence/src/mapper/user_mapper.dart';

import '../utils/date_matcher.dart';

void main() {
  test('toUser should map entity into User', () {
    final entity = UserEntity(
      id: 'testUserId',
      role: 'testType',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      lastActive: DateTime.now(),
      online: math.Random().nextBool(),
      banned: math.Random().nextBool(),
      extraData: {'test_extra_data': 'extraData'},
    );
    final user = entity.toUser();
    expect(user, isA<User>());
    expect(user.id, entity.id);
    expect(user.role, entity.role);
    expect(user.createdAt, isSameDateAs(entity.createdAt));
    expect(user.updatedAt, isSameDateAs(entity.updatedAt));
    expect(user.lastActive, isSameDateAs(entity.lastActive));
    expect(user.online, entity.online);
    expect(user.banned, entity.banned);
    expect(user.extraData, entity.extraData);
  });

  test('toEntity should map user into UserEntity', () {
    final user = User(
      id: 'testUserId',
      role: 'testType',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      lastActive: DateTime.now(),
      online: math.Random().nextBool(),
      banned: math.Random().nextBool(),
      extraData: {'test_extra_data': 'extraData'},
    );
    final entity = user.toEntity();
    expect(entity, isA<UserEntity>());
    expect(entity.id, user.id);
    expect(entity.role, user.role);
    expect(entity.createdAt, isSameDateAs(user.createdAt));
    expect(entity.updatedAt, isSameDateAs(user.updatedAt));
    expect(entity.lastActive, isSameDateAs(user.lastActive));
    expect(entity.online, user.online);
    expect(entity.banned, user.banned);
    expect(entity.extraData, user.extraData);
  });
}
