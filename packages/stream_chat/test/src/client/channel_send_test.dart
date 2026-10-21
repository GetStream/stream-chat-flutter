import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../matchers.dart';
import '../mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(FakeMessage());
    registerFallbackValue(FakeEvent());
  });

  group('when the message id already exists', () {
    test('marks the message as sent', () async {
      final client = MockStreamChatClient();
      final channel = _initializedChannel(client);
      final message = Message(id: 'stored-message-id', text: 'Hello world!');

      _whenSendingMessage(client, channel, message)
          .thenThrow(_messageAlreadyExistsError(message.id));
      await channel.sendMessage(message);

      expect(channel.state!.messages.single.state, MessageState.sent);
    });

    test('returns the message marked as sent', () async {
      final client = MockStreamChatClient();
      final channel = _initializedChannel(client);
      final message = Message(id: 'stored-message-id', text: 'Hello world!');

      _whenSendingMessage(client, channel, message)
          .thenThrow(_messageAlreadyExistsError(message.id));
      final response = await channel.sendMessage(message);

      expect(response.message.state, MessageState.sent);
    });

    test(
      'stamps the local creation date as the server creation date when no '
      'server copy arrived',
      () async {
        final client = MockStreamChatClient();
        final channel = _initializedChannel(client);
        final message = Message(id: 'stored-message-id', text: 'Hello world!');

        _whenSendingMessage(client, channel, message)
            .thenThrow(_messageAlreadyExistsError(message.id));
        await channel.sendMessage(message);

        final sentMessage = channel.state!.messages.single;
        expect(sentMessage.remoteCreatedAt, sentMessage.localCreatedAt);
      },
    );

    test('keeps the server creation date when message.new arrived first',
        () async {
      final client = MockStreamChatClient();
      final channel = _initializedChannel(client);
      final message = Message(id: 'stored-message-id', text: 'Hello world!');
      final serverCreatedAt = DateTime.utc(2026, 10, 8, 7, 47, 56);

      _whenSendingMessage(client, channel, message).thenAnswer((_) async {
        // The server's copy arrives over the WebSocket before the send fails.
        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.messageNew,
            message: message.copyWith(createdAt: serverCreatedAt),
          ),
        );
        await pumpEventQueue();
        throw _messageAlreadyExistsError(message.id);
      });
      await channel.sendMessage(message);

      expect(channel.state!.messages.single.remoteCreatedAt, serverCreatedAt);
    });

    test(
      'marks a timed-out send as sent once its retry is rejected as a '
      'duplicate',
      () async {
        final client = MockStreamChatClient();
        final channel = _initializedChannel(client);
        final message = Message(id: 'stored-message-id', text: 'Hello world!');

        // The first attempt times out, so the retry queue re-sends the message.
        final receiveTimeout = StreamChatNetworkError.raw(
          code: -1,
          message: 'The request took longer than the receive timeout',
          type: StreamChatNetworkErrorType.receiveTimeout,
        );
        final errors = [receiveTimeout, _messageAlreadyExistsError(message.id)];
        var attempt = 0;
        _whenSendingMessage(client, channel, message).thenAnswer((_) async {
          final error = errors[attempt];
          attempt += 1;
          throw error;
        });
        await expectLater(
          channel.sendMessage(message),
          throwsA(isA<StreamChatNetworkError>()),
        );
        await pumpEventQueue();

        expect(channel.state!.messages.single.state, MessageState.sent);
      },
    );
  });
}

Channel _initializedChannel(MockStreamChatClient client) {
  when(() => client.detachedLogger(any())).thenAnswer(
    (it) => Logger.detached(it.positionalArguments.first as String),
  );
  when(() => client.logger).thenReturn(Logger.detached('test-client'));
  when(() => client.state).thenReturn(FakeClientState());
  when(() => client.retryPolicy).thenReturn(
    RetryPolicy(shouldRetry: (_, __, ___) => false, delayFactor: Duration.zero),
  );
  when(() => client.channelDeliveryReporter.submitForDelivery(any()))
      .thenAnswer((_) async {});
  addTearDown(client.dispose);

  final channel = Channel.fromState(
    client,
    ChannelState(
      channel: ChannelModel(id: 'test-channel-id', type: 'test-channel-type'),
    ),
  );
  addTearDown(channel.dispose);

  return channel;
}

When<Future<SendMessageResponse>> _whenSendingMessage(
  StreamChatClient client,
  Channel channel,
  Message message,
) {
  return when(
    () => client.sendMessage(
      any(that: isSameMessageAs(message)),
      channel.id!,
      channel.type,
    ),
  );
}

StreamChatNetworkError _messageAlreadyExistsError(String messageId) {
  return _inputError(
    'SendMessage failed with error: "a message with ID $messageId already '
    'exists"',
  );
}

StreamChatNetworkError _inputError(String message) {
  return StreamChatNetworkError.raw(
    code: ChatErrorCode.inputError.code,
    message: message,
    statusCode: 400,
    data: ErrorResponse()
      ..code = ChatErrorCode.inputError.code
      ..message = message
      ..statusCode = 400,
    type: StreamChatNetworkErrorType.badResponse,
  );
}
