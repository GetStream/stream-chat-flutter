import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

final _deletedAt = DateTime.utc(2026, 7);

ChannelState Function(ChannelState) _seedChannel() {
  return (_) => createDefaultChannelState(
    channel: createDefaultChannelModel(
      cid: _channelCid,
      config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
      ownCapabilities: const [ChannelCapability.readEvents],
    ),
  );
}

Event _deleteMessageEvent(Message message, {bool hardDelete = false}) {
  return createDefaultEvent(
    cid: _channelCid,
    type: EventType.messageDeleted,
    message: message.copyWith(
      type: MessageType.deleted,
      deletedAt: _deletedAt,
    ),
    hardDelete: hardDelete,
  );
}

void main() {
  // A `message.deleted` event for a message outside the loaded window
  // must not upsert a "deleted" record into the sorted list — that would
  // create a phantom entry with a gap. Pinned + live-location
  // side-effects must still fire.
  group(EventType.messageDeleted, () {
    // Same design as the `messageUpdated` guards: the check is
    // "message-in-loaded-window" and is independent of `isUpToDate` —
    // an event for a message on an older, unloaded page must not be
    // turned into a phantom "deleted" record inserted into the sorted
    // list.
    group('when message is outside the loaded window', () {
      channelTest(
        'soft delete does NOT insert phantom "deleted" record into messages',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
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

          final olderPage = Message(
            id: 'older-page-msg',
            user: tester.currentUser,
            text: 'gone',
            createdAt: DateTime.utc(2025, 1, 1),
          );
          await tester.emitEvent(_deleteMessageEvent(olderPage));

          expect(tester.channelState!.messages.map((m) => m.id), ['tail-0', 'tail-1', 'tail-2']);
        },
      );

      channelTest(
        'soft delete marks message as deleted when it IS in the loaded window',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          const messageId = 'known';
          final seeded = Message(
            id: messageId,
            user: tester.currentUser,
            text: 'hi',
            createdAt: DateTime.utc(2026),
          );
          tester.channelState!.updateChannelState(
            tester.channelState!.channelState.copyWith(messages: [seeded]),
          );
          tester.channelState!.isUpToDate = false;

          await tester.emitEvent(_deleteMessageEvent(seeded));

          final stored = tester.channelState!.messages.singleWhere((m) => m.id == messageId);
          expect(stored.type, equals(MessageType.deleted));
          expect(stored.deletedAt, isNotNull);
        },
      );

      channelTest(
        'soft delete unpins a pinned-but-not-in-window message via _pinIsValid',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          const messageId = 'pinned-msg';
          final pinned = Message(
            id: messageId,
            user: tester.currentUser,
            pinned: true,
            createdAt: DateTime.utc(2026),
          );
          // Seed only the pinnedMessages list — message absent from
          // the main `messages` window.
          tester.channelState!.updateChannelState(
            tester.channelState!.channelState.copyWith(pinnedMessages: [pinned]),
          );
          tester.channelState!.isUpToDate = false;
          expect(tester.channelState!.messages, isEmpty);
          expect(tester.channelState!.pinnedMessages, hasLength(1));

          await tester.emitEvent(_deleteMessageEvent(pinned));

          expect(tester.channelState!.messages, isEmpty);
          expect(tester.channelState!.pinnedMessages, isEmpty);
        },
      );

      channelTest(
        'soft delete still clears activeLiveLocations even when message not in window',
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
            endAt: DateTime.timestamp().add(const Duration(hours: 1)),
          );

          // Seed only activeLiveLocations, keeping `messages` empty.
          tester.channelState!.updateChannelState(
            ChannelState(
              channel: tester.channelState!.channelState.channel,
              activeLiveLocations: [liveLocation],
            ),
          );
          tester.channelState!.isUpToDate = false;
          expect(tester.channelState!.messages, isEmpty);
          expect(tester.channelState!.activeLiveLocations, hasLength(1));

          final locationMessage = Message(
            id: 'loc-msg',
            text: 'Live location shared',
            sharedLocation: liveLocation,
          );
          await tester.emitEvent(_deleteMessageEvent(locationMessage));

          expect(tester.channelState!.messages, isEmpty);
          expect(tester.channelState!.activeLiveLocations, isEmpty);
        },
      );

      channelTest(
        'hard delete is a no-op when message is not in the loaded window',
        channelType: _channelType,
        channelId: _channelId,
        setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
        body: (tester) async {
          tester.channelState!.isUpToDate = false;
          expect(tester.channelState!.messages, isEmpty);

          final phantom = Message(
            id: 'phantom',
            user: tester.currentUser,
            text: 'gone',
            createdAt: DateTime.utc(2026),
          );
          await tester.emitEvent(_deleteMessageEvent(phantom, hardDelete: true));

          expect(tester.channelState!.messages, isEmpty);
          expect(tester.channelState!.pinnedMessages, isEmpty);
        },
      );
    });

    channelTest(
      'an in-window hard delete removes the message',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(
          id: 'doomed-message-id',
          user: User(id: 'other-user'),
          createdAt: DateTime.utc(2026),
        );
        tester.channelState!.updateMessage(message);
        expect(tester.channelState!.messages, hasLength(1));

        await tester.emitEvent(_deleteMessageEvent(message, hardDelete: true));

        expect(tester.channelState!.messages, isEmpty);
      },
    );

    channelTest(
      'deletedForMe is propagated to the stored message',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final message = Message(
          id: 'deleted-for-me-message-id',
          user: User(id: 'other-user'),
          createdAt: DateTime.utc(2026),
        );
        tester.channelState!.updateMessage(message);

        await tester.emitEvent(
          createDefaultEvent(
            cid: _channelCid,
            type: EventType.messageDeleted,
            deletedForMe: true,
            message: message.copyWith(
              type: MessageType.deleted,
              deletedAt: _deletedAt,
            ),
          ),
        );

        final stored = tester.channelState!.messages.single;
        expect(stored.deletedForMe, isTrue);
        expect(stored.type, MessageType.deleted);
      },
    );
  });
}
