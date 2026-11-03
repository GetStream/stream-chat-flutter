import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../fakes.dart';
import '../../mocks.dart';
import '../../utils.dart';

void main() {
  setUpAll(() => registerFallbackValue(FakeMessage()));

  test('marks a message left sending as failed to send', () {
    final channel = _channel(messages: [_message(state: .sending())]);

    expect(
      channel.state!.messages.single.state,
      MessageState.sendingFailed(skipPush: false, skipEnrichUrl: false),
    );
  });

  test('marks a message left updating as failed to update with its options', () {
    final updating = MessageState.updating(skipPush: true, skipEnrichUrl: true);

    final channel = _channel(messages: [_message(state: updating)]);

    expect(
      channel.state!.messages.single.state,
      MessageState.updatingFailed(skipPush: true, skipEnrichUrl: true),
    );
  });

  test('updates a message left updating again with its options', () async {
    final client = MockStreamChatClientWithPersistence();
    when(() => client.chatPersistenceClient.getChannelThreads(any())).thenAnswer((_) async => {});
    when(
      () => client.updateMessage(
        any(),
        skipPush: any(named: 'skipPush'),
        skipEnrichUrl: any(named: 'skipEnrichUrl'),
      ),
    ).thenAnswer((invocation) async {
      final message = invocation.positionalArguments.first as Message;
      return UpdateMessageResponse()..message = message;
    });
    final updating = MessageState.updating(skipPush: true, skipEnrichUrl: true);

    _channel(
      client: client,
      messages: [_message(state: updating)],
    );
    await pumpEventQueue();

    verify(() => client.updateMessage(any(), skipPush: true, skipEnrichUrl: true)).called(1);
  });

  test('updates a message left partially updating again as a partial update', () async {
    final client = MockStreamChatClientWithPersistence();
    when(() => client.chatPersistenceClient.getChannelThreads(any())).thenAnswer((_) async => {});
    when(
      () => client.partialUpdateMessage(
        any(),
        set: any(named: 'set'),
        unset: any(named: 'unset'),
        skipEnrichUrl: any(named: 'skipEnrichUrl'),
      ),
    ).thenAnswer((_) async => UpdateMessageResponse()..message = _message());
    final updating = MessageState.partialUpdating(set: {'pinned': true}, unset: ['pin_expires'], skipEnrichUrl: true);

    _channel(
      client: client,
      messages: [_message(state: updating)],
    );
    await pumpEventQueue();

    verify(
      () => client.partialUpdateMessage(
        'message',
        set: {'pinned': true},
        unset: ['pin_expires'],
        skipEnrichUrl: true,
      ),
    ).called(1);
    verifyNever(
      () => client.updateMessage(
        any(),
        skipPush: any(named: 'skipPush'),
        skipEnrichUrl: any(named: 'skipEnrichUrl'),
      ),
    );
  });

  test('marks a message left deleting as failed to delete for the same scope', () {
    final channel = _channel(
      messages: [_message(state: .deleting(scope: const .deleteForMe()))],
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

  test('changes only the message left in progress among the others', () {
    final failed = MessageState.sendingFailed(skipPush: false, skipEnrichUrl: false);
    final channel = _channel(
      messages: [
        _message(id: 'sent'),
        _message(id: 'failed', state: failed),
        _message(id: 'sending', state: .sending()),
      ],
    );

    final states = channel.state!.messages.map((it) => it.state);
    expect(states, [MessageState.sent, failed, failed]);
  });

  test('does not touch a message that starts sending after the channel is created', () async {
    final client = MockStreamChatClientWithPersistence();
    when(() => client.chatPersistenceClient.getChannelThreads(any())).thenAnswer((_) async => {});
    final channel = _channel(client: client);

    channel.state!.updateMessage(_message(state: .sending()));
    await pumpEventQueue();

    expect(channel.state!.messages.single.state, MessageState.sending());
    verifyNever(() => client.sendMessage(any(), any(), any()));
  });

  test('sends a stored thread reply left sending again', () async {
    final client = MockStreamChatClientWithPersistence();
    final reply = _message(id: 'reply', parentId: 'parent', state: .sending());
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
      messages: [_message(state: .sending())],
    );
    await pumpEventQueue();

    verify(() => client.sendMessage(any(), channel.id!, channel.type)).called(1);
  });

  test('sends a message left sending again with its push and link preview options', () async {
    final client = MockStreamChatClientWithPersistence();
    when(() => client.chatPersistenceClient.getChannelThreads(any())).thenAnswer((_) async => {});
    _stubSend(client);
    final sending = MessageState.sending(skipPush: true, skipEnrichUrl: true);

    final channel = _channel(
      client: client,
      messages: [_message(state: sending)],
    );
    await pumpEventQueue();

    verify(
      () => client.sendMessage(any(), channel.id!, channel.type, skipPush: true, skipEnrichUrl: true),
    ).called(1);
  });

  test('marks a message left deleting as deleted when it is already gone', () async {
    final client = MockStreamChatClientWithPersistence();
    when(() => client.chatPersistenceClient.getChannelThreads(any())).thenAnswer((_) async => {});
    const message = 'GetMessage failed with error: "message with id message has been deleted"';
    when(() => client.deleteMessage('message')).thenThrow(
      apiException(code: StreamErrorCode.notFound, statusCode: 404, message: message),
    );

    final channel = _channel(
      client: client,
      messages: [_message(state: .deleting(scope: .softDeleteForAll))],
    );
    await pumpEventQueue();

    expect(
      channel.state!.messages.single.state,
      MessageState.deleted(scope: MessageDeleteScope.softDeleteForAll),
    );
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
    return SendMessageResponse()..message = message.copyWith(state: .sent);
  });
}

Channel _channel({MockStreamChatClient? client, List<Message> messages = const []}) {
  final chatClient = client ?? MockStreamChatClient();
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
