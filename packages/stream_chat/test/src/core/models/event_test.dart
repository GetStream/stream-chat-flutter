import 'package:stream_chat/src/core/models/event.dart';
import 'package:stream_chat/src/core/models/own_user.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('src/models/event', () {
    test('should parse json correctly', () {
      final event = Event.fromJson(jsonFixture('event.json'));
      expect(event.type, 'type');
      expect(event.cid, 'cid');
      expect(event.connectionId, 'connectionId');
      expect(event.createdAt, isA<DateTime>());
      expect(event.me, isA<OwnUser>());
      expect(event.user, isA<User>());
      expect(event.isLocal, false);
    });

    test('should serialize to json correctly', () {
      final event = Event(
        user: User(id: 'id'),
        type: 'type',
        cid: 'cid',
        connectionId: 'connectionId',
        createdAt: DateTime.parse('2020-01-29T03:22:47.63613Z'),
        me: OwnUser(id: 'id2'),
        totalUnreadCount: 1,
        unreadChannels: 1,
        online: true,
      );

      expect(
        event.toJson(),
        {
          'type': 'type',
          'cid': 'cid',
          'connection_id': 'connectionId',
          'created_at': '2020-01-29T03:22:47.636130Z',
          'me': {'id': 'id2'},
          'user': {'id': 'id'},
          'reaction': null,
          'message': null,
          'channel': null,
          'total_unread_count': 1,
          'unread_channels': 1,
          'online': true,
          'member': null,
          'channel_id': null,
          'channel_type': null,
          'parent_id': null,
          'is_local': true,
        },
      );
    });
  });
}
