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

  group('Non-Initialized Channel', () {
    late final client = MockStreamChatClient();
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    late Channel channel;

    setUpAll(() {
      // detached loggers
      when(() => client.detachedLogger(any())).thenAnswer((invocation) {
        final name = invocation.positionalArguments.first;
        return _createLogger(name);
      });

      // client logger
      when(() => client.logger).thenReturn(_createLogger('mock-client-logger'));

      // fake clientState
      final clientState = FakeClientState();
      when(() => client.state).thenReturn(clientState);
    });

    setUp(() {
      channel = Channel(client, channelType, channelId);
    });

    tearDown(() {
      channel.dispose();
    });

    test('should be able to set `extraData`', () {
      expect(channel.extraData.isEmpty, isTrue);

      expect(
        () => channel.extraData = {'name': 'test-channel-name'},
        returnsNormally,
      );

      expect(channel.extraData.isEmpty, isFalse);
      expect(channel.extraData.containsKey('name'), isTrue);
      expect(channel.extraData['name'], 'test-channel-name');
    });

    test('should be able to get and set `image`', () {
      expect(channel.extraData.isEmpty, isTrue);

      const imageUrl = 'https://getstream.io/some-image';
      channel.image = imageUrl;

      expect(channel.image, imageUrl);
      expect(channel.extraData['image'], imageUrl);

      const newImage = 'https://getstream.io/new-image';
      final newChannelInstance = Channel(client, channelType, channelId, image: newImage);

      expect(newChannelInstance.image, newImage);
      expect(newChannelInstance.extraData['image'], newImage);
    });

    test('should be able to get and set `name`', () {
      expect(channel.extraData.isEmpty, isTrue);

      const name = 'Channel name';
      channel.name = name;

      expect(channel.name, name);
      expect(channel.extraData['name'], name);

      const newName = 'New channel name';
      final newChannelInstance = Channel(client, channelType, channelId, name: newName);

      expect(newChannelInstance.name, newName);
      expect(newChannelInstance.extraData['name'], newName);
    });

    test('setters remain usable after a failed watch()', () async {
      // Make initialization fail.
      when(
        () => client.queryChannel(
          channelType,
          channelId: any(named: 'channelId'),
          channelData: any(named: 'channelData'),
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          messagesPagination: any(named: 'messagesPagination'),
          membersPagination: any(named: 'membersPagination'),
          watchersPagination: any(named: 'watchersPagination'),
        ),
      ).thenThrow(StreamChatNetworkError(ChatErrorCode.inputError));

      // A failed watch() also completes `initialized` with the error. Attach
      // the expectation up-front so that error has a listener the moment it
      // occurs and isn't reported as an unhandled async error.
      final initializedFailure = expectLater(
        channel.initialized,
        throwsA(isA<StreamChatNetworkError>()),
      );

      await expectLater(
        channel.watch(),
        throwsA(isA<StreamChatNetworkError>()),
      );
      await initializedFailure;

      // Init never *succeeded*, so the raw setters must still work. Previously
      // they threw because the completer was merely `isCompleted` (it had
      // completed with an error).
      expect(() => channel.name = 'New name', returnsNormally);
      expect(channel.name, 'New name');
    });
  });

  group('Initialized Channel with Persistence', () {
    late final client = MockStreamChatClientWithPersistence();
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    const channelCid = '$channelType:$channelId';
    late Channel channel;

    setUpAll(() {
      // Fallback values
      registerFallbackValue(FakeMessage());
      registerFallbackValue(<Message>[]);
      registerFallbackValue(FakeAttachmentFile());

      // detached loggers
      when(() => client.detachedLogger(any())).thenAnswer((invocation) {
        final name = invocation.positionalArguments.first;
        return _createLogger(name);
      });

      final retryPolicy = RetryPolicy(
        shouldRetry: (_, __, ___) => false,
        delayFactor: Duration.zero,
      );
      when(() => client.retryPolicy).thenReturn(retryPolicy);

      // fake clientState
      final clientState = FakeClientState();
      when(() => client.state).thenReturn(clientState);

      // mock persistence client
      final channelThreads = <String, List<Message>>{};
      when(() => client.chatPersistenceClient.getChannelThreads(channelCid)).thenAnswer((_) async => channelThreads);
      final channelState = _generateChannelState(channelId, channelType);
      when(() => client.chatPersistenceClient.getChannelStateByCid(channelCid)).thenAnswer((_) async => channelState);
      when(() => client.chatPersistenceClient.updateMessages(channelCid, any())).thenAnswer((_) => Future.value());

      // client logger
      when(() => client.logger).thenReturn(_createLogger('mock-client-logger'));
    });

    // Setting up a initialized channel
    setUp(() {
      final channelState = _generateChannelState(channelId, channelType);
      channel = Channel.fromState(client, channelState);
    });

    tearDown(() {
      channel.dispose();
    });
  });

  group('Initialized Channel', () {
    late final client = MockStreamChatClient();
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    late Channel channel;

    setUpAll(() {
      // Fallback values
      registerFallbackValue(FakeMessage());
      registerFallbackValue(FakeAttachmentFile());
      registerFallbackValue(FakeEvent());

      // detached loggers
      when(() => client.detachedLogger(any())).thenAnswer((invocation) {
        final name = invocation.positionalArguments.first;
        return _createLogger(name);
      });

      final retryPolicy = RetryPolicy(
        shouldRetry: (_, __, ___) => false,
        delayFactor: Duration.zero,
      );
      when(() => client.retryPolicy).thenReturn(retryPolicy);

      // fake clientState
      final clientState = FakeClientState();
      when(() => client.state).thenReturn(clientState);

      // client logger
      when(() => client.logger).thenReturn(_createLogger('mock-client-logger'));

      // mock channel delivery reporter
      when(
        () => client.channelDeliveryReporter.submitForDelivery(any()),
      ).thenAnswer((_) async {});
    });

    // Setting up a initialized channel
    setUp(() {
      final channelState = _generateChannelState(
        channelId,
        channelType,
        mockChannelConfig: true,
        ownCapabilities: [ChannelCapability.readEvents],
      );
      channel = Channel.fromState(client, channelState);
    });

    tearDown(() {
      channel.dispose();
      clearInteractions(client);
    });

    test('should throw if trying to set `extraData`', () {
      try {
        channel.extraData = {'name': 'test-channel-name'};
      } catch (e) {
        expect(e, isA<StateError>());
      }
    });

    test('should throw if trying to set `image`', () {
      try {
        channel.image = 'https://stream.io/some-image';
      } catch (e) {
        expect(e, isA<StateError>());
      }
    });

    test('should throw if trying to set `name`', () {
      try {
        channel.name = 'New name';
      } catch (e) {
        expect(e, isA<StateError>());
      }
    });
  });

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
