// ignore_for_file: lines_longer_than_80_chars, cascade_invocations, deprecated_member_use_from_same_package, avoid_redundant_argument_values

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../fakes.dart';
import '../../mocks.dart';

void main() {
  group('WS events', () {
    late final client = MockStreamChatClient();

    setUpAll(() {
      // Fallback values
      registerFallbackValue(FakeMessage());
      registerFallbackValue(FakeAttachmentFile());
      registerFallbackValue(FakeEvent());

      // detached loggers
      when(() => client.detachedLogger(any())).thenAnswer((invocation) {
        final name = invocation.positionalArguments.first;
        return _createLogger(name);
      });

      final retryPolicy = RetryPolicy(
        shouldRetry: (_, __, ___) => false,
        delayFactor: Duration.zero,
      );
      when(() => client.retryPolicy).thenReturn(retryPolicy);

      // fake clientState
      final clientState = FakeClientState();
      when(() => client.state).thenReturn(clientState);

      // client logger
      when(() => client.logger).thenReturn(_createLogger('mock-client-logger'));

      // mock channel delivery reporter
      when(
        () => client.channelDeliveryReporter.submitForDelivery(any()),
      ).thenAnswer((_) async {});
    });
    group('Read Events', () {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      late Channel channel;

      setUp(() {
        final channelState = _generateChannelState(
          channelId,
          channelType,
          mockChannelConfig: true,
        );

        channel = Channel.fromState(client, channelState);
      });

      tearDown(() {
        channel.dispose();
      });

      test('should update read state on message read event', () async {
        final currentUser = User(id: 'test-user');
        final currentRead = Read(
          user: currentUser,
          lastRead: DateTime(2020),
          unreadMessages: 10,
        );

        // Setup initial read state
        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            read: [currentRead],
          ),
        );

        // Verify initial state
        final read = channel.state?.read.first;
        expect(read?.user.id, 'test-user');
        expect(read?.unreadMessages, 10);
        expect(read?.lastReadMessageId, isNull);
        expect(read?.lastRead.isAtSameMomentAs(DateTime(2020)), isTrue);

        // Create message read event
        final messageReadEvent = Event(
          cid: channel.cid,
          type: EventType.messageRead,
          user: currentUser,
          createdAt: DateTime(2022),
          unreadMessages: 0,
          lastReadMessageId: 'message-123',
        );

        // Dispatch event
        client.addEvent(messageReadEvent);

        // Wait for event to be processed
        await Future.delayed(Duration.zero);

        // Verify read state is updated
        final updatedRead = channel.state?.read.first;
        expect(updatedRead?.user.id, 'test-user');
        expect(updatedRead?.unreadMessages, 0);
        expect(updatedRead?.lastReadMessageId, 'message-123');
        expect(updatedRead?.lastRead.isAtSameMomentAs(DateTime(2022)), isTrue);
      });

      test(
        'should add a new read state if not exist on message read event',
        () async {
          // Create the current read state
          final currentUser = User(id: 'test-user');

          // Verify initial state
          final read = channel.state?.read;
          expect(read, isEmpty);

          // Create mark read notification event
          final markReadEvent = Event(
            cid: channel.cid,
            type: EventType.messageRead,
            user: currentUser,
            createdAt: DateTime(2022),
            unreadMessages: 0,
            lastReadMessageId: 'message-123',
          );

          // Dispatch event
          client.addEvent(markReadEvent);

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Verify read list has not changed
          final updated = channel.state?.read;
          expect(updated?.length, 1);
          expect(updated?.any((r) => r.user.id == currentUser.id), isTrue);
        },
      );

      test(
        'should not update channel read state on thread message read event',
        () async {
          final currentUser = User(id: 'test-user');
          final currentRead = Read(
            user: currentUser,
            lastRead: DateTime(2020),
            unreadMessages: 10,
            lastReadMessageId: 'channel-msg-1',
          );

          // Setup initial channel read state
          channel.state?.updateChannelState(
            channel.state!.channelState.copyWith(
              read: [currentRead],
            ),
          );

          // Verify initial state
          final read = channel.state?.read.first;
          expect(read?.unreadMessages, 10);
          expect(read?.lastReadMessageId, 'channel-msg-1');
          expect(read?.lastRead.isAtSameMomentAs(DateTime(2020)), isTrue);

          // Create a thread-scoped message.read event (thread != null)
          final threadMessageReadEvent = Event(
            cid: channel.cid,
            type: EventType.messageRead,
            user: currentUser,
            createdAt: DateTime(2022),
            lastReadMessageId: 'thread-reply-99',
            thread: Thread(
              channelCid: channel.cid!,
              parentMessageId: 'parent-msg-1',
              createdByUserId: currentUser.id,
              replyCount: 3,
              participantCount: 2,
            ),
          );

          // Dispatch event
          client.addEvent(threadMessageReadEvent);

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Channel read state must be untouched — thread reads
          // must not clobber the channel-level Read.
          final after = channel.state?.read.first;
          expect(after?.unreadMessages, 10);
          expect(after?.lastReadMessageId, 'channel-msg-1');
          expect(after?.lastRead.isAtSameMomentAs(DateTime(2020)), isTrue);
        },
      );

      test('should update read state on notification mark unread event', () async {
        // Create the current read state
        final currentUser = User(id: 'test-user');
        final currentRead = Read(
          user: currentUser,
          lastRead: DateTime(2020),
          unreadMessages: 10,
        );

        // Setup initial read state
        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            read: [currentRead],
          ),
        );

        // Verify initial state
        final read = channel.state?.read.first;
        expect(read?.user.id, 'test-user');
        expect(read?.unreadMessages, 10);
        expect(read?.lastReadMessageId, isNull);
        expect(read?.lastRead.isAtSameMomentAs(DateTime(2020)), isTrue);

        // Create mark unread notification event
        final markUnreadEvent = Event(
          cid: channel.cid,
          type: EventType.notificationMarkUnread,
          user: currentUser,
          lastReadAt: DateTime(2019),
          unreadMessages: 15,
          lastReadMessageId: 'message-100',
        );

        // Dispatch event
        client.addEvent(markUnreadEvent);

        // Wait for event to be processed
        await Future.delayed(Duration.zero);

        // Verify read state is updated
        final updatedRead = channel.state?.read.first;
        expect(updatedRead?.user.id, 'test-user');
        expect(updatedRead?.unreadMessages, 15);
        expect(updatedRead?.lastReadMessageId, 'message-100');
        expect(updatedRead?.lastRead.isAtSameMomentAs(DateTime(2019)), isTrue);
      });

      test(
        'should add a new read state if not exist on notification mark unread',
        () async {
          // Verify initial state
          final read = channel.state?.read;
          expect(read, isEmpty);

          // Create event for non-existing user
          final markUnreadEvent = Event(
            cid: channel.cid,
            type: EventType.notificationMarkUnread,
            user: User(id: 'non-existing-user'),
            lastReadAt: DateTime(2019),
            unreadMessages: 15,
            lastReadMessageId: 'message-100',
          );

          // Dispatch event
          client.addEvent(markUnreadEvent);

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Verify read list has not changed
          final updated = channel.state?.read;
          expect(updated?.length, 1);
          expect(updated?.any((r) => r.user.id == 'non-existing-user'), isTrue);
        },
      );

      test(
        'should preserve delivery info on message read event',
        () async {
          final currentUser = User(id: 'test-user');
          final currentRead = Read(
            user: currentUser,
            lastRead: DateTime(2020),
            unreadMessages: 10,
            lastDeliveredAt: DateTime(2021),
            lastDeliveredMessageId: 'delivered-msg-456',
          );

          // Setup initial read state with delivery info
          channel.state?.updateChannelState(
            channel.state!.channelState.copyWith(
              read: [currentRead],
            ),
          );

          // Verify initial state
          final read = channel.state?.read.first;
          expect(read?.lastDeliveredAt, isNotNull);
          expect(
            read?.lastDeliveredAt?.isAtSameMomentAs(DateTime(2021)),
            isTrue,
          );
          expect(read?.lastDeliveredMessageId, 'delivered-msg-456');

          // Create message read event (doesn't include delivery info)
          final messageReadEvent = Event(
            cid: channel.cid,
            type: EventType.messageRead,
            user: currentUser,
            createdAt: DateTime(2022),
            unreadMessages: 0,
            lastReadMessageId: 'message-123',
          );

          // Dispatch event
          client.addEvent(messageReadEvent);

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Verify read state is updated but delivery info is preserved
          final updatedRead = channel.state?.read.first;
          expect(updatedRead?.user.id, 'test-user');
          expect(updatedRead?.unreadMessages, 0);
          expect(updatedRead?.lastReadMessageId, 'message-123');
          expect(
            updatedRead?.lastRead.isAtSameMomentAs(DateTime(2022)),
            isTrue,
          );
          // Delivery info should be preserved
          expect(updatedRead?.lastDeliveredAt, isNotNull);
          expect(
            updatedRead?.lastDeliveredAt?.isAtSameMomentAs(DateTime(2021)),
            isTrue,
          );
          expect(updatedRead?.lastDeliveredMessageId, 'delivered-msg-456');
        },
      );

      test(
        'should reconcile delivery when message read event is from current user',
        () async {
          final currentUser = client.state.currentUser;
          final updatedUser = currentUser?.copyWith(id: 'current-user-id');

          client.state.updateUser(updatedUser);
          addTearDown(() => client.state.updateUser(currentUser));

          when(
            () => client.channelDeliveryReporter.reconcileDelivery([channel]),
          ).thenAnswer((_) => Future.value());

          // Create message read event from current user
          final messageReadEvent = Event(
            cid: channel.cid,
            type: EventType.messageRead,
            user: currentUser,
            createdAt: DateTime(2022),
            unreadMessages: 0,
            lastReadMessageId: 'message-123',
          );

          // Dispatch event
          client.addEvent(messageReadEvent);

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Verify reconcileDelivery was called
          verify(
            () => client.channelDeliveryReporter.reconcileDelivery([channel]),
          ).called(1);
        },
      );

      test(
        'should reset unread count on notification mark read event',
        () async {
          final currentUser = client.state.currentUser!;
          final currentRead = Read(
            user: currentUser,
            lastRead: DateTime(2020),
            unreadMessages: 10,
          );

          // Setup initial read state
          channel.state?.updateChannelState(
            channel.state!.channelState.copyWith(
              read: [currentRead],
            ),
          );

          when(
            () => client.channelDeliveryReporter.reconcileDelivery([channel]),
          ).thenAnswer((_) => Future.value());

          // Verify initial state
          expect(channel.state?.unreadCount, 10);

          // notification.mark_read is delivered on the reading user's own
          // connection, so it reaches non-watched channels as well.
          client.addEvent(
            Event(
              cid: channel.cid,
              type: EventType.notificationMarkRead,
              user: currentUser,
              createdAt: DateTime(2022),
              lastReadMessageId: 'message-123',
            ),
          );

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Verify read state is updated
          final updatedRead = channel.state?.read.first;
          expect(updatedRead?.user.id, currentUser.id);
          expect(channel.state?.unreadCount, 0);
          expect(updatedRead?.lastReadMessageId, 'message-123');
          expect(
            updatedRead?.lastRead.isAtSameMomentAs(DateTime(2022)),
            isTrue,
          );
        },
      );

      test(
        'should preserve delivery info on notification mark read event',
        () async {
          final currentUser = User(id: 'test-user');
          final currentRead = Read(
            user: currentUser,
            lastRead: DateTime(2020),
            unreadMessages: 10,
            lastDeliveredAt: DateTime(2021),
            lastDeliveredMessageId: 'delivered-msg-456',
          );

          // Setup initial read state
          channel.state?.updateChannelState(
            channel.state!.channelState.copyWith(
              read: [currentRead],
            ),
          );

          client.addEvent(
            Event(
              cid: channel.cid,
              type: EventType.notificationMarkRead,
              user: currentUser,
              createdAt: DateTime(2022),
              lastReadMessageId: 'message-123',
            ),
          );

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Verify read state is updated but delivery info is preserved
          final updatedRead = channel.state?.read.first;
          expect(updatedRead?.unreadMessages, 0);
          expect(
            updatedRead?.lastDeliveredAt?.isAtSameMomentAs(DateTime(2021)),
            isTrue,
          );
          expect(updatedRead?.lastDeliveredMessageId, 'delivered-msg-456');
        },
      );

      test(
        'should not update channel read state on thread notification mark '
        'read event',
        () async {
          final currentUser = User(id: 'test-user');
          final currentRead = Read(
            user: currentUser,
            lastRead: DateTime(2020),
            unreadMessages: 10,
            lastReadMessageId: 'channel-msg-1',
          );

          // Setup initial read state
          channel.state?.updateChannelState(
            channel.state!.channelState.copyWith(
              read: [currentRead],
            ),
          );

          client.addEvent(
            Event(
              cid: channel.cid,
              type: EventType.notificationMarkRead,
              user: currentUser,
              createdAt: DateTime(2022),
              lastReadMessageId: 'thread-reply-99',
              thread: Thread(
                channelCid: channel.cid!,
                parentMessageId: 'parent-msg-1',
                createdByUserId: currentUser.id,
                replyCount: 3,
                participantCount: 2,
              ),
            ),
          );

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Channel read state must be untouched — thread reads
          // must not clobber the channel-level Read.
          final after = channel.state?.read.first;
          expect(after?.unreadMessages, 10);
          expect(after?.lastReadMessageId, 'channel-msg-1');
          expect(after?.lastRead.isAtSameMomentAs(DateTime(2020)), isTrue);
        },
      );

      test(
        'should reconcile delivery when notification mark read event is from '
        'current user',
        () async {
          final currentUser = client.state.currentUser;

          when(
            () => client.channelDeliveryReporter.reconcileDelivery([channel]),
          ).thenAnswer((_) => Future.value());

          client.addEvent(
            Event(
              cid: channel.cid,
              type: EventType.notificationMarkRead,
              user: currentUser,
              createdAt: DateTime(2022),
              lastReadMessageId: 'message-123',
            ),
          );

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Verify reconcileDelivery was called
          verify(
            () => client.channelDeliveryReporter.reconcileDelivery([channel]),
          ).called(1);
        },
      );

      test('should update read state on message delivered event', () async {
        final currentUser = User(id: 'test-user');
        final distantPast = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
        final currentRead = Read(
          user: currentUser,
          lastRead: distantPast,
          unreadMessages: 5,
        );

        // Setup initial read state
        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            read: [currentRead],
          ),
        );

        // Verify initial state has no delivery info
        final read = channel.state?.read.first;
        expect(read?.user.id, 'test-user');
        expect(read?.lastDeliveredAt, isNull);
        expect(read?.lastDeliveredMessageId, isNull);

        // Create message delivered event
        final messageDeliveredEvent = Event(
          cid: channel.cid,
          type: EventType.messageDelivered,
          user: currentUser,
          lastDeliveredAt: DateTime(2022),
          lastDeliveredMessageId: 'message-456',
        );

        // Dispatch event
        client.addEvent(messageDeliveredEvent);

        // Wait for event to be processed
        await Future.delayed(Duration.zero);

        // Verify delivery state is updated
        final updatedRead = channel.state?.read.first;
        expect(updatedRead?.user.id, 'test-user');
        expect(updatedRead?.lastDeliveredAt, isNotNull);
        expect(
          updatedRead?.lastDeliveredAt?.isAtSameMomentAs(DateTime(2022)),
          isTrue,
        );
        expect(updatedRead?.lastDeliveredMessageId, 'message-456');
      });

      test(
        'should add a new read state if not exist on message delivered event',
        () async {
          final newUser = User(id: 'new-user');
          final distantPast = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

          // Verify initial state
          final read = channel.state?.read;
          expect(read, isEmpty);

          // Create message delivered event for new user
          final messageDeliveredEvent = Event(
            cid: channel.cid,
            type: EventType.messageDelivered,
            user: newUser,
            lastDeliveredAt: DateTime(2022),
            lastDeliveredMessageId: 'message-789',
          );

          // Dispatch event
          client.addEvent(messageDeliveredEvent);

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Verify read state was created with delivery info
          final updated = channel.state?.read;
          expect(updated?.length, 1);
          final newRead = updated?.first;
          expect(newRead?.user.id, 'new-user');
          expect(newRead?.lastDeliveredAt, isNotNull);
          expect(
            newRead?.lastDeliveredAt?.isAtSameMomentAs(DateTime(2022)),
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

      test(
        'should preserve read info on message delivered event',
        () async {
          final currentUser = User(id: 'test-user');
          final currentRead = Read(
            user: currentUser,
            lastRead: DateTime(2020),
            unreadMessages: 10,
            lastReadMessageId: 'read-msg-123',
          );

          // Setup initial read state
          channel.state?.updateChannelState(
            channel.state!.channelState.copyWith(
              read: [currentRead],
            ),
          );

          // Verify initial state
          final read = channel.state?.read.first;
          expect(read?.lastRead.isAtSameMomentAs(DateTime(2020)), isTrue);
          expect(read?.unreadMessages, 10);
          expect(read?.lastReadMessageId, 'read-msg-123');

          // Create message delivered event (doesn't include read info)
          final messageDeliveredEvent = Event(
            cid: channel.cid,
            type: EventType.messageDelivered,
            user: currentUser,
            lastDeliveredAt: DateTime(2022),
            lastDeliveredMessageId: 'delivered-msg-456',
          );

          // Dispatch event
          client.addEvent(messageDeliveredEvent);

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Verify delivery state is updated but read info is preserved
          final updatedRead = channel.state?.read.first;
          expect(updatedRead?.user.id, 'test-user');
          expect(
            updatedRead?.lastDeliveredAt?.isAtSameMomentAs(DateTime(2022)),
            isTrue,
          );
          expect(updatedRead?.lastDeliveredMessageId, 'delivered-msg-456');
          // Read info should be preserved
          expect(
            updatedRead?.lastRead.isAtSameMomentAs(DateTime(2020)),
            isTrue,
          );
          expect(updatedRead?.unreadMessages, 10);
          expect(updatedRead?.lastReadMessageId, 'read-msg-123');
        },
      );

      test(
        'should reconcile delivery when message delivered event is from current user',
        () async {
          final currentUser = client.state.currentUser;
          final updatedUser = currentUser?.copyWith(id: 'current-user-id');

          client.state.updateUser(updatedUser);
          addTearDown(() => client.state.updateUser(currentUser));

          when(
            () => client.channelDeliveryReporter.reconcileDelivery([channel]),
          ).thenAnswer((_) => Future.value());

          // Create message delivered event from current user
          final messageDeliveredEvent = Event(
            cid: channel.cid,
            type: EventType.messageDelivered,
            user: currentUser,
            lastDeliveredAt: DateTime(2022),
            lastDeliveredMessageId: 'message-456',
          );

          // Dispatch event
          client.addEvent(messageDeliveredEvent);

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Verify reconcileDelivery was called
          verify(
            () => client.channelDeliveryReporter.reconcileDelivery([channel]),
          ).called(1);
        },
      );
    });

    group('Draft events', () {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      late Channel channel;

      setUp(() {
        final channelState = _generateChannelState(channelId, channelType);
        channel = Channel.fromState(client, channelState);
      });

      tearDown(() {
        channel.dispose();
      });

      test('should handle draft.updated event for channel drafts', () async {
        // Verify initial state
        expect(channel.state?.draft, isNull);

        // Create Draft
        final draft = Draft(
          channelCid: channel.cid!,
          createdAt: DateTime.now(),
          message: DraftMessage(text: 'test message'),
        );

        // Create draft.updated event
        final draftUpdatedEvent = Event(
          cid: channel.cid,
          type: EventType.draftUpdated,
          draft: draft,
        );

        // Dispatch event
        client.addEvent(draftUpdatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Verify channel draft was updated
        expect(channel.state?.draft, isNotNull);
        expect(channel.state?.draft?.message.text, 'test message');
      });

      test('should handle draft.updated event for thread drafts', () async {
        const threadParentMessageId = 'thread-parent-id';

        // Setup initial state with a regular message
        channel.state?.updateMessage(
          Message(
            id: threadParentMessageId,
            user: client.state.currentUser,
          ),
        );

        // Verify initial state
        expect(channel.state?.threadDraft(threadParentMessageId), isNull);

        // Create thread Draft
        final draft = Draft(
          channelCid: channel.cid!,
          createdAt: DateTime.now(),
          parentId: threadParentMessageId,
          message: DraftMessage(text: 'thread reply'),
        );

        // Create draft.updated event
        final draftUpdatedEvent = Event(
          cid: channel.cid,
          type: EventType.draftUpdated,
          draft: draft,
        );

        // Dispatch event
        client.addEvent(draftUpdatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Verify thread draft was updated
        final threadDraft = channel.state?.threadDraft(threadParentMessageId);
        expect(threadDraft, isNotNull);
        expect(threadDraft?.message.text, 'thread reply');
      });

      test('should handle draft.deleted event for channel drafts', () async {
        // Setup initial state with a draft
        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            draft: Draft(
              channelCid: channel.cid!,
              createdAt: DateTime.now(),
              message: DraftMessage(text: 'test message'),
            ),
          ),
        );

        // Verify initial state
        final draft = channel.state?.draft;
        expect(draft, isNotNull);
        expect(draft?.message.text, 'test message');

        // Create draft.deleted event
        final draftUpdatedEvent = Event(
          cid: channel.cid,
          type: EventType.draftDeleted,
          draft: draft,
        );

        // Dispatch event
        client.addEvent(draftUpdatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Verify channel draft was updated
        expect(channel.state?.draft, isNull);
      });

      test('should handle draft.deleted event for thread drafts', () async {
        const threadParentMessageId = 'thread-parent-id';

        // Setup initial state with a thread draft
        channel.state?.updateMessage(
          Message(
            id: threadParentMessageId,
            user: client.state.currentUser,
            draft: Draft(
              channelCid: channel.cid!,
              createdAt: DateTime.now(),
              parentId: threadParentMessageId,
              message: DraftMessage(text: 'thread reply'),
            ),
          ),
        );

        // Verify initial state
        final threadDraft = channel.state?.threadDraft(threadParentMessageId);
        expect(threadDraft, isNotNull);
        expect(threadDraft?.message.text, 'thread reply');

        // Create draft.deleted event
        final draftDeletedEvent = Event(
          cid: channel.cid,
          type: EventType.draftDeleted,
          draft: threadDraft,
        );

        // Dispatch event
        client.addEvent(draftDeletedEvent);

        // Allow event to be processed
        await Future.delayed(Duration.zero);

        // Verify thread draft was removed
        expect(channel.state?.threadDraft(threadParentMessageId), isNull);
      });

      test(
        'should update current channel draft if draft.updated event is emitted',
        () async {
          // Setup initial state with a draft
          final initialDraft = Draft(
            channelCid: channel.cid!,
            createdAt: DateTime.now(),
            message: DraftMessage(text: 'test message'),
          );

          channel.state?.updateChannelState(
            channel.state!.channelState.copyWith(
              draft: initialDraft,
            ),
          );

          // Verify initial state
          expect(channel.state?.draft, isNotNull);
          expect(channel.state?.draft?.message.text, 'test message');

          // Create Draft
          final updatedDraft = initialDraft.copyWith(
            message: DraftMessage(text: 'updated message'),
          );

          // Create draft.updated event
          final draftUpdatedEvent = Event(
            cid: channel.cid,
            type: EventType.draftUpdated,
            draft: updatedDraft,
          );

          // Dispatch event
          client.addEvent(draftUpdatedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify channel draft was updated
          expect(channel.state?.draft, isNotNull);
          expect(channel.state?.draft?.message.text, 'updated message');
        },
      );

      test(
        'should update current thread draft if draft.updated event is emitted',
        () async {
          const threadParentMessageId = 'thread-parent-id';

          // Setup initial state with a thread draft
          final initialDraft = Draft(
            channelCid: channel.cid!,
            createdAt: DateTime.now(),
            parentId: threadParentMessageId,
            message: DraftMessage(text: 'thread reply'),
          );

          channel.state?.updateMessage(
            Message(
              id: threadParentMessageId,
              user: client.state.currentUser,
              draft: initialDraft,
            ),
          );

          // Verify initial state
          final draft = channel.state?.threadDraft(threadParentMessageId);
          expect(draft, isNotNull);
          expect(draft?.message.text, 'thread reply');

          // Create Draft
          final updatedDraft = initialDraft.copyWith(
            message: DraftMessage(text: 'updated thread reply'),
          );

          // Create draft.updated event
          final draftUpdatedEvent = Event(
            cid: channel.cid,
            type: EventType.draftUpdated,
            draft: updatedDraft,
          );

          // Dispatch event
          client.addEvent(draftUpdatedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify thread draft was updated
          final threadDraft = channel.state?.threadDraft(threadParentMessageId);
          expect(threadDraft, isNotNull);
          expect(threadDraft?.message.text, 'updated thread reply');
        },
      );

      test('an event without a draft is ignored', () async {
        client.addEvent(Event(cid: channel.cid, type: EventType.draftUpdated));
        await Future.delayed(Duration.zero);

        expect(channel.state?.draft, isNull);
      });
    });

    group('Location events', () {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      late Channel channel;

      setUp(() {
        final channelState = _generateChannelState(channelId, channelType);
        channel = Channel.fromState(client, channelState);
      });

      tearDown(() {
        channel.dispose();
      });

      test('should handle location.shared event', () async {
        // Verify initial state
        expect(channel.state?.activeLiveLocations, isEmpty);

        // Create live location
        final liveLocation = Location(
          channelCid: channel.cid,
          userId: 'user1',
          messageId: 'msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.now().add(const Duration(hours: 1)),
        );

        final locationMessage = Message(
          id: 'msg1',
          text: 'Live location shared',
          sharedLocation: liveLocation,
        );

        // Create location.shared event
        final locationSharedEvent = Event(
          cid: channel.cid,
          type: EventType.locationShared,
          message: locationMessage,
        );

        // Dispatch event
        client.addEvent(locationSharedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Check if message was added
        final messages = channel.state?.messages;
        final message = messages?.firstWhere((m) => m.id == 'msg1');
        expect(message, isNotNull);

        // Check if active live location was updated
        final activeLiveLocations = channel.state?.activeLiveLocations;
        expect(activeLiveLocations, hasLength(1));
        expect(activeLiveLocations?.first.messageId, equals('msg1'));
      });

      test('should handle location.updated event', () async {
        // Setup initial state with location message
        final liveLocation = Location(
          channelCid: channel.cid,
          userId: 'user1',
          messageId: 'msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.now().add(const Duration(hours: 1)),
        );

        final locationMessage = Message(
          id: 'msg1',
          text: 'Live location shared',
          sharedLocation: liveLocation,
        );

        // Add initial message
        channel.state?.addNewMessage(locationMessage);

        // Create updated location
        final updatedLocation = liveLocation.copyWith(
          latitude: 40.7500, // Updated latitude
          longitude: -74.1000, // Updated longitude
        );

        final updatedMessage = locationMessage.copyWith(
          sharedLocation: updatedLocation,
        );

        // Create location.updated event
        final locationUpdatedEvent = Event(
          cid: channel.cid,
          type: EventType.locationUpdated,
          message: updatedMessage,
        );

        // Dispatch event
        client.addEvent(locationUpdatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Check if message was updated
        final messages = channel.state?.messages;
        final message = messages?.firstWhere((m) => m.id == 'msg1');
        expect(message?.sharedLocation?.latitude, equals(40.7500));
        expect(message?.sharedLocation?.longitude, equals(-74.1000));

        // Check if active live location was updated
        final activeLiveLocations = channel.state?.activeLiveLocations;
        expect(activeLiveLocations, hasLength(1));
        expect(activeLiveLocations?.first.latitude, equals(40.7500));
        expect(activeLiveLocations?.first.longitude, equals(-74.1000));
      });

      test('should handle location.expired event', () async {
        // Setup initial state with location message
        final liveLocation = Location(
          channelCid: channel.cid,
          userId: 'user1',
          messageId: 'msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.now().add(const Duration(hours: 1)),
        );

        final locationMessage = Message(
          id: 'msg1',
          text: 'Live location shared',
          sharedLocation: liveLocation,
        );

        // Add initial message
        channel.state?.addNewMessage(locationMessage);
        expect(channel.state?.activeLiveLocations, hasLength(1));

        // Create expired location
        final expiredLocation = liveLocation.copyWith(
          endAt: DateTime.now().subtract(const Duration(hours: 1)),
        );

        final expiredMessage = locationMessage.copyWith(
          sharedLocation: expiredLocation,
        );

        // Create location.expired event
        final locationExpiredEvent = Event(
          cid: channel.cid,
          type: EventType.locationExpired,
          message: expiredMessage,
        );

        // Dispatch event
        client.addEvent(locationExpiredEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Check if message was updated
        final messages = channel.state?.messages;
        final message = messages?.firstWhere((m) => m.id == 'msg1');
        expect(message?.sharedLocation?.isExpired, isTrue);

        // Check if active live location was removed
        expect(channel.state?.activeLiveLocations, isEmpty);
      });

      test("should auto-expire another user's live location once at endAt", () async {
        final liveLocation = Location(
          channelCid: channel.cid,
          userId: 'user1', // Another user.
          messageId: 'msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.now().add(const Duration(milliseconds: 800)),
        );

        channel.state?.addNewMessage(
          Message(id: 'msg1', sharedLocation: liveLocation),
        );
        expect(channel.state?.activeLiveLocations, hasLength(1));

        // Before endAt no expiry event is emitted.
        await Future.delayed(const Duration(milliseconds: 200));
        verifyNever(() => client.handleEvent(any()));

        // After endAt the scheduler emits exactly one location.expired event.
        await Future.delayed(const Duration(milliseconds: 900));
        final captured = verify(() => client.handleEvent(captureAny())).captured;
        expect(captured, hasLength(1));
        final event = captured.single as Event;
        expect(event.type, EventType.locationExpired);
        expect(event.message?.id, 'msg1');
      });

      test("should not auto-expire the current user's own live location", () async {
        final ownLocation = Location(
          channelCid: channel.cid,
          userId: 'test-user-id', // The current user (handled by the client).
          messageId: 'msg-own',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.now().add(const Duration(milliseconds: 150)),
        );

        channel.state?.addNewMessage(
          Message(id: 'msg-own', sharedLocation: ownLocation),
        );
        expect(channel.state?.activeLiveLocations, hasLength(1));

        // The channel scheduler skips the current user's own locations, so no
        // expiry event is emitted even after endAt passes.
        await Future.delayed(const Duration(milliseconds: 300));
        verifyNever(() => client.handleEvent(any()));
      });

      test("should auto-expire another user's location that arrives expired", () async {
        final expiredLocation = Location(
          channelCid: channel.cid,
          userId: 'user1', // Another user.
          messageId: 'msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.now().subtract(const Duration(minutes: 5)),
        );

        // Mirrors a query/watch response whose live location is already past
        // endAt by the local clock, e.g. when the device clock runs ahead of
        // the server or endAt passed while the response was in flight.
        channel.state?.updateChannelState(
          ChannelState(messages: const [], activeLiveLocations: [expiredLocation]),
        );
        expect(channel.state?.activeLiveLocations, hasLength(1));

        // The scheduler fires straight away and emits exactly one event.
        await Future.delayed(const Duration(milliseconds: 100));
        final captured = verify(() => client.handleEvent(captureAny())).captured;
        expect(captured, hasLength(1));
        final event = captured.single as Event;
        expect(event.type, EventType.locationExpired);
        expect(event.message?.id, 'msg1');
      });

      test('should not add static location to active locations', () async {
        final staticLocation = Location(
          channelCid: channel.cid,
          userId: 'user1',
          messageId: 'msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          // No endAt - static location
        );

        final staticMessage = Message(
          id: 'msg1',
          text: 'Static location shared',
          sharedLocation: staticLocation,
        );

        // Create location.shared event
        final locationSharedEvent = Event(
          cid: channel.cid,
          type: EventType.locationShared,
          message: staticMessage,
        );

        // Dispatch event
        client.addEvent(locationSharedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Check if message was added
        final messages = channel.state?.messages;
        final message = messages?.firstWhere((m) => m.id == 'msg1');
        expect(message?.sharedLocation, isNotNull);

        // Check if active live location was NOT updated (should remain empty)
        expect(channel.state?.activeLiveLocations, isEmpty);
      });

      test(
        'should update active locations when location message is deleted',
        () async {
          final liveLocation = Location(
            channelCid: channel.cid,
            userId: 'user1',
            messageId: 'msg1',
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device1',
            endAt: DateTime.now().add(const Duration(hours: 1)),
          );

          final locationMessage = Message(
            id: 'msg1',
            text: 'Live location shared',
            sharedLocation: liveLocation,
          );

          // Verify initial state
          channel.state?.addNewMessage(locationMessage);
          expect(channel.state?.activeLiveLocations, hasLength(1));

          final messageDeletedEvent = Event(
            type: EventType.messageDeleted,
            cid: channel.cid,
            message: locationMessage.copyWith(
              type: MessageType.deleted,
              deletedAt: DateTime.timestamp(),
            ),
          );

          // Dispatch event
          client.addEvent(messageDeletedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify active locations are updated
          expect(channel.state?.activeLiveLocations, isEmpty);
        },
      );

      test('should merge locations with same key', () async {
        final liveLocation = Location(
          channelCid: channel.cid,
          userId: 'user1',
          messageId: 'msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.now().add(const Duration(hours: 1)),
        );

        final locationMessage = Message(
          id: 'msg1',
          text: 'Live location shared',
          sharedLocation: liveLocation,
        );

        // Add initial location for setup
        channel.state?.addNewMessage(locationMessage);
        expect(channel.state?.activeLiveLocations, hasLength(1));

        // Create new location with same user, channel, and device
        final newLocation = Location(
          channelCid: channel.cid,
          userId: 'user1', // Same user
          messageId: 'msg2', // Different message
          latitude: 40.7500,
          longitude: -74.1000,
          createdByDeviceId: 'device1', // Same device
          endAt: DateTime.now().add(const Duration(hours: 2)),
        );

        final newMessage = Message(
          id: 'msg2',
          text: 'Updated location',
          sharedLocation: newLocation,
        );

        // Create location.shared event for the new message
        final locationSharedEvent = Event(
          cid: channel.cid,
          type: EventType.locationShared,
          message: newMessage,
        );

        // Dispatch event
        client.addEvent(locationSharedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Should still have only one active location (merged)
        final activeLiveLocations = channel.state?.activeLiveLocations;
        expect(activeLiveLocations, hasLength(1));
        expect(activeLiveLocations?.first.messageId, equals('msg2'));
        expect(activeLiveLocations?.first.latitude, equals(40.7500));
      });

      test(
        'should handle multiple active locations from different devices',
        () async {
          final liveLocation = Location(
            channelCid: channel.cid,
            userId: 'user1',
            messageId: 'msg1',
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device1',
            endAt: DateTime.now().add(const Duration(hours: 1)),
          );

          final locationMessage = Message(
            id: 'msg1',
            text: 'Live location shared',
            sharedLocation: liveLocation,
          );

          // Add first location for setup
          channel.state?.addNewMessage(locationMessage);
          expect(channel.state?.activeLiveLocations, hasLength(1));

          // Create location from different device
          final location2 = Location(
            channelCid: channel.cid,
            userId: 'user1', // Same user
            messageId: 'msg2',
            latitude: 34.0522,
            longitude: -118.2437,
            createdByDeviceId: 'device2', // Different device
            endAt: DateTime.now().add(const Duration(hours: 1)),
          );

          final message2 = Message(
            id: 'msg2',
            text: 'Location from device 2',
            sharedLocation: location2,
          );

          // Create location.shared event for the second message
          final locationSharedEvent = Event(
            cid: channel.cid,
            type: EventType.locationShared,
            message: message2,
          );

          // Dispatch event
          client.addEvent(locationSharedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Should have two active locations
          expect(channel.state?.activeLiveLocations, hasLength(2));
        },
      );

      test('should handle location messages in threads', () async {
        final parentMessage = Message(
          id: 'parent1',
          text: 'Thread parent',
        );

        // Add parent message first for setup
        channel.state?.addNewMessage(parentMessage);

        final liveLocation = Location(
          channelCid: channel.cid,
          userId: 'user1',
          messageId: 'thread-msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.now().add(const Duration(hours: 1)),
        );

        final threadLocationMessage = Message(
          id: 'thread-msg1',
          text: 'Live location in thread',
          parentId: 'parent1',
          sharedLocation: liveLocation,
        );

        // Create location.shared event for the thread message
        final locationSharedEvent = Event(
          cid: channel.cid,
          type: EventType.locationShared,
          message: threadLocationMessage,
        );

        // Dispatch event
        client.addEvent(locationSharedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Check if thread message was added
        final thread = channel.state?.threads['parent1'];
        expect(thread, contains(threadLocationMessage));

        // Check if location was added to active locations
        final activeLiveLocations = channel.state?.activeLiveLocations;
        expect(activeLiveLocations, hasLength(1));
        expect(activeLiveLocations?.first.messageId, equals('thread-msg1'));
      });

      test('should update thread location messages', () async {
        final parentMessage = Message(
          id: 'parent1',
          text: 'Thread parent',
        );

        final liveLocation = Location(
          channelCid: channel.cid,
          userId: 'user1',
          messageId: 'thread-msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.now().add(const Duration(hours: 1)),
        );

        final threadLocationMessage = Message(
          id: 'thread-msg1',
          text: 'Live location in thread',
          parentId: 'parent1',
          sharedLocation: liveLocation,
        );

        // Add messages
        channel.state?.addNewMessage(parentMessage);
        channel.state?.addNewMessage(threadLocationMessage);

        // Update the location
        final updatedLocation = liveLocation.copyWith(
          latitude: 40.7500,
          longitude: -74.1000,
        );

        final updatedThreadMessage = threadLocationMessage.copyWith(
          sharedLocation: updatedLocation,
        );

        // Create location.updated event for the thread message
        final locationUpdatedEvent = Event(
          cid: channel.cid,
          type: EventType.locationUpdated,
          message: updatedThreadMessage,
        );

        // Dispatch event
        client.addEvent(locationUpdatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Check if thread message was updated
        final thread = channel.state?.threads['parent1'];
        final threadMessage = thread?.firstWhere((m) => m.id == 'thread-msg1');
        expect(threadMessage?.sharedLocation?.latitude, equals(40.7500));
        expect(threadMessage?.sharedLocation?.longitude, equals(-74.1000));

        // Check if active location was updated
        final activeLiveLocations = channel.state?.activeLiveLocations;
        expect(activeLiveLocations, hasLength(1));
        expect(activeLiveLocations?.first.latitude, equals(40.7500));
        expect(activeLiveLocations?.first.longitude, equals(-74.1000));
      });
    });

    group('Channel push preference events', () {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      late Channel channel;

      setUp(() {
        final channelState = _generateChannelState(channelId, channelType);
        channel = Channel.fromState(client, channelState);
      });

      tearDown(() {
        channel.dispose();
      });

      test('should handle channel.push_preference.updated event', () async {
        // Verify initial state
        expect(channel.state?.channelState.pushPreferences, isNull);

        // Create channel push preference
        final channelPushPreference = ChannelPushPreference(
          chatLevel: ChatLevel.mentions,
          disabledUntil: DateTime.now().add(const Duration(hours: 1)),
        );

        // Create channel.push_preference.updated event
        final channelPushPreferenceUpdatedEvent = Event(
          cid: channel.cid,
          type: EventType.channelPushPreferenceUpdated,
          channelPushPreference: channelPushPreference,
        );

        // Dispatch event
        client.addEvent(channelPushPreferenceUpdatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Verify channel push preferences were updated
        final updatedPreferences = channel.state?.channelState.pushPreferences;
        expect(updatedPreferences, isNotNull);
        expect(updatedPreferences?.chatLevel, ChatLevel.mentions);
        expect(
          updatedPreferences?.disabledUntil,
          channelPushPreference.disabledUntil,
        );
      });

      test('should update existing channel push preferences', () async {
        // Set initial push preferences
        const initialPushPreference = ChannelPushPreference(
          chatLevel: ChatLevel.all,
        );

        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            pushPreferences: initialPushPreference,
          ),
        );

        // Verify initial state
        final pushPreferences = channel.state?.channelState.pushPreferences;
        expect(pushPreferences?.chatLevel, ChatLevel.all);
        expect(pushPreferences?.disabledUntil, isNull);

        // Create updated channel push preference
        final updatedPushPreference = ChannelPushPreference(
          chatLevel: ChatLevel.none,
          disabledUntil: DateTime.now().add(const Duration(hours: 2)),
        );

        // Create channel.push_preference.updated event
        final channelPushPreferenceUpdatedEvent = Event(
          cid: channel.cid,
          type: EventType.channelPushPreferenceUpdated,
          channelPushPreference: updatedPushPreference,
        );

        // Dispatch event
        client.addEvent(channelPushPreferenceUpdatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Verify channel push preferences were updated
        final updatedPreferences = channel.state?.channelState.pushPreferences;
        expect(updatedPreferences?.chatLevel, ChatLevel.none);
        expect(
          updatedPreferences?.disabledUntil,
          updatedPushPreference.disabledUntil,
        );
      });

      test('an event without a push preference is ignored', () async {
        client.addEvent(Event(cid: channel.cid, type: EventType.channelPushPreferenceUpdated));
        await Future.delayed(Duration.zero);

        expect(channel.state?.channelState.pushPreferences, isNull);
      });
    });

    group('User messages deleted event', () {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      late Channel channel;
      late MockPersistenceClient persistenceClient;

      setUp(() {
        persistenceClient = MockPersistenceClient();
        when(() => client.chatPersistenceClient).thenReturn(persistenceClient);
        when(
          () => persistenceClient.deleteMessagesFromUser(
            cid: any(named: 'cid'),
            userId: any(named: 'userId'),
            hardDelete: any(named: 'hardDelete'),
            deletedAt: any(named: 'deletedAt'),
          ),
        ).thenAnswer((_) async {});
        when(() => persistenceClient.deleteMessageByIds(any())).thenAnswer((_) async {});
        when(() => persistenceClient.deletePinnedMessageByIds(any())).thenAnswer((_) async {});
        when(() => persistenceClient.getChannelThreads(any())).thenAnswer((_) async => <String, List<Message>>{});

        final channelState = _generateChannelState(channelId, channelType);
        channel = Channel.fromState(client, channelState);
      });

      tearDown(() {
        channel.dispose();
      });

      test(
        'should soft delete all messages from user when hardDelete is false',
        () async {
          // Setup: Add messages from different users
          final user1 = User(id: 'user-1', name: 'User 1');
          final user2 = User(id: 'user-2', name: 'User 2');

          final message1 = Message(
            id: 'msg-1',
            text: 'Message from user 1',
            user: user1,
          );
          final message2 = Message(
            id: 'msg-2',
            text: 'Another message from user 1',
            user: user1,
          );
          final message3 = Message(
            id: 'msg-3',
            text: 'Message from user 2',
            user: user2,
          );

          channel.state?.addNewMessage(message1);
          channel.state?.addNewMessage(message2);
          channel.state?.addNewMessage(message3);

          // Verify initial state
          expect(channel.state?.messages.length, equals(3));
          expect(
            channel.state?.messages.where((m) => m.user?.id == 'user-1').length,
            equals(2),
          );
          expect(
            channel.state?.messages.where((m) => m.user?.id == 'user-2').length,
            equals(1),
          );

          // Create user.messages.deleted event (soft delete)
          final deletedAt = DateTime.now();
          final userMessagesDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.userMessagesDeleted,
            user: user1,
            hardDelete: false,
            createdAt: deletedAt,
          );

          // Dispatch event
          client.addEvent(userMessagesDeletedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify user1's messages are soft deleted
          expect(channel.state?.messages.length, equals(3));
          final deletedMessages = channel.state?.messages.where((m) => m.user?.id == 'user-1').toList();
          expect(deletedMessages?.length, equals(2));
          for (final message in deletedMessages!) {
            expect(message.type, equals(MessageType.deleted));
            expect(message.deletedAt, isNotNull);
            expect(message.state.isDeleted, isTrue);
          }

          // Verify user2's message is unaffected
          final user2Message = channel.state?.messages.firstWhere((m) => m.id == 'msg-3');
          expect(user2Message?.type, isNot(MessageType.deleted));
          expect(user2Message?.deletedAt, isNull);
        },
      );

      test(
        'should hard delete all messages from user when hardDelete is true',
        () async {
          // Setup: Add messages from different users
          final user1 = User(id: 'user-1', name: 'User 1');
          final user2 = User(id: 'user-2', name: 'User 2');

          final message1 = Message(
            id: 'msg-1',
            text: 'Message from user 1',
            user: user1,
          );
          final message2 = Message(
            id: 'msg-2',
            text: 'Another message from user 1',
            user: user1,
          );
          final message3 = Message(
            id: 'msg-3',
            text: 'Message from user 2',
            user: user2,
          );

          channel.state?.addNewMessage(message1);
          channel.state?.addNewMessage(message2);
          channel.state?.addNewMessage(message3);

          // Verify initial state
          expect(channel.state?.messages.length, equals(3));

          // Create user.messages.deleted event (hard delete)
          final userMessagesDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.userMessagesDeleted,
            user: user1,
            hardDelete: true,
          );

          // Dispatch event
          client.addEvent(userMessagesDeletedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify user1's messages are removed
          expect(channel.state?.messages.length, equals(1));
          expect(
            channel.state?.messages.any((m) => m.user?.id == 'user-1'),
            isFalse,
          );

          // Verify user2's message still exists
          final user2Message = channel.state?.messages.firstWhere((m) => m.id == 'msg-3');
          expect(user2Message, isNotNull);
          expect(user2Message?.user?.id, equals('user-2'));
        },
      );

      test(
        'should handle thread messages from user',
        () async {
          // Setup: Add parent and thread messages
          final user1 = User(id: 'user-1', name: 'User 1');
          final user2 = User(id: 'user-2', name: 'User 2');

          final parentMessage = Message(
            id: 'parent-msg',
            text: 'Parent message',
            user: user2,
          );
          final threadMessage1 = Message(
            id: 'thread-msg-1',
            text: 'Thread message from user 1',
            user: user1,
            parentId: 'parent-msg',
          );
          final threadMessage2 = Message(
            id: 'thread-msg-2',
            text: 'Another thread message from user 1',
            user: user1,
            parentId: 'parent-msg',
          );

          channel.state?.addNewMessage(parentMessage);
          channel.state?.addNewMessage(threadMessage1);
          channel.state?.addNewMessage(threadMessage2);

          // Verify initial state
          expect(channel.state?.messages.length, equals(1));
          expect(channel.state?.threads['parent-msg']?.length, equals(2));

          // Create user.messages.deleted event (soft delete)
          final userMessagesDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.userMessagesDeleted,
            user: user1,
            hardDelete: false,
          );

          // Dispatch event
          client.addEvent(userMessagesDeletedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify thread messages are soft deleted
          final threadMessages = channel.state?.threads['parent-msg'];
          expect(threadMessages?.length, equals(2));
          for (final message in threadMessages!) {
            expect(message.type, equals(MessageType.deleted));
            expect(message.state.isDeleted, isTrue);
          }

          // Verify parent message is unaffected
          final parent = channel.state?.messages.first;
          expect(parent?.type, isNot(MessageType.deleted));
        },
      );

      test(
        'should do nothing when user is null',
        () async {
          // Setup: Add messages
          final user1 = User(id: 'user-1', name: 'User 1');
          final message1 = Message(
            id: 'msg-1',
            text: 'Message from user 1',
            user: user1,
          );

          channel.state?.addNewMessage(message1);

          // Verify initial state
          expect(channel.state?.messages.length, equals(1));

          // Create user.messages.deleted event without user
          final userMessagesDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.userMessagesDeleted,
            hardDelete: false,
          );

          // Dispatch event
          client.addEvent(userMessagesDeletedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify messages are unaffected
          expect(channel.state?.messages.length, equals(1));
          expect(
            channel.state?.messages.first.type,
            isNot(MessageType.deleted),
          );
        },
      );

      test(
        'should handle empty message list',
        () async {
          // Setup: Empty channel
          expect(channel.state?.messages.length, equals(0));

          // Create user.messages.deleted event
          final userMessagesDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.userMessagesDeleted,
            user: User(id: 'user-1'),
            hardDelete: false,
          );

          // Dispatch event - should not throw
          client.addEvent(userMessagesDeletedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify state is still empty
          expect(channel.state?.messages.length, equals(0));
        },
      );

      test(
        'should delete messages from persistence when hardDelete is true',
        () async {
          // Setup: Add messages from different users
          final user1 = User(id: 'user-1', name: 'User 1');
          final user2 = User(id: 'user-2', name: 'User 2');

          final message1 = Message(
            id: 'msg-1',
            text: 'Message from user 1',
            user: user1,
          );
          final message2 = Message(
            id: 'msg-2',
            text: 'Another message from user 1',
            user: user1,
          );
          final message3 = Message(
            id: 'msg-3',
            text: 'Message from user 2',
            user: user2,
          );

          channel.state?.addNewMessage(message1);
          channel.state?.addNewMessage(message2);
          channel.state?.addNewMessage(message3);

          // Verify initial state
          expect(channel.state?.messages.length, equals(3));

          // Create user.messages.deleted event (hard delete)
          final userMessagesDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.userMessagesDeleted,
            user: user1,
            hardDelete: true,
          );

          // Dispatch event
          client.addEvent(userMessagesDeletedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify messages are removed from persistence
          verify(
            () => persistenceClient.deleteMessageByIds(['msg-1', 'msg-2']),
          ).called(1);
          verify(
            () => persistenceClient.deletePinnedMessageByIds(['msg-1', 'msg-2']),
          ).called(1);

          // Verify user1's messages are removed from state
          expect(channel.state?.messages.length, equals(1));
          expect(
            channel.state?.messages.any((m) => m.user?.id == 'user-1'),
            isFalse,
          );
        },
      );

      test(
        'should not delete from persistence when hardDelete is false',
        () async {
          // Setup: Add messages
          final user1 = User(id: 'user-1', name: 'User 1');
          final message1 = Message(
            id: 'msg-1',
            text: 'Message from user 1',
            user: user1,
          );

          channel.state?.addNewMessage(message1);

          // Create user.messages.deleted event (soft delete)
          final userMessagesDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.userMessagesDeleted,
            user: user1,
            hardDelete: false,
          );

          // Dispatch event
          client.addEvent(userMessagesDeletedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify persistence deletion methods were NOT called
          verifyNever(() => persistenceClient.deleteMessageByIds(any()));
          verifyNever(() => persistenceClient.deletePinnedMessageByIds(any()));

          // Verify message is soft deleted (still in state)
          expect(channel.state?.messages.length, equals(1));
          expect(channel.state?.messages.first.type, equals(MessageType.deleted));
        },
      );

      test(
        'should delete all user messages including those only in storage',
        () async {
          final user1 = User(id: 'user-1', name: 'User 1');
          final user2 = User(id: 'user-2', name: 'User 2');

          final stateMessage1 = Message(
            id: 'msg-1',
            text: 'Message from user 1 in state',
            user: user1,
            pinned: true,
          );
          final stateMessage2 = Message(
            id: 'msg-2',
            text: 'Message from user 2 in state',
            user: user2,
          );
          final stateThreadMessage1 = Message(
            id: 'thread-msg-1',
            text: 'Thread message from user 1 in state',
            user: user1,
            parentId: 'msg-1',
          );
          final stateThreadMessage2 = Message(
            id: 'thread-msg-2',
            text: 'Another thread message from user 2 in state',
            user: user2,
            parentId: 'msg-1',
          );

          // Load the state with only 2 messages and 1 thread with 2 replies.
          // Note: In reality, storage may contain many more user1 messages
          // (e.g., older messages not loaded into state yet), but the delete
          // operation should remove ALL of them from storage.
          channel.state?.addNewMessage(stateMessage1);
          channel.state?.addNewMessage(stateMessage2);
          channel.state?.addNewMessage(stateThreadMessage1);
          channel.state?.addNewMessage(stateThreadMessage2);

          // Verify initial state has only 2 messages and 1 thread with 2 replies
          expect(channel.state?.messages.length, equals(2));
          expect(channel.state?.threads['msg-1']?.length, equals(2));

          // Create user.messages.deleted event (hard delete)
          final userMessagesDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.userMessagesDeleted,
            user: user1,
            hardDelete: true,
          );

          // Dispatch event
          client.addEvent(userMessagesDeletedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify user1's messages are removed from state
          expect(channel.state?.messages.length, equals(1));
          expect(channel.state?.threads['msg-1']?.length, equals(1));

          expect(
            channel.state?.messages.any((m) => m.user?.id == 'user-1'),
            isFalse,
          );

          expect(
            channel.state?.threads['msg-1']?.any((m) => m.user?.id == 'user-1'),
            isFalse,
          );

          // Verify persistence delete was called - this handles ALL messages
          // in storage (both those in state AND those only in storage)
          verify(
            () => persistenceClient.deleteMessagesFromUser(
              cid: channel.cid,
              userId: user1.id,
              hardDelete: true,
              deletedAt: any(named: 'deletedAt'),
            ),
          ).called(1);

          // Verify in-state messages were also removed from state's persistence
          final capturedIds =
              verify(
                    () => persistenceClient.deleteMessageByIds(captureAny()),
                  ).captured.first
                  as List<String>;

          expect(
            capturedIds,
            containsAll([
              'msg-1', // state message
              'thread-msg-1', // state thread message
            ]),
          );
        },
      );

      test(
        'should delete every authored message across threads without '
        'cross-thread leakage (regression: _updateThreadMessages)',
        () async {
          // user-1 authors a top-level message AND replies in two different
          // threads (owned by user-2). The user.messages.deleted flow
          // collects everything from user-1 across channel + threads and
          // routes it through a single _updateMessages batch — historically
          // this batch was passed unfiltered to every affected thread's
          // merge, so replies to thread A leaked into thread B and v.v.
          final user1 = User(id: 'user-1', name: 'User 1');
          final user2 = User(id: 'user-2', name: 'User 2');

          final parentA = Message(id: 'parent-A', text: 'Thread A', user: user2);
          final parentB = Message(id: 'parent-B', text: 'Thread B', user: user2);

          final topLevelFromUser1 = Message(
            id: 'top-1',
            text: 'user-1 top-level message',
            user: user1,
          );
          final replyA = Message(
            id: 'reply-A',
            text: 'user-1 reply in thread A',
            user: user1,
            parentId: 'parent-A',
          );
          final replyB = Message(
            id: 'reply-B',
            text: 'user-1 reply in thread B',
            user: user1,
            parentId: 'parent-B',
          );

          channel.state?.addNewMessage(parentA);
          channel.state?.addNewMessage(parentB);
          channel.state?.addNewMessage(topLevelFromUser1);
          channel.state?.addNewMessage(replyA);
          channel.state?.addNewMessage(replyB);

          // Initial state: each thread has exactly its own reply.
          expect(
            channel.state?.threads['parent-A']?.map((m) => m.id),
            equals(['reply-A']),
          );
          expect(
            channel.state?.threads['parent-B']?.map((m) => m.id),
            equals(['reply-B']),
          );

          // Trigger the multi-thread batch via user.messages.deleted.
          final userMessagesDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.userMessagesDeleted,
            user: user1,
            hardDelete: false,
          );
          client.addEvent(userMessagesDeletedEvent);
          await Future.delayed(Duration.zero);

          // 1) Thread membership is preserved — no cross-thread leakage.
          //    Without the fix, replyB would leak into thread A and v.v.
          expect(
            channel.state?.threads['parent-A']?.map((m) => m.id),
            equals(['reply-A']),
            reason: 'thread A must not contain replies from thread B',
          );
          expect(
            channel.state?.threads['parent-B']?.map((m) => m.id),
            equals(['reply-B']),
            reason: 'thread B must not contain replies from thread A',
          );

          // 2) Every message authored by user-1 is soft-deleted — top-level
          //    AND in both threads. The fix must not narrow this scope.
          expect(
            channel.state?.messages.firstWhere((m) => m.id == 'top-1').type,
            equals(MessageType.deleted),
            reason: 'top-level user-1 message must be deleted',
          );
          expect(
            channel.state?.threads['parent-A']?.first.type,
            equals(MessageType.deleted),
            reason: 'thread A reply from user-1 must be deleted',
          );
          expect(
            channel.state?.threads['parent-B']?.first.type,
            equals(MessageType.deleted),
            reason: 'thread B reply from user-1 must be deleted',
          );

          // 3) Other users' messages are unaffected.
          expect(
            channel.state?.messages.firstWhere((m) => m.id == 'parent-A').type,
            isNot(MessageType.deleted),
          );
          expect(
            channel.state?.messages.firstWhere((m) => m.id == 'parent-B').type,
            isNot(MessageType.deleted),
          );
        },
      );
    });
  });

  group('Local unread count', () {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    final currentUser = OwnUser(id: 'current-user-id');

    late final client = MockStreamChatClient();

    setUpAll(() {
      when(() => client.detachedLogger(any())).thenAnswer((invocation) {
        final name = invocation.positionalArguments.first;
        return _createLogger(name);
      });
      when(() => client.retryPolicy).thenReturn(
        RetryPolicy(shouldRetry: (_, __, ___) => false, delayFactor: Duration.zero),
      );
      when(() => client.state).thenReturn(FakeClientState(currentUser: currentUser));
      when(() => client.logger).thenReturn(_createLogger('mock-client-logger'));
      when(
        () => client.channelDeliveryReporter.submitForDelivery(any()),
      ).thenAnswer((_) async {});
      when(
        () => client.channelDeliveryReporter.reconcileDelivery(any()),
      ).thenAnswer((_) async {});
      client.isLocalUnreadCountEnabled = true;
    });

    // A "livestream-like" channel: read events are disabled, both via the
    // channel-type config and the current user's own capabilities.
    Channel _createLivestreamChannel({
      StreamChatClient? overrideClient,
      List<Message>? messages,
      List<Read>? reads,
    }) {
      final channelState = ChannelState(
        channel: ChannelModel(
          id: channelId,
          type: channelType,
          config: ChannelConfig(readEvents: false),
          ownCapabilities: const [], // No readEvents capability.
        ),
        messages: messages,
        read: reads,
      );

      final channel = Channel.fromState(overrideClient ?? client, channelState);
      addTearDown(channel.dispose);
      return channel;
    }

    test(
      'increments unreadCount locally for new messages when the channel has '
      'no read events capability',
      () async {
        final channel = _createLivestreamChannel();
        expect(channel.state?.unreadCount, equals(0));

        final message = Message(
          id: 'message-1',
          text: 'Hello',
          user: User(id: 'other-user'),
          createdAt: DateTime(2024, 1, 1),
        );

        client.addEvent(
          Event(cid: channel.cid, type: EventType.messageNew, message: message),
        );
        await Future.delayed(Duration.zero);

        expect(channel.state?.unreadCount, equals(1));
      },
    );

    test(
      'does not increment unreadCount when local unread count tracking is '
      'disabled',
      () async {
        final disabledClient = MockStreamChatClient();
        when(() => disabledClient.detachedLogger(any())).thenAnswer((invocation) {
          final name = invocation.positionalArguments.first;
          return _createLogger(name);
        });
        when(() => disabledClient.retryPolicy).thenReturn(
          RetryPolicy(shouldRetry: (_, __, ___) => false),
        );
        when(() => disabledClient.state).thenReturn(FakeClientState(currentUser: currentUser));
        when(() => disabledClient.logger).thenReturn(_createLogger('mock-client-logger'));
        when(
          () => disabledClient.channelDeliveryReporter.submitForDelivery(any()),
        ).thenAnswer((_) async {});
        // `isLocalUnreadCountEnabled` defaults to `false` on the mock.

        final channel = _createLivestreamChannel(overrideClient: disabledClient);

        final message = Message(
          id: 'message-1',
          text: 'Hello',
          user: User(id: 'other-user'),
          createdAt: DateTime(2024, 1, 1),
        );

        disabledClient.addEvent(
          Event(cid: channel.cid, type: EventType.messageNew, message: message),
        );
        await Future.delayed(Duration.zero);

        expect(channel.state?.unreadCount, equals(0));
      },
    );

    test('decrements unreadCount when a counted message is hard-deleted', () async {
      final message = Message(
        id: 'message-1',
        text: 'Hello',
        user: User(id: 'other-user'),
        createdAt: DateTime(2024, 1, 1),
      );
      final channel = _createLivestreamChannel(
        messages: [message],
        reads: [
          Read(
            user: currentUser,
            lastRead: message.createdAt.subtract(const Duration(days: 1)),
          ),
        ],
      );
      channel.state!.unreadCount = 1;
      expect(channel.state?.unreadCount, equals(1));

      client.addEvent(
        Event(
          cid: channel.cid,
          type: EventType.messageDeleted,
          message: message,
          hardDelete: true,
        ),
      );
      await Future.delayed(Duration.zero);

      expect(channel.state?.unreadCount, equals(0));
    });

    test('does not decrement unreadCount when a message is soft-deleted', () async {
      final message = Message(
        id: 'message-1',
        text: 'Hello',
        user: User(id: 'other-user'),
        createdAt: DateTime(2024, 1, 1),
      );
      final channel = _createLivestreamChannel(
        messages: [message],
        reads: [
          Read(
            user: currentUser,
            lastRead: message.createdAt.subtract(const Duration(days: 1)),
          ),
        ],
      );
      channel.state!.unreadCount = 1;

      client.addEvent(
        Event(
          cid: channel.cid,
          type: EventType.messageDeleted,
          message: message,
          hardDelete: false,
        ),
      );
      await Future.delayed(Duration.zero);

      expect(channel.state?.unreadCount, equals(1));
    });

    test(
      'markRead resets unreadCount locally without making a network request',
      () async {
        final channel = _createLivestreamChannel();
        channel.state!.unreadCount = 3;
        expect(channel.state?.unreadCount, equals(3));

        await expectLater(channel.markRead(), completes);

        expect(channel.state?.unreadCount, equals(0));
        verifyNever(
          () => client.markChannelRead(
            any(),
            any(),
            messageId: any(named: 'messageId'),
          ),
        );
      },
    );

    test(
      'markUnreadByTimestamp recomputes unreadCount locally without making a '
      'network request',
      () async {
        final now = DateTime(2024, 1, 1);
        final messages = [
          Message(
            id: 'm1',
            text: '1',
            user: User(id: 'other-user'),
            createdAt: now,
          ),
          Message(
            id: 'm2',
            text: '2',
            user: User(id: 'other-user'),
            createdAt: now.add(const Duration(minutes: 1)),
          ),
          Message(
            id: 'm3',
            text: '3',
            user: User(id: 'other-user'),
            createdAt: now.add(const Duration(minutes: 2)),
          ),
        ];
        final channel = _createLivestreamChannel(
          messages: messages,
          reads: [
            Read(user: currentUser, lastRead: now.add(const Duration(minutes: 5))),
          ],
        );
        expect(channel.state?.unreadCount, equals(0));

        await expectLater(
          channel.markUnreadByTimestamp(now.add(const Duration(seconds: 30))),
          completes,
        );

        // Only m2 and m3 were created after the given timestamp.
        expect(channel.state?.unreadCount, equals(2));
        verifyNever(
          () => client.markChannelUnreadByTimestamp(any(), any(), any()),
        );
      },
    );

    test(
      'markUnread throws when the message is not locally known',
      () async {
        final channel = _createLivestreamChannel();

        await expectLater(
          channel.markUnread('unknown-message-id'),
          throwsA(isA<StreamChatError>()),
        );
        verifyNever(
          () => client.markChannelUnread(any(), any(), any()),
        );
      },
    );

    test(
      'markRead reconciles pending delivery receipts',
      () async {
        final channel = _createLivestreamChannel();
        channel.state!.unreadCount = 2;

        await expectLater(channel.markRead(), completes);

        verify(
          () => client.channelDeliveryReporter.reconcileDelivery([channel]),
        ).called(1);
      },
    );

    group('local read boundary anchors', () {
      final start = DateTime(2024, 1, 1);
      final messages = [
        Message(
          id: 'm1',
          text: '1',
          user: User(id: 'other-user'),
          createdAt: start,
        ),
        Message(
          id: 'm2',
          text: '2',
          user: User(id: 'other-user'),
          createdAt: start.add(const Duration(minutes: 1)),
        ),
        Message(
          id: 'm3',
          text: '3',
          user: User(id: 'other-user'),
          createdAt: start.add(const Duration(minutes: 2)),
        ),
      ];

      test(
        'markUnread is inclusive of the anchor and points lastReadMessageId at '
        'the previous message',
        () async {
          final channel = _createLivestreamChannel(
            messages: messages,
            reads: [
              Read(user: currentUser, lastRead: start.add(const Duration(minutes: 5))),
            ],
          );

          await expectLater(channel.markUnread('m2'), completes);

          // m2 (the anchor) and m3 are unread; m1 stays read.
          expect(channel.state?.unreadCount, equals(2));
          expect(channel.state?.currentUserRead?.lastReadMessageId, equals('m1'));
          verifyNever(() => client.markChannelUnread(any(), any(), any()));
        },
      );

      test(
        'markUnread leaves lastReadMessageId null when the anchor is the oldest '
        'known message',
        () async {
          final channel = _createLivestreamChannel(
            messages: messages,
            reads: [
              Read(user: currentUser, lastRead: start.add(const Duration(minutes: 5))),
            ],
          );

          await expectLater(channel.markUnread('m1'), completes);

          expect(channel.state?.unreadCount, equals(3));
          expect(channel.state?.currentUserRead?.lastReadMessageId, isNull);
        },
      );

      test(
        'markUnreadByTimestamp is exclusive of the boundary and points '
        'lastReadMessageId at the newest message at or before it',
        () async {
          final channel = _createLivestreamChannel(
            messages: messages,
            reads: [
              Read(user: currentUser, lastRead: start.add(const Duration(minutes: 5))),
            ],
          );

          // Exactly m2's createdAt: m2 stays read, only m3 becomes unread.
          await expectLater(channel.markUnreadByTimestamp(messages[1].createdAt), completes);

          expect(channel.state?.unreadCount, equals(1));
          expect(channel.state?.currentUserRead?.lastReadMessageId, equals('m2'));
          verifyNever(() => client.markChannelUnreadByTimestamp(any(), any(), any()));
        },
      );

      test(
        'markUnread(id) and markUnreadByTimestamp(createdAt) intentionally '
        'differ by the anchor message',
        () async {
          final byId = _createLivestreamChannel(
            messages: messages,
            reads: [
              Read(user: currentUser, lastRead: start.add(const Duration(minutes: 5))),
            ],
          );
          final byTimestamp = _createLivestreamChannel(
            messages: messages,
            reads: [
              Read(user: currentUser, lastRead: start.add(const Duration(minutes: 5))),
            ],
          );

          await byId.markUnread('m2');
          await byTimestamp.markUnreadByTimestamp(messages[1].createdAt);

          // `markUnread` includes m2, `markUnreadByTimestamp` excludes it.
          expect(byId.state?.unreadCount, equals(2));
          expect(byTimestamp.state?.unreadCount, equals(1));

          // ...and they agree once the timestamp is nudged below the anchor.
          await byTimestamp.markUnreadByTimestamp(
            messages[1].createdAt.subtract(const Duration(microseconds: 1)),
          );
          expect(byTimestamp.state?.unreadCount, equals(2));
          expect(byTimestamp.state?.currentUserRead?.lastReadMessageId, equals('m1'));
        },
      );
    });

    test(
      'server payloads do not clobber the locally-tracked read state',
      () async {
        final channel = _createLivestreamChannel();
        channel.state!.unreadCount = 5;

        final serverRead = Read(
          user: currentUser,
          lastRead: DateTime.now(),
          unreadMessages: 0,
        );
        channel.state!.updateChannelStateFromServer(
          channel.state!.channelState.copyWith(read: [serverRead]),
        );

        expect(channel.state?.unreadCount, equals(5));
      },
    );

    test(
      'local (non-remote) state updates are not affected by the server-merge '
      'guard',
      () async {
        final channel = _createLivestreamChannel();
        channel.state!.unreadCount = 5;

        // A plain local mutation (via updateChannelState, not
        // updateChannelStateFromServer) should still be able to change the
        // locally-tracked read state.
        await expectLater(channel.markRead(), completes);

        expect(channel.state?.unreadCount, equals(0));
      },
    );
  });

  group('updateChannelState identity guard', () {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    late final client = MockStreamChatClient();

    setUpAll(() {
      when(() => client.detachedLogger(any())).thenAnswer((invocation) {
        final name = invocation.positionalArguments.first;
        return _createLogger(name);
      });
      when(() => client.retryPolicy).thenReturn(
        RetryPolicy(
          shouldRetry: (_, __, ___) => false,
          delayFactor: Duration.zero,
        ),
      );
      when(() => client.state).thenReturn(FakeClientState());
      when(() => client.logger).thenReturn(_createLogger('mock-client-logger'));
      when(
        () => client.channelDeliveryReporter.submitForDelivery(any()),
      ).thenAnswer((_) async {});
    });

    Channel _seededChannel() {
      final base = _generateChannelState(channelId, channelType);
      final now = DateTime.now();
      final seeded = base.copyWith(
        messages: [
          Message(id: 'm1', text: '1', createdAt: now),
          Message(id: 'm2', text: '2', createdAt: now.add(const Duration(seconds: 1))),
          Message(id: 'm3', text: '3', createdAt: now.add(const Duration(seconds: 2))),
        ],
      );
      return Channel.fromState(client, seeded);
    }

    test(
      'preserves messages reference when updatedState.messages is null',
      () {
        final channel = _seededChannel();
        addTearDown(channel.dispose);

        final before = channel.state!.messages;
        channel.state!.updateChannelState(
          ChannelState(channel: channel.state!.channelState.channel),
        );
        final after = channel.state!.messages;

        expect(identical(before, after), isTrue);
      },
    );

    test(
      'preserves messages reference when updatedState.messages is identical',
      () {
        final channel = _seededChannel();
        addTearDown(channel.dispose);

        final before = channel.state!.messages;
        // copyWith without messages keeps the same `messages` reference, so
        // updateChannelState should hit the identity-guard fast path.
        channel.state!.updateChannelState(
          channel.state!.channelState.copyWith(
            read: [
              Read(
                user: User(id: 'me'),
                lastRead: DateTime.now(),
                unreadMessages: 1,
              ),
            ],
          ),
        );
        final after = channel.state!.messages;

        expect(identical(before, after), isTrue);
      },
    );

    test(
      'still merges messages when updatedState.messages is a different list',
      () {
        final channel = _seededChannel();
        addTearDown(channel.dispose);

        final newMessage = Message(
          id: 'm4',
          text: '4',
          createdAt: DateTime.now().add(const Duration(seconds: 10)),
        );
        channel.state!.updateChannelState(
          ChannelState(
            channel: channel.state!.channelState.channel,
            messages: [newMessage],
          ),
        );

        expect(
          channel.state!.messages.map((m) => m.id),
          ['m1', 'm2', 'm3', 'm4'],
        );
      },
    );

    test('cold-path merge interleaves new messages in sorted order', () {
      final channel = _seededChannel();
      addTearDown(channel.dispose);

      final base = channel.state!.messages.first.createdAt;
      // Incoming list is sorted ascending by createdAt and slots between
      // the existing m1, m2, m3.
      final incoming = [
        Message(
          id: 'm1.5',
          text: 'between m1 and m2',
          createdAt: base.add(const Duration(milliseconds: 500)),
        ),
        Message(
          id: 'm2.5',
          text: 'between m2 and m3',
          createdAt: base.add(const Duration(milliseconds: 1500)),
        ),
      ];
      channel.state!.updateChannelState(
        ChannelState(
          channel: channel.state!.channelState.channel,
          messages: incoming,
        ),
      );

      expect(
        channel.state!.messages.map((m) => m.id),
        ['m1', 'm1.5', 'm2', 'm2.5', 'm3'],
      );
    });

    test('cold-path merge runs syncWith on overlapping ids', () {
      final channel = _seededChannel();
      addTearDown(channel.dispose);

      final localStamp = DateTime.now();
      // Seed m2 with a localCreatedAt that the incoming version doesn't
      // carry, so we can verify syncWith fired during the merge.
      channel.state!.updateMessage(
        Message(
          id: 'm2',
          text: '2',
          createdAt: channel.state!.messages.firstWhere((m) => m.id == 'm2').createdAt,
        ).copyWith(localCreatedAt: localStamp),
      );

      final incoming = [
        Message(
          id: 'm2',
          text: '2 (server)',
          createdAt: channel.state!.messages.firstWhere((m) => m.id == 'm2').createdAt,
        ),
      ];
      channel.state!.updateChannelState(
        ChannelState(
          channel: channel.state!.channelState.channel,
          messages: incoming,
        ),
      );

      final m2 = channel.state!.messages.firstWhere((m) => m.id == 'm2');
      expect(m2.text, '2 (server)');
      // Local-only field carried over by syncWith during the merge.
      expect(m2.localCreatedAt, localStamp);
    });
  });

  group('updateMessage quoted-rewrite', () {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    late final client = MockStreamChatClient();

    setUpAll(() {
      when(() => client.detachedLogger(any())).thenAnswer((invocation) {
        final name = invocation.positionalArguments.first;
        return _createLogger(name);
      });
      when(() => client.retryPolicy).thenReturn(
        RetryPolicy(
          shouldRetry: (_, __, ___) => false,
          delayFactor: Duration.zero,
        ),
      );
      when(() => client.state).thenReturn(FakeClientState());
      when(() => client.logger).thenReturn(_createLogger('mock-client-logger'));
      when(
        () => client.channelDeliveryReporter.submitForDelivery(any()),
      ).thenAnswer((_) async {});
    });

    Channel _seededChannel({required List<Message> messages}) {
      final base = _generateChannelState(channelId, channelType);
      return Channel.fromState(client, base.copyWith(messages: messages));
    }

    test(
      'rewrites quotedMessage on every quoter when target is deleted',
      () {
        final now = DateTime.now();
        final target = Message(id: 'target', text: 'hi', createdAt: now);
        final quoter1 = Message(
          id: 'q1',
          text: 'reply',
          quotedMessageId: 'target',
          quotedMessage: target,
          createdAt: now.add(const Duration(seconds: 1)),
        );
        final unrelated = Message(
          id: 'u1',
          text: 'other',
          createdAt: now.add(const Duration(seconds: 2)),
        );
        final quoter2 = Message(
          id: 'q2',
          text: 'reply2',
          quotedMessageId: 'target',
          quotedMessage: target,
          createdAt: now.add(const Duration(seconds: 3)),
        );

        final channel = _seededChannel(messages: [target, quoter1, unrelated, quoter2]);
        addTearDown(channel.dispose);

        final unrelatedBefore = channel.state!.messages.firstWhere((m) => m.id == 'u1');

        final deleted = target.copyWith(
          type: MessageType.deleted,
          deletedAt: now.add(const Duration(seconds: 5)),
        );
        channel.state!.updateMessage(deleted);

        final after = channel.state!.messages;
        final q1After = after.firstWhere((m) => m.id == 'q1');
        final q2After = after.firstWhere((m) => m.id == 'q2');
        final uAfter = after.firstWhere((m) => m.id == 'u1');

        expect(q1After.quotedMessage?.deletedAt, isNotNull);
        expect(q1After.quotedMessage?.type, MessageType.deleted);
        expect(q2After.quotedMessage?.deletedAt, isNotNull);
        expect(q2After.quotedMessage?.type, MessageType.deleted);
        // Unrelated messages must not be rebuilt by the rewrite.
        expect(identical(uAfter, unrelatedBefore), isTrue);
      },
    );

    test(
      'preserves messages reference when no message quotes the deleted one',
      () {
        final now = DateTime.now();
        final target = Message(id: 'target', text: 'hi', createdAt: now);
        final unrelated = Message(
          id: 'u1',
          text: 'other',
          createdAt: now.add(const Duration(seconds: 1)),
        );

        final channel = _seededChannel(messages: [target, unrelated]);
        addTearDown(channel.dispose);

        final deleted = target.copyWith(
          type: MessageType.deleted,
          deletedAt: now.add(const Duration(seconds: 5)),
        );
        channel.state!.updateMessage(deleted);

        // No message quotes `target`, so `updateIf` short-circuits and the
        // remaining messages keep their identities (only `target` itself was
        // replaced by `sortedUpsert`).
        final unrelatedAfter = channel.state!.messages.firstWhere((m) => m.id == 'u1');
        expect(identical(unrelatedAfter, unrelated), isTrue);
      },
    );

    test(
      'does not rewrite quotes when an existing quoted target is updated '
      'without being deleted',
      () {
        final now = DateTime.now();
        final target = Message(id: 'target', text: 'original', createdAt: now);
        final quoter = Message(
          id: 'q1',
          text: 'reply',
          quotedMessageId: 'target',
          quotedMessage: target,
          createdAt: now.add(const Duration(seconds: 1)),
        );

        final channel = _seededChannel(messages: [target, quoter]);
        addTearDown(channel.dispose);

        final quoterBefore = channel.state!.messages.firstWhere((m) => m.id == 'q1');

        // Plain text update — not a deletion.
        channel.state!.updateMessage(target.copyWith(text: 'edited'));

        final quoterAfter = channel.state!.messages.firstWhere((m) => m.id == 'q1');
        // `updateIf` is gated on `message.isDeleted`, so the quoter must keep
        // its identity (no allocation, no quoted-message overwrite).
        expect(identical(quoterAfter, quoterBefore), isTrue);
      },
    );
  });

  group('Message enrichment preservation on merge', () {
    late final client = MockStreamChatClient();
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    late Channel channel;

    setUpAll(() {
      registerFallbackValue(FakeMessage());
      registerFallbackValue(<Message>[]);

      when(() => client.detachedLogger(any())).thenAnswer((invocation) {
        final name = invocation.positionalArguments.first;
        return _createLogger(name);
      });

      when(() => client.logger).thenReturn(_createLogger('mock-client-logger'));

      final clientState = FakeClientState();
      when(() => client.state).thenReturn(clientState);

      final retryPolicy = RetryPolicy(
        shouldRetry: (_, __, ___) => false,
        delayFactor: Duration.zero,
      );
      when(() => client.retryPolicy).thenReturn(retryPolicy);
    });

    setUp(() {
      final channelState = _generateChannelState(channelId, channelType);
      channel = Channel.fromState(client, channelState);
    });

    tearDown(() {
      channel.dispose();
      clearInteractions(client);
    });

    test(
      'preserves the `poll` on a quotedMessage when the server omits it during '
      're-sync (regression: poll quote disappears after foregrounding)',
      () async {
        final pollUser = User(id: 'poll-author');
        final poll = Poll(
          id: 'poll-1',
          name: 'Pizza or pasta?',
          options: const [
            PollOption(id: 'opt-1', text: 'Pizza'),
            PollOption(id: 'opt-2', text: 'Pasta'),
          ],
          createdById: pollUser.id,
        );

        final pollMessage = Message(
          id: 'poll-msg-1',
          poll: poll,
          pollId: poll.id,
          user: pollUser,
          createdAt: DateTime.utc(2026, 4, 29, 10),
        );

        final replyToPoll = Message(
          id: 'reply-1',
          text: 'Voting now',
          quotedMessageId: pollMessage.id,
          quotedMessage: pollMessage,
          user: User(id: 'reply-user'),
          createdAt: DateTime.utc(2026, 4, 29, 11),
        );

        // Seed channel state with the fully-enriched messages (mirrors what
        // the local DB load produces).
        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            messages: [pollMessage, replyToPoll],
          ),
        );

        // Simulate a re-sync from the API: the server echoes the reply with
        // a `quoted_message` that has only `poll_id` (no `poll` object).
        // Constructed directly (not via copyWith) because copyWith cannot
        // clear `poll` — see Message.copyWith.
        final strippedPollSnapshot = Message(
          id: pollMessage.id,
          pollId: pollMessage.pollId,
          user: pollUser,
          createdAt: pollMessage.createdAt,
        );
        final reSyncedReply = replyToPoll.copyWith(quotedMessage: strippedPollSnapshot);

        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            messages: [reSyncedReply],
          ),
        );

        final mergedReply = channel.state?.messages.firstWhere((it) => it.id == replyToPoll.id);

        expect(mergedReply, isNotNull);
        expect(mergedReply!.quotedMessage, isNotNull);
        expect(mergedReply.quotedMessage!.id, pollMessage.id);
        expect(mergedReply.quotedMessage!.poll, isNotNull);
        expect(mergedReply.quotedMessage!.poll!.id, poll.id);
        expect(mergedReply.quotedMessage!.poll!.name, poll.name);
      },
    );

    test(
      'preserves a nested quotedMessage (poll) two levels deep when the '
      'server omits it during re-sync (regression: quote-of-quote of a poll '
      'disappears completely after foregrounding)',
      () async {
        final pollUser = User(id: 'poll-author');
        final poll = Poll(
          id: 'poll-2',
          name: 'Coffee or tea?',
          options: const [
            PollOption(id: 'opt-a', text: 'Coffee'),
            PollOption(id: 'opt-b', text: 'Tea'),
          ],
          createdById: pollUser.id,
        );

        final pollMessage = Message(
          id: 'poll-msg-2',
          poll: poll,
          pollId: poll.id,
          user: pollUser,
          createdAt: DateTime.utc(2026, 4, 29, 10),
        );

        final replyToPoll = Message(
          id: 'reply-A',
          text: 'My pick',
          quotedMessageId: pollMessage.id,
          quotedMessage: pollMessage,
          user: User(id: 'user-a'),
          createdAt: DateTime.utc(2026, 4, 29, 11),
        );

        final replyToReply = Message(
          id: 'reply-B',
          text: 'Same here',
          quotedMessageId: replyToPoll.id,
          quotedMessage: replyToPoll,
          user: User(id: 'user-b'),
          createdAt: DateTime.utc(2026, 4, 29, 12),
        );

        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            messages: [pollMessage, replyToPoll, replyToReply],
          ),
        );

        // Simulate the server response where:
        // - replyA's nested quoted poll is missing the `poll` object.
        // - replyB's nested quoted replyA is missing its own `quoted_message`
        //   (the server typically does not nest two levels deep).
        // Stripped poll snapshot is constructed directly because copyWith
        // cannot clear `poll` — see Message.copyWith.
        final strippedPollSnapshot = Message(
          id: pollMessage.id,
          pollId: pollMessage.pollId,
          user: pollUser,
          createdAt: pollMessage.createdAt,
        );
        final strippedReplyA = replyToPoll.copyWith(quotedMessage: null);

        final reSyncedReplyA = replyToPoll.copyWith(quotedMessage: strippedPollSnapshot);
        final reSyncedReplyB = replyToReply.copyWith(quotedMessage: strippedReplyA);

        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            messages: [pollMessage, reSyncedReplyA, reSyncedReplyB],
          ),
        );

        final mergedReplyA = channel.state?.messages.firstWhere((it) => it.id == replyToPoll.id);
        final mergedReplyB = channel.state?.messages.firstWhere((it) => it.id == replyToReply.id);

        // First-level quote (reply A's quote of the poll) must keep the poll.
        expect(mergedReplyA?.quotedMessage?.poll, isNotNull);
        expect(mergedReplyA?.quotedMessage?.poll?.id, poll.id);

        // Second-level quote (reply B's quote of reply A) must keep reply A's
        // own nested quotedMessage so the poll preview still resolves.
        expect(mergedReplyB?.quotedMessage, isNotNull);
        expect(mergedReplyB?.quotedMessage?.id, replyToPoll.id);
        expect(mergedReplyB?.quotedMessage?.quotedMessage, isNotNull);
        expect(mergedReplyB?.quotedMessage?.quotedMessage?.id, pollMessage.id);
        expect(mergedReplyB?.quotedMessage?.quotedMessage?.poll, isNotNull);
        expect(mergedReplyB?.quotedMessage?.quotedMessage?.poll?.id, poll.id);
      },
    );

    test(
      'still preserves quotedMessage when the updated payload has no '
      'quoted_message at all (existing behavior should not regress)',
      () async {
        final pollUser = User(id: 'poll-author');
        final poll = Poll(
          id: 'poll-3',
          name: 'Beach or mountains?',
          options: const [
            PollOption(id: 'opt-x', text: 'Beach'),
            PollOption(id: 'opt-y', text: 'Mountains'),
          ],
          createdById: pollUser.id,
        );

        final pollMessage = Message(
          id: 'poll-msg-3',
          poll: poll,
          pollId: poll.id,
          user: pollUser,
          createdAt: DateTime.utc(2026, 4, 29, 10),
        );

        final replyToPoll = Message(
          id: 'reply-3',
          text: 'Definitely beach',
          quotedMessageId: pollMessage.id,
          quotedMessage: pollMessage,
          user: User(id: 'reply-user'),
          createdAt: DateTime.utc(2026, 4, 29, 11),
        );

        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            messages: [pollMessage, replyToPoll],
          ),
        );

        // Simulate an update event that touches the reply but doesn't echo
        // the nested quoted_message at all (only quotedMessageId is set).
        final reSyncedReply = Message(
          id: replyToPoll.id,
          text: 'Definitely beach (edited)',
          quotedMessageId: pollMessage.id,
          user: replyToPoll.user,
          createdAt: replyToPoll.createdAt,
        );

        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            messages: [reSyncedReply],
          ),
        );

        final mergedReply = channel.state?.messages.firstWhere((it) => it.id == replyToPoll.id);

        expect(mergedReply, isNotNull);
        expect(mergedReply!.text, 'Definitely beach (edited)');
        expect(mergedReply.quotedMessage, isNotNull);
        expect(mergedReply.quotedMessage!.poll?.id, poll.id);
      },
    );

    test(
      'preserves the top-level `poll` when the server emits a `message.updated`'
      ' that omits the `poll` object (regression: poll disappears from the '
      'parent message after a thread reply is added)',
      () async {
        final pollUser = User(id: 'poll-author');
        final poll = Poll(
          id: 'poll-thread',
          name: 'What is for lunch?',
          options: const [
            PollOption(id: 'opt-1', text: 'Burgers'),
            PollOption(id: 'opt-2', text: 'Salads'),
          ],
          createdById: pollUser.id,
        );

        final pollMessage = Message(
          id: 'parent-poll-msg',
          poll: poll,
          pollId: poll.id,
          user: pollUser,
          createdAt: DateTime.utc(2026, 4, 29, 10),
          replyCount: 0,
        );

        // Seed channel state with the fully-enriched parent poll message.
        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            messages: [pollMessage],
          ),
        );

        // Simulate the `message.updated` event the backend fires for the
        // parent after a thread reply is added: bookkeeping fields are bumped
        // (`reply_count`, `updated_at`) but the `poll` object is omitted from
        // the payload — only `pollId` is set. Constructed directly because
        // copyWith cannot clear `poll` — see Message.copyWith.
        final strippedParentUpdate = Message(
          id: pollMessage.id,
          pollId: pollMessage.pollId,
          user: pollUser,
          createdAt: pollMessage.createdAt,
          replyCount: 1,
          updatedAt: DateTime.utc(2026, 4, 29, 11),
        );

        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.messageUpdated,
            message: strippedParentUpdate,
          ),
        );

        // Wait for the event to be processed.
        await Future.delayed(Duration.zero);

        final merged = channel.state?.messages.firstWhere((it) => it.id == pollMessage.id);

        // Parent poll message must remain in the channel state after a thread reply.
        expect(merged, isNotNull);
        // Bookkeeping fields from the event should still apply.
        expect(merged!.replyCount, 1);
        // Locally-known poll must be preserved when the server omits it from a
        // `message.updated` payload (e.g. when a thread reply bumps reply_count).
        expect(merged.poll, isNotNull);
        expect(merged.poll!.id, poll.id);
        expect(merged.poll!.name, poll.name);
        expect(merged.pollId, poll.id);
      },
    );

    test(
      'still uses the updated `poll` when the server includes one in '
      '`message.updated` (poll edits should not be reverted to the locally '
      'cached version)',
      () async {
        final pollUser = User(id: 'poll-author');
        final poll = Poll(
          id: 'poll-edit',
          name: 'Initial name',
          options: const [
            PollOption(id: 'opt-1', text: 'Original A'),
          ],
          createdById: pollUser.id,
        );

        final pollMessage = Message(
          id: 'edit-parent',
          poll: poll,
          pollId: poll.id,
          user: pollUser,
          createdAt: DateTime.utc(2026, 4, 29, 10),
        );

        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            messages: [pollMessage],
          ),
        );

        final updatedPoll = poll.copyWith(name: 'Edited name');
        final updatedParent = pollMessage.copyWith(poll: updatedPoll, updatedAt: DateTime.utc(2026, 4, 29, 12));

        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.messageUpdated,
            message: updatedParent,
          ),
        );

        await Future.delayed(Duration.zero);

        final merged = channel.state?.messages.firstWhere((it) => it.id == pollMessage.id);

        // Server-echoed poll must override the locally cached one — poll edits
        // should not be reverted by the local-fallback merge.
        expect(merged?.poll, isNotNull);
        expect(merged?.poll?.name, 'Edited name');
      },
    );
  });
}

// region Test Helpers

ChannelState _generateChannelState(
  String channelId,
  String channelType, {
  DateTime? lastMessageAt,
  List<ChannelCapability>? ownCapabilities,
  bool mockChannelConfig = false,
}) {
  ChannelConfig? config;
  if (mockChannelConfig) {
    config = MockChannelConfig();
    when(() => config!.readEvents).thenReturn(true);
    when(() => config!.typingEvents).thenReturn(true);
  }
  final channel = ChannelModel(
    id: channelId,
    type: channelType,
    config: config,
    ownCapabilities: ownCapabilities,
    lastMessageAt: lastMessageAt,
  );
  return ChannelState(channel: channel);
}

Logger _createLogger(String name) {
  final logger = Logger.detached(name)..level = Level.ALL;
  logger.onRecord.listen(print);
  return logger;
}

// endregion
