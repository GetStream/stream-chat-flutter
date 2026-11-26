import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/stream_thread_list_controller.dart';
import 'package:stream_chat_flutter_core/src/stream_thread_list_event_handler.dart';

// Mock classes
class MockStreamThreadListController extends Mock implements StreamThreadListController {}

class MockMessage extends Mock implements Message {}

class MockUser extends Mock implements User {}

class MockThread extends Mock implements Thread {}

void main() {
  group('StreamThreadListEventHandler', () {
    late final handler = StreamThreadListEventHandler();
    late final mockController = MockStreamThreadListController();
    late final mockMessage = MockMessage();

    setUpAll(() {
      registerFallbackValue(MockMessage());
      registerFallbackValue(MockUser());
      registerFallbackValue(MockThread());
    });

    // Reset all the mock objects after each test.
    tearDown(() {
      reset(mockController);
      reset(mockMessage);
    });

    test('onThreadUpdated does nothing by default', () {
      handler.onThreadUpdated(ThreadUpdatedEvent(), mockController);
      verifyNoMoreInteractions(mockController);
    });

    test('onConnectionRecovered calls refresh on controller', () {
      when(() => mockController.refresh()).thenAnswer((_) async {});
      handler.onConnectionRecovered(ConnectionRecoveredEvent(), mockController);
      verify(() => mockController.refresh());
    });

    test('onReactionNew calls updateParent first for every message', () {
      final event = ReactionNewEvent(channel: _channel(), message: mockMessage);
      when(() => mockController.updateParent(mockMessage)).thenReturn(true);

      handler.onReactionNew(event, mockController);
      verify(() => mockController.updateParent(mockMessage));
      verifyNever(() => mockController.upsertReply(mockMessage));
    });

    test('onReactionNew calls upsertReply if updateParent fails', () {
      final event = ReactionNewEvent(channel: _channel(), message: mockMessage);
      when(() => mockController.updateParent(mockMessage)).thenReturn(false);
      when(() => mockController.upsertReply(mockMessage)).thenReturn(true);

      handler.onReactionNew(event, mockController);
      verify(() => mockController.updateParent(mockMessage));
      verify(() => mockController.upsertReply(mockMessage));
    });

    test('onReactionNew does nothing if message is null', () {
      handler.onReactionNew(ReactionNewEvent(channel: _channel()), mockController);
      verifyNever(() => mockController.updateParent(any()));
      verifyNever(() => mockController.upsertReply(any()));
    });

    test(
      'onNotificationThreadMessageNew updates unseenThreadIds if thread null',
      () {
        final event = NotificationThreadMessageNewEvent(
          channel: _channel(),
          message: mockMessage,
          watcherCount: 1,
        );
        when(() => mockMessage.parentId).thenReturn('parent-id');
        when(() => mockController.getThread(parentMessageId: any(named: 'parentMessageId'))).thenReturn(null);

        handler.onNotificationThreadMessageNew(event, mockController);
        verify(() => mockController.addUnseenThreadId('parent-id'));
      },
    );

    test('onMessageNew updates parent or reply message', () {
      final event = MessageNewEvent(message: mockMessage, watcherCount: 1);
      when(() => mockController.updateParent(any())).thenReturn(false);
      when(() => mockController.upsertReply(any())).thenReturn(true);

      handler.onMessageNew(event, mockController);
      verify(() => mockController.updateParent(mockMessage));
      verify(() => mockController.upsertReply(mockMessage));
    });

    test(
      'onMessageDeleted deletes thread if message is parent and hard deleted',
      () {
        when(() => mockMessage.id).thenReturn('message-id');
        when(() => mockMessage.parentId).thenReturn(null);
        final event = MessageDeletedEvent(message: mockMessage, hardDelete: true);
        when(() => mockController.deleteThread(parentMessageId: 'message-id')).thenReturn(true);

        handler.onMessageDeleted(event, mockController);
        verify(() => mockController.deleteThread(parentMessageId: 'message-id'));
        verifyNever(() => mockController.deleteReply(any()));
      },
    );

    test(
      'onMessageDeleted deletes reply if message is reply and hard deleted',
      () {
        when(() => mockMessage.id).thenReturn('message-id');
        when(() => mockMessage.parentId).thenReturn('parent-id');
        final event = MessageDeletedEvent(message: mockMessage, hardDelete: true);
        when(() => mockController.deleteReply(any())).thenReturn(true);

        handler.onMessageDeleted(event, mockController);
        verify(() => mockController.deleteReply(any()));
        verifyNever(
          () => mockController.deleteThread(parentMessageId: 'message-id'),
        );
      },
    );

    test(
      'onMessageDeleted updates thread if message is parent and soft deleted',
      () {
        when(() => mockMessage.id).thenReturn('message-id');
        when(() => mockMessage.parentId).thenReturn(null);
        final event = MessageDeletedEvent(message: mockMessage, hardDelete: false);
        when(() => mockController.updateParent(mockMessage)).thenReturn(true);

        handler.onMessageDeleted(event, mockController);
        verify(() => mockController.updateParent(mockMessage));
        verifyNever(() => mockController.upsertReply(mockMessage));
        verifyNever(() => mockController.deleteReply(any()));
        verifyNever(
          () => mockController.deleteThread(parentMessageId: 'message-id'),
        );
      },
    );

    test(
      'onMessageDeleted updates reply if message is reply and soft deleted',
      () {
        when(() => mockMessage.id).thenReturn('message-id');
        when(() => mockMessage.parentId).thenReturn('parent-id');
        final event = MessageDeletedEvent(message: mockMessage, hardDelete: false);
        when(() => mockController.updateParent(mockMessage)).thenReturn(false);
        when(() => mockController.upsertReply(mockMessage)).thenReturn(true);

        handler.onMessageDeleted(event, mockController);
        verify(() => mockController.updateParent(mockMessage));
        verify(() => mockController.upsertReply(mockMessage));
        verifyNever(() => mockController.deleteReply(any()));
        verifyNever(
          () => mockController.deleteThread(parentMessageId: 'message-id'),
        );
      },
    );

    test('onChannelDeleted deletes threads by channel cid', () {
      final event = ChannelDeletedEvent(cid: 'messaging:general', channel: _channel());

      handler.onChannelDeleted(event, mockController);
      verify(() => mockController.deleteThreadByChannelCid(channelCid: 'messaging:general'));
    });

    test('onChannelTruncated deletes threads by channel cid', () {
      final event = ChannelTruncatedEvent(cid: 'messaging:general', channel: _channel());

      handler.onChannelTruncated(event, mockController);
      verify(() => mockController.deleteThreadByChannelCid(channelCid: 'messaging:general'));
    });

    test('onMessageRead marks thread as read', () {
      final reader = User(id: 'reader');
      final readAt = DateTime.utc(2026, 1, 2);
      final thread = _thread(
        read: [Read(user: reader, lastRead: DateTime.utc(2026), unreadMessages: 3)],
      );
      final event = MessageReadEvent(thread: _thread(), user: reader, createdAt: readAt);
      when(() => mockController.getThread(parentMessageId: 'parent-id')).thenReturn(thread);
      when(() => mockController.updateThread(any())).thenReturn(true);

      handler.onMessageRead(event, mockController);

      verify(
        () => mockController.updateThread(
          thread.copyWith(
            read: [Read(user: reader, lastRead: readAt, unreadMessages: 0)],
          ),
        ),
      );
    });

    test('onNotificationMarkUnread marks thread as unread', () {
      final reader = User(id: 'reader');
      final markedAt = DateTime.utc(2026, 1, 2);
      final thread = _thread(
        read: [Read(user: reader, lastRead: DateTime.utc(2026), unreadMessages: 3)],
      );
      final event = NotificationMarkUnreadEvent(threadId: 'parent-id', user: reader, createdAt: markedAt);
      when(() => mockController.getThread(parentMessageId: 'parent-id')).thenReturn(thread);
      when(() => mockController.updateThread(any())).thenReturn(true);

      handler.onNotificationMarkUnread(event, mockController);

      verify(
        () => mockController.updateThread(
          thread.copyWith(
            read: [Read(user: reader, lastRead: markedAt, unreadMessages: 4)],
          ),
        ),
      );
    });
  });
}

Thread _thread({List<Read>? read}) => Thread(
  channelCid: 'messaging:general',
  parentMessageId: 'parent-id',
  createdByUserId: 'creator',
  replyCount: 1,
  participantCount: 1,
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
  read: read,
);

ChannelModel _channel() => ChannelModel(cid: 'messaging:general');
