import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

ChannelState Function(ChannelState) _seedChannel({
  List<ChannelCapability>? ownCapabilities,
  List<Read> read = const [],
}) {
  return (_) => createDefaultChannelState(
    channel: createDefaultChannelModel(
      cid: _channelCid,
      config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
      ownCapabilities: ownCapabilities,
    ),
    read: read,
  );
}

void main() {
  group('Read Events', () {
    channelTest(
      'should update read state on message read event',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final currentUser = User(id: 'test-user');
        final currentRead = Read(
          user: currentUser,
          lastRead: DateTime.utc(2020),
          unreadMessages: 10,
        );

        // Setup initial read state
        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
            read: [currentRead],
          ),
        );

        // Verify initial state
        final read = tester.channelState?.read.first;
        expect(read?.user.id, 'test-user');
        expect(read?.unreadMessages, 10);
        expect(read?.lastReadMessageId, isNull);
        expect(read?.lastRead.isAtSameMomentAs(DateTime.utc(2020)), isTrue);

        // Create message read event
        final messageReadEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.messageRead,
          user: currentUser,
          createdAt: DateTime.utc(2022),
          unreadMessages: 0,
          lastReadMessageId: 'message-123',
        );

        // Dispatch event
        await tester.emitEvent(messageReadEvent);

        // Verify read state is updated
        final updatedRead = tester.channelState?.read.first;
        expect(updatedRead?.user.id, 'test-user');
        expect(updatedRead?.unreadMessages, 0);
        expect(updatedRead?.lastReadMessageId, 'message-123');
        expect(updatedRead?.lastRead.isAtSameMomentAs(DateTime.utc(2022)), isTrue);
      },
    );

    channelTest(
      'should add a new read state if not exist on message read event',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        // Create the current read state
        final currentUser = User(id: 'test-user');

        // Verify initial state
        final read = tester.channelState?.read;
        expect(read, isEmpty);

        // Create mark read notification event
        final markReadEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.messageRead,
          user: currentUser,
          createdAt: DateTime.utc(2022),
          unreadMessages: 0,
          lastReadMessageId: 'message-123',
        );

        // Dispatch event
        await tester.emitEvent(markReadEvent);

        // Verify read list has not changed
        final updated = tester.channelState?.read;
        expect(updated?.length, 1);
        expect(updated?.any((r) => r.user.id == currentUser.id), isTrue);
      },
    );

    channelTest(
      'should not update channel read state on thread message read event',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final currentUser = User(id: 'test-user');
        final currentRead = Read(
          user: currentUser,
          lastRead: DateTime.utc(2020),
          unreadMessages: 10,
          lastReadMessageId: 'channel-msg-1',
        );

        // Setup initial channel read state
        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
            read: [currentRead],
          ),
        );

        // Verify initial state
        final read = tester.channelState?.read.first;
        expect(read?.unreadMessages, 10);
        expect(read?.lastReadMessageId, 'channel-msg-1');
        expect(read?.lastRead.isAtSameMomentAs(DateTime.utc(2020)), isTrue);

        // Create a thread-scoped message.read event (thread != null)
        final threadMessageReadEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.messageRead,
          user: currentUser,
          createdAt: DateTime.utc(2022),
          lastReadMessageId: 'thread-reply-99',
          thread: Thread(
            channelCid: tester.channel.cid!,
            parentMessageId: 'parent-msg-1',
            createdByUserId: currentUser.id,
            replyCount: 3,
            participantCount: 2,
          ),
        );

        // Dispatch event
        await tester.emitEvent(threadMessageReadEvent);

        // Channel read state must be untouched — thread reads
        // must not clobber the channel-level Read.
        final after = tester.channelState?.read.first;
        expect(after?.unreadMessages, 10);
        expect(after?.lastReadMessageId, 'channel-msg-1');
        expect(after?.lastRead.isAtSameMomentAs(DateTime.utc(2020)), isTrue);
      },
    );

    channelTest(
      'should update read state on notification mark unread event',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        // Create the current read state
        final currentUser = User(id: 'test-user');
        final currentRead = Read(
          user: currentUser,
          lastRead: DateTime.utc(2020),
          unreadMessages: 10,
        );

        // Setup initial read state
        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
            read: [currentRead],
          ),
        );

        // Verify initial state
        final read = tester.channelState?.read.first;
        expect(read?.user.id, 'test-user');
        expect(read?.unreadMessages, 10);
        expect(read?.lastReadMessageId, isNull);
        expect(read?.lastRead.isAtSameMomentAs(DateTime.utc(2020)), isTrue);

        // Create mark unread notification event
        final markUnreadEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.notificationMarkUnread,
          user: currentUser,
          lastReadAt: DateTime.utc(2019),
          unreadMessages: 15,
          lastReadMessageId: 'message-100',
        );

        // Dispatch event
        await tester.emitEvent(markUnreadEvent);

        // Verify read state is updated
        final updatedRead = tester.channelState?.read.first;
        expect(updatedRead?.user.id, 'test-user');
        expect(updatedRead?.unreadMessages, 15);
        expect(updatedRead?.lastReadMessageId, 'message-100');
        expect(updatedRead?.lastRead.isAtSameMomentAs(DateTime.utc(2019)), isTrue);
      },
    );

    channelTest(
      'should add a new read state if not exist on notification mark unread',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        // Verify initial state
        final read = tester.channelState?.read;
        expect(read, isEmpty);

        // Create event for non-existing user
        final markUnreadEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.notificationMarkUnread,
          user: User(id: 'non-existing-user'),
          lastReadAt: DateTime.utc(2019),
          unreadMessages: 15,
          lastReadMessageId: 'message-100',
        );

        // Dispatch event
        await tester.emitEvent(markUnreadEvent);

        // Verify read list has not changed
        final updated = tester.channelState?.read;
        expect(updated?.length, 1);
        expect(updated?.any((r) => r.user.id == 'non-existing-user'), isTrue);
      },
    );

    channelTest(
      'should preserve delivery info on message read event',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final currentUser = User(id: 'test-user');
        final currentRead = Read(
          user: currentUser,
          lastRead: DateTime.utc(2020),
          unreadMessages: 10,
          lastDeliveredAt: DateTime.utc(2021),
          lastDeliveredMessageId: 'delivered-msg-456',
        );

        // Setup initial read state with delivery info
        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
            read: [currentRead],
          ),
        );

        // Verify initial state
        final read = tester.channelState?.read.first;
        expect(read?.lastDeliveredAt, isNotNull);
        expect(
          read?.lastDeliveredAt?.isAtSameMomentAs(DateTime.utc(2021)),
          isTrue,
        );
        expect(read?.lastDeliveredMessageId, 'delivered-msg-456');

        // Create message read event (doesn't include delivery info)
        final messageReadEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.messageRead,
          user: currentUser,
          createdAt: DateTime.utc(2022),
          unreadMessages: 0,
          lastReadMessageId: 'message-123',
        );

        // Dispatch event
        await tester.emitEvent(messageReadEvent);

        // Verify read state is updated but delivery info is preserved
        final updatedRead = tester.channelState?.read.first;
        expect(updatedRead?.user.id, 'test-user');
        expect(updatedRead?.unreadMessages, 0);
        expect(updatedRead?.lastReadMessageId, 'message-123');
        expect(
          updatedRead?.lastRead.isAtSameMomentAs(DateTime.utc(2022)),
          isTrue,
        );
        // Delivery info should be preserved
        expect(updatedRead?.lastDeliveredAt, isNotNull);
        expect(
          updatedRead?.lastDeliveredAt?.isAtSameMomentAs(DateTime.utc(2021)),
          isTrue,
        );
        expect(updatedRead?.lastDeliveredMessageId, 'delivered-msg-456');
      },
    );

    channelTest(
      'should reconcile delivery when message read event is from current user',
      channelType: _channelType,
      channelId: _channelId,
      // The delivery reporter is real here, so the reconciliation is observed
      // through its effect: a pending delivery receipt — armed by an incoming
      // message on a delivery-capable channel with a stale read — is dropped
      // once the current user's read supersedes it.
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(
          ownCapabilities: const [ChannelCapability.readEvents, ChannelCapability.deliveryEvents],
          read: [createDefaultRead()],
        ),
      ),
      body: (tester) async {
        registerFallbackValue(<MessageDelivery>[]);
        tester.mockApi(
          (api) => api.channel.markChannelsDelivered(any()),
          result: createDefaultEmptyResponse(),
        );

        // An incoming message from another user arms a pending delivery
        // receipt for this channel.
        final message = Message(
          id: 'message-123',
          user: User(id: 'other-user'),
          createdAt: DateTime.utc(2021, 2),
        );
        await tester.emitEvent(
          createDefaultEvent(cid: tester.channel.cid, type: EventType.messageNew, message: message),
        );

        // Create message read event from current user
        final messageReadEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.messageRead,
          user: tester.currentUser,
          createdAt: DateTime.utc(2022),
          unreadMessages: 0,
          lastReadMessageId: 'message-123',
        );

        // Dispatch event
        await tester.emitEvent(messageReadEvent);

        // The delivery reporter batches receipts behind a 1s trailing
        // throttle; by then reconciliation must have dropped the receipt.
        await Future.delayed(const Duration(milliseconds: 1100));

        // Verify the reconciled receipt was never sent
        tester.verifyNeverCalled((api) => api.channel.markChannelsDelivered(any()));
      },
    );

    channelTest(
      'should reset unread count on notification mark read event',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final currentUser = tester.currentUser!;
        final currentRead = Read(
          user: currentUser,
          lastRead: DateTime.utc(2020),
          unreadMessages: 10,
        );

        // Setup initial read state
        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
            read: [currentRead],
          ),
        );

        // Verify initial state
        expect(tester.channelState?.unreadCount, 10);

        // notification.mark_read is delivered on the reading user's own
        // connection, so it reaches non-watched channels as well.
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.notificationMarkRead,
            user: currentUser,
            createdAt: DateTime.utc(2022),
            lastReadMessageId: 'message-123',
          ),
        );

        // Verify read state is updated
        final updatedRead = tester.channelState?.read.first;
        expect(updatedRead?.user.id, currentUser.id);
        expect(tester.channelState?.unreadCount, 0);
        expect(updatedRead?.lastReadMessageId, 'message-123');
        expect(
          updatedRead?.lastRead.isAtSameMomentAs(DateTime.utc(2022)),
          isTrue,
        );
      },
    );

    channelTest(
      'should preserve delivery info on notification mark read event',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final currentUser = User(id: 'test-user');
        final currentRead = Read(
          user: currentUser,
          lastRead: DateTime.utc(2020),
          unreadMessages: 10,
          lastDeliveredAt: DateTime.utc(2021),
          lastDeliveredMessageId: 'delivered-msg-456',
        );

        // Setup initial read state
        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
            read: [currentRead],
          ),
        );

        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.notificationMarkRead,
            user: currentUser,
            createdAt: DateTime.utc(2022),
            lastReadMessageId: 'message-123',
          ),
        );

        // Verify read state is updated but delivery info is preserved
        final updatedRead = tester.channelState?.read.first;
        expect(updatedRead?.unreadMessages, 0);
        expect(
          updatedRead?.lastDeliveredAt?.isAtSameMomentAs(DateTime.utc(2021)),
          isTrue,
        );
        expect(updatedRead?.lastDeliveredMessageId, 'delivered-msg-456');
      },
    );

    channelTest(
      'should not update channel read state on thread notification mark '
      'read event',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final currentUser = User(id: 'test-user');
        final currentRead = Read(
          user: currentUser,
          lastRead: DateTime.utc(2020),
          unreadMessages: 10,
          lastReadMessageId: 'channel-msg-1',
        );

        // Setup initial read state
        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
            read: [currentRead],
          ),
        );

        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.notificationMarkRead,
            user: currentUser,
            createdAt: DateTime.utc(2022),
            lastReadMessageId: 'thread-reply-99',
            thread: Thread(
              channelCid: tester.channel.cid!,
              parentMessageId: 'parent-msg-1',
              createdByUserId: currentUser.id,
              replyCount: 3,
              participantCount: 2,
            ),
          ),
        );

        // Channel read state must be untouched — thread reads
        // must not clobber the channel-level Read.
        final after = tester.channelState?.read.first;
        expect(after?.unreadMessages, 10);
        expect(after?.lastReadMessageId, 'channel-msg-1');
        expect(after?.lastRead.isAtSameMomentAs(DateTime.utc(2020)), isTrue);
      },
    );

    channelTest(
      'should reconcile delivery when notification mark read event is from '
      'current user',
      channelType: _channelType,
      channelId: _channelId,
      // The delivery reporter is real here, so the reconciliation is observed
      // through its effect: a pending delivery receipt — armed by an incoming
      // message on a delivery-capable channel with a stale read — is dropped
      // once the current user's read supersedes it.
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(
          ownCapabilities: const [ChannelCapability.readEvents, ChannelCapability.deliveryEvents],
          read: [createDefaultRead()],
        ),
      ),
      body: (tester) async {
        registerFallbackValue(<MessageDelivery>[]);
        tester.mockApi(
          (api) => api.channel.markChannelsDelivered(any()),
          result: createDefaultEmptyResponse(),
        );

        // An incoming message from another user arms a pending delivery
        // receipt for this channel.
        final message = Message(
          id: 'message-123',
          user: User(id: 'other-user'),
          createdAt: DateTime.utc(2021, 2),
        );
        await tester.emitEvent(
          createDefaultEvent(cid: tester.channel.cid, type: EventType.messageNew, message: message),
        );

        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.notificationMarkRead,
            user: tester.currentUser,
            createdAt: DateTime.utc(2022),
            lastReadMessageId: 'message-123',
          ),
        );

        // The delivery reporter batches receipts behind a 1s trailing
        // throttle; by then reconciliation must have dropped the receipt.
        await Future.delayed(const Duration(milliseconds: 1100));

        // Verify the reconciled receipt was never sent
        tester.verifyNeverCalled((api) => api.channel.markChannelsDelivered(any()));
      },
    );

    channelTest(
      'should update read state on message delivered event',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final currentUser = User(id: 'test-user');
        final distantPast = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
        final currentRead = Read(
          user: currentUser,
          lastRead: distantPast,
          unreadMessages: 5,
        );

        // Setup initial read state
        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
            read: [currentRead],
          ),
        );

        // Verify initial state has no delivery info
        final read = tester.channelState?.read.first;
        expect(read?.user.id, 'test-user');
        expect(read?.lastDeliveredAt, isNull);
        expect(read?.lastDeliveredMessageId, isNull);

        // Create message delivered event
        final messageDeliveredEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.messageDelivered,
          user: currentUser,
          lastDeliveredAt: DateTime.utc(2022),
          lastDeliveredMessageId: 'message-456',
        );

        // Dispatch event
        await tester.emitEvent(messageDeliveredEvent);

        // Verify delivery state is updated
        final updatedRead = tester.channelState?.read.first;
        expect(updatedRead?.user.id, 'test-user');
        expect(updatedRead?.lastDeliveredAt, isNotNull);
        expect(
          updatedRead?.lastDeliveredAt?.isAtSameMomentAs(DateTime.utc(2022)),
          isTrue,
        );
        expect(updatedRead?.lastDeliveredMessageId, 'message-456');
      },
    );

    channelTest(
      'should add a new read state if not exist on message delivered event',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final newUser = User(id: 'new-user');
        final distantPast = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

        // Verify initial state
        final read = tester.channelState?.read;
        expect(read, isEmpty);

        // Create message delivered event for new user
        final messageDeliveredEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.messageDelivered,
          user: newUser,
          lastDeliveredAt: DateTime.utc(2022),
          lastDeliveredMessageId: 'message-789',
        );

        // Dispatch event
        await tester.emitEvent(messageDeliveredEvent);

        // Verify read state was created with delivery info
        final updated = tester.channelState?.read;
        expect(updated?.length, 1);
        final newRead = updated?.first;
        expect(newRead?.user.id, 'new-user');
        expect(newRead?.lastDeliveredAt, isNotNull);
        expect(
          newRead?.lastDeliveredAt?.isAtSameMomentAs(DateTime.utc(2022)),
          isTrue,
        );
        expect(newRead?.lastDeliveredMessageId, 'message-789');
        // lastRead should default to distantPast
        expect(
          newRead?.lastRead.isAtSameMomentAs(distantPast),
          isTrue,
        );
      },
    );

    channelTest(
      'should preserve read info on message delivered event',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final currentUser = User(id: 'test-user');
        final currentRead = Read(
          user: currentUser,
          lastRead: DateTime.utc(2020),
          unreadMessages: 10,
          lastReadMessageId: 'read-msg-123',
        );

        // Setup initial read state
        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
            read: [currentRead],
          ),
        );

        // Verify initial state
        final read = tester.channelState?.read.first;
        expect(read?.lastRead.isAtSameMomentAs(DateTime.utc(2020)), isTrue);
        expect(read?.unreadMessages, 10);
        expect(read?.lastReadMessageId, 'read-msg-123');

        // Create message delivered event (doesn't include read info)
        final messageDeliveredEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.messageDelivered,
          user: currentUser,
          lastDeliveredAt: DateTime.utc(2022),
          lastDeliveredMessageId: 'delivered-msg-456',
        );

        // Dispatch event
        await tester.emitEvent(messageDeliveredEvent);

        // Verify delivery state is updated but read info is preserved
        final updatedRead = tester.channelState?.read.first;
        expect(updatedRead?.user.id, 'test-user');
        expect(
          updatedRead?.lastDeliveredAt?.isAtSameMomentAs(DateTime.utc(2022)),
          isTrue,
        );
        expect(updatedRead?.lastDeliveredMessageId, 'delivered-msg-456');
        // Read info should be preserved
        expect(
          updatedRead?.lastRead.isAtSameMomentAs(DateTime.utc(2020)),
          isTrue,
        );
        expect(updatedRead?.unreadMessages, 10);
        expect(updatedRead?.lastReadMessageId, 'read-msg-123');
      },
    );

    channelTest(
      'should reconcile delivery when message delivered event is from current user',
      channelType: _channelType,
      channelId: _channelId,
      // The delivery reporter is real here, so the reconciliation is observed
      // through its effect: a pending delivery receipt — armed by an incoming
      // message on a delivery-capable channel with a stale read — is dropped
      // once the current user's delivery marker supersedes it.
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(
          ownCapabilities: const [ChannelCapability.readEvents, ChannelCapability.deliveryEvents],
          read: [createDefaultRead()],
        ),
      ),
      body: (tester) async {
        registerFallbackValue(<MessageDelivery>[]);
        tester.mockApi(
          (api) => api.channel.markChannelsDelivered(any()),
          result: createDefaultEmptyResponse(),
        );

        // An incoming message from another user arms a pending delivery
        // receipt for this channel.
        final message = Message(
          id: 'message-456',
          user: User(id: 'other-user'),
          createdAt: DateTime.utc(2021, 2),
        );
        await tester.emitEvent(
          createDefaultEvent(cid: tester.channel.cid, type: EventType.messageNew, message: message),
        );

        // Create message delivered event from current user
        final messageDeliveredEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.messageDelivered,
          user: tester.currentUser,
          lastDeliveredAt: DateTime.utc(2022),
          lastDeliveredMessageId: 'message-456',
        );

        // Dispatch event
        await tester.emitEvent(messageDeliveredEvent);

        // The delivery reporter batches receipts behind a 1s trailing
        // throttle; by then reconciliation must have dropped the receipt.
        await Future.delayed(const Duration(milliseconds: 1100));

        // Verify the reconciled receipt was never sent
        tester.verifyNeverCalled((api) => api.channel.markChannelsDelivered(any()));
      },
    );
  });
}
