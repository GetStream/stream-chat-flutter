import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

ChannelState Function(ChannelState) _seedChannel() {
  return (_) => createDefaultChannelState(
    channel: createDefaultChannelModel(
      cid: _channelCid,
      config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
      ownCapabilities: const [ChannelCapability.readEvents],
    ),
  );
}

Event _updateMessageEvent(Message message) => createDefaultEvent(
  type: EventType.messageUpdated,
  cid: _channelCid,
  message: message,
);

void main() {
  group(EventType.messageUpdated, () {
    channelTest(
      "should update 'channel.state.pinnedMessages' and should add message to pinned messages only once if updatedMessage.pinned is true",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        const messageId = 'test-message-id';
        final message = Message(
          id: messageId,
          user: tester.currentUser,
          pinned: true,
        );

        await tester.emitEvent(_updateMessageEvent(message));

        expect(tester.channelState?.pinnedMessages.length, equals(1));
        expect(tester.channelState?.pinnedMessages.first.id, equals(messageId));
      },
    );

    channelTest(
      'should update pinned message itself if updatedMessage.pinned is true and message is already pinned',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        const messageId = 'test-message-id';
        const oldText = 'Old text';
        const newText = 'New text';
        final message = Message(
          id: messageId,
          user: tester.currentUser,
          text: oldText,
          pinned: true,
        );

        await tester.emitEvent(_updateMessageEvent(message));

        expect(tester.channelState?.pinnedMessages.length, equals(1));
        expect(tester.channelState?.pinnedMessages.first.id, equals(messageId));
        expect(tester.channelState?.pinnedMessages.first.text, equals(oldText));

        final updatedMessage = message.copyWith(text: newText);
        await tester.emitEvent(_updateMessageEvent(updatedMessage));

        expect(tester.channelState?.pinnedMessages.length, equals(1));
        expect(tester.channelState?.pinnedMessages.first.id, equals(messageId));
        expect(tester.channelState?.pinnedMessages.first.text, equals(newText));
      },
    );

    channelTest(
      "should update 'channel.state.pinnedMessages' and should add message to pinned messages "
      'and not unpin previous pinned message if updatedMessage.pinned is true and there is already another pinned message',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        const firstMessageId = 'first-test-message-id';
        const secondMessageId = 'second-test-message-id';
        final firstMessage = Message(
          id: firstMessageId,
          user: tester.currentUser,
          pinned: true,
        );
        final secondMessage = firstMessage.copyWith(id: secondMessageId);

        await tester.emitEvent(_updateMessageEvent(firstMessage));

        expect(tester.channelState?.pinnedMessages.length, equals(1));
        expect(
          tester.channelState?.pinnedMessages.first.id,
          equals(firstMessageId),
        );

        await tester.emitEvent(_updateMessageEvent(secondMessage));

        expect(tester.channelState?.pinnedMessages.length, equals(2));
        expect(
          tester.channelState?.pinnedMessages.first.id,
          equals(firstMessageId),
        );
        expect(
          tester.channelState?.pinnedMessages[1].id,
          equals(secondMessageId),
        );
      },
    );

    channelTest(
      "should update 'channel.state.pinnedMessages' and should remove message from pinned messages if updatedMessage.pinned is false",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        const messageId = 'test-message-id';
        final pinnedMessage = Message(
          id: messageId,
          user: tester.currentUser,
          pinned: true,
        );

        await tester.emitEvent(_updateMessageEvent(pinnedMessage));

        expect(tester.channelState?.pinnedMessages.length, equals(1));
        expect(tester.channelState?.pinnedMessages.first.id, equals(messageId));

        final unpinnedMessage = pinnedMessage.copyWith(pinned: false);
        await tester.emitEvent(_updateMessageEvent(unpinnedMessage));

        expect(tester.channelState?.pinnedMessages, isEmpty);
      },
    );

    // A `message.updated` event for a message outside the loaded window
    // would otherwise upsert into the sorted list — creating a phantom
    // entry with a gap. The guard is "id not in the loaded list", and
    // is independent of `isUpToDate` — even at the latest page we may
    // have paginated past older history and receive an event for a
    // message no longer in memory.
    group('when message is outside the loaded window', () {
      channelTest(
        'should NOT insert unknown message into `messages` list',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          // Simulate "we have the latest page but not older history":
          // seed the tail messages.
          final tail = List.generate(
            3,
            (i) => Message(
              id: 'tail-$i',
              user: tester.currentUser,
              text: 'tail $i',
              createdAt: DateTime.utc(2026, 6, 1).add(Duration(seconds: i)),
            ),
          );
          tester.channelState!.updateChannelState(
            tester.channelState!.channelState.copyWith(messages: tail),
          );
          expect(tester.channelState!.messages, hasLength(3));

          // Event for a message on an older page we don't have loaded.
          final olderPageEdit = Message(
            id: 'older-page-msg',
            user: tester.currentUser,
            text: 'edited on older page',
            createdAt: DateTime.utc(2025, 1, 1),
          );
          await tester.emitEvent(_updateMessageEvent(olderPageEdit));

          // Tail is unchanged, no phantom entry inserted at position 0.
          expect(tester.channelState!.messages.map((m) => m.id), ['tail-0', 'tail-1', 'tail-2']);
          expect(tester.channelState!.pinnedMessages, isEmpty);
        },
      );

      channelTest(
        'should update message in place when it IS in the loaded window',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          const messageId = 'known';
          final seeded = Message(
            id: messageId,
            user: tester.currentUser,
            text: 'old',
            createdAt: DateTime.utc(2026),
          );
          tester.channelState!.updateChannelState(
            tester.channelState!.channelState.copyWith(messages: [seeded]),
          );
          tester.channelState!.isUpToDate = false;

          final edited = seeded.copyWith(text: 'new');
          await tester.emitEvent(_updateMessageEvent(edited));

          final stored = tester.channelState!.messages.singleWhere((m) => m.id == messageId);
          expect(stored.text, equals('new'));
        },
      );

      channelTest(
        'should still add to pinnedMessages when pinned:true even if not in loaded window',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          tester.channelState!.isUpToDate = false;
          expect(tester.channelState!.messages, isEmpty);
          expect(tester.channelState!.pinnedMessages, isEmpty);

          const messageId = 'pin-me';
          final pinned = Message(
            id: messageId,
            user: tester.currentUser,
            pinned: true,
          );
          await tester.emitEvent(_updateMessageEvent(pinned));

          expect(tester.channelState!.messages, isEmpty);
          expect(tester.channelState!.pinnedMessages.length, equals(1));
          expect(tester.channelState!.pinnedMessages.first.id, equals(messageId));
        },
      );

      channelTest(
        'should NOT insert unknown reply into threads[parentId]',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          const parentId = 'parent-1';
          final knownReply = Message(
            id: 'known-reply',
            parentId: parentId,
            user: tester.currentUser,
            createdAt: DateTime.utc(2026),
          );
          // Populate threads[parentId] via addNewMessage's thread-only path.
          tester.channelState!.addNewMessage(knownReply);
          await Future.delayed(Duration.zero);
          expect(tester.channelState!.threads[parentId], hasLength(1));

          tester.channelState!.isUpToDate = false;

          final phantomReply = Message(
            id: 'other-reply',
            parentId: parentId,
            user: tester.currentUser,
            text: 'edited',
            createdAt: DateTime.utc(2026, 1, 2),
          );
          await tester.emitEvent(_updateMessageEvent(phantomReply));

          expect(tester.channelState!.threads[parentId]!.map((m) => m.id), ['known-reply']);
        },
      );

      channelTest(
        'should NOT create phantom threads[parentId] entry for unloaded thread',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          const parentId = 'unloaded-parent';
          // The thread was never paged in, so there's no entry for it.
          expect(tester.channelState!.threads.containsKey(parentId), isFalse);

          tester.channelState!.isUpToDate = false;

          final phantomReply = Message(
            id: 'phantom-reply',
            parentId: parentId,
            user: tester.currentUser,
            text: 'edited',
            createdAt: DateTime.utc(2026, 1, 2),
          );
          await tester.emitEvent(_updateMessageEvent(phantomReply));

          // The dropped reply must not leave behind an empty thread entry.
          expect(tester.channelState!.threads.containsKey(parentId), isFalse);
        },
      );

      channelTest(
        'should still expire activeLiveLocations for out-of-window message',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          final liveLocation = Location(
            channelCid: tester.channel.cid,
            userId: 'user1',
            messageId: 'loc-msg',
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device1',
            endAt: DateTime.now().add(const Duration(hours: 1)),
          );

          // Seed only activeLiveLocations, keeping `messages` empty —
          // the exact "message is outside the loaded window" scenario.
          tester.channelState!.updateChannelState(
            ChannelState(
              channel: tester.channelState!.channelState.channel,
              activeLiveLocations: [liveLocation],
            ),
          );
          tester.channelState!.isUpToDate = false;
          expect(tester.channelState!.messages, isEmpty);
          expect(tester.channelState!.activeLiveLocations, hasLength(1));

          // A message.updated that expires the live location.
          final expiredMessage = Message(
            id: 'loc-msg',
            text: 'Live location shared',
            sharedLocation: liveLocation.copyWith(
              endAt: DateTime.now().subtract(const Duration(minutes: 1)),
            ),
          );
          // Applied directly, the way the `message.updated` listener would:
          // a WS `message.updated` carrying an expired live location is
          // rerouted by `locationExpiredResolver` to `location.expired` before
          // channel state sees it, and that handler no-ops when the message is
          // not loaded. This keeps the state-layer guard itself pinned.
          tester.channelState!.updateMessage(expiredMessage, upsert: false);
          await Future.delayed(Duration.zero);

          expect(tester.channelState!.messages, isEmpty);
          expect(tester.channelState!.activeLiveLocations, isEmpty);
        },
      );
    });
  });
}
