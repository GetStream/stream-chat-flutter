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
      expect(event.aiState, AITypingState.thinking);
      expect(event.aiMessage, 'Some message');
      expect(event.unreadThreadMessages, 2);
      expect(event.unreadThreads, 3);
      expect(event.channelLastMessageAt, isA<DateTime>());
      expect(event.lastReadAt, null);
      expect(event.unreadMessages, null);
      expect(event.lastReadMessageId, null);
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
        aiState: AITypingState.thinking,
        aiMessage: 'Some message',
        messageId: 'messageId',
        unreadThreadMessages: 2,
        unreadThreads: 3,
        channelLastMessageAt: DateTime.parse('2019-03-27T17:40:17.155892Z'),
        lastReadAt: DateTime.parse('2020-02-10T10:00:00.000Z'),
        unreadMessages: 5,
        lastReadMessageId: 'last-read-message-id',
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
          'poll': null,
          'poll_vote': null,
          'channel': null,
          'total_unread_count': 1,
          'unread_channels': 1,
          'online': true,
          'member': null,
          'channel_id': null,
          'channel_type': null,
          'parent_id': null,
          'is_local': true,
          'ai_state': 'AI_STATE_THINKING',
          'ai_message': 'Some message',
          'message_id': 'messageId',
          'thread': null,
          'unread_thread_messages': 2,
          'unread_threads': 3,
          'channel_last_message_at': '2019-03-27T17:40:17.155892Z',
          'last_read_at': '2020-02-10T10:00:00.000Z',
          'unread_messages': 5,
          'last_read_message_id': 'last-read-message-id',
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
      expect(newEvent.unreadThreadMessages, 2);
      expect(newEvent.unreadThreads, 3);
      expect(newEvent.channelLastMessageAt, isA<DateTime>());
      expect(newEvent.lastReadAt, null);
      expect(newEvent.unreadMessages, null);
      expect(newEvent.lastReadMessageId, null);

      newEvent = event.copyWith(
        type: 'test',
        cid: 'test',
        connectionId: 'test',
        extraData: {},
        user: User(id: 'test'),
        channelId: 'test',
        totalUnreadCount: 2,
        channelType: 'testtype',
        unreadThreadMessages: 6,
        unreadThreads: 7,
        channelLastMessageAt: DateTime.parse('2020-01-29T03:22:47.636130Z'),
        lastReadAt: DateTime.parse('2020-02-10T10:00:00.000000Z'),
        unreadMessages: 5,
        lastReadMessageId: 'last-read-message-id',
      );

      expect(newEvent.channelType, 'testtype');
      expect(newEvent.totalUnreadCount, 2);
      expect(newEvent.type, 'test');
      expect(newEvent.channelId, 'test');
      expect(newEvent.cid, 'test');
      expect(newEvent.connectionId, 'test');
      expect(newEvent.extraData, {});
      expect(newEvent.user!.id, 'test');
      expect(newEvent.unreadThreadMessages, 6);
      expect(newEvent.unreadThreads, 7);
      expect(
        newEvent.channelLastMessageAt,
        DateTime.parse('2020-01-29T03:22:47.636130Z'),
      );
      expect(
        newEvent.lastReadAt,
        DateTime.parse('2020-02-10T10:00:00.000000Z'),
      );
      expect(newEvent.unreadMessages, 5);
      expect(newEvent.lastReadMessageId, 'last-read-message-id');
    });
  });
}
