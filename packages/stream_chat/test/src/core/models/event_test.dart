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

    test('copyWith', () {
      final event = Event.fromJson(jsonFixture('event.json'));
      var newEvent = event.copyWith();
      expect(newEvent.type, 'type');
      expect(newEvent.cid, 'cid');
      expect(newEvent.connectionId, 'connectionId');
      expect(newEvent.createdAt, isA<DateTime>());
      expect(newEvent.me, isA<OwnUser>());
      expect(newEvent.user, isA<User>());
      expect(newEvent.isLocal, false);

      newEvent = event.copyWith(
        type: 'test',
        cid: 'test',
        connectionId: 'test',
        extraData: {},
        user: User(id: 'test'),
        channelId: 'test',
        totalUnreadCount: 2,
        channelType: 'testtype',
      );

      expect(newEvent.channelType, 'testtype');
      expect(newEvent.totalUnreadCount, 2);
      expect(newEvent.type, 'test');
      expect(newEvent.channelId, 'test');
      expect(newEvent.cid, 'test');
      expect(newEvent.connectionId, 'test');
      expect(newEvent.extraData, {});
      expect(newEvent.user!.id, 'test');
    });

    group('eventChannel', () {
      test('should parse json correctly', () {
        final eventChannel =
            EventChannel.fromJson(jsonFixture('event_channel.json'));
        expect(eventChannel.type, 'messaging');
        expect(eventChannel.cid,
            'messaging:!members-v9ktpgmYysZA-MjgC-GMoeEawFHSelkOdTu6JGxFZWU');
        expect(eventChannel.createdBy!.id, 'super-band-9');
        expect(eventChannel.frozen, false);
        expect(eventChannel.members!.length, 2);
        expect(eventChannel.memberCount, 2);
        expect(eventChannel.config, isA<ChannelConfig>());
        expect(eventChannel.name, 'test');
      });
    });
  });
}
