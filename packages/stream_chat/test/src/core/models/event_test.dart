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
      expect(event.draft, null);

      // Test parsing with draft
      final draftJson = {
        ...jsonFixture('event.json'),
        'draft': {
          'created_at': '2020-01-29T03:22:47.636130Z',
          'channel_cid': 'messaging:123',
          'message': {
            'id': 'draft-123',
            'text': 'Draft text',
            'poll_id': 'poll-123',
          },
        },
      };

      final eventWithDraft = Event.fromJson(draftJson);
      expect(eventWithDraft.draft, isNotNull);
      expect(eventWithDraft.draft?.message.id, equals('draft-123'));
      expect(eventWithDraft.draft?.message.text, equals('Draft text'));
      expect(eventWithDraft.draft?.message.pollId, equals('poll-123'));
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
        draft: Draft(
          createdAt: DateTime.parse('2020-01-29T03:22:47.636130Z'),
          channelCid: 'messaging:123',
          message: DraftMessage(
            id: 'draft-id',
            text: 'Draft message',
          ),
        ),
      );

      final json = event.toJson();
      expect(
        json,
        {
          'type': 'type',
          'cid': 'cid',
          'connection_id': 'connectionId',
          'created_at': '2020-01-29T03:22:47.636130Z',
          'me': {'id': 'id2'},
          'user': {'id': 'id'},
          'total_unread_count': 1,
          'unread_channels': 1,
          'online': true,
          'is_local': true,
          'ai_state': 'AI_STATE_THINKING',
          'ai_message': 'Some message',
          'message_id': 'messageId',
          'unread_thread_messages': 2,
          'unread_threads': 3,
          'channel_last_message_at': '2019-03-27T17:40:17.155892Z',
          'last_read_at': '2020-02-10T10:00:00.000Z',
          'unread_messages': 5,
          'last_read_message_id': 'last-read-message-id',
          'draft': {
            'created_at': '2020-01-29T03:22:47.636130Z',
            'channel_cid': 'messaging:123',
            'message': {
              'id': 'draft-id',
              'text': 'Draft message',
              'type': 'regular',
              'attachments': [],
              'mentioned_users': [],
              'silent': false,
            },
          }
        },
      );

      // Test round-trip serialization/deserialization with draft
      final roundTripEvent = Event.fromJson(json);
      expect(roundTripEvent.draft, isNotNull);
      expect(roundTripEvent.draft?.message.id, equals('draft-id'));
      expect(roundTripEvent.draft?.message.text, equals('Draft message'));
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
      expect(newEvent.draft, null);

      final draft = Draft(
        createdAt: DateTime.parse('2020-01-29T03:22:47.636130Z'),
        channelCid: 'messaging:123',
        message: DraftMessage(
          id: 'draft-id',
          text: 'Draft text',
        ),
      );

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
        draft: draft,
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
      expect(newEvent.draft, isNotNull);
      expect(newEvent.draft, equals(draft));
      expect(newEvent.draft?.message.id, equals('draft-id'));
      expect(newEvent.draft?.message.text, equals('Draft text'));

      // Test updating draft with copyWith
      final updatedDraft = Draft(
        createdAt: DateTime.parse('2020-01-29T03:22:47.636130Z'),
        channelCid: 'messaging:123',
        message: DraftMessage(
          id: 'updated-draft-id',
          text: 'Updated draft text',
        ),
      );

      final eventWithUpdatedDraft = newEvent.copyWith(
        draft: updatedDraft,
      );

      expect(eventWithUpdatedDraft.draft, isNotNull);
      expect(eventWithUpdatedDraft.draft, equals(updatedDraft));

      expect(
        eventWithUpdatedDraft.draft?.message.id,
        equals('updated-draft-id'),
      );

      expect(
        eventWithUpdatedDraft.draft?.message.text,
        equals('Updated draft text'),
      );
    });
  });
}
