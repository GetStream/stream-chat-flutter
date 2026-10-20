import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../fakes.dart';
import '../../mocks.dart';

void main() {
  setUpAll(() => registerFallbackValue(FakeEvent()));

  test('deleting a bounced message emits a hard-deleted message.deleted', () async {
    final (:client, :channel) = _channel();
    final bounced = Message(
      id: 'bounced',
      text: 'bad word',
      type: MessageType.error,
      moderation: const Moderation(action: ModerationAction.bounce, originalText: 'bad word'),
    );
    channel.state!.addNewMessage(bounced);

    await channel.deleteMessage(bounced);

    expect(
      _emittedEvent(client),
      isA<Event>()
          .having((it) => it.type, 'type', EventType.messageDeleted)
          .having((it) => it.cid, 'cid', channel.cid)
          .having((it) => it.hardDelete, 'hardDelete', isTrue)
          .having((it) => it.message?.id, 'message id', 'bounced'),
    );
  });

  test('deleting an unsent message emits message.deleted', () async {
    final (:client, :channel) = _channel();
    final unsent = Message(id: 'unsent', text: 'Hello', state: MessageState.sending);
    channel.state!.addNewMessage(unsent);

    await channel.deleteMessage(unsent);

    expect(
      _emittedEvent(client),
      isA<Event>()
          .having((it) => it.type, 'type', EventType.messageDeleted)
          .having((it) => it.message?.id, 'message id', 'unsent'),
    );
  });
}

// A channel created from a state, on a client that records the events it is
// given.
({MockStreamChatClient client, Channel channel}) _channel() {
  final client = MockStreamChatClient();
  when(() => client.state).thenReturn(FakeClientState());
  when(() => client.channelDeliveryReporter.submitForDelivery(any())).thenAnswer((_) async {});
  when(() => client.retryPolicy).thenReturn(
    RetryPolicy(shouldRetry: (_, __, ___) => false, delayFactor: Duration.zero),
  );
  final channel = Channel.fromState(
    client,
    ChannelState(
      channel: ChannelModel(type: 'messaging', id: 'local-delete'),
    ),
  );
  addTearDown(channel.dispose);
  return (client: client, channel: channel);
}

Event _emittedEvent(MockStreamChatClient client) {
  return verify(() => client.handleEvent(captureAny())).captured.single as Event;
}
