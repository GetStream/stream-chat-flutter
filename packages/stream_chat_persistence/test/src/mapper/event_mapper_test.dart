import 'package:test/test.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';
import 'package:stream_chat_persistence/src/mapper/event_mapper.dart';

import '../utils/date_matcher.dart';

void main() {
  test('toEvent should map entity into Event', () {
    const type = 'dummy.type';
    final now = DateTime.now();
    final ownUser = OwnUser(id: 'testUserId');
    final entity = ConnectionEventEntity(
      id: 3,
      type: type,
      ownUser: ownUser.toJson(),
      totalUnreadCount: 33,
      unreadChannels: 33,
      lastSyncAt: now,
      lastEventAt: now,
    );
    final event = entity.toEvent();
    expect(event, isA<Event>());
    expect(event.type, type);
    expect(event.createdAt, isSameDateAs(now));
    expect(event.me!.id, ownUser.id);
    expect(event.totalUnreadCount, entity.totalUnreadCount);
    expect(event.unreadChannels, entity.unreadChannels);
  });
}
