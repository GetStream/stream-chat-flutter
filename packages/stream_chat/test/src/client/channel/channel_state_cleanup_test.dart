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
      ownCapabilities: [ChannelCapability.readEvents],
    ),
  );
}

// A bare channel state (no config, no capabilities) used to seed messages
// directly into the channel's client state.
ChannelState _channelStateWith({
  List<Message> messages = const [],
  List<Message> pinnedMessages = const [],
}) {
  return createDefaultChannelState(
    channel: createDefaultChannelModel(cid: _channelCid),
    messages: messages,
    pinnedMessages: pinnedMessages,
  );
}

List<Message> _generateMessages(int count) => List.generate(
  count,
  (i) => Message(
    id: 'msg-$i',
    text: 'Hello $i',
    createdAt: DateTime.utc(2024).add(Duration(seconds: i)),
  ),
);

void main() {
  group('stale error message cleanup', () {
    final errorMessage = Message(type: MessageType.error);
    final bouncedErrorMessage = Message(
      type: MessageType.error,
      moderation: const Moderation(
        action: ModerationAction.bounce,
        originalText: 'original text',
      ),
    );

    // Test case: sending a message cleans up stale error messages
    channelTest(
      'when sending a new message',
      channelType: _channelType,
      channelId: _channelId,
      // Channel with 2 error messages
      setUp: (tester) => tester.watch(
        modifyResponse: (_) => _channelStateWith(
          messages: [errorMessage, bouncedErrorMessage],
        ),
      ),
      body: (tester) async {
        // Set up the mock response for sending message
        final newMessage = Message(text: 'New message');

        tester.mockApi(
          (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(newMessage))),
          result: createDefaultSendMessageResponse(message: newMessage.copyWith(state: MessageState.sent)),
        );

        // Send a new message
        await tester.channel.sendMessage(newMessage);
        final messages = tester.channelState!.messages;

        // Verify the cleanup
        expect(messages.length, 2);
        expect(messages.any((m) => m.id == errorMessage.id), false);
        expect(messages.any((m) => m.id == bouncedErrorMessage.id), true);
        expect(messages.any((m) => m.id == newMessage.id), true);

        tester.verifyApi(
          (api) => api.message.sendMessage(_channelId, _channelType, any(that: isSameMessageAs(newMessage))),
        );
      },
    );
  });

  group('`.state.pruneOldest`', () {
    channelTest(
      'keeps only the [maxMessages] most recent messages',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final initial = _generateMessages(10);
        tester.channelState!.updateChannelState(_channelStateWith(messages: initial));
        expect(tester.channelState!.messages, hasLength(10));

        tester.channelState!.pruneOldest(4);

        final pruned = tester.channelState!.messages;
        expect(pruned, hasLength(4));
        expect(pruned.map((m) => m.id), ['msg-6', 'msg-7', 'msg-8', 'msg-9']);
      },
    );

    channelTest(
      'emits the pruned list on `messagesStream`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final initial = _generateMessages(6);
        tester.channelState!.updateChannelState(_channelStateWith(messages: initial));

        final next = tester.channelState!.messagesStream.firstWhere((messages) => messages.length == 3);

        tester.channelState!.pruneOldest(3);

        final emitted = await next;
        expect(emitted.map((m) => m.id), ['msg-3', 'msg-4', 'msg-5']);
      },
    );

    channelTest(
      'is a no-op when message count is within the limit',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final initial = _generateMessages(3);
        tester.channelState!.updateChannelState(_channelStateWith(messages: initial));

        tester.channelState!.pruneOldest(5);
        expect(tester.channelState!.messages, hasLength(3));

        tester.channelState!.pruneOldest(3);
        expect(tester.channelState!.messages, hasLength(3));
      },
    );

    channelTest(
      'is a no-op when [maxMessages] is zero or negative',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final initial = _generateMessages(5);
        tester.channelState!.updateChannelState(_channelStateWith(messages: initial));

        tester.channelState!.pruneOldest(0);
        expect(tester.channelState!.messages, hasLength(5));

        tester.channelState!.pruneOldest(-1);
        expect(tester.channelState!.messages, hasLength(5));
      },
    );

    channelTest(
      'is a no-op when `isUpToDate` is false',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final initial = _generateMessages(10);
        tester.channelState!.updateChannelState(_channelStateWith(messages: initial));

        tester.channelState!.isUpToDate = false;
        tester.channelState!.pruneOldest(3);
        expect(tester.channelState!.messages, hasLength(10));
      },
    );

    channelTest(
      'only mutates `messages`; other channel state fields untouched',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final initial = _generateMessages(10);
        final pinned = [
          Message(
            id: 'pinned-1',
            text: 'pinned message',
            createdAt: DateTime.utc(2024),
          ),
        ];

        tester.channelState!.updateChannelState(
          _channelStateWith(messages: initial, pinnedMessages: pinned),
        );

        tester.channelState!.pruneOldest(3);

        expect(tester.channelState!.messages, hasLength(3));
        expect(tester.channelState!.pinnedMessages, equals(pinned));
      },
    );

    channelTest(
      'does not emit on `messagesStream` for no-op calls',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        final initial = _generateMessages(5);
        tester.channelState!.updateChannelState(_channelStateWith(messages: initial));

        // Skip the seeded emission from updateChannelState.
        await pumpEventQueue();

        final emissions = <List<Message>>[];
        final sub = tester.channelState!.messagesStream.skip(1).listen(emissions.add);
        addTearDown(sub.cancel);

        tester.channelState!.pruneOldest(0); // non-positive guard
        tester.channelState!.pruneOldest(-1); // non-positive guard
        tester.channelState!.pruneOldest(10); // within limit guard
        tester.channelState!.isUpToDate = false;
        tester.channelState!.pruneOldest(2); // !isUpToDate guard

        await pumpEventQueue();
        expect(emissions, isEmpty);
      },
    );
  });
}
