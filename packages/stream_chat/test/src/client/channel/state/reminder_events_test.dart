import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

// Deterministic stand-in for `DateTime.now()`: emitted reminders round-trip
// through JSON, and only UTC values survive that round-trip unchanged.
final _now = DateTime.utc(2021, 3);

ChannelState _seedChannel(ChannelState _) => createDefaultChannelState(
  channel: createDefaultChannelModel(cid: _channelCid),
);

void main() {
  group('Reminder events', () {
    channelTest(
      'should handle reminder.created event',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        const messageId = 'test-message-id';

        // Setup initial state with a message without reminder
        final message = Message(
          id: messageId,
          user: tester.currentUser,
          text: 'Test message',
        );

        tester.channelState?.updateMessage(message);

        // Verify initial state - no reminder
        final initialMessage = tester.channelState?.messages.firstWhere(
          (m) => m.id == messageId,
        );
        expect(initialMessage?.reminder, isNull);

        // Create reminder
        final reminder = createDefaultMessageReminder(
          messageId: messageId,
          channelCid: tester.channel.cid!,
          userId: 'test-user-id',
          remindAt: _now.add(const Duration(days: 30)),
        );

        // Emit reminder.created event
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.reminderCreated,
            reminder: reminder,
          ),
        );

        // Verify message reminder was added
        final updatedMessage = tester.channelState?.messages.firstWhere(
          (m) => m.id == messageId,
        );
        expect(updatedMessage?.reminder, isNotNull);
        expect(updatedMessage?.reminder?.messageId, messageId);
        expect(updatedMessage?.reminder?.remindAt, reminder.remindAt);
      },
    );

    channelTest(
      'should handle reminder.updated event',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        const messageId = 'test-message-id';

        // Setup initial state with a message with existing reminder
        final remindAt = _now.add(const Duration(days: 30));
        final initialReminder = createDefaultMessageReminder(
          messageId: messageId,
          channelCid: tester.channel.cid!,
          userId: 'test-user-id',
          remindAt: remindAt,
        );

        final message = Message(
          id: messageId,
          user: tester.currentUser,
          text: 'Test message',
          reminder: initialReminder,
        );

        tester.channelState?.updateMessage(message);

        // Verify initial state
        final initialMessage = tester.channelState?.messages.firstWhere(
          (m) => m.id == messageId,
        );
        expect(initialMessage?.reminder, isNotNull);
        expect(initialMessage?.reminder?.remindAt, remindAt);

        // Create updated reminder
        final updatedRemindAt = remindAt.add(const Duration(days: 15));
        final updatedReminder = initialReminder.copyWith(
          remindAt: updatedRemindAt,
          updatedAt: _now,
        );

        // Emit reminder.updated event
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.reminderUpdated,
            reminder: updatedReminder,
          ),
        );

        // Verify message reminder was updated
        final updatedMessage = tester.channelState?.messages.firstWhere(
          (m) => m.id == messageId,
        );
        expect(updatedMessage?.reminder, isNotNull);
        expect(updatedMessage?.reminder?.messageId, messageId);
        expect(updatedMessage?.reminder?.remindAt, updatedRemindAt);
      },
    );

    channelTest(
      'should handle reminder.deleted event',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        const messageId = 'test-message-id';

        // Setup initial state with a message with existing reminder
        final remindAt = _now.add(const Duration(days: 30));
        final initialReminder = createDefaultMessageReminder(
          messageId: messageId,
          channelCid: tester.channel.cid!,
          userId: 'test-user-id',
          remindAt: remindAt,
        );

        final message = Message(
          id: messageId,
          user: tester.currentUser,
          text: 'Test message',
          reminder: initialReminder,
        );

        tester.channelState?.updateMessage(message);

        // Verify initial state
        final initialMessage = tester.channelState?.messages.firstWhere(
          (m) => m.id == messageId,
        );
        expect(initialMessage?.reminder, isNotNull);

        // Emit reminder.deleted event
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.reminderDeleted,
            reminder: initialReminder,
          ),
        );

        // Verify message reminder was removed
        final updatedMessage = tester.channelState?.messages.firstWhere(
          (m) => m.id == messageId,
        );
        expect(updatedMessage?.reminder, isNull);
      },
    );

    channelTest(
      'should handle reminder.created event for thread messages',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        const messageId = 'test-message-id';
        const parentId = 'test-parent-id';

        // Setup initial state with a thread message without reminder
        final threadMessage = Message(
          id: messageId,
          parentId: parentId,
          user: tester.currentUser,
          text: 'Thread message',
          // `Message.createdAt` falls back to `DateTime.now()` per call when
          // not provided, which breaks merge/sort keyed on createdAt.
          createdAt: _now,
        );

        tester.channelState?.updateMessage(threadMessage);

        // Verify initial state - no reminder
        final initialMessage = tester.channelState?.threads[parentId]?.firstWhere(
          (m) => m.id == messageId,
        );
        expect(initialMessage?.reminder, isNull);

        // Create reminder
        final remindAt = _now.add(const Duration(days: 30));
        final reminder = createDefaultMessageReminder(
          messageId: messageId,
          channelCid: tester.channel.cid!,
          userId: 'test-user-id',
          remindAt: remindAt,
        );

        // Emit reminder.created event
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.reminderCreated,
            reminder: reminder,
          ),
        );

        // Verify thread message reminder was added
        final updatedMessage = tester.channelState?.threads[parentId]?.firstWhere(
          (m) => m.id == messageId,
        );
        expect(updatedMessage?.reminder, isNotNull);
        expect(updatedMessage?.reminder?.messageId, messageId);
        expect(updatedMessage?.reminder?.remindAt, reminder.remindAt);
      },
    );

    channelTest(
      'should handle reminder.updated event for thread messages',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        const messageId = 'test-message-id';
        const parentId = 'test-parent-id';

        // Setup initial state with a thread message with existing reminder
        final remindAt = _now.add(const Duration(days: 30));
        final initialReminder = createDefaultMessageReminder(
          messageId: messageId,
          channelCid: tester.channel.cid!,
          userId: 'test-user-id',
          remindAt: remindAt,
        );

        final threadMessage = Message(
          id: messageId,
          parentId: parentId,
          user: tester.currentUser,
          text: 'Thread message',
          reminder: initialReminder,
          // `Message.createdAt` falls back to `DateTime.now()` per call when
          // not provided, which breaks merge/sort keyed on createdAt.
          createdAt: _now,
        );

        tester.channelState?.updateMessage(threadMessage);

        // Verify initial state
        final initialMessage = tester.channelState?.threads[parentId]?.firstWhere(
          (m) => m.id == messageId,
        );
        expect(initialMessage?.reminder, isNotNull);
        expect(initialMessage?.reminder?.remindAt, remindAt);

        // Create updated reminder
        final updatedRemindAt = remindAt.add(const Duration(days: 15));
        final updatedReminder = initialReminder.copyWith(
          remindAt: updatedRemindAt,
          updatedAt: _now,
        );

        // Emit reminder.updated event
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.reminderUpdated,
            reminder: updatedReminder,
          ),
        );

        // Verify thread message reminder was updated
        final updatedMessage = tester.channelState?.threads[parentId]?.firstWhere(
          (m) => m.id == messageId,
        );
        expect(updatedMessage?.reminder, isNotNull);
        expect(updatedMessage?.reminder?.messageId, messageId);
        expect(updatedMessage?.reminder?.remindAt, updatedRemindAt);
      },
    );

    channelTest(
      'should handle reminder.deleted event for thread messages',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        const messageId = 'test-message-id';
        const parentId = 'test-parent-id';

        // Setup initial state with a thread message with existing reminder
        final remindAt = _now.add(const Duration(days: 30));
        final initialReminder = createDefaultMessageReminder(
          messageId: messageId,
          channelCid: tester.channel.cid!,
          userId: 'test-user-id',
          remindAt: remindAt,
        );

        final threadMessage = Message(
          id: messageId,
          parentId: parentId,
          user: tester.currentUser,
          text: 'Thread message',
          reminder: initialReminder,
          // Explicit `createdAt` so `Message.createdAt` is deterministic
          // across reads — without one it falls back to `DateTime.now()`
          // on every call, which breaks any sort/merge keyed on createdAt.
          createdAt: _now,
        );

        tester.channelState?.updateMessage(threadMessage);

        // Verify initial state
        final initialMessage = tester.channelState?.threads[parentId]?.firstWhere(
          (m) => m.id == messageId,
        );
        expect(initialMessage?.reminder, isNotNull);

        // Emit reminder.deleted event
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.reminderDeleted,
            reminder: initialReminder,
          ),
        );

        // Verify thread message reminder was removed
        final updatedMessage = tester.channelState?.threads[parentId]?.firstWhere(
          (m) => m.id == messageId,
        );
        expect(updatedMessage?.reminder, isNull);
      },
    );

    channelTest(
      'an event without a reminder is ignored',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        const messageId = 'test-message-id';

        final message = Message(
          id: messageId,
          user: tester.currentUser,
          text: 'Test message',
        );
        tester.channelState?.updateMessage(message);

        await tester.emitEvent(createDefaultEvent(cid: tester.channel.cid, type: EventType.reminderCreated));

        final storedMessage = tester.channelState?.messages.firstWhere((m) => m.id == messageId);
        expect(storedMessage?.reminder, isNull);
      },
    );
  });
}
