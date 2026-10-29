import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../fakes.dart';
import '../../mocks.dart';

void main() {
  setUpAll(() => registerFallbackValue(FakeMessage()));

  test('marks a message left sending as failed to send', () {
    final channel = _channel(messages: [_message(state: MessageState.sending)]);

    expect(
      channel.state!.messages.single.state,
      MessageState.sendingFailed(skipPush: false, skipEnrichUrl: false),
    );
  });

  test('marks a message left updating as failed to update', () {
    final channel = _channel(messages: [_message(state: MessageState.updating)]);

    expect(
      channel.state!.messages.single.state,
      MessageState.updatingFailed(skipPush: false, skipEnrichUrl: false),
    );
  });

  test('marks a message left deleting as failed to delete for the same scope', () {
    final channel = _channel(
      messages: [_message(state: MessageState.deleting(scope: const MessageDeleteScope.deleteForMe()))],
    );

    expect(
      channel.state!.messages.single.state,
      MessageState.deletingFailed(scope: const MessageDeleteScope.deleteForMe()),
    );
  });

  test('keeps the messages as they are when none was left in progress', () {
    final messages = [_message(), _message(id: 'other-message')];

    final channel = _channel(messages: messages);

    expect(channel.state!.messages, same(messages));
  });

  test('sends a stored thread reply left sending again', () async {
    final client = MockStreamChatClientWithPersistence();
    final reply = _message(id: 'reply', parentId: 'parent', state: MessageState.sending);
    when(() => client.chatPersistenceClient.getChannelThreads(any())).thenAnswer(
      (_) async => {
        'parent': [reply],
      },
    );
    _stubSend(client);

    final channel = _channel(client: client);
    await pumpEventQueue();

    verify(
      () => client.sendMessage(any(that: isA<Message>().having((it) => it.id, 'id', 'reply')), any(), any()),
    ).called(1);
    expect(channel.state!.threads['parent']?.single.state.isCompleted, isTrue);
  });

  test('sends a message left sending again', () async {
    final client = MockStreamChatClientWithPersistence();
    when(() => client.chatPersistenceClient.getChannelThreads(any())).thenAnswer((_) async => {});
    _stubSend(client);

    final channel = _channel(
      client: client,
      messages: [_message(state: MessageState.sending)],
    );
    await pumpEventQueue();

    verify(() => client.sendMessage(any(), channel.id!, channel.type)).called(1);
  });
}

Message _message({
  String id = 'message',
  String? parentId,
  MessageState state = MessageState.sent,
}) {
  return Message(
    id: id,
    text: 'Hello',
    parentId: parentId,
    user: User(id: 'current-user'),
    createdAt: DateTime(2026, 10, 29, 12),
    state: state,
  );
}

void _stubSend(MockStreamChatClient client) {
  when(
    () => client.sendMessage(
      any(),
      any(),
      any(),
      skipPush: any(named: 'skipPush'),
      skipEnrichUrl: any(named: 'skipEnrichUrl'),
    ),
  ).thenAnswer((invocation) async {
    final message = invocation.positionalArguments.first as Message;
    return SendMessageResponse()..message = message.copyWith(state: MessageState.sent);
  });
}

Channel _channel({MockStreamChatClient? client, List<Message> messages = const []}) {
  final chatClient = client ?? MockStreamChatClient();
  when(
    () => chatClient.detachedLogger(any()),
  ).thenAnswer((invocation) => Logger.detached(invocation.positionalArguments.first as String));
  when(() => chatClient.logger).thenReturn(Logger.detached('client'));
  when(() => chatClient.state).thenReturn(FakeClientState());
  when(() => chatClient.channelDeliveryReporter.submitForDelivery(any())).thenAnswer((_) async {});
  when(() => chatClient.retryPolicy).thenReturn(
    RetryPolicy(shouldRetry: (_, __, ___) => false, delayFactor: Duration.zero),
  );

  final channel = Channel.fromState(
    chatClient,
    ChannelState(
      channel: ChannelModel(type: 'messaging', id: 'interrupted'),
      messages: messages,
    ),
  );
  addTearDown(channel.dispose);
  return channel;
}
