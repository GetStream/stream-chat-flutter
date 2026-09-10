// ignore_for_file: lines_longer_than_80_chars, cascade_invocations, deprecated_member_use_from_same_package, avoid_redundant_argument_values

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../fakes.dart';
import '../../matchers.dart';
import '../../mocks.dart';

void main() {
  ChannelState _generateChannelState(
    String channelId,
    String channelType, {
    DateTime? lastMessageAt,
    List<ChannelCapability>? ownCapabilities,
    bool mockChannelConfig = false,
  }) {
    ChannelConfig? config;
    if (mockChannelConfig) {
      config = MockChannelConfig();
      when(() => config!.readEvents).thenReturn(true);
      when(() => config!.typingEvents).thenReturn(true);
    }
    final channel = ChannelModel(
      id: channelId,
      type: channelType,
      config: config,
      ownCapabilities: ownCapabilities,
      lastMessageAt: lastMessageAt,
    );
    final state = ChannelState(channel: channel);
    return state;
  }

  Logger _createLogger(String name) {
    final logger = Logger.detached(name)..level = Level.ALL;
    logger.onRecord.listen(print);
    return logger;
  }

  group('Retry functionality with parameter preservation', () {
    late final client = MockStreamChatClient();
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    late Channel channel;

    setUpAll(() {
      registerFallbackValue(FakeMessage());
      registerFallbackValue(<Message>[]);
      registerFallbackValue(FakeAttachmentFile());

      when(() => client.detachedLogger(any())).thenAnswer((invocation) {
        final name = invocation.positionalArguments.first;
        return _createLogger(name);
      });

      when(() => client.logger).thenReturn(_createLogger('mock-client-logger'));

      final clientState = FakeClientState();
      when(() => client.state).thenReturn(clientState);

      final retryPolicy = RetryPolicy(
        shouldRetry: (_, __, error) {
          return error is StreamChatNetworkError && error.isRetriable;
        },
      );
      when(() => client.retryPolicy).thenReturn(retryPolicy);
    });

    setUp(() {
      final channelState = _generateChannelState(channelId, channelType);
      channel = Channel.fromState(client, channelState);
    });

    tearDown(() {
      channel.dispose();
    });

    group('retryMessage method', () {
      test('should call sendMessage with preserved skipPush and skipEnrichUrl parameters', () async {
        final message = Message(
          id: 'test-message-id',
          text: 'Hello, World!',
          state: MessageState.sendingFailed(
            skipPush: true,
            skipEnrichUrl: true,
          ),
        );

        final sendMessageResponse = SendMessageResponse()..message = message.copyWith(state: MessageState.sent);

        when(
          () => client.sendMessage(
            any(that: isSameMessageAs(message)),
            channelId,
            channelType,
            skipPush: true,
            skipEnrichUrl: true,
          ),
        ).thenAnswer((_) async => sendMessageResponse);

        final result = await channel.retryMessage(message);

        expect(result, isNotNull);
        expect(result, isA<SendMessageResponse>());

        verify(
          () => client.sendMessage(
            any(that: isSameMessageAs(message)),
            channelId,
            channelType,
            skipPush: true,
            skipEnrichUrl: true,
          ),
        ).called(1);
      });

      test('should call sendMessage with preserved skipPush parameter', () async {
        final message = Message(
          id: 'test-message-id',
          text: 'Hello, World!',
          state: MessageState.sendingFailed(
            skipPush: true,
            skipEnrichUrl: false,
          ),
        );

        final sendMessageResponse = SendMessageResponse()..message = message.copyWith(state: MessageState.sent);

        when(
          () => client.sendMessage(
            any(that: isSameMessageAs(message)),
            channelId,
            channelType,
            skipPush: true,
          ),
        ).thenAnswer((_) async => sendMessageResponse);

        final result = await channel.retryMessage(message);

        expect(result, isNotNull);
        expect(result, isA<SendMessageResponse>());

        verify(
          () => client.sendMessage(
            any(that: isSameMessageAs(message)),
            channelId,
            channelType,
            skipPush: true,
          ),
        ).called(1);
      });

      test('should call sendMessage with preserved skipEnrichUrl parameter', () async {
        final message = Message(
          id: 'test-message-id',
          text: 'Hello, World!',
          state: MessageState.sendingFailed(
            skipPush: false,
            skipEnrichUrl: true,
          ),
        );

        final sendMessageResponse = SendMessageResponse()..message = message.copyWith(state: MessageState.sent);

        when(
          () => client.sendMessage(
            any(that: isSameMessageAs(message)),
            channelId,
            channelType,
            skipEnrichUrl: true,
          ),
        ).thenAnswer((_) async => sendMessageResponse);

        final result = await channel.retryMessage(message);

        expect(result, isNotNull);
        expect(result, isA<SendMessageResponse>());

        verify(
          () => client.sendMessage(
            any(that: isSameMessageAs(message)),
            channelId,
            channelType,
            skipEnrichUrl: true,
          ),
        ).called(1);
      });

      test('should call sendMessage with preserved false skipPush and skipEnrichUrl parameters', () async {
        final message = Message(
          id: 'test-message-id',
          text: 'Hello, World!',
          state: MessageState.sendingFailed(
            skipPush: false,
            skipEnrichUrl: false,
          ),
        );

        final sendMessageResponse = SendMessageResponse()..message = message.copyWith(state: MessageState.sent);

        when(
          () => client.sendMessage(
            any(that: isSameMessageAs(message)),
            channelId,
            channelType,
          ),
        ).thenAnswer((_) async => sendMessageResponse);

        final result = await channel.retryMessage(message);

        expect(result, isNotNull);
        expect(result, isA<SendMessageResponse>());

        verify(
          () => client.sendMessage(
            any(that: isSameMessageAs(message)),
            channelId,
            channelType,
          ),
        ).called(1);
      });

      test('should call updateMessage with preserved skipPush, skipEnrichUrl parameter', () async {
        final message = Message(
          id: 'test-message-id',
          text: 'Hello, World!',
          state: MessageState.updatingFailed(
            skipPush: true,
            skipEnrichUrl: true,
          ),
        );

        final updateMessageResponse = UpdateMessageResponse()..message = message.copyWith(state: MessageState.updated);

        when(
          () => client.updateMessage(
            any(that: isSameMessageAs(message)),
            skipPush: true,
            skipEnrichUrl: true,
          ),
        ).thenAnswer((_) async => updateMessageResponse);

        final result = await channel.retryMessage(message);

        expect(result, isNotNull);
        expect(result, isA<UpdateMessageResponse>());

        verify(
          () => client.updateMessage(
            any(that: isSameMessageAs(message)),
            skipPush: true,
            skipEnrichUrl: true,
          ),
        ).called(1);
      });

      test('should call updateMessage with preserved false skipPush, skipEnrichUrl parameter', () async {
        final message = Message(
          id: 'test-message-id',
          state: MessageState.updatingFailed(
            skipPush: false,
            skipEnrichUrl: false,
          ),
        );

        final updateMessageResponse = UpdateMessageResponse()..message = message.copyWith(state: MessageState.updated);

        when(
          () => client.updateMessage(
            any(that: isSameMessageAs(message)),
          ),
        ).thenAnswer((_) async => updateMessageResponse);

        final result = await channel.retryMessage(message);

        expect(result, isNotNull);
        expect(result, isA<UpdateMessageResponse>());

        verify(
          () => client.updateMessage(
            any(that: isSameMessageAs(message)),
          ),
        ).called(1);
      });

      test('should call deleteMessage with preserved hard parameter', () async {
        final message = Message(
          id: 'test-message-id',
          createdAt: DateTime.now(),
          state: MessageState.hardDeletingFailed,
        );

        when(
          () => client.deleteMessage(
            message.id,
            hard: true,
          ),
        ).thenAnswer((_) async => EmptyResponse());

        final result = await channel.retryMessage(message);

        expect(result, isNotNull);
        expect(result, isA<EmptyResponse>());

        verify(
          () => client.deleteMessage(
            message.id,
            hard: true,
          ),
        ).called(1);
      });

      test('should call deleteMessage with preserved false hard parameter', () async {
        final message = Message(
          id: 'test-message-id',
          createdAt: DateTime.now(),
          state: MessageState.softDeletingFailed,
        );

        when(
          () => client.deleteMessage(
            message.id,
          ),
        ).thenAnswer((_) async => EmptyResponse());

        final result = await channel.retryMessage(message);

        expect(result, isNotNull);
        expect(result, isA<EmptyResponse>());

        verify(
          () => client.deleteMessage(
            message.id,
          ),
        ).called(1);
      });

      test('should call deleteMessageForMe for deletingForMeFailed state', () async {
        final message = Message(
          id: 'test-message-id',
          createdAt: DateTime.now(),
          state: MessageState.deletingForMeFailed,
        );

        when(() => client.deleteMessageForMe(message.id)).thenAnswer((_) async => EmptyResponse());

        final result = await channel.retryMessage(message);

        expect(result, isNotNull);
        expect(result, isA<EmptyResponse>());

        verify(() => client.deleteMessageForMe(message.id)).called(1);
      });

      test('should throw AssertionError when message state is not failed', () async {
        final message = Message(
          id: 'test-message-id',
          state: MessageState.sent,
        );

        expect(() => channel.retryMessage(message), throwsA(isA<AssertionError>()));
      });
    });
  });
}
