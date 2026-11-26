import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/mapper/event_mapper.dart';

void main() {
  test('toOwnUser should map entity into OwnUser', () {
    const type = 'dummy.type';
    final now = DateTime.now();
    final ownUser = OwnUser(id: 'testUserId', totalUnreadCount: 33, unreadChannels: 33);
    final entity = ConnectionEventEntity(
      id: 3,
      type: type,
      ownUser: ownUser.toJson(),
      totalUnreadCount: 33,
      unreadChannels: 33,
      lastSyncAt: now,
      lastEventAt: now,
    );
    final user = entity.toOwnUser();
    expect(user, isA<OwnUser>());
    expect(user!.id, ownUser.id);
    expect(user.totalUnreadCount, ownUser.totalUnreadCount);
    expect(user.unreadChannels, ownUser.unreadChannels);
  });

  test('toOwnUser should return null when the entity stores no user', () {
    const entity = ConnectionEventEntity(id: 3, type: 'dummy.type');

    expect(entity.toOwnUser(), isNull);
  });
}
