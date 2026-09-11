import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

ChannelState _seedChannel(ChannelState _) => createDefaultChannelState(
  channel: createDefaultChannelModel(cid: _channelCid),
);

// Stubs every persistence call the harness makes on the way to a user-level
// deletion: `updateConnectionInfo` on connect, `getChannelThreads` when the
// channel state initializes, the debounced channel-state/threads writes (they
// only fire when a run is slow enough for the 1s debounce to elapse
// mid-test), and the three calls the `user.messages.deleted` handler makes.
MockPersistenceClient _createPersistenceClient() {
  registerFallbackValue(createDefaultEvent());
  registerFallbackValue(createDefaultChannelState());
  final persistenceClient = MockPersistenceClient();
  when(() => persistenceClient.updateConnectionInfo(any())).thenAnswer((_) async {});
  when(() => persistenceClient.getChannelThreads(_channelCid)).thenAnswer((_) async => {});
  when(() => persistenceClient.updateChannelState(any())).thenAnswer((_) async {});
  when(() => persistenceClient.updateChannelThreads(any(), any())).thenAnswer((_) async {});
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
  return persistenceClient;
}

void main() {
  group('User messages deleted event', () {
    final softDeletePersistence = _createPersistenceClient();
    channelTest(
      'should soft delete all messages from user when hardDelete is false',
      channelType: _channelType,
      channelId: _channelId,
      chatPersistenceClient: softDeletePersistence,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
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

        tester.channelState?.addNewMessage(message1);
        tester.channelState?.addNewMessage(message2);
        tester.channelState?.addNewMessage(message3);

        // Verify initial state
        expect(tester.channelState?.messages.length, equals(3));
        expect(
          tester.channelState?.messages.where((m) => m.user?.id == 'user-1').length,
          equals(2),
        );
        expect(
          tester.channelState?.messages.where((m) => m.user?.id == 'user-2').length,
          equals(1),
        );

        // Create user.messages.deleted event (soft delete)
        final deletedAt = DateTime.utc(2021, 3);
        final userMessagesDeletedEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.userMessagesDeleted,
          user: user1,
          hardDelete: false,
          createdAt: deletedAt,
        );

        // Dispatch event and wait for it to be processed
        await tester.emitEvent(userMessagesDeletedEvent);

        // Verify user1's messages are soft deleted
        expect(tester.channelState?.messages.length, equals(3));
        final deletedMessages = tester.channelState?.messages.where((m) => m.user?.id == 'user-1').toList();
        expect(deletedMessages?.length, equals(2));
        for (final message in deletedMessages!) {
          expect(message.type, equals(MessageType.deleted));
          expect(message.deletedAt, isNotNull);
          expect(message.state.isDeleted, isTrue);
        }

        // Verify user2's message is unaffected
        final user2Message = tester.channelState?.messages.firstWhere((m) => m.id == 'msg-3');
        expect(user2Message?.type, isNot(MessageType.deleted));
        expect(user2Message?.deletedAt, isNull);
      },
    );

    final hardDeletePersistence = _createPersistenceClient();
    channelTest(
      'should hard delete all messages from user when hardDelete is true',
      channelType: _channelType,
      channelId: _channelId,
      chatPersistenceClient: hardDeletePersistence,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
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

        tester.channelState?.addNewMessage(message1);
        tester.channelState?.addNewMessage(message2);
        tester.channelState?.addNewMessage(message3);

        // Verify initial state
        expect(tester.channelState?.messages.length, equals(3));

        // Create user.messages.deleted event (hard delete)
        final userMessagesDeletedEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.userMessagesDeleted,
          user: user1,
          hardDelete: true,
        );

        // Dispatch event and wait for it to be processed
        await tester.emitEvent(userMessagesDeletedEvent);

        // Verify user1's messages are removed
        expect(tester.channelState?.messages.length, equals(1));
        expect(
          tester.channelState?.messages.any((m) => m.user?.id == 'user-1'),
          isFalse,
        );

        // Verify user2's message still exists
        final user2Message = tester.channelState?.messages.firstWhere((m) => m.id == 'msg-3');
        expect(user2Message, isNotNull);
        expect(user2Message?.user?.id, equals('user-2'));
      },
    );

    final threadMessagesPersistence = _createPersistenceClient();
    channelTest(
      'should handle thread messages from user',
      channelType: _channelType,
      channelId: _channelId,
      chatPersistenceClient: threadMessagesPersistence,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
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

        tester.channelState?.addNewMessage(parentMessage);
        tester.channelState?.addNewMessage(threadMessage1);
        tester.channelState?.addNewMessage(threadMessage2);

        // Verify initial state
        expect(tester.channelState?.messages.length, equals(1));
        expect(tester.channelState?.threads['parent-msg']?.length, equals(2));

        // Create user.messages.deleted event (soft delete)
        final userMessagesDeletedEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.userMessagesDeleted,
          user: user1,
          hardDelete: false,
        );

        // Dispatch event and wait for it to be processed
        await tester.emitEvent(userMessagesDeletedEvent);

        // Verify thread messages are soft deleted
        final threadMessages = tester.channelState?.threads['parent-msg'];
        expect(threadMessages?.length, equals(2));
        for (final message in threadMessages!) {
          expect(message.type, equals(MessageType.deleted));
          expect(message.state.isDeleted, isTrue);
        }

        // Verify parent message is unaffected
        final parent = tester.channelState?.messages.first;
        expect(parent?.type, isNot(MessageType.deleted));
      },
    );

    final nullUserPersistence = _createPersistenceClient();
    channelTest(
      'should do nothing when user is null',
      channelType: _channelType,
      channelId: _channelId,
      chatPersistenceClient: nullUserPersistence,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        // Setup: Add messages
        final user1 = User(id: 'user-1', name: 'User 1');
        final message1 = Message(
          id: 'msg-1',
          text: 'Message from user 1',
          user: user1,
        );

        tester.channelState?.addNewMessage(message1);

        // Verify initial state
        expect(tester.channelState?.messages.length, equals(1));

        // Create user.messages.deleted event without user
        final userMessagesDeletedEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.userMessagesDeleted,
          hardDelete: false,
        );

        // Dispatch event and wait for it to be processed
        await tester.emitEvent(userMessagesDeletedEvent);

        // Verify messages are unaffected
        expect(tester.channelState?.messages.length, equals(1));
        expect(
          tester.channelState?.messages.first.type,
          isNot(MessageType.deleted),
        );
      },
    );

    final emptyChannelPersistence = _createPersistenceClient();
    channelTest(
      'should handle empty message list',
      channelType: _channelType,
      channelId: _channelId,
      chatPersistenceClient: emptyChannelPersistence,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        // Setup: Empty channel
        expect(tester.channelState?.messages.length, equals(0));

        // Create user.messages.deleted event
        final userMessagesDeletedEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.userMessagesDeleted,
          user: User(id: 'user-1'),
          hardDelete: false,
        );

        // Dispatch event - should not throw
        await tester.emitEvent(userMessagesDeletedEvent);

        // Verify state is still empty
        expect(tester.channelState?.messages.length, equals(0));
      },
    );

    final hardDeleteStoragePersistence = _createPersistenceClient();
    channelTest(
      'should delete messages from persistence when hardDelete is true',
      channelType: _channelType,
      channelId: _channelId,
      chatPersistenceClient: hardDeleteStoragePersistence,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
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

        tester.channelState?.addNewMessage(message1);
        tester.channelState?.addNewMessage(message2);
        tester.channelState?.addNewMessage(message3);

        // Verify initial state
        expect(tester.channelState?.messages.length, equals(3));

        // Create user.messages.deleted event (hard delete)
        final userMessagesDeletedEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.userMessagesDeleted,
          user: user1,
          hardDelete: true,
        );

        // Dispatch event and wait for it to be processed
        await tester.emitEvent(userMessagesDeletedEvent);

        // Verify messages are removed from persistence
        verify(
          () => hardDeleteStoragePersistence.deleteMessageByIds(['msg-1', 'msg-2']),
        ).called(1);
        verify(
          () => hardDeleteStoragePersistence.deletePinnedMessageByIds(['msg-1', 'msg-2']),
        ).called(1);

        // Verify user1's messages are removed from state
        expect(tester.channelState?.messages.length, equals(1));
        expect(
          tester.channelState?.messages.any((m) => m.user?.id == 'user-1'),
          isFalse,
        );
      },
    );

    final softDeleteStoragePersistence = _createPersistenceClient();
    channelTest(
      'should not delete from persistence when hardDelete is false',
      channelType: _channelType,
      channelId: _channelId,
      chatPersistenceClient: softDeleteStoragePersistence,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        // Setup: Add messages
        final user1 = User(id: 'user-1', name: 'User 1');
        final message1 = Message(
          id: 'msg-1',
          text: 'Message from user 1',
          user: user1,
        );

        tester.channelState?.addNewMessage(message1);

        // Create user.messages.deleted event (soft delete)
        final userMessagesDeletedEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.userMessagesDeleted,
          user: user1,
          hardDelete: false,
        );

        // Dispatch event and wait for it to be processed
        await tester.emitEvent(userMessagesDeletedEvent);

        // Verify persistence deletion methods were NOT called
        verifyNever(() => softDeleteStoragePersistence.deleteMessageByIds(any()));
        verifyNever(() => softDeleteStoragePersistence.deletePinnedMessageByIds(any()));

        // Verify message is soft deleted (still in state)
        expect(tester.channelState?.messages.length, equals(1));
        expect(tester.channelState?.messages.first.type, equals(MessageType.deleted));
      },
    );

    final storageWidePersistence = _createPersistenceClient();
    channelTest(
      'should delete all user messages including those only in storage',
      channelType: _channelType,
      channelId: _channelId,
      chatPersistenceClient: storageWidePersistence,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
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
        tester.channelState?.addNewMessage(stateMessage1);
        tester.channelState?.addNewMessage(stateMessage2);
        tester.channelState?.addNewMessage(stateThreadMessage1);
        tester.channelState?.addNewMessage(stateThreadMessage2);

        // Verify initial state has only 2 messages and 1 thread with 2 replies
        expect(tester.channelState?.messages.length, equals(2));
        expect(tester.channelState?.threads['msg-1']?.length, equals(2));

        // Create user.messages.deleted event (hard delete)
        final userMessagesDeletedEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.userMessagesDeleted,
          user: user1,
          hardDelete: true,
        );

        // Dispatch event and wait for it to be processed
        await tester.emitEvent(userMessagesDeletedEvent);

        // Verify user1's messages are removed from state
        expect(tester.channelState?.messages.length, equals(1));
        expect(tester.channelState?.threads['msg-1']?.length, equals(1));

        expect(
          tester.channelState?.messages.any((m) => m.user?.id == 'user-1'),
          isFalse,
        );

        expect(
          tester.channelState?.threads['msg-1']?.any((m) => m.user?.id == 'user-1'),
          isFalse,
        );

        // Verify persistence delete was called - this handles ALL messages
        // in storage (both those in state AND those only in storage)
        verify(
          () => storageWidePersistence.deleteMessagesFromUser(
            cid: tester.channel.cid,
            userId: user1.id,
            hardDelete: true,
            deletedAt: any(named: 'deletedAt'),
          ),
        ).called(1);

        // Verify in-state messages were also removed from state's persistence
        final capturedIds =
            verify(
                  () => storageWidePersistence.deleteMessageByIds(captureAny()),
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

    final crossThreadPersistence = _createPersistenceClient();
    channelTest(
      'should delete every authored message across threads without '
      'cross-thread leakage (regression: _updateThreadMessages)',
      channelType: _channelType,
      channelId: _channelId,
      chatPersistenceClient: crossThreadPersistence,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
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

        tester.channelState?.addNewMessage(parentA);
        tester.channelState?.addNewMessage(parentB);
        tester.channelState?.addNewMessage(topLevelFromUser1);
        tester.channelState?.addNewMessage(replyA);
        tester.channelState?.addNewMessage(replyB);

        // Initial state: each thread has exactly its own reply.
        expect(
          tester.channelState?.threads['parent-A']?.map((m) => m.id),
          equals(['reply-A']),
        );
        expect(
          tester.channelState?.threads['parent-B']?.map((m) => m.id),
          equals(['reply-B']),
        );

        // Trigger the multi-thread batch via user.messages.deleted.
        final userMessagesDeletedEvent = createDefaultEvent(
          cid: tester.channel.cid,
          type: EventType.userMessagesDeleted,
          user: user1,
          hardDelete: false,
        );
        await tester.emitEvent(userMessagesDeletedEvent);

        // 1) Thread membership is preserved — no cross-thread leakage.
        //    Without the fix, replyB would leak into thread A and v.v.
        expect(
          tester.channelState?.threads['parent-A']?.map((m) => m.id),
          equals(['reply-A']),
          reason: 'thread A must not contain replies from thread B',
        );
        expect(
          tester.channelState?.threads['parent-B']?.map((m) => m.id),
          equals(['reply-B']),
          reason: 'thread B must not contain replies from thread A',
        );

        // 2) Every message authored by user-1 is soft-deleted — top-level
        //    AND in both threads. The fix must not narrow this scope.
        expect(
          tester.channelState?.messages.firstWhere((m) => m.id == 'top-1').type,
          equals(MessageType.deleted),
          reason: 'top-level user-1 message must be deleted',
        );
        expect(
          tester.channelState?.threads['parent-A']?.first.type,
          equals(MessageType.deleted),
          reason: 'thread A reply from user-1 must be deleted',
        );
        expect(
          tester.channelState?.threads['parent-B']?.first.type,
          equals(MessageType.deleted),
          reason: 'thread B reply from user-1 must be deleted',
        );

        // 3) Other users' messages are unaffected.
        expect(
          tester.channelState?.messages.firstWhere((m) => m.id == 'parent-A').type,
          isNot(MessageType.deleted),
        );
        expect(
          tester.channelState?.messages.firstWhere((m) => m.id == 'parent-B').type,
          isNot(MessageType.deleted),
        );
      },
    );
  });
}
