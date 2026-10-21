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

    group('aiState', () {
      AITypingState? parse(Object? aiState) => Event.fromJson({
        'type': EventType.aiIndicatorUpdate,
        'ai_state': ?aiState,
      }).aiState;

      test('should parse both spellings of the checking sources state', () {
        expect(parse('AI_STATE_CHECKING_SOURCES'), AITypingState.checkingSources);
        expect(parse('AI_STATE_EXTERNAL_SOURCES'), AITypingState.checkingSources);
      });

      test('should fall back to idle for an unknown state', () {
        expect(parse('AI_STATE_SOMETHING_NEW'), AITypingState.idle);
      });

      test('should be null when the state is missing', () {
        expect(parse(null), isNull);
      });
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
