import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

final _messageCreatedAt = DateTime.utc(2021, 3);

ChannelState Function(ChannelState) _seedChannel() {
  return (_) => createDefaultChannelState(
    channel: createDefaultChannelModel(
      cid: _channelCid,
      config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
      ownCapabilities: const [ChannelCapability.readEvents],
    ),
  );
}

void main() {
  group('Watching Events', () {
    channelTest(
      '${EventType.userWatchingStart} adds the watcher and updates watcherCount',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final watcher = User(id: 'watcher-1');

        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.userWatchingStart,
            user: watcher,
            watcherCount: 3,
          ),
        );

        expect(tester.channelState!.watcherCount, 3);
        expect(
          tester.channelState!.channelState.watchers?.map((it) => it.id),
          contains('watcher-1'),
        );
      },
    );

    channelTest(
      '${EventType.userWatchingStop} removes the watcher and updates watcherCount',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final watcher = User(id: 'watcher-1');

        // The watcher starts watching first (count = 2).
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.userWatchingStart,
            user: watcher,
            watcherCount: 2,
          ),
        );
        expect(tester.channelState!.watcherCount, 2);
        expect(
          tester.channelState!.channelState.watchers?.map((it) => it.id),
          contains('watcher-1'),
        );

        // Then stops watching (count = 1).
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.userWatchingStop,
            user: watcher,
            watcherCount: 1,
          ),
        );

        expect(tester.channelState!.watcherCount, 1);
        expect(
          tester.channelState!.channelState.watchers?.map((it) => it.id),
          isNot(contains('watcher-1')),
        );
      },
    );

    channelTest(
      'watching event without watcherCount preserves the existing count',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        // Seed an initial watcher count.
        tester.channelState!.updateChannelState(
          tester.channelState!.channelState.copyWith(watcherCount: 5),
        );
        expect(tester.channelState!.watcherCount, 5);

        // A watching event that omits watcher_count must not wipe the count.
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.userWatchingStart,
            user: User(id: 'watcher-2'),
          ),
        );

        expect(tester.channelState!.watcherCount, 5);
        expect(
          tester.channelState!.channelState.watchers?.map((it) => it.id),
          contains('watcher-2'),
        );
      },
    );

    channelTest(
      '${EventType.messageNew} updates watcherCount from the event',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        expect(tester.channelState!.watcherCount, isNull);

        final message = Message(
          id: 'test-message-id',
          user: tester.currentUser,
          createdAt: _messageCreatedAt,
        );

        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.messageNew,
            message: message,
            watcherCount: 7,
          ),
        );

        expect(tester.channelState!.watcherCount, 7);
      },
    );

    channelTest(
      '${EventType.messageNew} without watcherCount preserves the existing count',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        // Seed an initial watcher count.
        tester.channelState!.updateChannelState(
          tester.channelState!.channelState.copyWith(watcherCount: 4),
        );
        expect(tester.channelState!.watcherCount, 4);

        // A local/optimistic message.new without watcher_count must not
        // reset the count.
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.messageNew,
            message: Message(
              id: 'test-message-id-2',
              user: tester.currentUser,
              createdAt: _messageCreatedAt,
            ),
          ),
        );

        expect(tester.channelState!.watcherCount, 4);
      },
    );

    channelTest(
      '${EventType.notificationMessageNew} does not overwrite watcherCount',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        // Seed a known watcher count.
        tester.channelState!.updateChannelState(
          tester.channelState!.channelState.copyWith(watcherCount: 5),
        );
        expect(tester.channelState!.watcherCount, 5);

        // notification.message_new is delivered to non-watchers and reports
        // watcher_count: 0; it must not clobber the real count.
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.notificationMessageNew,
            message: Message(
              id: 'notif-message-id',
              user: User(id: 'other-user'),
              createdAt: _messageCreatedAt,
            ),
            watcherCount: 0,
          ),
        );

        expect(tester.channelState!.watcherCount, 5);
      },
    );

    channelTest(
      '${EventType.userWatchingStop} without a watcher count preserves the count',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.userWatchingStart,
            user: User(id: 'watcher-1'),
            watcherCount: 5,
          ),
        );
        expect(tester.channelState!.watcherCount, 5);

        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.userWatchingStop,
            user: User(id: 'watcher-1'),
          ),
        );

        expect(tester.channelState!.channelState.watchers, isEmpty);
        expect(tester.channelState!.watcherCount, 5);
      },
    );
  });
}
