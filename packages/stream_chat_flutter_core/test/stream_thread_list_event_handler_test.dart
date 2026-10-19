import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter_core/src/stream_thread_list_controller.dart';
import 'package:stream_chat_flutter_core/src/stream_thread_list_event_handler.dart';

// Mock classes
class MockStreamThreadListController extends Mock implements StreamThreadListController {}

class MockEvent extends Mock implements Event {}

class MockMessage extends Mock implements Message {}

class MockUser extends Mock implements User {}

class MockThread extends Mock implements Thread {}

void main() {
  group('StreamThreadListEventHandler', () {
    late final handler = StreamThreadListEventHandler();
    late final mockController = MockStreamThreadListController();
    late final mockEvent = MockEvent();
    late final mockMessage = MockMessage();

    setUpAll(() {
      registerFallbackValue(MockEvent());
      registerFallbackValue(MockMessage());
      registerFallbackValue(MockUser());
      registerFallbackValue(MockThread());
    });

    // Reset all the mock objects after each test.
    tearDown(() {
      reset(mockController);
      reset(mockEvent);
      reset(mockMessage);
    });

    test('onThreadUpdated does nothing by default', () {
      handler.onThreadUpdated(mockEvent, mockController);
      verifyNoMoreInteractions(mockController);
    });

    test('onConnectionRecovered calls refresh on controller', () {
      when(() => mockController.refresh()).thenAnswer((_) async {});
      handler.onConnectionRecovered(mockEvent, mockController);
      verify(() => mockController.refresh());
    });

    test('onReactionNew calls updateParent first for every message', () {
      when(() => mockEvent.message).thenReturn(mockMessage);
      when(() => mockController.updateParent(mockMessage)).thenReturn(true);

      handler.onReactionNew(mockEvent, mockController);
      verify(() => mockController.updateParent(mockMessage));
      verifyNever(() => mockController.upsertReply(mockMessage));
    });

    test('onReactionNew calls upsertReply if updateParent fails', () {
      when(() => mockEvent.message).thenReturn(mockMessage);
      when(() => mockController.updateParent(mockMessage)).thenReturn(false);
      when(() => mockController.upsertReply(mockMessage)).thenReturn(true);

      handler.onReactionNew(mockEvent, mockController);
      verify(() => mockController.updateParent(mockMessage));
      verify(() => mockController.upsertReply(mockMessage));
    });

    test('onReactionNew does nothing if message is null', () {
      when(() => mockEvent.message).thenReturn(null);
      handler.onReactionNew(mockEvent, mockController);
      verifyNever(() => mockController.updateParent(any()));
      verifyNever(() => mockController.upsertReply(any()));
    });

    test(
      'onNotificationThreadMessageNew updates unseenThreadIds if thread null',
      () {
        when(() => mockEvent.message).thenReturn(mockMessage);
        when(() => mockMessage.parentId).thenReturn('parent-id');
        when(() => mockController.getThread(parentMessageId: any(named: 'parentMessageId'))).thenReturn(null);

        handler.onNotificationThreadMessageNew(mockEvent, mockController);
        verify(() => mockController.addUnseenThreadId('parent-id'));
      },
    );

    test('onMessageNew updates parent or reply message', () {
      when(() => mockEvent.message).thenReturn(mockMessage);
      when(() => mockController.updateParent(any())).thenReturn(false);
      when(() => mockController.upsertReply(any())).thenReturn(true);

      handler.onMessageNew(mockEvent, mockController);
      verify(() => mockController.updateParent(mockMessage));
      verify(() => mockController.upsertReply(mockMessage));
    });

    test(
      'onMessageDeleted deletes thread if message is parent and hard deleted',
      () {
        when(() => mockMessage.id).thenReturn('message-id');
        when(() => mockMessage.parentId).thenReturn(null);
        when(() => mockEvent.message).thenReturn(mockMessage);
        when(() => mockEvent.hardDelete).thenReturn(true);
        when(() => mockController.deleteThread(parentMessageId: 'message-id')).thenReturn(true);

        handler.onMessageDeleted(mockEvent, mockController);
        verify(() => mockController.deleteThread(parentMessageId: 'message-id'));
        verifyNever(() => mockController.deleteReply(any()));
      },
    );

    test(
      'onMessageDeleted deletes reply if message is reply and hard deleted',
      () {
        when(() => mockMessage.id).thenReturn('message-id');
        when(() => mockMessage.parentId).thenReturn('parent-id');
        when(() => mockEvent.message).thenReturn(mockMessage);
        when(() => mockEvent.hardDelete).thenReturn(true);
        when(() => mockController.deleteReply(any())).thenReturn(true);

        handler.onMessageDeleted(mockEvent, mockController);
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
        when(() => mockEvent.message).thenReturn(mockMessage);
        when(() => mockEvent.hardDelete).thenReturn(false);
        when(() => mockController.updateParent(mockMessage)).thenReturn(true);

        handler.onMessageDeleted(mockEvent, mockController);
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
        when(() => mockEvent.message).thenReturn(mockMessage);
        when(() => mockEvent.hardDelete).thenReturn(false);
        when(() => mockController.updateParent(mockMessage)).thenReturn(false);
        when(() => mockController.upsertReply(mockMessage)).thenReturn(true);

        handler.onMessageDeleted(mockEvent, mockController);
        verify(() => mockController.updateParent(mockMessage));
        verify(() => mockController.upsertReply(mockMessage));
        verifyNever(() => mockController.deleteReply(any()));
        verifyNever(
          () => mockController.deleteThread(parentMessageId: 'message-id'),
        );
      },
    );

    test('onChannelDeleted deletes threads by channel cid', () {
      when(() => mockEvent.cid).thenReturn('channel-cid');

      handler.onChannelDeleted(mockEvent, mockController);
      verify(() => mockController.deleteThreadByChannelCid(channelCid: 'channel-cid'));
    });

    test('onChannelTruncated deletes threads by channel cid', () {
      when(() => mockEvent.cid).thenReturn('channel-cid');

      handler.onChannelTruncated(mockEvent, mockController);
      verify(() => mockController.deleteThreadByChannelCid(channelCid: 'channel-cid'));
    });

    test('onMessageRead marks thread as read', () {
      final reader = User(id: 'reader');
      final readAt = DateTime.utc(2026, 1, 2);
      final thread = _thread(
        read: [Read(user: reader, lastRead: DateTime.utc(2026), unreadMessages: 3)],
      );
      when(() => mockEvent.thread).thenReturn(_thread());
      when(() => mockEvent.user).thenReturn(reader);
      when(() => mockEvent.createdAt).thenReturn(readAt);
      when(() => mockController.getThread(parentMessageId: 'parent-id')).thenReturn(thread);
      when(() => mockController.updateThread(any())).thenReturn(true);

      handler.onMessageRead(mockEvent, mockController);

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
      when(() => mockEvent.thread).thenReturn(_thread());
      when(() => mockEvent.user).thenReturn(reader);
      when(() => mockEvent.createdAt).thenReturn(markedAt);
      when(() => mockController.getThread(parentMessageId: 'parent-id')).thenReturn(thread);
      when(() => mockController.updateThread(any())).thenReturn(true);

      handler.onNotificationMarkUnread(mockEvent, mockController);

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
