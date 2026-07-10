// ignore_for_file: lines_longer_than_80_chars, cascade_invocations, deprecated_member_use_from_same_package, avoid_redundant_argument_values

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../fakes.dart';
import '../matchers.dart';
import '../mocks.dart';

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
    const channelCid = '$channelType:$channelId';
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

    group('`.sendMessage`', () {
      test('should work fine', () async {
        final message = Message(
          id: 'test-message-id',
          text: 'Hello world!',
          user: client.state.currentUser,
        );

        final sendMessageResponse = SendMessageResponse()..message = message.copyWith(state: MessageState.sent);

        when(
          () => client.sendMessage(
            any(that: isSameMessageAs(message)),
            channelId,
            channelType,
          ),
        ).thenAnswer((_) async => sendMessageResponse);

        expectLater(
          // skipping first seed message list -> [] messages
          channel.state?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.sending),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.sent),
                matchMessageState: true,
              ),
            ],
          ]),
        );

        final res = await channel.sendMessage(message);

        expect(res, isNotNull);
        expect(res.message.id, message.id);

        verify(
          () => client.sendMessage(
            any(that: isSameMessageAs(message)),
            channelId,
            channelType,
          ),
        ).called(1);
      });

      test(
        'should handle StreamChatNetworkError by adding message to retry queue with skipPush: true, skipEnrichUrl: false',
        () async {
          final message = Message(
            id: 'test-message-id',
            text: 'Hello world!',
            user: client.state.currentUser,
          );

          when(
            () => client.sendMessage(
              any(that: isSameMessageAs(message)),
              channelId,
              channelType,
              skipPush: true,
            ),
          ).thenThrow(StreamChatNetworkError(ChatErrorCode.notAllowed));

          expectLater(
            // skipping first seed message list -> [] messages
            channel.state?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.sending),
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sendingFailed(
                      skipPush: true,
                      skipEnrichUrl: false,
                    ),
                  ),
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          try {
            await channel.sendMessage(
              message,
              skipPush: true,
            );
          } catch (e) {
            expect(e, isA<StreamChatNetworkError>());

            final networkError = e as StreamChatNetworkError;
            expect(networkError.code, equals(ChatErrorCode.notAllowed.code));
          }
        },
      );

      test(
        'should handle StreamChatNetworkError by adding message to retry queue with skipPush: true, skipEnrichUrl: true',
        () async {
          final message = Message(
            id: 'test-message-id-2',
            text: 'Hello world!',
            user: client.state.currentUser,
          );

          when(
            () => client.sendMessage(
              any(that: isSameMessageAs(message)),
              channelId,
              channelType,
              skipPush: true,
              skipEnrichUrl: true,
            ),
          ).thenThrow(StreamChatNetworkError(ChatErrorCode.notAllowed));

          expectLater(
            // skipping first seed message list -> [] messages
            channel.state?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.sending),
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sendingFailed(
                      skipPush: true,
                      skipEnrichUrl: true,
                    ),
                  ),
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          try {
            await channel.sendMessage(
              message,
              skipPush: true,
              skipEnrichUrl: true,
            );
          } catch (e) {
            expect(e, isA<StreamChatNetworkError>());

            final networkError = e as StreamChatNetworkError;
            expect(networkError.code, equals(ChatErrorCode.notAllowed.code));
          }
        },
      );

      test(
        'should handle StreamChatNetworkError by adding message to retry queue with skipPush: false, skipEnrichUrl: true',
        () async {
          final message = Message(
            id: 'test-message-id-3',
            text: 'Hello world!',
            user: client.state.currentUser,
          );

          when(
            () => client.sendMessage(
              any(that: isSameMessageAs(message)),
              channelId,
              channelType,
              skipEnrichUrl: true,
            ),
          ).thenThrow(StreamChatNetworkError(ChatErrorCode.notAllowed));

          expectLater(
            // skipping first seed message list -> [] messages
            channel.state?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.sending),
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sendingFailed(
                      skipPush: false,
                      skipEnrichUrl: true,
                    ),
                  ),
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          try {
            await channel.sendMessage(
              message,
              skipEnrichUrl: true,
            );
          } catch (e) {
            expect(e, isA<StreamChatNetworkError>());

            final networkError = e as StreamChatNetworkError;
            expect(networkError.code, equals(ChatErrorCode.notAllowed.code));
          }
        },
      );

      test(
        'should handle StreamChatNetworkError by adding message to retry queue with skipPush: false, skipEnrichUrl: false',
        () async {
          final message = Message(
            id: 'test-message-id-4',
            text: 'Hello world!',
            user: client.state.currentUser,
          );

          when(
            () => client.sendMessage(
              any(that: isSameMessageAs(message)),
              channelId,
              channelType,
            ),
          ).thenThrow(StreamChatNetworkError(ChatErrorCode.notAllowed));

          expectLater(
            // skipping first seed message list -> [] messages
            channel.state?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.sending),
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sendingFailed(
                      skipPush: false,
                      skipEnrichUrl: false,
                    ),
                  ),
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          try {
            await channel.sendMessage(
              message,
            );
          } catch (e) {
            expect(e, isA<StreamChatNetworkError>());

            final networkError = e as StreamChatNetworkError;
            expect(networkError.code, equals(ChatErrorCode.notAllowed.code));
          }
        },
      );

      test('should update message state even when non-retriable error occurs', () async {
        final message = Message(
          id: 'test-message-id',
          text: 'Hello world!',
          user: client.state.currentUser,
        );

        when(
          () => client.sendMessage(
            any(that: isSameMessageAs(message)),
            channelId,
            channelType,
          ),
        ).thenThrow(
          StreamChatNetworkError.raw(
            code: ChatErrorCode.inputError.code,
            message: 'Input error',
            data: ErrorResponse()
              ..code = ChatErrorCode.inputError.code
              ..message = 'Input error'
              ..statusCode = 400,
          ),
        );

        expectLater(
          // skipping first seed message list -> [] messages
          channel.state?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.sending),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.sendingFailed(
                    skipPush: false,
                    skipEnrichUrl: false,
                  ),
                ),
                matchMessageState: true,
              ),
            ],
          ]),
        );

        try {
          await channel.sendMessage(message);
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());
        }
      });

      test('with attachments should work just fine', () async {
        final attachments = List.generate(
          3,
          (index) => Attachment(
            id: 'test-attachment-id-$index',
            type: index.isEven ? 'image' : 'file',
            file: AttachmentFile(size: index * 33, path: 'test-file-path'),
          ),
        );

        final message = Message(
          id: 'test-message-id',
          attachments: attachments,
        );

        final sendImageResponse = SendImageResponse()..file = 'test-image-url';
        final sendFileResponse = SendFileResponse()..file = 'test-file-url';

        when(
          () => client.sendImage(
            any(),
            channelId,
            channelType,
            onSendProgress: any(named: 'onSendProgress'),
            cancelToken: any(named: 'cancelToken'),
            extraData: any(named: 'extraData'),
          ),
        ).thenAnswer((_) async => sendImageResponse);

        when(
          () => client.sendFile(
            any(),
            channelId,
            channelType,
            onSendProgress: any(named: 'onSendProgress'),
            cancelToken: any(named: 'cancelToken'),
            extraData: any(named: 'extraData'),
          ),
        ).thenAnswer((_) async => sendFileResponse);

        when(
          () => client.sendMessage(
            any(that: isSameMessageAs(message)),
            channelId,
            channelType,
          ),
        ).thenAnswer(
          (_) async => SendMessageResponse()
            ..message = message.copyWith(
              attachments: attachments
                  .map((it) => it.copyWith(uploadState: const UploadState.success()))
                  .toList(growable: false),
              state: MessageState.sent,
            ),
        );

        expectLater(
          // skipping first seed message list -> [] messages
          channel.state?.messagesStream.skip(1),
          emitsInOrder(
            [
              // preparing attachments to upload
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sending,
                    attachments: [...attachments.map((it) => it.copyWith(uploadState: const UploadState.preparing()))],
                  ),
                  matchMessageState: true,
                  matchAttachments: true,
                  matchAttachmentsUploadState: true,
                ),
              ],
              // 0th attachment is successfully uploaded
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sending,
                    attachments: [...attachments]
                      ..[0] = attachments[0].copyWith(
                        uploadState: const UploadState.success(),
                      ),
                  ),
                  matchMessageState: true,
                  matchAttachments: true,
                  matchAttachmentsUploadState: true,
                ),
              ],
              // 0th and 1st attachment is successfully uploaded
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sending,
                    attachments: [...attachments]
                      ..[0] = attachments[0].copyWith(
                        uploadState: const UploadState.success(),
                      )
                      ..[1] = attachments[1].copyWith(
                        uploadState: const UploadState.success(),
                      ),
                  ),
                  matchMessageState: true,
                  matchAttachments: true,
                  matchAttachmentsUploadState: true,
                ),
              ],
              // all the attachments are successfully uploaded
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sending,
                    attachments: [...attachments.map((it) => it.copyWith(uploadState: const UploadState.success()))],
                  ),
                  matchMessageState: true,
                  matchAttachments: true,
                  matchAttachmentsUploadState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sent,
                    attachments: [...attachments.map((it) => it.copyWith(uploadState: const UploadState.success()))],
                  ),
                  matchMessageState: true,
                  matchAttachments: true,
                  matchAttachmentsUploadState: true,
                ),
              ],
            ],
          ),
        );

        final res = await channel.sendMessage(message);

        expect(res, isNotNull);
        expect(res.message.id, message.id);
        expect(res.message.attachments.length, message.attachments.length);
        expect(
          res.message.attachments.every(
            (it) => it.uploadState == const UploadState.success(),
          ),
          isTrue,
        );

        verify(
          () => client.sendImage(
            any(),
            channelId,
            channelType,
            onSendProgress: any(named: 'onSendProgress'),
            cancelToken: any(named: 'cancelToken'),
            extraData: any(named: 'extraData'),
          ),
        ).called(2);

        verify(
          () => client.sendFile(
            any(),
            channelId,
            channelType,
            onSendProgress: any(named: 'onSendProgress'),
            cancelToken: any(named: 'cancelToken'),
            extraData: any(named: 'extraData'),
          ),
        ).called(1);

        verify(
          () => client.sendMessage(
            any(that: isSameMessageAs(message)),
            channelId,
            channelType,
          ),
        ).called(1);
      });

      test('should not send if the message is invalid', () async {
        final message = Message(id: 'test-message-id');

        expect(
          () => channel.sendMessage(message),
          throwsA(isA<StreamChatError>()),
        );

        verifyNever(
          () => client.sendMessage(any(), channelId, channelType),
        );
      });

      test(
        'should not send empty message when all attachments are cancelled',
        () async {
          final attachment = Attachment(
            id: 'test-attachment-id',
            type: 'image',
            file: AttachmentFile(size: 100, path: 'test-file-path'),
          );

          final message = Message(
            id: 'test-message-id',
            attachments: [attachment],
          );

          when(
            () => client.sendImage(
              any(),
              channelId,
              channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            ),
          ).thenAnswer(
            (_) async => throw StreamChatNetworkError.raw(
              code: 0,
              message: 'Request cancelled',
              isRequestCancelledError: true,
            ),
          );

          expect(
            () => channel.sendMessage(message),
            throwsA(isA<StreamChatError>()),
          );

          verify(
            () => client.sendImage(
              any(),
              channelId,
              channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            ),
          );

          verifyNever(
            () => client.sendMessage(any(), channelId, channelType),
          );
        },
      );

      test(
        'should send message when attachment is cancelled but text exists',
        () async {
          final attachment = Attachment(
            id: 'test-attachment-id',
            type: 'image',
            file: AttachmentFile(size: 100, path: 'test-file-path'),
          );

          final message = Message(
            id: 'test-message-id',
            text: 'Hello world!',
            attachments: [attachment],
          );

          when(
            () => client.sendImage(
              any(),
              channelId,
              channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            ),
          ).thenAnswer(
            (_) async => throw StreamChatNetworkError.raw(
              code: 0,
              message: 'Request cancelled',
              isRequestCancelledError: true,
            ),
          );

          when(
            () => client.sendMessage(
              any(that: isSameMessageAs(message)),
              channelId,
              channelType,
            ),
          ).thenAnswer(
            (_) async => SendMessageResponse()
              ..message = message.copyWith(
                attachments: [],
                state: MessageState.sent,
              ),
          );

          final res = await channel.sendMessage(message);

          expect(res, isNotNull);
          expect(res.message.text, 'Hello world!');

          verify(
            () => client.sendImage(
              any(),
              channelId,
              channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            ),
          );

          verify(
            () => client.sendMessage(
              any(that: isSameMessageAs(message)),
              channelId,
              channelType,
            ),
          );
        },
      );

      test(
        'should send message when attachment is cancelled but quoted message exists',
        () async {
          final attachment = Attachment(
            id: 'test-attachment-id',
            type: 'image',
            file: AttachmentFile(size: 100, path: 'test-file-path'),
          );

          final quotedMessage = Message(
            id: 'quoted-123',
            text: 'Original message',
          );

          final message = Message(
            id: 'test-message-id',
            attachments: [attachment],
            quotedMessageId: quotedMessage.id,
          );

          when(
            () => client.sendImage(
              any(),
              channelId,
              channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            ),
          ).thenAnswer(
            (_) async => throw StreamChatNetworkError.raw(
              code: 0,
              message: 'Request cancelled',
              isRequestCancelledError: true,
            ),
          );

          when(
            () => client.sendMessage(
              any(that: isSameMessageAs(message)),
              channelId,
              channelType,
            ),
          ).thenAnswer(
            (_) async => SendMessageResponse()
              ..message = message.copyWith(
                attachments: [],
                state: MessageState.sent,
              ),
          );

          final res = await channel.sendMessage(message);

          expect(res, isNotNull);
          expect(res.message.quotedMessageId, quotedMessage.id);

          verify(
            () => client.sendImage(
              any(),
              channelId,
              channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            ),
          );

          verify(
            () => client.sendMessage(
              any(that: isSameMessageAs(message)),
              channelId,
              channelType,
            ),
          );
        },
      );

      test(
        'should send message when attachment is cancelled but poll exists',
        () async {
          final attachment = Attachment(
            id: 'test-attachment-id',
            type: 'image',
            file: AttachmentFile(size: 100, path: 'test-file-path'),
          );

          final message = Message(
            id: 'test-message-id',
            attachments: [attachment],
            pollId: 'poll-123',
          );

          when(
            () => client.sendImage(
              any(),
              channelId,
              channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            ),
          ).thenAnswer(
            (_) async => throw StreamChatNetworkError.raw(
              code: 0,
              message: 'Request cancelled',
              isRequestCancelledError: true,
            ),
          );

          when(
            () => client.sendMessage(
              any(that: isSameMessageAs(message)),
              channelId,
              channelType,
            ),
          ).thenAnswer(
            (_) async => SendMessageResponse()
              ..message = message.copyWith(
                attachments: [],
                state: MessageState.sent,
              ),
          );

          final res = await channel.sendMessage(message);

          expect(res, isNotNull);
          expect(res.message.pollId, 'poll-123');

          verify(
            () => client.sendImage(
              any(),
              channelId,
              channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            ),
          );

          verify(
            () => client.sendMessage(
              any(that: isSameMessageAs(message)),
              channelId,
              channelType,
            ),
          );
        },
      );
    });

    group('`.sendStaticLocation`', () {
      const deviceId = 'test-device-id';
      const locationId = 'test-location-id';
      const coordinates = LocationCoordinates(
        latitude: 40.7128,
        longitude: -74.0060,
      );

      test('should create a static location and call sendMessage', () async {
        when(
          () => client.sendMessage(any(), channelId, channelType),
        ).thenAnswer(
          (_) async => SendMessageResponse()
            ..message = Message(
              id: locationId,
              text: 'Location shared',
              extraData: const {'custom': 'data'},
              sharedLocation: Location(
                channelCid: channel.cid,
                messageId: locationId,
                userId: client.state.currentUser?.id,
                latitude: coordinates.latitude,
                longitude: coordinates.longitude,
                createdByDeviceId: deviceId,
              ),
            ),
        );

        final response = await channel.sendStaticLocation(
          id: locationId,
          messageText: 'Location shared',
          createdByDeviceId: deviceId,
          location: coordinates,
          extraData: {'custom': 'data'},
        );

        expect(response, isNotNull);
        expect(response.message.id, locationId);
        expect(response.message.text, 'Location shared');
        expect(response.message.extraData['custom'], 'data');
        expect(response.message.sharedLocation, isNotNull);

        verify(
          () => client.sendMessage(any(), channelId, channelType),
        ).called(1);
      });
    });

    group('`.startLiveLocationSharing`', () {
      const deviceId = 'test-device-id';
      const locationId = 'test-location-id';
      final endSharingAt = DateTime.timestamp().add(const Duration(hours: 1));
      const coordinates = LocationCoordinates(
        latitude: 40.7128,
        longitude: -74.0060,
      );

      test(
        'should create message with live location and call sendMessage',
        () async {
          when(
            () => client.sendMessage(any(), channelId, channelType),
          ).thenAnswer(
            (_) async => SendMessageResponse()
              ..message = Message(
                id: locationId,
                text: 'Location shared',
                extraData: const {'custom': 'data'},
                sharedLocation: Location(
                  channelCid: channel.cid,
                  messageId: locationId,
                  userId: client.state.currentUser?.id,
                  latitude: coordinates.latitude,
                  longitude: coordinates.longitude,
                  createdByDeviceId: deviceId,
                  endAt: endSharingAt,
                ),
              ),
          );

          final response = await channel.startLiveLocationSharing(
            id: locationId,
            messageText: 'Location shared',
            createdByDeviceId: deviceId,
            location: coordinates,
            endSharingAt: endSharingAt,
            extraData: {'custom': 'data'},
          );

          expect(response, isNotNull);
          expect(response.message.id, locationId);
          expect(response.message.text, 'Location shared');
          expect(response.message.extraData['custom'], 'data');
          expect(response.message.sharedLocation, isNotNull);
          expect(response.message.sharedLocation?.endAt, endSharingAt);

          verify(
            () => client.sendMessage(any(), channelId, channelType),
          ).called(1);
        },
      );
    });

    group('`.createDraft`', () {
      final draftMessage = DraftMessage(text: 'Draft message text');

      setUp(() {
        when(
          () => client.createDraft(
            draftMessage,
            channelId,
            channelType,
          ),
        ).thenAnswer(
          (_) async => CreateDraftResponse()
            ..draft = Draft(
              channelCid: channelCid,
              createdAt: DateTime.now(),
              message: draftMessage,
            ),
        );
      });

      test('should call client.createDraft', () async {
        final res = await channel.createDraft(draftMessage);

        expect(res, isNotNull);
        expect(res.draft.message, draftMessage);

        verify(
          () => channel.client.createDraft(
            draftMessage,
            channelId,
            channelType,
          ),
        ).called(1);
      });
    });

    group('`.getDraft`', () {
      final draftMessage = DraftMessage(text: 'Draft message text');

      setUp(() {
        when(
          () => client.getDraft(
            channelId,
            channelType,
            parentId: any(named: 'parentId'),
          ),
        ).thenAnswer(
          (_) async => GetDraftResponse()
            ..draft = Draft(
              channelCid: channelCid,
              createdAt: DateTime.now(),
              message: draftMessage,
            ),
        );
      });

      test('should call client.getDraft', () async {
        final res = await channel.getDraft();

        expect(res, isNotNull);
        expect(res.draft.message, draftMessage);

        verify(
          () => channel.client.getDraft(
            channelId,
            channelType,
          ),
        ).called(1);
      });

      test('with parentId should pass parentId to client', () async {
        const parentId = 'parent-123';
        final res = await channel.getDraft(parentId: parentId);

        expect(res, isNotNull);
        expect(res.draft.message, draftMessage);

        verify(
          () => channel.client.getDraft(
            channelId,
            channelType,
            parentId: parentId,
          ),
        ).called(1);
      });
    });

    group('`.deleteDraft`', () {
      setUp(() {
        when(
          () => client.deleteDraft(
            channelId,
            channelType,
            parentId: any(named: 'parentId'),
          ),
        ).thenAnswer((_) async => EmptyResponse());
      });

      test('should call client.deleteDraft', () async {
        final res = await channel.deleteDraft();

        expect(res, isNotNull);

        verify(
          () => channel.client.deleteDraft(
            channelId,
            channelType,
          ),
        ).called(1);
      });

      test('with parentId should pass parentId to client', () async {
        const parentId = 'parent-123';
        final res = await channel.deleteDraft(parentId: parentId);

        expect(res, isNotNull);

        verify(
          () => channel.client.deleteDraft(
            channelId,
            channelType,
            parentId: parentId,
          ),
        ).called(1);
      });
    });

    group('`.createReminder`', () {
      const messageId = 'test-message-id';

      setUp(() {
        when(
          () => client.createReminder(
            messageId,
            remindAt: any(named: 'remindAt'),
          ),
        ).thenAnswer(
          (_) async => CreateReminderResponse()
            ..reminder = MessageReminder(
              messageId: messageId,
              channelCid: channelCid,
              userId: 'test-user-id',
              remindAt: DateTime(2024, 6, 15, 14, 30),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
        );
      });

      test('should call client.createReminder', () async {
        final res = await channel.createReminder(messageId);

        expect(res, isNotNull);
        expect(res.reminder.messageId, messageId);

        verify(() => channel.client.createReminder(messageId)).called(1);
      });

      test('with remindAt should pass remindAt to client', () async {
        final remindAt = DateTime(2024, 6, 15, 14, 30);
        final res = await channel.createReminder(messageId, remindAt: remindAt);

        expect(res, isNotNull);
        expect(res.reminder.messageId, messageId);
        expect(res.reminder.remindAt, remindAt);

        verify(
          () => channel.client.createReminder(
            messageId,
            remindAt: remindAt,
          ),
        ).called(1);
      });
    });

    group('`.updateReminder`', () {
      const messageId = 'test-message-id';

      setUp(() {
        when(
          () => client.updateReminder(
            messageId,
            remindAt: any(named: 'remindAt'),
          ),
        ).thenAnswer(
          (_) async => UpdateReminderResponse()
            ..reminder = MessageReminder(
              messageId: messageId,
              channelCid: channelCid,
              userId: 'test-user-id',
              remindAt: DateTime(2024, 8, 20, 16, 45),
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
        );
      });

      test('should call client.updateReminder', () async {
        final res = await channel.updateReminder(messageId);

        expect(res, isNotNull);
        expect(res.reminder.messageId, messageId);

        verify(() => channel.client.updateReminder(messageId)).called(1);
      });

      test('with remindAt should pass remindAt to client', () async {
        final remindAt = DateTime(2024, 8, 20, 16, 45);
        final res = await channel.updateReminder(messageId, remindAt: remindAt);

        expect(res, isNotNull);
        expect(res.reminder.messageId, messageId);
        expect(res.reminder.remindAt, remindAt);

        verify(
          () => channel.client.updateReminder(
            messageId,
            remindAt: remindAt,
          ),
        ).called(1);
      });
    });

    group('`.deleteReminder`', () {
      const messageId = 'test-message-id';

      setUp(() {
        when(() => client.deleteReminder(messageId)).thenAnswer(
          (_) async => EmptyResponse(),
        );
      });

      test('should call client.deleteReminder', () async {
        final res = await channel.deleteReminder(messageId);

        expect(res, isNotNull);

        verify(() => channel.client.deleteReminder(messageId)).called(1);
      });
    });

    group('`.updateMessage`', () {
      test('should work fine', () async {
        final message = Message(
          id: 'test-message-id',
          state: MessageState.sent,
        );

        final updateMessageResponse = UpdateMessageResponse()..message = message;

        when(
          () => client.updateMessage(any(that: isSameMessageAs(message))),
        ).thenAnswer((_) async => updateMessageResponse);

        expectLater(
          // skipping first seed message list -> [] messages
          channel.state?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updating),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updated),
                matchMessageState: true,
              ),
            ],
          ]),
        );

        final res = await channel.updateMessage(message);

        expect(res, isNotNull);
        expect(res.message.id, message.id);

        verify(
          () => client.updateMessage(
            any(that: isSameMessageAs(message)),
          ),
        ).called(1);
      });

      test('with attachments should work just fine', () async {
        final attachments = List.generate(
          3,
          (index) => Attachment(
            id: 'test-attachment-id-$index',
            type: index.isEven ? 'image' : 'file',
            file: AttachmentFile(size: index * 33, path: 'test-file-path'),
          ),
        );

        final message = Message(
          id: 'test-message-id',
          attachments: attachments,
        );

        final sendImageResponse = SendImageResponse()..file = 'test-image-url';
        final sendFileResponse = SendFileResponse()..file = 'test-file-url';

        when(
          () => client.sendImage(
            any(),
            channelId,
            channelType,
            onSendProgress: any(named: 'onSendProgress'),
            cancelToken: any(named: 'cancelToken'),
            extraData: any(named: 'extraData'),
          ),
        ).thenAnswer((_) async => sendImageResponse);

        when(
          () => client.sendFile(
            any(),
            channelId,
            channelType,
            onSendProgress: any(named: 'onSendProgress'),
            cancelToken: any(named: 'cancelToken'),
            extraData: any(named: 'extraData'),
          ),
        ).thenAnswer((_) async => sendFileResponse);

        when(
          () => client.updateMessage(
            any(that: isSameMessageAs(message)),
          ),
        ).thenAnswer(
          (_) async => UpdateMessageResponse()
            ..message = message.copyWith(
              state: MessageState.sent,
              attachments: attachments
                  .map((it) => it.copyWith(uploadState: const UploadState.success()))
                  .toList(growable: false),
            ),
        );

        expectLater(
          // skipping first seed message list -> [] messages
          channel.state?.messagesStream.skip(1),
          emitsInOrder(
            [
              // preparing attachments to upload
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.updating,
                    attachments: [...attachments.map((it) => it.copyWith(uploadState: const UploadState.preparing()))],
                  ),
                  matchMessageState: true,
                  matchAttachments: true,
                  matchAttachmentsUploadState: true,
                ),
              ],
              // 0th attachment is successfully uploaded
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.updating,
                    attachments: [...attachments]
                      ..[0] = attachments[0].copyWith(
                        uploadState: const UploadState.success(),
                      ),
                  ),
                  matchMessageState: true,
                  matchAttachments: true,
                  matchAttachmentsUploadState: true,
                ),
              ],
              // 0th and 1st attachment is successfully uploaded
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.updating,
                    attachments: [...attachments]
                      ..[0] = attachments[0].copyWith(
                        uploadState: const UploadState.success(),
                      )
                      ..[1] = attachments[1].copyWith(
                        uploadState: const UploadState.success(),
                      ),
                  ),
                  matchMessageState: true,
                  matchAttachments: true,
                  matchAttachmentsUploadState: true,
                ),
              ],
              // all the attachments are successfully uploaded
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.updating,
                    attachments: [...attachments.map((it) => it.copyWith(uploadState: const UploadState.success()))],
                  ),
                  matchMessageState: true,
                  matchAttachments: true,
                  matchAttachmentsUploadState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.updated,
                    attachments: [...attachments.map((it) => it.copyWith(uploadState: const UploadState.success()))],
                  ),
                  matchMessageState: true,
                  matchAttachments: true,
                  matchAttachmentsUploadState: true,
                ),
              ],
            ],
          ),
        );

        final res = await channel.updateMessage(message);

        expect(res, isNotNull);
        expect(res.message.id, message.id);
        expect(res.message.attachments.length, message.attachments.length);
        expect(
          res.message.attachments.every(
            (it) => it.uploadState == const UploadState.success(),
          ),
          isTrue,
        );

        verify(
          () => client.sendImage(
            any(),
            channelId,
            channelType,
            onSendProgress: any(named: 'onSendProgress'),
            cancelToken: any(named: 'cancelToken'),
            extraData: any(named: 'extraData'),
          ),
        ).called(2);

        verify(
          () => client.sendFile(
            any(),
            channelId,
            channelType,
            onSendProgress: any(named: 'onSendProgress'),
            cancelToken: any(named: 'cancelToken'),
            extraData: any(named: 'extraData'),
          ),
        ).called(1);

        verify(
          () => client.updateMessage(
            any(that: isSameMessageAs(message)),
          ),
        ).called(1);
      });

      test('should update message state even when error is not StreamChatNetworkError', () async {
        final message = Message(
          id: 'test-message-id-error-1',
          state: MessageState.sent,
        );

        when(
          () => client.updateMessage(
            any(that: isSameMessageAs(message)),
            skipEnrichUrl: true,
          ),
        ).thenThrow(ArgumentError('Invalid argument'));

        expectLater(
          // skipping first seed message list -> [] messages
          channel.state?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updating),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.updatingFailed(
                    skipPush: false,
                    skipEnrichUrl: true,
                  ),
                ),
                matchMessageState: true,
              ),
            ],
          ]),
        );

        try {
          await channel.updateMessage(message, skipEnrichUrl: true);
        } catch (e) {
          expect(e, isA<ArgumentError>());
        }
      });

      test(
        'should add message to retry queue when retriable StreamChatNetworkError occurs with skipPush: false, skipEnrichUrl: true',
        () async {
          final message = Message(
            id: 'test-message-id-retry-1',
            state: MessageState.sent,
          );

          // Create a retriable error (data == null)
          when(
            () => client.updateMessage(
              any(that: isSameMessageAs(message)),
              skipEnrichUrl: true,
            ),
          ).thenThrow(
            StreamChatNetworkError.raw(
              code: ChatErrorCode.requestTimeout.code,
              message: 'Request timed out',
            ),
          );

          expectLater(
            // skipping first seed message list -> [] messages
            channel.state?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.updating),
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.updatingFailed(
                      skipPush: false,
                      skipEnrichUrl: true,
                    ),
                  ),
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          try {
            await channel.updateMessage(message, skipEnrichUrl: true);
          } catch (e) {
            expect(e, isA<StreamChatNetworkError>());

            final networkError = e as StreamChatNetworkError;
            expect(networkError.code, equals(ChatErrorCode.requestTimeout.code));
            expect(networkError.isRetriable, isTrue);
          }
        },
      );

      test(
        'should add message to retry queue when retriable StreamChatNetworkError occurs with skipPush: true, skipEnrichUrl: false',
        () async {
          final message = Message(
            id: 'test-message-id-retry-2',
            state: MessageState.sent,
          );

          // Create a retriable error (data == null)
          when(
            () => client.updateMessage(
              any(that: isSameMessageAs(message)),
              skipPush: true,
            ),
          ).thenThrow(
            StreamChatNetworkError.raw(
              code: ChatErrorCode.internalSystemError.code,
              message: 'Internal system error',
            ),
          );

          expectLater(
            // skipping first seed message list -> [] messages
            channel.state?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.updating),
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.updatingFailed(
                      skipPush: true,
                      skipEnrichUrl: false,
                    ),
                  ),
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          try {
            await channel.updateMessage(message, skipPush: true);
          } catch (e) {
            expect(e, isA<StreamChatNetworkError>());

            final networkError = e as StreamChatNetworkError;
            expect(networkError.code, equals(ChatErrorCode.internalSystemError.code));
            expect(networkError.isRetriable, isTrue);
          }
        },
      );

      test('should handle non-retriable StreamChatNetworkError with skipPush: true, skipEnrichUrl: true', () async {
        final message = Message(
          id: 'test-message-id-error-2',
          state: MessageState.sent,
        );

        when(
          () => client.updateMessage(
            any(that: isSameMessageAs(message)),
            skipPush: true,
            skipEnrichUrl: true,
          ),
        ).thenThrow(StreamChatNetworkError(ChatErrorCode.notAllowed));

        expectLater(
          // skipping first seed message list -> [] messages
          channel.state?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updating),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.updatingFailed(
                    skipPush: true,
                    skipEnrichUrl: true,
                  ),
                ),
                matchMessageState: true,
              ),
            ],
          ]),
        );

        try {
          await channel.updateMessage(
            message,
            skipPush: true,
            skipEnrichUrl: true,
          );
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());

          final networkError = e as StreamChatNetworkError;
          expect(networkError.code, equals(ChatErrorCode.notAllowed.code));
        }
      });

      test('should handle non-retriable StreamChatNetworkError with skipPush: false, skipEnrichUrl: false', () async {
        final message = Message(
          id: 'test-message-id-error-3',
          state: MessageState.sent,
        );

        when(
          () => client.updateMessage(
            any(that: isSameMessageAs(message)),
          ),
        ).thenThrow(StreamChatNetworkError(ChatErrorCode.notAllowed));

        expectLater(
          // skipping first seed message list -> [] messages
          channel.state?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updating),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.updatingFailed(
                    skipPush: false,
                    skipEnrichUrl: false,
                  ),
                ),
                matchMessageState: true,
              ),
            ],
          ]),
        );

        try {
          await channel.updateMessage(message);
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());

          final networkError = e as StreamChatNetworkError;
          expect(networkError.code, equals(ChatErrorCode.notAllowed.code));
        }
      });
    });

    group('`ChannelClientState.updateMessage`', () {
      test('upsert: true (default) adds an unknown message', () async {
        final message = Message(
          id: 'unknown-message',
          user: client.state.currentUser,
          text: 'hello',
          createdAt: DateTime.utc(2026),
        );

        expect(channel.state!.messages, isEmpty);

        channel.state!.updateMessage(message);

        expect(channel.state!.messages.map((m) => m.id), ['unknown-message']);
      });

      test('upsert: false does NOT add an unknown message', () async {
        final message = Message(
          id: 'unknown-message',
          user: client.state.currentUser,
          text: 'hello',
          createdAt: DateTime.utc(2026),
        );

        expect(channel.state!.messages, isEmpty);

        channel.state!.updateMessage(message, upsert: false);

        expect(channel.state!.messages, isEmpty);
      });

      test('upsert: false updates a message already in the window', () async {
        const messageId = 'known-message';
        final seeded = Message(
          id: messageId,
          user: client.state.currentUser,
          text: 'old',
          createdAt: DateTime.utc(2026),
        );
        channel.state!.updateChannelState(
          channel.state!.channelState.copyWith(messages: [seeded]),
        );

        channel.state!.updateMessage(
          seeded.copyWith(text: 'new'),
          upsert: false,
        );

        final stored = channel.state!.messages.single;
        expect(stored.id, equals(messageId));
        expect(stored.text, equals('new'));
      });
    });

    test('`.partialUpdateMessage`', () async {
      final message = Message(
        id: 'test-message-id',
        state: MessageState.sent,
      );

      const set = {'text': 'Update Message text'};
      const unset = ['pinExpires'];

      final updateMessageResponse = UpdateMessageResponse()
        ..message = message.copyWith(text: set['text'], pinExpires: null);

      when(
        () => client.partialUpdateMessage(message.id, set: set, unset: unset),
      ).thenAnswer((_) async => updateMessageResponse);

      expectLater(
        // skipping first seed message list -> [] messages
        channel.state?.messagesStream.skip(1),
        emitsInOrder([
          [
            isSameMessageAs(
              message.copyWith(
                state: MessageState.updating,
              ),
              matchText: true,
              matchMessageState: true,
            ),
          ],
          [
            isSameMessageAs(
              updateMessageResponse.message.copyWith(
                state: MessageState.updated,
              ),
              matchText: true,
              matchMessageState: true,
            ),
          ],
        ]),
      );

      final res = await channel.partialUpdateMessage(
        message,
        set: set,
        unset: unset,
      );

      expect(res, isNotNull);
      expect(res.message.id, message.id);
      expect(res.message.id, message.id);
      expect(res.message.text, set['text']);
      expect(res.message.pinExpires, isNull);

      verify(
        () => client.partialUpdateMessage(message.id, set: set, unset: unset),
      ).called(1);
    });

    group('`.partialUpdateMessage` error handling', () {
      test('should update message state even when error is not StreamChatNetworkError', () async {
        final message = Message(
          id: 'test-message-id-error-partial-1',
          state: MessageState.sent,
        );

        // Add message to channel state first
        channel.state?.updateMessage(message);

        const set = {'text': 'Update Message text'};
        const unset = ['pinExpires'];

        when(
          () => client.partialUpdateMessage(
            message.id,
            set: set,
            unset: unset,
          ),
        ).thenThrow(ArgumentError('Invalid argument'));

        expectLater(
          // skipping first seed message list -> [] messages
          channel.state?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.updating,
                ),
                matchText: true,
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.partialUpdatingFailed(
                    set: set,
                    unset: unset,
                    skipEnrichUrl: false,
                  ),
                ),
                matchText: true,
                matchMessageState: true,
              ),
            ],
          ]),
        );

        try {
          await channel.partialUpdateMessage(
            message,
            set: set,
            unset: unset,
          );
        } catch (e) {
          expect(e, isA<ArgumentError>());
        }
      });

      test(
        'should add message to retry queue when retriable StreamChatNetworkError occurs with skipEnrichUrl: true',
        () async {
          final message = Message(
            id: 'test-message-id-retry-partial-1',
            state: MessageState.sent,
          );

          // Add message to channel state first
          channel.state?.updateMessage(message);

          const set = {'text': 'Update Message text'};
          const unset = ['pinExpires'];

          // Create a retriable error (data == null)
          when(
            () => client.partialUpdateMessage(
              message.id,
              set: set,
              unset: unset,
              skipEnrichUrl: true,
            ),
          ).thenThrow(
            StreamChatNetworkError.raw(
              code: ChatErrorCode.requestTimeout.code,
              message: 'Request timed out',
            ),
          );

          expectLater(
            // skipping first seed message list -> [] messages
            channel.state?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.updating,
                  ),
                  matchText: true,
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.partialUpdatingFailed(
                      set: set,
                      unset: unset,
                      skipEnrichUrl: true,
                    ),
                  ),
                  matchText: true,
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          try {
            await channel.partialUpdateMessage(
              message,
              set: set,
              unset: unset,
              skipEnrichUrl: true,
            );
          } catch (e) {
            expect(e, isA<StreamChatNetworkError>());

            final networkError = e as StreamChatNetworkError;
            expect(networkError.code, equals(ChatErrorCode.requestTimeout.code));
            expect(networkError.isRetriable, isTrue);
          }
        },
      );

      test(
        'should add message to retry queue when retriable StreamChatNetworkError occurs with skipEnrichUrl: false',
        () async {
          final message = Message(
            id: 'test-message-id-retry-partial-2',
            state: MessageState.sent,
          );

          // Add message to channel state first
          channel.state?.updateMessage(message);

          const set = {'text': 'Update Message text'};
          const unset = ['pinExpires'];

          // Create a retriable error (data == null)
          when(
            () => client.partialUpdateMessage(
              message.id,
              set: set,
              unset: unset,
            ),
          ).thenThrow(
            StreamChatNetworkError.raw(
              code: ChatErrorCode.internalSystemError.code,
              message: 'Internal system error',
            ),
          );

          expectLater(
            // skipping first seed message list -> [] messages
            channel.state?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.updating,
                  ),
                  matchText: true,
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.partialUpdatingFailed(
                      set: set,
                      unset: unset,
                      skipEnrichUrl: false,
                    ),
                  ),
                  matchText: true,
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          try {
            await channel.partialUpdateMessage(
              message,
              set: set,
              unset: unset,
            );
          } catch (e) {
            expect(e, isA<StreamChatNetworkError>());

            final networkError = e as StreamChatNetworkError;
            expect(networkError.code, equals(ChatErrorCode.internalSystemError.code));
            expect(networkError.isRetriable, isTrue);
          }
        },
      );

      test('should handle non-retriable StreamChatNetworkError with skipEnrichUrl: true', () async {
        final message = Message(
          id: 'test-message-id-error-partial-2',
          state: MessageState.sent,
        );

        // Add message to channel state first
        channel.state?.updateMessage(message);

        const set = {'text': 'Update Message text'};
        const unset = ['pinExpires'];

        when(
          () => client.partialUpdateMessage(
            message.id,
            set: set,
            unset: unset,
            skipEnrichUrl: true,
          ),
        ).thenThrow(StreamChatNetworkError(ChatErrorCode.notAllowed));

        expectLater(
          // skipping first seed message list -> [] messages
          channel.state?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.updating,
                ),
                matchText: true,
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.partialUpdatingFailed(
                    set: set,
                    unset: unset,
                    skipEnrichUrl: true,
                  ),
                ),
                matchText: true,
                matchMessageState: true,
              ),
            ],
          ]),
        );

        try {
          await channel.partialUpdateMessage(
            message,
            set: set,
            unset: unset,
            skipEnrichUrl: true,
          );
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());

          final networkError = e as StreamChatNetworkError;
          expect(networkError.code, equals(ChatErrorCode.notAllowed.code));
        }
      });

      test('should handle non-retriable StreamChatNetworkError with skipEnrichUrl: false', () async {
        final message = Message(
          id: 'test-message-id-error-partial-3',
          state: MessageState.sent,
        );

        // Add message to channel state first
        channel.state?.updateMessage(message);

        const set = {'text': 'Update Message text'};
        const unset = ['pinExpires'];

        when(
          () => client.partialUpdateMessage(
            message.id,
            set: set,
            unset: unset,
          ),
        ).thenThrow(StreamChatNetworkError(ChatErrorCode.notAllowed));

        expectLater(
          // skipping first seed message list -> [] messages
          channel.state?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.updating,
                ),
                matchText: true,
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.partialUpdatingFailed(
                    set: set,
                    unset: unset,
                    skipEnrichUrl: false,
                  ),
                ),
                matchText: true,
                matchMessageState: true,
              ),
            ],
          ]),
        );

        try {
          await channel.partialUpdateMessage(
            message,
            set: set,
            unset: unset,
          );
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());

          final networkError = e as StreamChatNetworkError;
          expect(networkError.code, equals(ChatErrorCode.notAllowed.code));
        }
      });
    });

    group('`.deleteMessage`', () {
      test('should work fine', () async {
        const messageId = 'test-message-id';
        final message = Message(
          id: messageId,
          createdAt: DateTime.now(),
          state: MessageState.sent,
        );

        when(() => client.deleteMessage(messageId)).thenAnswer((_) async => EmptyResponse());

        expectLater(
          // skipping first seed message list -> [] messages
          channel.state?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.softDeleting),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.softDeleted),
                matchMessageState: true,
              ),
            ],
          ]),
        );

        final res = await channel.deleteMessage(message);

        expect(res, isNotNull);

        verify(() => client.deleteMessage(messageId)).called(1);
      });

      test('should delete attachments for hard delete', () async {
        final attachments = List.generate(
          3,
          (index) => Attachment(
            id: 'test-attachment-id-$index',
            type: index.isEven ? 'image' : 'file',
            file: AttachmentFile(size: index * 33, path: 'test-file-path'),
            imageUrl: index.isEven ? 'test-image-url-$index' : null,
            assetUrl: index.isOdd ? 'test-asset-url-$index' : null,
            uploadState: const UploadState.success(),
          ),
        );

        const messageId = 'test-message-id';
        final message = Message(
          id: messageId,
          attachments: attachments,
          createdAt: DateTime.now(),
          state: MessageState.sent,
        );

        when(
          () => client.deleteMessage(messageId, hard: true),
        ).thenAnswer((_) async => EmptyResponse());

        when(
          () => client.deleteImage(any(), channelId, channelType),
        ).thenAnswer((_) async => EmptyResponse());

        when(
          () => client.deleteFile(any(), channelId, channelType),
        ).thenAnswer((_) async => EmptyResponse());

        final res = await channel.deleteMessage(message, hard: true);
        expect(res, isNotNull);

        verify(() => client.deleteMessage(messageId, hard: true)).called(1);

        verify(() => client.deleteImage(any(), channelId, channelType)).called(2);

        verify(() => client.deleteFile(any(), channelId, channelType)).called(1);
      });

      test(
        'should hard delete the message if the state is sending or failed',
        () async {
          const messageId = 'test-message-id';
          final message = Message(
            id: messageId,
            text: 'Hello World!',
            state: MessageState.sending,
          );

          expectLater(
            // skipping first seed message list -> [] messages
            channel.state?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.sending),
                  matchMessageState: true,
                ),
              ],
              const [], // message is hard deleted from state
            ]),
          );

          // Add message to channel state first
          channel.state?.addNewMessage(message);

          final res = await channel.deleteMessage(message);

          expect(res, isNotNull);
          verifyNever(() => client.deleteMessage(messageId));
        },
      );
    });

    group('`.deleteMessageForMe`', () {
      test('should work fine', () async {
        const messageId = 'test-message-id';
        final message = Message(
          id: messageId,
          createdAt: DateTime.now(),
          state: MessageState.sent,
        );

        when(() => client.deleteMessageForMe(messageId)).thenAnswer((_) async => EmptyResponse());

        expectLater(
          // skipping first seed message list -> [] messages
          channel.state?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.deletingForMe),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.deletedForMe),
                matchMessageState: true,
              ),
            ],
          ]),
        );

        final res = await channel.deleteMessageForMe(message);

        expect(res, isNotNull);

        verify(() => client.deleteMessageForMe(messageId)).called(1);
      });

      test(
        'should hard delete the message if the state is sending or failed',
        () async {
          const messageId = 'test-message-id';
          final message = Message(
            id: messageId,
            text: 'Hello World!',
            state: MessageState.sending,
          );

          expectLater(
            // skipping first seed message list -> [] messages
            channel.state?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.sending),
                  matchMessageState: true,
                ),
              ],
              const [], // message is hard deleted from state
            ]),
          );

          // Add message to channel state first
          channel.state?.addNewMessage(message);

          final res = await channel.deleteMessageForMe(message);

          expect(res, isNotNull);
          verifyNever(() => client.deleteMessageForMe(messageId));
        },
      );
    });

    group('`.pinMessage`', () {
      test('should work fine without passing timeoutOrExpirationDate', () async {
        final message = Message(id: 'test-message-id');

        when(
          () => client.partialUpdateMessage(
            message.id,
            set: any(named: 'set'),
            unset: any(named: 'unset'),
          ),
        ).thenAnswer(
          (_) async => UpdateMessageResponse()
            ..message = message.copyWith(
              pinned: true,
              pinExpires: null,
            ),
        );

        expectLater(
          // skipping first seed message list -> [] messages
          channel.state?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updating),
                matchMessageState: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(state: MessageState.updated),
                matchMessageState: true,
              ),
            ],
          ]),
        );

        final res = await channel.pinMessage(message);

        expect(res, isNotNull);
        expect(res.message.pinned, isTrue);
        expect(res.message.pinExpires, isNull);

        verify(
          () => client.partialUpdateMessage(
            message.id,
            set: any(named: 'set'),
            unset: any(named: 'unset'),
          ),
        ).called(1);
      });

      test(
        'should work fine if passed timeoutOrExpirationDate as num(seconds)',
        () async {
          final message = Message(id: 'test-message-id');
          const timeoutOrExpirationDate = 300; // 300 seconds

          when(
            () => client.partialUpdateMessage(
              message.id,
              set: any(named: 'set'),
              unset: any(named: 'unset'),
            ),
          ).thenAnswer(
            (_) async => UpdateMessageResponse()
              ..message = message.copyWith(
                pinned: true,
                pinExpires: DateTime.now().add(
                  const Duration(seconds: timeoutOrExpirationDate),
                ),
              ),
          );

          expectLater(
            // skipping first seed message list -> [] messages
            channel.state?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.updating),
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.updated),
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          final res = await channel.pinMessage(
            message,
            timeoutOrExpirationDate: timeoutOrExpirationDate,
          );

          expect(res, isNotNull);
          expect(res.message.pinned, isTrue);
          expect(res.message.pinExpires, isNotNull);

          verify(
            () => client.partialUpdateMessage(
              message.id,
              set: any(named: 'set'),
              unset: any(named: 'unset'),
            ),
          ).called(1);
        },
      );

      test(
        'should work fine if passed timeoutOrExpirationDate as DateTime',
        () async {
          final message = Message(id: 'test-message-id');
          final timeoutOrExpirationDate = DateTime.now().add(const Duration(days: 3)); // 3 days

          when(
            () => client.partialUpdateMessage(
              message.id,
              set: any(named: 'set'),
              unset: any(named: 'unset'),
            ),
          ).thenAnswer(
            (_) async => UpdateMessageResponse()
              ..message = message.copyWith(
                pinned: true,
                pinExpires: timeoutOrExpirationDate,
              ),
          );

          expectLater(
            // skipping first seed message list -> [] messages
            channel.state?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.updating),
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message.copyWith(state: MessageState.updated),
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          final res = await channel.pinMessage(
            message,
            timeoutOrExpirationDate: timeoutOrExpirationDate,
          );

          expect(res, isNotNull);
          expect(res.message.pinned, isTrue);
          expect(res.message.pinExpires, isNotNull);
          expect(res.message.pinExpires, timeoutOrExpirationDate.toUtc());

          verify(
            () => client.partialUpdateMessage(
              message.id,
              set: any(named: 'set'),
              unset: any(named: 'unset'),
            ),
          ).called(1);
        },
      );

      test(
        'should throw if invalid timeoutOrExpirationDate is passed',
        () async {
          final message = Message(id: 'test-message-id');
          const timeoutOrExpirationDate = 'invalid-value';

          try {
            await channel.pinMessage(
              message,
              timeoutOrExpirationDate: timeoutOrExpirationDate,
            );
          } catch (e) {
            expect(e, isA<ArgumentError>());
          }
        },
      );
    });

    test('`.unpinMessage`', () async {
      final message = Message(id: 'test-message-id', pinned: true);

      when(
        () => client.partialUpdateMessage(
          message.id,
          set: {'pinned': false},
        ),
      ).thenAnswer((_) async => UpdateMessageResponse()..message = message.copyWith(pinned: false));

      expectLater(
        // skipping first seed message list -> [] messages
        channel.state?.messagesStream.skip(1),
        emitsInOrder([
          [
            isSameMessageAs(
              message.copyWith(state: MessageState.updating),
              matchMessageState: true,
            ),
          ],
          [
            isSameMessageAs(
              message.copyWith(state: MessageState.updated),
              matchMessageState: true,
            ),
          ],
        ]),
      );

      final res = await channel.unpinMessage(message);

      expect(res, isNotNull);
      expect(res.message.pinned, isFalse);

      verify(
        () => client.partialUpdateMessage(
          message.id,
          set: {'pinned': false},
        ),
      ).called(1);
    });

    group('`.search`', () {
      final filter = Filter.in_('cid', const [channelCid]);

      test('should work fine with `query`', () async {
        const query = 'test-search-query';
        const sort = [SortOption.asc('test-sort-field')];
        const pagination = PaginationParams();

        final results = List.generate(3, (index) => GetMessageResponse());

        when(
          () => client.search(
            filter,
            query: query,
            sort: any(named: 'sort'),
            paginationParams: any(named: 'paginationParams'),
          ),
        ).thenAnswer(
          (_) async => SearchMessagesResponse()..results = results,
        );

        final res = await channel.search(
          query: query,
          sort: sort,
          paginationParams: pagination,
        );

        expect(res, isNotNull);
        expect(res.results.length, results.length);

        verify(
          () => client.search(
            filter,
            query: query,
            sort: any(named: 'sort'),
            paginationParams: any(named: 'paginationParams'),
          ),
        ).called(1);
      });

      test('should work fine with `messageFilters`', () async {
        final messageFilters = Filter.query('key', 'text');
        const sort = [SortOption.desc('test-sort-field')];
        const pagination = PaginationParams();

        final results = List.generate(3, (index) => GetMessageResponse());

        when(
          () => client.search(
            filter,
            messageFilters: messageFilters,
            sort: any(named: 'sort'),
            paginationParams: any(named: 'paginationParams'),
          ),
        ).thenAnswer(
          (_) async => SearchMessagesResponse()..results = results,
        );

        final res = await channel.search(
          sort: sort,
          paginationParams: pagination,
          messageFilters: messageFilters,
        );

        expect(res, isNotNull);
        expect(res.results.length, results.length);

        verify(
          () => client.search(
            filter,
            messageFilters: messageFilters,
            sort: any(named: 'sort'),
            paginationParams: any(named: 'paginationParams'),
          ),
        ).called(1);
      });
    });

    test('`.deleteFile`', () async {
      const url = 'test-file-url';

      when(
        () => client.deleteFile(url, channelId, channelType, cancelToken: any(named: 'cancelToken')),
      ).thenAnswer((_) async => EmptyResponse());

      final res = await channel.deleteFile(url);

      expect(res, isNotNull);

      verify(() => client.deleteFile(url, channelId, channelType, cancelToken: any(named: 'cancelToken'))).called(1);
    });

    test('`.deleteImage`', () async {
      const url = 'test-image-url';

      when(
        () => client.deleteImage(url, channelId, channelType, cancelToken: any(named: 'cancelToken')),
      ).thenAnswer((_) async => EmptyResponse());

      final res = await channel.deleteImage(url);

      expect(res, isNotNull);

      verify(() => client.deleteImage(url, channelId, channelType, cancelToken: any(named: 'cancelToken'))).called(1);
    });

    test('`.stopAIResponse`', () async {
      final stopAIEvent = Event(type: EventType.aiIndicatorStop);

      when(
        () => client.sendEvent(
          channelId,
          channelType,
          any(that: isSameEventAs(stopAIEvent)),
        ),
      ).thenAnswer((_) async => EmptyResponse());

      final res = await channel.stopAIResponse();

      expect(res, isNotNull);

      verify(
        () => client.sendEvent(
          channelId,
          channelType,
          any(that: isSameEventAs(stopAIEvent)),
        ),
      ).called(1);
    });

    test('`.sendEvent`', () async {
      final event = Event(type: 'event.local');

      when(() => client.sendEvent(channelId, channelType, event)).thenAnswer((_) async => EmptyResponse());

      final res = await channel.sendEvent(event);

      expect(res, isNotNull);

      verify(() => client.sendEvent(channelId, channelType, event)).called(1);
    });

    group('`.sendReaction`', () {
      test('should work fine', () async {
        final message = Message(
          id: 'test-message-id',
          state: MessageState.sent,
        );

        const type = 'like';
        const emojiCode = '👍';
        const score = 4;

        final reaction = Reaction(
          type: type,
          messageId: message.id,
          emojiCode: emojiCode,
          score: score,
          user: client.state.currentUser,
        );

        when(() => client.sendReaction(message.id, reaction)).thenAnswer(
          (_) async => SendReactionResponse()
            ..message = message
            ..reaction = reaction,
        );

        expectLater(
          // skipping first seed message list -> [] messages
          channel.state?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.sent,
                  reactionGroups: {type: ReactionGroup(count: 1, sumScores: 1)},
                  latestReactions: [reaction],
                  ownReactions: [reaction],
                ),
                matchReactions: true,
                matchMessageState: true,
              ),
            ],
          ]),
        );

        final res = await channel.sendReaction(message, reaction);

        expect(res, isNotNull);
        expect(res.reaction.type, type);
        expect(res.reaction.messageId, message.id);
        expect(res.reaction.emojiCode, emojiCode);
        expect(res.reaction.score, score);

        verify(() => client.sendReaction(message.id, reaction)).called(1);
      });

      test(
        'should restore previous message if `client.sendReaction` throws',
        () async {
          const type = 'test-reaction-type';
          final message = Message(
            id: 'test-message-id',
            state: MessageState.sent,
          );

          final reaction = Reaction(
            type: type,
            messageId: message.id,
            user: client.state.currentUser,
          );

          when(
            () => client.sendReaction(message.id, reaction),
          ).thenThrow(StreamChatNetworkError(ChatErrorCode.inputError));

          expectLater(
            // skipping first seed message list -> [] messages
            channel.state?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sent,
                    reactionGroups: {
                      type: ReactionGroup(
                        count: 1,
                        sumScores: 1,
                      ),
                    },
                    latestReactions: [reaction],
                    ownReactions: [reaction],
                  ),
                  matchReactions: true,
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message,
                  matchReactions: true,
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          try {
            await channel.sendReaction(message, reaction);
          } catch (e) {
            expect(e, isA<StreamChatNetworkError>());
          }

          verify(() => client.sendReaction(message.id, reaction)).called(1);
        },
      );

      test(
        '''should override previous reaction if present and `enforceUnique` is true''',
        () async {
          const messageId = 'test-message-id';
          const prevType = 'test-reaction-type';
          final prevReaction = Reaction(
            type: prevType,
            messageId: messageId,
            user: client.state.currentUser,
          );
          final message = Message(
            id: messageId,
            ownReactions: [prevReaction],
            latestReactions: [prevReaction],
            reactionGroups: {
              prevType: ReactionGroup(
                count: 1,
                sumScores: 1,
              ),
            },
            state: MessageState.sent,
          );

          const type = 'test-reaction-type-2';
          final newReaction = Reaction(
            type: type,
            messageId: messageId,
            user: client.state.currentUser,
          );
          final newMessage = message.copyWith(
            ownReactions: [newReaction],
            latestReactions: [newReaction],
          );

          const enforceUnique = true;

          when(
            () => client.sendReaction(
              messageId,
              newReaction,
              enforceUnique: enforceUnique,
            ),
          ).thenAnswer(
            (_) async => SendReactionResponse()
              ..message = newMessage
              ..reaction = newReaction,
          );

          expectLater(
            // skipping first seed message list -> [] messages
            channel.state?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  newMessage,
                  matchReactions: true,
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          final res = await channel.sendReaction(
            message,
            newReaction,
            enforceUnique: enforceUnique,
          );

          expect(res, isNotNull);
          expect(res.reaction.type, type);
          expect(res.reaction.messageId, messageId);

          verify(
            () => client.sendReaction(
              messageId,
              newReaction,
              enforceUnique: enforceUnique,
            ),
          ).called(1);
        },
      );
    });

    group('`.sendReaction in thread`', () {
      test('should work fine', () async {
        const type = 'test-reaction-type';
        final message = Message(
          id: 'test-message-id',
          parentId: 'test-parent-id', // is thread message
          state: MessageState.sent,
        );

        final reaction = Reaction(
          type: type,
          messageId: message.id,
          user: client.state.currentUser,
        );

        when(() => client.sendReaction(message.id, reaction)).thenAnswer(
          (_) async => SendReactionResponse()
            ..message = message
            ..reaction = reaction,
        );

        expectLater(
          channel.state?.threadsStream
              // skipping first seed message list -> [] messages
              .skip(1)
              .map((event) => event['test-parent-id']),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.sent,
                  reactionGroups: {
                    type: ReactionGroup(
                      count: 1,
                      sumScores: 1,
                    ),
                  },
                  latestReactions: [reaction],
                  ownReactions: [reaction],
                ),
                matchReactions: true,
                matchMessageState: true,
                matchParentId: true,
              ),
            ],
          ]),
        );

        final res = await channel.sendReaction(message, reaction);

        expect(res, isNotNull);
        expect(res.reaction.type, type);
        expect(res.reaction.messageId, message.id);

        verify(() => client.sendReaction(message.id, reaction)).called(1);
      });

      test(
        '''should restore previous thread message if `client.sendReaction` throws''',
        () async {
          const type = 'test-reaction-type';
          final message = Message(
            id: 'test-message-id',
            parentId: 'test-parent-id', // is thread message
            state: MessageState.sent,
            // `Message.createdAt` falls back to `DateTime.now()` per call
            // when not provided, which breaks merge/sort keyed on createdAt.
            createdAt: DateTime.now(),
          );

          final reaction = Reaction(
            type: type,
            messageId: message.id,
            user: client.state.currentUser,
          );

          when(
            () => client.sendReaction(message.id, reaction),
          ).thenThrow(StreamChatNetworkError(ChatErrorCode.inputError));

          expectLater(
            // skipping first seed message list -> [] messages
            channel.state?.threadsStream.skip(1).map((event) => event['test-parent-id']),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sent,
                    reactionGroups: {
                      type: ReactionGroup(
                        count: 1,
                        sumScores: 1,
                      ),
                    },
                    latestReactions: [reaction],
                    ownReactions: [reaction],
                  ),
                  matchReactions: true,
                  matchMessageState: true,
                  matchParentId: true,
                ),
              ],
              [
                isSameMessageAs(
                  message,
                  matchReactions: true,
                  matchMessageState: true,
                  matchParentId: true,
                ),
              ],
            ]),
          );

          try {
            await channel.sendReaction(message, reaction);
          } catch (e) {
            expect(e, isA<StreamChatNetworkError>());
          }

          verify(() => client.sendReaction(message.id, reaction)).called(1);
        },
      );

      test(
        '''should override previous thread reaction if present and `enforceUnique` is true''',
        () async {
          const messageId = 'test-message-id';
          const parentId = 'test-parent-id';
          const prevType = 'test-reaction-type';
          final prevReaction = Reaction(
            type: prevType,
            messageId: messageId,
            user: client.state.currentUser,
          );
          final message = Message(
            id: messageId,
            parentId: parentId,
            ownReactions: [prevReaction],
            latestReactions: [prevReaction],
            reactionGroups: {
              prevType: ReactionGroup(
                count: 1,
                sumScores: 1,
              ),
            },
            state: MessageState.sent,
          );

          const type = 'test-reaction-type-2';
          final newReaction = Reaction(
            type: type,
            messageId: messageId,
            user: client.state.currentUser,
          );
          final newMessage = message.copyWith(
            ownReactions: [newReaction],
            latestReactions: [newReaction],
          );

          const enforceUnique = true;

          when(
            () => client.sendReaction(
              messageId,
              newReaction,
              enforceUnique: enforceUnique,
            ),
          ).thenAnswer(
            (_) async => SendReactionResponse()
              ..message = newMessage
              ..reaction = newReaction,
          );

          expectLater(
            // skipping first seed message list -> [] messages
            channel.state?.threadsStream.skip(1).map((event) => event['test-parent-id']),
            emitsInOrder([
              [
                isSameMessageAs(
                  newMessage.copyWith(state: MessageState.sent),
                  matchReactions: true,
                  matchMessageState: true,
                  matchParentId: true,
                ),
              ],
            ]),
          );

          final res = await channel.sendReaction(
            message,
            newReaction,
            enforceUnique: enforceUnique,
          );

          expect(res, isNotNull);
          expect(res.reaction.type, type);
          expect(res.reaction.messageId, messageId);

          verify(
            () => client.sendReaction(
              messageId,
              newReaction,
              enforceUnique: enforceUnique,
            ),
          ).called(1);
        },
      );
    });

    group('`.deleteReaction`', () {
      test('should work fine', () async {
        const userId = 'test-user-id';
        const messageId = 'test-message-id';
        const type = 'test-reaction-type';
        final reaction = Reaction(
          type: type,
          messageId: messageId,
          userId: userId,
        );
        final message = Message(
          id: messageId,
          ownReactions: [reaction],
          latestReactions: [reaction],
          reactionGroups: {
            type: ReactionGroup(
              count: 1,
              sumScores: 1,
            ),
          },
          state: MessageState.sent,
        );

        when(() => client.deleteReaction(messageId, type)).thenAnswer((_) async => EmptyResponse());

        expectLater(
          // skipping first seed message list -> [] messages
          channel.state?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.sent,
                  latestReactions: [],
                  ownReactions: [],
                ),
                matchReactions: true,
                matchMessageState: true,
              ),
            ],
          ]),
        );

        final res = await channel.deleteReaction(message, reaction);

        expect(res, isNotNull);

        verify(() => client.deleteReaction(messageId, type)).called(1);
      });

      test(
        'should restore prev message state if `client.deleteReaction` throws',
        () async {
          const userId = 'test-user-id';
          const messageId = 'test-message-id';
          const type = 'test-reaction-type';
          final reaction = Reaction(
            type: type,
            messageId: messageId,
            userId: userId,
          );
          final message = Message(
            id: messageId,
            ownReactions: [reaction],
            latestReactions: [reaction],
            reactionGroups: {
              type: ReactionGroup(
                count: 1,
                sumScores: 1,
              ),
            },
            state: MessageState.sent,
          );

          when(
            () => client.deleteReaction(messageId, type),
          ).thenThrow(StreamChatNetworkError(ChatErrorCode.inputError));

          expectLater(
            // skipping first seed message list -> [] messages
            channel.state?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sent,
                    latestReactions: [],
                    ownReactions: [],
                  ),
                  matchReactions: true,
                  matchMessageState: true,
                ),
              ],
              [
                isSameMessageAs(
                  message,
                  matchReactions: true,
                  matchMessageState: true,
                ),
              ],
            ]),
          );

          try {
            await channel.deleteReaction(message, reaction);
          } catch (e) {
            expect(e, isA<StreamChatNetworkError>());
          }

          verify(() => client.deleteReaction(messageId, type)).called(1);
        },
      );
    });

    group('`.deleteReaction in thread`', () {
      test('should work fine', () async {
        const userId = 'test-user-id';
        const messageId = 'test-message-id';
        const parentId = 'test-parent-id';
        const type = 'test-reaction-type';
        final reaction = Reaction(
          type: type,
          messageId: messageId,
          userId: userId,
        );
        final message = Message(
          id: messageId,
          parentId: parentId,
          // is thread
          ownReactions: [reaction],
          latestReactions: [reaction],
          reactionGroups: {
            type: ReactionGroup(
              count: 1,
              sumScores: 1,
            ),
          },
          state: MessageState.sent,
          // `Message.createdAt` falls back to `DateTime.now()` per call when
          // not provided, which breaks merge/sort keyed on createdAt.
          createdAt: DateTime.now(),
        );

        when(() => client.deleteReaction(messageId, type)).thenAnswer((_) async => EmptyResponse());

        expectLater(
          // skipping first seed message list -> [] messages
          channel.state?.threadsStream.skip(1).map((event) => event['test-parent-id']),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(
                  state: MessageState.sent,
                  latestReactions: [],
                  ownReactions: [],
                ),
                matchReactions: true,
                matchMessageState: true,
                matchParentId: true,
              ),
            ],
          ]),
        );

        final res = await channel.deleteReaction(message, reaction);

        expect(res, isNotNull);

        verify(() => client.deleteReaction(messageId, type)).called(1);
      });

      test(
        'should restore prev message state if `client.deleteReaction` throws',
        () async {
          const userId = 'test-user-id';
          const messageId = 'test-message-id';
          const parentId = 'test-parent-id';
          const type = 'test-reaction-type';
          final reaction = Reaction(
            type: type,
            messageId: messageId,
            userId: userId,
          );
          final message = Message(
            id: messageId,
            parentId: parentId,
            ownReactions: [reaction],
            latestReactions: [reaction],
            reactionGroups: {
              type: ReactionGroup(
                count: 1,
                sumScores: 1,
              ),
            },
            state: MessageState.sent,
            // `Message.createdAt` falls back to `DateTime.now()` per call
            // when not provided, which breaks merge/sort keyed on createdAt.
            createdAt: DateTime.now(),
          );

          when(
            () => client.deleteReaction(messageId, type),
          ).thenThrow(StreamChatNetworkError(ChatErrorCode.inputError));

          expectLater(
            // skipping first seed message list -> [] messages
            channel.state?.threadsStream.skip(1).map((event) => event['test-parent-id']),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sent,
                    latestReactions: [],
                    ownReactions: [],
                  ),
                  matchReactions: true,
                  matchMessageState: true,
                  matchParentId: true,
                ),
              ],
              [
                isSameMessageAs(
                  message,
                  matchReactions: true,
                  matchMessageState: true,
                  matchParentId: true,
                ),
              ],
            ]),
          );

          try {
            await channel.deleteReaction(message, reaction);
          } catch (e) {
            expect(e, isA<StreamChatNetworkError>());
          }

          verify(() => client.deleteReaction(messageId, type)).called(1);
        },
      );
    });

    test('`.update`', () async {
      const channelData = {
        'name': 'Stream Team',
        'profile_image': 'test-profile-image',
      };
      final updateMessage = Message(
        id: 'test-message-id',
        text: 'updated channel',
      );

      final channelModel = ChannelModel(
        cid: channelCid,
        extraData: channelData,
      );

      when(() => client.updateChannel(channelId, channelType, channelData, message: any(named: 'message'))).thenAnswer(
        (_) async => UpdateChannelResponse()
          ..channel = channelModel
          ..message = updateMessage,
      );

      final res = await channel.update(
        channelData,
        updateMessage: updateMessage,
      );

      expect(res, isNotNull);
      expect(res.channel.cid, channelModel.cid);
      expect(res.channel.extraData, channelData);
      expect(res.message?.id, updateMessage.id);

      verify(() => client.updateChannel(channelId, channelType, channelData, message: any(named: 'message'))).called(1);
    });

    test('`.updateImage`', () async {
      const image = 'https://getstream.io/new-image';

      final channelModel = ChannelModel(
        cid: channelCid,
        extraData: {'image': image},
      );

      when(
        () => client.updateChannelPartial(
          channelId,
          channelType,
          set: {'image': image},
        ),
      ).thenAnswer(
        (_) async => PartialUpdateChannelResponse()..channel = channelModel,
      );

      final res = await channel.updateImage(image);

      expect(res, isNotNull);
      expect(res.channel.extraData['image'], image);

      verify(
        () => client.updateChannelPartial(
          channelId,
          channelType,
          set: {'image': image},
        ),
      ).called(1);
    });

    test('`.updateName`', () async {
      const name = 'Name';

      final channelModel = ChannelModel(
        cid: channelCid,
        extraData: {'name': name},
      );

      when(
        () => client.updateChannelPartial(
          channelId,
          channelType,
          set: {'name': name},
        ),
      ).thenAnswer(
        (_) async => PartialUpdateChannelResponse()..channel = channelModel,
      );

      final res = await channel.updateName(name);

      expect(res, isNotNull);
      expect(res.channel.extraData['name'], name);

      verify(
        () => client.updateChannelPartial(
          channelId,
          channelType,
          set: {'name': name},
        ),
      ).called(1);
    });

    test('`.updatePartial`', () async {
      const set = {
        'name': 'Stream Team',
        'profile_image': 'test-profile-image',
      };

      const unset = ['tag', 'last_name'];

      final channelModel = ChannelModel(
        cid: channelCid,
        extraData: {
          'coolness': 999,
          ...set,
        },
      );

      when(
        () => client.updateChannelPartial(
          channelId,
          channelType,
          set: set,
          unset: unset,
        ),
      ).thenAnswer(
        (_) async => PartialUpdateChannelResponse()..channel = channelModel,
      );

      final res = await channel.updatePartial(set: set, unset: unset);

      expect(res, isNotNull);
      expect(res.channel.cid, channelModel.cid);
      expect(
        res.channel.extraData,
        {'coolness': 999, ...set},
      );

      verify(
        () => client.updateChannelPartial(
          channelId,
          channelType,
          set: set,
          unset: unset,
        ),
      ).called(1);
    });

    test('`.delete`', () async {
      when(() => client.deleteChannel(channelId, channelType)).thenAnswer((_) async => EmptyResponse());

      final res = await channel.delete();

      expect(res, isNotNull);

      verify(() => client.deleteChannel(channelId, channelType)).called(1);
    });

    test('`.truncate`', () async {
      when(() => client.truncateChannel(channelId, channelType)).thenAnswer((_) async => EmptyResponse());

      final res = await channel.truncate();

      expect(res, isNotNull);

      verify(() => client.truncateChannel(channelId, channelType)).called(1);
    });

    test('`.acceptInvite`', () async {
      final message = Message(id: 'test-message-id', text: 'Invite Accepted');

      final channelModel = ChannelModel(cid: channelCid);

      when(() => client.acceptChannelInvite(channelId, channelType, message: any(named: 'message'))).thenAnswer(
        (_) async => AcceptInviteResponse()
          ..channel = channelModel
          ..message = message,
      );

      final res = await channel.acceptInvite(message);

      expect(res, isNotNull);
      expect(res.channel.cid, channelModel.cid);
      expect(res.message?.id, message.id);

      verify(() => client.acceptChannelInvite(channelId, channelType, message: any(named: 'message'))).called(1);
    });

    test('`.rejectInvite`', () async {
      final message = Message(id: 'test-message-id', text: 'Invite Rejected');

      final channelModel = ChannelModel(cid: channelCid);

      when(() => client.rejectChannelInvite(channelId, channelType, message: any(named: 'message'))).thenAnswer(
        (_) async => RejectInviteResponse()
          ..channel = channelModel
          ..message = message,
      );

      final res = await channel.rejectInvite(message);

      expect(res, isNotNull);
      expect(res.channel.cid, channelModel.cid);
      expect(res.message?.id, message.id);

      verify(() => client.rejectChannelInvite(channelId, channelType, message: any(named: 'message'))).called(1);
    });

    test('`.addMembers`', () async {
      final members = List.generate(
        3,
        (index) => Member(userId: 'test-member-id-$index'),
      );
      final memberIds = members.map((it) => it.userId).whereType<String>().toList(growable: false);
      final message = Message(id: 'test-message-id', text: 'Members Added');

      final channelModel = ChannelModel(cid: channelCid);

      when(
        () => client.addChannelMembers(channelId, channelType, memberIds, message: any(named: 'message')),
      ).thenAnswer(
        (_) async => AddMembersResponse()
          ..channel = channelModel
          ..members = members
          ..message = message,
      );

      final res = await channel.addMembers(memberIds, message: message);

      expect(res, isNotNull);
      expect(res.channel.cid, channelModel.cid);
      expect(res.members.length, members.length);
      expect(res.message?.id, message.id);

      verify(
        () => client.addChannelMembers(channelId, channelType, memberIds, message: any(named: 'message')),
      ).called(1);
    });

    test('`.addMembers` with hideHistoryBefore', () async {
      final members = List.generate(
        3,
        (index) => Member(userId: 'test-member-id-$index'),
      );
      final memberIds = members.map((it) => it.userId).whereType<String>().toList(growable: false);
      final message = Message(id: 'test-message-id', text: 'Members Added');
      final hideHistoryBefore = DateTime.parse('2024-01-01T00:00:00Z');

      final channelModel = ChannelModel(cid: channelCid);

      when(
        () => client.addChannelMembers(
          channelId,
          channelType,
          memberIds,
          message: message,
          hideHistoryBefore: hideHistoryBefore,
        ),
      ).thenAnswer(
        (_) async => AddMembersResponse()
          ..channel = channelModel
          ..members = members
          ..message = message,
      );

      final res = await channel.addMembers(
        memberIds,
        message: message,
        hideHistoryBefore: hideHistoryBefore,
      );

      expect(res, isNotNull);
      expect(res.channel.cid, channelModel.cid);
      expect(res.members.length, members.length);
      expect(res.message?.id, message.id);

      verify(
        () => client.addChannelMembers(
          channelId,
          channelType,
          memberIds,
          message: message,
          hideHistoryBefore: hideHistoryBefore,
        ),
      ).called(1);
    });

    test('`.inviteMembers`', () async {
      final members = List.generate(
        3,
        (index) => Member(userId: 'test-member-id-$index'),
      );
      final memberIds = members.map((it) => it.userId).whereType<String>().toList(growable: false);
      final message = Message(id: 'test-message-id', text: 'Members Invited');

      final channelModel = ChannelModel(cid: channelCid);

      when(
        () => client.inviteChannelMembers(channelId, channelType, memberIds, message: any(named: 'message')),
      ).thenAnswer(
        (_) async => InviteMembersResponse()
          ..channel = channelModel
          ..members = members
          ..message = message,
      );

      final res = await channel.inviteMembers(memberIds, message: message);

      expect(res, isNotNull);
      expect(res.channel.cid, channelModel.cid);
      expect(res.members.length, members.length);
      expect(res.message?.id, message.id);

      verify(
        () => client.inviteChannelMembers(channelId, channelType, memberIds, message: any(named: 'message')),
      ).called(1);
    });

    test('`.removeMembers`', () async {
      final members = List.generate(
        3,
        (index) => Member(userId: 'test-member-id-$index'),
      );
      final memberIds = members.map((it) => it.userId).whereType<String>().toList(growable: false);
      final message = Message(id: 'test-message-id', text: 'Members Removed');

      final channelModel = ChannelModel(cid: channelCid);

      when(
        () => client.removeChannelMembers(channelId, channelType, memberIds, message: any(named: 'message')),
      ).thenAnswer(
        (_) async => RemoveMembersResponse()
          ..channel = channelModel
          ..members = members
          ..message = message,
      );

      final res = await channel.removeMembers(memberIds, message: message);

      expect(res, isNotNull);
      expect(res.channel.cid, channelModel.cid);
      expect(res.members.length, members.length);
      expect(res.message?.id, message.id);

      verify(
        () => client.removeChannelMembers(channelId, channelType, memberIds, message: any(named: 'message')),
      ).called(1);
    });

    group('`.sendAction`', () {
      test('should work fine', () async {
        final message = Message(id: 'test-message-id', text: 'Action Sent');
        const formData = {'key': 'value'};

        when(
          () => client.sendAction(channelId, channelType, message.id, formData),
        ).thenAnswer((_) async => SendActionResponse());

        final res = await channel.sendAction(message, formData);

        expect(res, isNotNull);

        verify(
          () => client.sendAction(channelId, channelType, message.id, formData),
        ).called(1);
      });

      test('should emit received message if not null', () async {
        final message = Message(id: 'test-message-id', text: 'Action Sent');
        const formData = {'key': 'value'};

        when(
          () => client.sendAction(channelId, channelType, message.id, formData),
        ).thenAnswer((_) async => SendActionResponse()..message = message);

        expectLater(
          // skipping first seed message list -> [] messages
          channel.state?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message,
                matchMessageState: true,
              ),
            ],
          ]),
        );

        final res = await channel.sendAction(message, formData);

        expect(res, isNotNull);
        expect(res.message?.id, message.id);

        verify(
          () => client.sendAction(channelId, channelType, message.id, formData),
        ).called(1);
      });
    });

    group('`.watch`', () {
      test('should work fine', () async {
        when(
          () => client.queryChannel(
            channelType,
            channelId: channelId,
            watch: true,
            channelData: any(named: 'channelData'),
            messagesPagination: any(named: 'messagesPagination'),
            membersPagination: any(named: 'membersPagination'),
            watchersPagination: any(named: 'watchersPagination'),
          ),
        ).thenAnswer(
          (_) async => _generateChannelState(channelId, channelType),
        );

        final res = await channel.watch();

        expect(res, isNotNull);
        expect(res.channel, isNotNull);
        expect(res.channel?.cid, channelCid);

        verify(
          () => client.queryChannel(
            channelType,
            channelId: channelId,
            watch: true,
            channelData: any(named: 'channelData'),
            messagesPagination: any(named: 'messagesPagination'),
            membersPagination: any(named: 'membersPagination'),
            watchersPagination: any(named: 'watchersPagination'),
          ),
        ).called(1);
      });

      test('should rethrow if `.query` throws', () async {
        when(
          () => client.queryChannel(
            channelType,
            channelId: channelId,
            watch: true,
            channelData: any(named: 'channelData'),
            messagesPagination: any(named: 'messagesPagination'),
            membersPagination: any(named: 'membersPagination'),
            watchersPagination: any(named: 'watchersPagination'),
          ),
        ).thenThrow(StreamChatNetworkError(ChatErrorCode.inputError));

        try {
          await channel.watch();
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());
        }

        verify(
          () => client.queryChannel(
            channelType,
            channelId: channelId,
            watch: true,
            channelData: any(named: 'channelData'),
            messagesPagination: any(named: 'messagesPagination'),
            membersPagination: any(named: 'membersPagination'),
            watchersPagination: any(named: 'watchersPagination'),
          ),
        ).called(1);
      });
    });

    test('`.stopWatching`', () async {
      when(() => client.stopChannelWatching(channelId, channelType)).thenAnswer((_) async => EmptyResponse());

      final res = await channel.stopWatching();

      expect(res, isNotNull);

      verify(() => client.stopChannelWatching(channelId, channelType)).called(1);
    });

    test('`.getReplies`', () async {
      const parentId = 'test-parent-id';

      final messages = List.generate(
        3,
        (index) => Message(
          id: 'test-message-id-$index',
          parentId: parentId,
        ),
      );

      when(() => client.getReplies(parentId)).thenAnswer(
        (_) async => QueryRepliesResponse()..messages = messages,
      );

      final res = await channel.getReplies(parentId);

      expect(res, isNotNull);
      expect(res.messages.length, messages.length);
      expect(res.messages.every((it) => it.parentId == parentId), isTrue);

      verify(() => client.getReplies(parentId)).called(1);
    });

    test('`.getReactions`', () async {
      const messageId = 'test-message-id';

      final reactions = List.generate(
        3,
        (index) => Reaction(
          type: 'test-reaction-type-$index',
          messageId: messageId,
        ),
      );

      when(() => client.getReactions(messageId)).thenAnswer(
        (_) async => QueryReactionsResponse()..reactions = reactions,
      );

      final res = await channel.getReactions(messageId);

      expect(res, isNotNull);
      expect(res.reactions.length, reactions.length);
      expect(res.reactions.every((it) => it.messageId == messageId), isTrue);

      verify(() => client.getReactions(messageId)).called(1);
    });

    test('`.getMessagesById`', () async {
      final messages = List.generate(
        3,
        (index) => Message(id: 'test-message-id-$index'),
      );

      final messageIds = messages.map((it) => it.id).toList(growable: false);

      when(() => client.getMessagesById(channelId, channelType, messageIds)).thenAnswer(
        (_) async => GetMessagesByIdResponse()..messages = messages,
      );

      final res = await channel.getMessagesById(messageIds);

      expect(res, isNotNull);
      expect(res.messages.length, messageIds.length);

      verify(
        () => client.getMessagesById(channelId, channelType, messageIds),
      ).called(1);
    });

    test('`.translateMessage`', () async {
      const messageId = 'test-message-id';
      const language = 'hi'; // Hindi
      const translatedMessageText = 'नमस्ते';

      final translatedMessage = Message(
        i18n: const {
          language: translatedMessageText,
        },
      );

      when(() => client.translateMessage(messageId, language)).thenAnswer(
        (_) async => TranslateMessageResponse()..message = translatedMessage,
      );

      final res = await channel.translateMessage(messageId, language);

      expect(res, isNotNull);
      expect(res.message.i18n, translatedMessage.i18n);

      verify(() => client.translateMessage(messageId, language)).called(1);
    });

    group('`.query`', () {
      test('should work fine', () async {
        final channelState = _generateChannelState(channelId, channelType);

        when(
          () => client.queryChannel(
            channelType,
            channelId: channelId,
            channelData: any(named: 'channelData'),
            messagesPagination: any(named: 'messagesPagination'),
            membersPagination: any(named: 'membersPagination'),
            watchersPagination: any(named: 'watchersPagination'),
          ),
        ).thenAnswer((_) async => channelState);

        final res = await channel.query();

        expect(res, isNotNull);

        verify(
          () => client.queryChannel(
            channelType,
            channelId: channelId,
            channelData: any(named: 'channelData'),
            messagesPagination: any(named: 'messagesPagination'),
            membersPagination: any(named: 'membersPagination'),
            watchersPagination: any(named: 'watchersPagination'),
          ),
        ).called(1);
      });

      test('should rethrow if `client.queryChannel` throws', () async {
        when(
          () => client.queryChannel(
            channelType,
            channelId: channelId,
            channelData: any(named: 'channelData'),
            messagesPagination: any(named: 'messagesPagination'),
            membersPagination: any(named: 'membersPagination'),
            watchersPagination: any(named: 'watchersPagination'),
          ),
        ).thenThrow(StreamChatNetworkError(ChatErrorCode.inputError));

        try {
          await channel.query();
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());
        }

        verify(
          () => client.queryChannel(
            channelType,
            channelId: channelId,
            channelData: any(named: 'channelData'),
            messagesPagination: any(named: 'messagesPagination'),
            membersPagination: any(named: 'membersPagination'),
            watchersPagination: any(named: 'watchersPagination'),
          ),
        ).called(1);
      });

      test('should truncate state when querying around message id', () async {
        final initialMessages = [
          Message(id: 'msg1', text: 'Hello 1'),
          Message(id: 'msg2', text: 'Hello 2'),
          Message(id: 'msg3', text: 'Hello 3'),
        ];

        final stateWithMessages = _generateChannelState(
          channelId,
          channelType,
        ).copyWith(messages: initialMessages);

        channel.state!.updateChannelState(stateWithMessages);
        expect(channel.state!.messages, hasLength(3));

        final newState =
            _generateChannelState(
              channelId,
              channelType,
            ).copyWith(
              messages: [
                Message(id: 'msg-before-1', text: 'Message before 1'),
                Message(id: 'msg-before-2', text: 'Message before 2'),
                Message(id: 'target-message-id', text: 'Target message'),
                Message(id: 'msg-after-1', text: 'Message after 1'),
                Message(id: 'msg-after-2', text: 'Message after 2'),
              ],
            );

        when(
          () => client.queryChannel(
            channelType,
            channelId: channelId,
            channelData: any(named: 'channelData'),
            messagesPagination: any(named: 'messagesPagination'),
            membersPagination: any(named: 'membersPagination'),
            watchersPagination: any(named: 'watchersPagination'),
          ),
        ).thenAnswer((_) async => newState);

        const pagination = PaginationParams(idAround: 'target-message-id');

        final res = await channel.query(messagesPagination: pagination);

        expect(res, isNotNull);
        expect(channel.state!.messages, hasLength(5));
        expect(channel.state!.messages[2].id, 'target-message-id');

        verify(
          () => client.queryChannel(
            channelType,
            channelId: channelId,
            channelData: any(named: 'channelData'),
            messagesPagination: pagination,
            membersPagination: any(named: 'membersPagination'),
            watchersPagination: any(named: 'watchersPagination'),
          ),
        ).called(1);
      });

      test('should truncate state when querying around created date', () async {
        final initialMessages = [
          Message(id: 'msg1', text: 'Hello 1'),
          Message(id: 'msg2', text: 'Hello 2'),
          Message(id: 'msg3', text: 'Hello 3'),
        ];

        final stateWithMessages = _generateChannelState(
          channelId,
          channelType,
        ).copyWith(messages: initialMessages);

        channel.state!.updateChannelState(stateWithMessages);
        expect(channel.state!.messages, hasLength(3));

        final targetDate = DateTime.now();
        final newState =
            _generateChannelState(
              channelId,
              channelType,
            ).copyWith(
              messages: [
                Message(id: 'msg-before-1', text: 'Message before 1'),
                Message(id: 'msg-before-2', text: 'Message before 2'),
                Message(id: 'target-message', text: 'Target message'),
                Message(id: 'msg-after-1', text: 'Message after 1'),
                Message(id: 'msg-after-2', text: 'Message after 2'),
              ],
            );

        when(
          () => client.queryChannel(
            channelType,
            channelId: channelId,
            channelData: any(named: 'channelData'),
            messagesPagination: any(named: 'messagesPagination'),
            membersPagination: any(named: 'membersPagination'),
            watchersPagination: any(named: 'watchersPagination'),
          ),
        ).thenAnswer((_) async => newState);

        final pagination = PaginationParams(createdAtAround: targetDate);

        final res = await channel.query(messagesPagination: pagination);

        expect(res, isNotNull);
        expect(channel.state!.messages, hasLength(5));
        expect(channel.state!.messages[2].id, 'target-message');

        verify(
          () => client.queryChannel(
            channelType,
            channelId: channelId,
            channelData: any(named: 'channelData'),
            messagesPagination: pagination,
            membersPagination: any(named: 'membersPagination'),
            watchersPagination: any(named: 'watchersPagination'),
          ),
        ).called(1);
      });

      test(
        'should submit for delivery when querying latest messages (no pagination)',
        () async {
          final channelState = _generateChannelState(channelId, channelType);

          when(
            () => client.queryChannel(
              channelType,
              channelId: channelId,
              channelData: any(named: 'channelData'),
              messagesPagination: any(named: 'messagesPagination'),
              membersPagination: any(named: 'membersPagination'),
              watchersPagination: any(named: 'watchersPagination'),
            ),
          ).thenAnswer((_) async => channelState);

          // Query without pagination params (fetching latest messages)
          await channel.query();

          // Verify submitForDelivery was called
          verify(
            () => client.channelDeliveryReporter.submitForDelivery([channel]),
          ).called(1);
        },
      );

      test(
        'should NOT submit for delivery when querying with pagination (older messages)',
        () async {
          final channelState = _generateChannelState(channelId, channelType);

          when(
            () => client.queryChannel(
              channelType,
              channelId: channelId,
              channelData: any(named: 'channelData'),
              messagesPagination: any(named: 'messagesPagination'),
              membersPagination: any(named: 'membersPagination'),
              watchersPagination: any(named: 'watchersPagination'),
            ),
          ).thenAnswer((_) async => channelState);

          // Query with pagination params (fetching older messages)
          await channel.query(
            messagesPagination: const PaginationParams(
              limit: 20,
              lessThan: 'some-message-id',
            ),
          );

          // Verify submitForDelivery was NOT called
          verifyNever(
            () => client.channelDeliveryReporter.submitForDelivery([channel]),
          );
        },
      );
    });

    test('`.queryMembers`', () async {
      final filter = Filter.in_('cid', const [channelCid]);

      final members = List.generate(
        3,
        (index) => Member(userId: 'test-user-id-$index'),
      );

      when(
        () => client.queryMembers(
          channelType,
          channelId: channelId,
          filter: filter,
          members: any(named: 'members'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) async => QueryMembersResponse()..members = members);

      final res = await channel.queryMembers(filter: filter);

      expect(res, isNotNull);
      expect(res.members.length, members.length);

      verify(
        () => client.queryMembers(
          channelType,
          channelId: channelId,
          filter: filter,
          members: any(named: 'members'),
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).called(1);
    });

    test('`.queryBannedUsers`', () async {
      final filter = Filter.equal('channel_cid', channelCid);

      final bans = List.generate(
        3,
        (index) => BannedUser(
          user: User(id: 'test-user-id-$index'),
          bannedBy: User(id: 'test-user-id-${index + 1}'),
        ),
      );

      when(
        () => client.queryBannedUsers(
          filter: filter,
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).thenAnswer((_) async => QueryBannedUsersResponse()..bans = bans);

      final res = await channel.queryBannedUsers();

      expect(res, isNotNull);
      expect(res.bans.length, bans.length);

      verify(
        () => client.queryBannedUsers(
          filter: filter,
          sort: any(named: 'sort'),
          pagination: any(named: 'pagination'),
        ),
      ).called(1);
    });

    test('`.mute`', () async {
      when(
        () => client.muteChannel(
          channelCid,
          expiration: any(named: 'expiration'),
        ),
      ).thenAnswer((_) async => EmptyResponse());

      final res = await channel.mute();

      expect(res, isNotNull);

      verify(
        () => client.muteChannel(
          channelCid,
          expiration: any(named: 'expiration'),
        ),
      ).called(1);
    });

    test('`.mute with expiration`', () async {
      const expiration = Duration(seconds: 3);

      when(
        () => client.muteChannel(
          channelCid,
          expiration: expiration,
        ),
      ).thenAnswer((_) async => EmptyResponse());

      when(() => client.unmuteChannel(channelCid)).thenAnswer((_) async => EmptyResponse());

      final res = await channel.mute(expiration: expiration);

      expect(res, isNotNull);

      verify(
        () => client.muteChannel(
          channelCid,
          expiration: expiration,
        ),
      ).called(1);

      // wait for expiration
      await Future.delayed(expiration);
      verify(() => client.unmuteChannel(channelCid)).called(1);
    });

    test('`.unmute`', () async {
      when(
        () => client.unmuteChannel(channelCid),
      ).thenAnswer((_) async => EmptyResponse());

      final res = await channel.unmute();

      expect(res, isNotNull);

      verify(
        () => client.unmuteChannel(channelCid),
      ).called(1);
    });

    test('`.enableSlowMode`', () async {
      const cooldown = 10;

      final channelModel = ChannelModel(
        cid: channelCid,
        cooldown: cooldown,
      );

      when(
        () => client.enableSlowdown(
          channelId,
          channelType,
          cooldown,
        ),
      ).thenAnswer((_) async => PartialUpdateChannelResponse()..channel = channelModel);

      final res = await channel.enableSlowMode(cooldownInterval: 10);

      expect(res, isNotNull);

      verify(
        () => client.enableSlowdown(
          channelId,
          channelType,
          cooldown,
        ),
      ).called(1);
    });

    test('`.disableSlowMode`', () async {
      final channelModel = ChannelModel(
        cid: channelCid,
      );

      when(
        () => client.disableSlowdown(
          channelId,
          channelType,
        ),
      ).thenAnswer((_) async => PartialUpdateChannelResponse()..channel = channelModel);

      final res = await channel.disableSlowMode();

      expect(res, isNotNull);

      verify(() => client.disableSlowdown(channelId, channelType)).called(1);
    });

    test('`.banUser`', () async {
      const userId = 'test-user-id';
      const options = {'key': 'value'};

      when(
        () => client.banUser(
          userId,
          {'type': channelType, 'id': channelId, ...options},
        ),
      ).thenAnswer((_) async => EmptyResponse());

      final res = await channel.banMember(userId, options);

      expect(res, isNotNull);

      verify(
        () => client.banUser(
          userId,
          {'type': channelType, 'id': channelId, ...options},
        ),
      ).called(1);
    });

    test('`.unbanUser`', () async {
      const userId = 'test-user-id';

      when(() => client.unbanUser(userId, any())).thenAnswer((_) async => EmptyResponse());

      final res = await channel.unbanMember(userId);

      expect(res, isNotNull);

      verify(() => client.unbanUser(userId, any())).called(1);
    });

    test('`.shadowBan`', () async {
      const userId = 'test-user-id';
      const options = {'key': 'value'};

      when(
        () => client.shadowBan(
          userId,
          {'type': channelType, 'id': channelId, ...options},
        ),
      ).thenAnswer((_) async => EmptyResponse());

      final res = await channel.shadowBan(userId, options);

      expect(res, isNotNull);

      verify(
        () => client.shadowBan(
          userId,
          {'type': channelType, 'id': channelId, ...options},
        ),
      ).called(1);
    });

    test('`.removeShadowBan`', () async {
      const userId = 'test-user-id';

      when(() => client.removeShadowBan(userId, any())).thenAnswer((_) async => EmptyResponse());

      final res = await channel.removeShadowBan(userId);

      expect(res, isNotNull);

      verify(() => client.removeShadowBan(userId, any())).called(1);
    });

    test('`.hide`', () async {
      const clearHistory = true;

      when(
        () => client.hideChannel(
          channelId,
          channelType,
          clearHistory: clearHistory,
        ),
      ).thenAnswer((_) async => EmptyResponse());

      final res = await channel.hide(clearHistory: clearHistory);

      expect(res, isNotNull);

      verify(
        () => client.hideChannel(
          channelId,
          channelType,
          clearHistory: clearHistory,
        ),
      ).called(1);
    });

    test('`.show`', () async {
      when(() => client.showChannel(channelId, channelType)).thenAnswer((_) async => EmptyResponse());

      final res = await channel.show();

      expect(res, isNotNull);

      verify(() => client.showChannel(channelId, channelType)).called(1);
    });

    // testing archiving
    test('`.archive`', () async {
      when(() => client.archiveChannel(channelId: channelId, channelType: channelType)).thenAnswer(
        (_) async => FakePartialUpdateMemberResponse(),
      );

      final res = await channel.archive();

      expect(res, isNotNull);

      verify(() => client.archiveChannel(channelId: channelId, channelType: channelType)).called(1);
    });

    test('`.unarchive`', () async {
      when(() => client.unarchiveChannel(channelId: channelId, channelType: channelType)).thenAnswer(
        (_) async => FakePartialUpdateMemberResponse(),
      );

      final res = await channel.unarchive();

      expect(res, isNotNull);

      verify(() => client.unarchiveChannel(channelId: channelId, channelType: channelType)).called(1);
    });

    // testing pinning
    test('`.pin`', () async {
      when(
        () => client.pinChannel(channelId: channelId, channelType: channelType),
      ).thenAnswer((_) async => FakePartialUpdateMemberResponse());

      final res = await channel.pin();

      expect(res, isNotNull);

      verify(() => client.pinChannel(channelId: channelId, channelType: channelType)).called(1);
    });

    test('`.unpin`', () async {
      when(
        () => client.unpinChannel(channelId: channelId, channelType: channelType),
      ).thenAnswer((_) async => FakePartialUpdateMemberResponse());

      final res = await channel.unpin();

      expect(res, isNotNull);

      verify(() => client.unpinChannel(channelId: channelId, channelType: channelType)).called(1);
    });

    test('`.on`', () async {
      const eventType = 'test.event';
      final event = Event(type: eventType, cid: channelCid);

      Future.microtask(() => client.addEvent(event));

      return expectLater(channel.on(eventType), emitsInOrder([event]));
    });

    group('stale error message cleanup', () {
      final channelState = _generateChannelState(channelId, channelType);

      final errorMessage = Message(type: MessageType.error);
      final bouncedErrorMessage = Message(
        type: MessageType.error,
        moderation: const Moderation(
          action: ModerationAction.bounce,
          originalText: 'original text',
        ),
      );

      // Test case: sending a message cleans up stale error messages
      test('when sending a new message', () async {
        // Channel with 2 error messages
        final channel = Channel.fromState(
          client,
          channelState.copyWith(
            messages: [errorMessage, bouncedErrorMessage],
          ),
        );

        // Set up the mock response for sending message
        final newMessage = Message(text: 'New message');

        when(
          () => client.sendMessage(any(), channelId, channelType),
        ).thenAnswer((_) async => SendMessageResponse()..message = newMessage.copyWith(state: MessageState.sent));

        // Send a new message
        await channel.sendMessage(newMessage);
        final messages = channel.state!.messages;

        // Verify the cleanup
        expect(messages.length, 2);
        expect(messages.any((m) => m.id == errorMessage.id), false);
        expect(messages.any((m) => m.id == bouncedErrorMessage.id), true);
        expect(messages.any((m) => m.id == newMessage.id), true);

        verify(() => client.sendMessage(any(), channelId, channelType));
      });
    });

    group('`.state.pruneOldest`', () {
      List<Message> _generateMessages(int count) => List.generate(
        count,
        (i) => Message(
          id: 'msg-$i',
          text: 'Hello $i',
          createdAt: DateTime(2024).add(Duration(seconds: i)),
        ),
      );

      test('keeps only the [maxMessages] most recent messages', () {
        final initial = _generateMessages(10);
        channel.state!.updateChannelState(
          _generateChannelState(channelId, channelType).copyWith(messages: initial),
        );
        expect(channel.state!.messages, hasLength(10));

        channel.state!.pruneOldest(4);

        final pruned = channel.state!.messages;
        expect(pruned, hasLength(4));
        expect(pruned.map((m) => m.id), ['msg-6', 'msg-7', 'msg-8', 'msg-9']);
      });

      test('emits the pruned list on `messagesStream`', () async {
        final initial = _generateMessages(6);
        channel.state!.updateChannelState(
          _generateChannelState(channelId, channelType).copyWith(messages: initial),
        );

        final next = channel.state!.messagesStream.firstWhere((messages) => messages.length == 3);

        channel.state!.pruneOldest(3);

        final emitted = await next;
        expect(emitted.map((m) => m.id), ['msg-3', 'msg-4', 'msg-5']);
      });

      test('is a no-op when message count is within the limit', () {
        final initial = _generateMessages(3);
        channel.state!.updateChannelState(
          _generateChannelState(channelId, channelType).copyWith(messages: initial),
        );

        channel.state!.pruneOldest(5);
        expect(channel.state!.messages, hasLength(3));

        channel.state!.pruneOldest(3);
        expect(channel.state!.messages, hasLength(3));
      });

      test('is a no-op when [maxMessages] is zero or negative', () {
        final initial = _generateMessages(5);
        channel.state!.updateChannelState(
          _generateChannelState(channelId, channelType).copyWith(messages: initial),
        );

        channel.state!.pruneOldest(0);
        expect(channel.state!.messages, hasLength(5));

        channel.state!.pruneOldest(-1);
        expect(channel.state!.messages, hasLength(5));
      });

      test('is a no-op when `isUpToDate` is false', () {
        final initial = _generateMessages(10);
        channel.state!.updateChannelState(
          _generateChannelState(channelId, channelType).copyWith(messages: initial),
        );

        channel.state!.isUpToDate = false;
        channel.state!.pruneOldest(3);
        expect(channel.state!.messages, hasLength(10));
      });

      test('only mutates `messages`; other channel state fields untouched', () {
        final initial = _generateMessages(10);
        final pinned = [
          Message(
            id: 'pinned-1',
            text: 'pinned message',
            createdAt: DateTime(2024),
          ),
        ];

        channel.state!.updateChannelState(
          _generateChannelState(channelId, channelType).copyWith(
            messages: initial,
            pinnedMessages: pinned,
          ),
        );

        channel.state!.pruneOldest(3);

        expect(channel.state!.messages, hasLength(3));
        expect(channel.state!.pinnedMessages, equals(pinned));
      });

      test('does not emit on `messagesStream` for no-op calls', () async {
        final initial = _generateMessages(5);
        channel.state!.updateChannelState(
          _generateChannelState(channelId, channelType).copyWith(messages: initial),
        );

        // Skip the seeded emission from updateChannelState.
        await pumpEventQueue();

        final emissions = <List<Message>>[];
        final sub = channel.state!.messagesStream.skip(1).listen(emissions.add);
        addTearDown(sub.cancel);

        channel.state!.pruneOldest(0); // non-positive guard
        channel.state!.pruneOldest(-1); // non-positive guard
        channel.state!.pruneOldest(10); // within limit guard
        channel.state!.isUpToDate = false;
        channel.state!.pruneOldest(2); // !isUpToDate guard

        await pumpEventQueue();
        expect(emissions, isEmpty);
      });
    });
  });

  group('WS events', () {
    late final client = MockStreamChatClient();

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

    group(
      '${EventType.messageNew} or ${EventType.notificationMessageNew}',
      () {
        final initialLastMessageAt = DateTime.now();
        const channelId = 'test-channel-id';
        const channelType = 'test-channel-type';
        late Channel channel;

        setUp(() {
          final channelState = _generateChannelState(
            channelId,
            channelType,
            mockChannelConfig: true,
            ownCapabilities: const [ChannelCapability.readEvents],
            lastMessageAt: initialLastMessageAt,
          );

          channel = Channel.fromState(client, channelState);
        });

        tearDown(() => channel.dispose());

        Event createNewMessageEvent(Message message) {
          return Event(
            cid: channel.cid,
            type: EventType.messageNew,
            message: message,
          );
        }

        test(
          "should update 'channel.lastMessageAt'",
          () async {
            expect(channel.lastMessageAt, equals(initialLastMessageAt));

            final message = Message(
              id: 'test-message-id',
              user: client.state.currentUser,
              createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
            );

            final newMessageEvent = createNewMessageEvent(message);
            client.addEvent(newMessageEvent);

            // Wait for the event to get processed
            await Future.delayed(Duration.zero);

            expect(channel.lastMessageAt, equals(message.createdAt));
            expect(channel.lastMessageAt, isNot(initialLastMessageAt));
          },
        );

        test(
          "should update 'channel.lastMessageAt' when Message has restricted visibility only for the current user",
          () async {
            expect(channel.lastMessageAt, equals(initialLastMessageAt));

            final message = Message(
              id: 'test-message-id',
              user: client.state.currentUser,
              // Message is visible to the current user.
              restrictedVisibility: [client.state.currentUser!.id],
              createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
            );

            final newMessageEvent = createNewMessageEvent(message);
            client.addEvent(newMessageEvent);

            // Wait for the event to get processed
            await Future.delayed(Duration.zero);

            expect(channel.lastMessageAt, equals(message.createdAt));
            expect(channel.lastMessageAt, isNot(initialLastMessageAt));
          },
        );

        test(
          "should not update 'channel.lastMessageAt' when 'message.createdAt' is older",
          () async {
            expect(channel.lastMessageAt, equals(initialLastMessageAt));

            final message = Message(
              id: 'test-message-id',
              user: client.state.currentUser,
              // Older than the current 'channel.lastMessageAt'.
              createdAt: initialLastMessageAt.subtract(const Duration(days: 1)),
            );

            final newMessageEvent = createNewMessageEvent(message);
            client.addEvent(newMessageEvent);

            // Wait for the event to get processed
            await Future.delayed(Duration.zero);

            expect(channel.lastMessageAt, isNot(message.createdAt));
            expect(channel.lastMessageAt, equals(initialLastMessageAt));
          },
        );

        test(
          "should not update 'channel.lastMessageAt' when Message is shadowed",
          () async {
            expect(channel.lastMessageAt, equals(initialLastMessageAt));

            final message = Message(
              id: 'test-message-id',
              user: client.state.currentUser,
              shadowed: true,
              createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
            );

            final newMessageEvent = createNewMessageEvent(message);
            client.addEvent(newMessageEvent);

            // Wait for the event to get processed
            await Future.delayed(Duration.zero);

            expect(channel.lastMessageAt, isNot(message.createdAt));
            expect(channel.lastMessageAt, equals(initialLastMessageAt));
          },
        );

        test(
          "should not update 'channel.lastMessageAt' when Message is ephemeral",
          () async {
            expect(channel.lastMessageAt, equals(initialLastMessageAt));

            final message = Message(
              type: MessageType.ephemeral,
              id: 'test-message-id',
              user: client.state.currentUser,
              createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
            );

            final newMessageEvent = createNewMessageEvent(message);
            client.addEvent(newMessageEvent);

            // Wait for the event to get processed
            await Future.delayed(Duration.zero);

            expect(channel.lastMessageAt, isNot(message.createdAt));
            expect(channel.lastMessageAt, equals(initialLastMessageAt));
          },
        );

        test(
          "should not update 'channel.lastMessageAt' when Message has restricted visibility but not for the current user",
          () async {
            expect(channel.lastMessageAt, equals(initialLastMessageAt));

            final message = Message(
              id: 'test-message-id',
              user: client.state.currentUser,
              // Message is only visible to user-1 not the current user.
              restrictedVisibility: const ['user-1'],
              createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
            );

            final newMessageEvent = createNewMessageEvent(message);
            client.addEvent(newMessageEvent);

            // Wait for the event to get processed
            await Future.delayed(Duration.zero);

            expect(channel.lastMessageAt, isNot(message.createdAt));
            expect(channel.lastMessageAt, equals(initialLastMessageAt));
          },
        );

        test(
          "should not update 'channel.lastMessageAt' when Message is system and skip is enabled",
          () async {
            expect(channel.lastMessageAt, equals(initialLastMessageAt));

            when(
              () => channel.config?.skipLastMsgUpdateForSystemMsgs,
            ).thenReturn(true);

            final message = Message(
              type: MessageType.system,
              id: 'test-message-id',
              user: client.state.currentUser,
              createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
            );

            final newMessageEvent = createNewMessageEvent(message);
            client.addEvent(newMessageEvent);

            // Wait for the event to get processed
            await Future.delayed(Duration.zero);

            expect(channel.lastMessageAt, isNot(message.createdAt));
            expect(channel.lastMessageAt, equals(initialLastMessageAt));
          },
        );

        test("should update 'unreadCount'", () async {
          expect(channel.state?.unreadCount, equals(0));

          final message = Message(
            id: 'test-message-id',
            user: User(id: 'other-user'),
            createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
          );

          final newMessageEvent = createNewMessageEvent(message);
          client.addEvent(newMessageEvent);

          // Wait for the event to get processed
          await Future.delayed(Duration.zero);

          expect(channel.state?.unreadCount, equals(1));

          final message2 = Message(
            id: 'test-message-id-2',
            user: User(id: 'other-user'),
            createdAt: message.createdAt.add(const Duration(seconds: 3)),
          );

          final newMessage2Event = createNewMessageEvent(message2);
          client.addEvent(newMessage2Event);

          // Wait for the event to get processed
          await Future.delayed(Duration.zero);

          expect(channel.state?.unreadCount, equals(2));
        });

        group("should not update 'unreadCount'", () {
          test(
            'when the message is silent',
            () async {
              expect(channel.state?.unreadCount, equals(0));

              final message = Message(
                id: 'test-message-id',
                silent: true,
                user: User(id: 'other-user'),
                createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
              );

              final newMessageEvent = createNewMessageEvent(message);
              client.addEvent(newMessageEvent);

              // Wait for the event to get processed
              await Future.delayed(Duration.zero);

              expect(channel.state?.unreadCount, equals(0));
            },
          );

          test(
            'when the message is shadowed',
            () async {
              expect(channel.state?.unreadCount, equals(0));

              final message = Message(
                id: 'test-message-id',
                shadowed: true,
                user: User(id: 'other-user'),
                createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
              );

              final newMessageEvent = createNewMessageEvent(message);
              client.addEvent(newMessageEvent);

              // Wait for the event to get processed
              await Future.delayed(Duration.zero);

              expect(channel.state?.unreadCount, equals(0));
            },
          );

          test(
            'when the message type is ephemeral',
            () async {
              expect(channel.state?.unreadCount, equals(0));

              final message = Message(
                id: 'test-message-id',
                type: MessageType.ephemeral,
                user: User(id: 'other-user'),
                createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
              );

              final newMessageEvent = createNewMessageEvent(message);
              client.addEvent(newMessageEvent);

              // Wait for the event to get processed
              await Future.delayed(Duration.zero);

              expect(channel.state?.unreadCount, equals(0));
            },
          );

          test(
            'when the message is a thread reply',
            () async {
              expect(channel.state?.unreadCount, equals(0));

              final message = Message(
                id: 'test-message-id',
                parentId: 'test-parent-id',
                showInChannel: false,
                user: User(id: 'other-user'),
                createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
              );

              final newMessageEvent = createNewMessageEvent(message);
              client.addEvent(newMessageEvent);

              // Wait for the event to get processed
              await Future.delayed(Duration.zero);

              expect(channel.state?.unreadCount, equals(0));
            },
          );

          test(
            'when the message is a thread reply',
            () async {
              expect(channel.state?.unreadCount, equals(0));

              final message = Message(
                id: 'test-message-id',
                parentId: 'test-parent-id',
                showInChannel: false,
                user: User(id: 'other-user'),
                createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
              );

              final newMessageEvent = createNewMessageEvent(message);
              client.addEvent(newMessageEvent);

              // Wait for the event to get processed
              await Future.delayed(Duration.zero);

              expect(channel.state?.unreadCount, equals(0));
            },
          );

          test(
            'when the message is from the current user',
            () async {
              expect(channel.state?.unreadCount, equals(0));

              final message = Message(
                id: 'test-message-id',
                user: client.state.currentUser,
                createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
              );

              final newMessageEvent = createNewMessageEvent(message);
              client.addEvent(newMessageEvent);

              // Wait for the event to get processed
              await Future.delayed(Duration.zero);

              expect(channel.state?.unreadCount, equals(0));
            },
          );

          test(
            'when the message is not restricted for the current user',
            () async {
              expect(channel.state?.unreadCount, equals(0));

              final message = Message(
                id: 'test-message-id',
                user: User(id: 'other-user'),
                createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
                restrictedVisibility: const ['other-user-2'],
              );

              final newMessageEvent = createNewMessageEvent(message);
              client.addEvent(newMessageEvent);

              // Wait for the event to get processed
              await Future.delayed(Duration.zero);

              expect(channel.state?.unreadCount, equals(0));
            },
          );
        });

        test(
          'should submit channel for delivery when message is received',
          () async {
            final message = Message(
              id: 'test-message-id',
              user: User(id: 'other-user'),
              createdAt: initialLastMessageAt.add(const Duration(seconds: 3)),
            );

            final newMessageEvent = createNewMessageEvent(message);
            client.addEvent(newMessageEvent);

            // Wait for the event to get processed
            await Future.delayed(Duration.zero);

            // Verify submitForDelivery was called
            verify(
              () => client.channelDeliveryReporter.submitForDelivery([channel]),
            ).called(1);
          },
        );

        test(
          'should not duplicate when server echoes back an optimistically '
          'inserted message with a later createdAt',
          () async {
            // Local message used as the input to `channel.sendMessage`.
            final localCreatedAt = initialLastMessageAt.add(const Duration(seconds: 3));
            final localMessage = Message(
              id: 'test-message-id',
              text: 'Hello world!',
              user: client.state.currentUser,
              createdAt: localCreatedAt,
            );

            // Mock the network send to return the message unchanged so the
            // optimistic insert + sent-state update both land on the same
            // `createdAt`. The bug fires later, on the WS echo.
            final sendMessageResponse = SendMessageResponse()
              ..message = localMessage.copyWith(state: MessageState.sent);
            when(() => client.sendMessage(any(), channelId, channelType)).thenAnswer((_) async => sendMessageResponse);

            await channel.sendMessage(localMessage);

            expect(channel.state!.messages, hasLength(1));

            // Server then broadcasts the same message via a `message.new`
            // event with a slightly later `createdAt` (server-assigned
            // timestamp).
            final serverMessage = localMessage.copyWith(
              createdAt: localCreatedAt.add(const Duration(milliseconds: 50)),
            );
            client.addEvent(createNewMessageEvent(serverMessage));

            // Wait for the event to get processed
            await Future.delayed(Duration.zero);

            // The state should contain exactly one message with that id,
            // not a duplicate.
            final matching = channel.state!.messages.where((it) => it.id == localMessage.id);
            expect(matching, hasLength(1));
            expect(channel.state!.messages, hasLength(1));
          },
        );

        test(
          'should not duplicate when the locally-sent message is no longer '
          'the latest (retry-after-offline scenario)',
          () async {
            // Mirrors the offline-retry flow: a local message is sent, then
            // another message arrives via WS while the local one is still
            // pending. When the retry finally succeeds the server response's
            // `createdAt` is later than the intervening message, so the
            // locally-sent copy is no longer `messages.last`.
            final localCreatedAt = initialLastMessageAt.add(const Duration(seconds: 1));
            final localMessage = Message(
              id: 'local-message-id',
              text: 'Hello world!',
              user: client.state.currentUser,
              createdAt: localCreatedAt,
            );

            final sendMessageResponse = SendMessageResponse()
              ..message = localMessage.copyWith(state: MessageState.sent);
            when(() => client.sendMessage(any(), channelId, channelType)).thenAnswer((_) async => sendMessageResponse);

            await channel.sendMessage(localMessage);

            // Another message arrives via WS with a later `createdAt`,
            // pushing the locally-sent message off the tail.
            final otherMessage = Message(
              id: 'other-message-id',
              user: User(id: 'other-user'),
              createdAt: localCreatedAt.add(const Duration(seconds: 2)),
            );
            client.addEvent(createNewMessageEvent(otherMessage));
            await Future.delayed(Duration.zero);

            // Server then broadcasts the locally-sent message via
            // `message.new` with a `createdAt` that is later than the
            // intervening message — exactly the shape produced by a
            // successful retry after another message arrived in between.
            final serverEcho = localMessage.copyWith(
              createdAt: otherMessage.createdAt.add(const Duration(seconds: 1)),
            );
            client.addEvent(createNewMessageEvent(serverEcho));
            await Future.delayed(Duration.zero);

            final localMatches = channel.state!.messages.where((it) => it.id == localMessage.id);
            expect(localMatches, hasLength(1));
            expect(channel.state!.messages, hasLength(2));
          },
        );
      },
    );

    group(
      EventType.messageUpdated,
      () {
        const channelId = 'test-channel-id';
        const channelType = 'test-channel-type';
        late Channel channel;

        setUp(() {
          final channelState = _generateChannelState(
            channelId,
            channelType,
            mockChannelConfig: true,
            ownCapabilities: const [ChannelCapability.readEvents],
          );

          channel = Channel.fromState(client, channelState);
        });

        tearDown(() => channel.dispose());

        Event createUpdateMessageEvent(Message message) {
          return Event(
            cid: channel.cid,
            type: EventType.messageUpdated,
            message: message,
          );
        }

        test(
          "should update 'channel.state.pinnedMessages' and should add message to pinned messages only once if updatedMessage.pinned is true",
          () async {
            const messageId = 'test-message-id';
            final message = Message(
              id: messageId,
              user: client.state.currentUser,
              pinned: true,
            );

            final newMessageEvent = createUpdateMessageEvent(message);
            client.addEvent(newMessageEvent);

            // Wait for the event to get processed
            await Future.delayed(Duration.zero);

            expect(channel.state?.pinnedMessages.length, equals(1));
            expect(channel.state?.pinnedMessages.first.id, equals(messageId));
          },
        );

        test(
          'should update pinned message itself if updatedMessage.pinned is true and message is already pinned',
          () async {
            const messageId = 'test-message-id';
            const oldText = 'Old text';
            const newText = 'New text';
            final message = Message(
              id: messageId,
              user: client.state.currentUser,
              text: oldText,
              pinned: true,
            );

            final firstUpdateEvent = createUpdateMessageEvent(message);
            client.addEvent(firstUpdateEvent);

            // Wait for the first event to get processed
            await Future.delayed(Duration.zero);

            expect(channel.state?.pinnedMessages.length, equals(1));
            expect(channel.state?.pinnedMessages.first.id, equals(messageId));
            expect(channel.state?.pinnedMessages.first.text, equals(oldText));

            final updatedMessage = message.copyWith(text: newText);
            final secondUpdateEvent = createUpdateMessageEvent(updatedMessage);
            client.addEvent(secondUpdateEvent);

            // Wait for the second event to get processed
            await Future.delayed(Duration.zero);

            expect(channel.state?.pinnedMessages.length, equals(1));
            expect(channel.state?.pinnedMessages.first.id, equals(messageId));
            expect(channel.state?.pinnedMessages.first.text, equals(newText));
          },
        );

        test(
          "should update 'channel.state.pinnedMessages' and should add message to pinned messages "
          'and not unpin previous pinned message if updatedMessage.pinned is true and there is already another pinned message',
          () async {
            const firstMessageId = 'first-test-message-id';
            const secondMessageId = 'second-test-message-id';
            final firstMessage = Message(
              id: firstMessageId,
              user: client.state.currentUser,
              pinned: true,
            );
            final secondMessage = firstMessage.copyWith(id: secondMessageId);

            final firstUpdateEvent = createUpdateMessageEvent(firstMessage);
            client.addEvent(firstUpdateEvent);

            // Wait for the first event to get processed
            await Future.delayed(Duration.zero);

            expect(channel.state?.pinnedMessages.length, equals(1));
            expect(
              channel.state?.pinnedMessages.first.id,
              equals(firstMessageId),
            );

            final secondUpdateEvent = createUpdateMessageEvent(secondMessage);
            client.addEvent(secondUpdateEvent);

            // Wait for the second event to get processed
            await Future.delayed(Duration.zero);

            expect(channel.state?.pinnedMessages.length, equals(2));
            expect(
              channel.state?.pinnedMessages.first.id,
              equals(firstMessageId),
            );
            expect(
              channel.state?.pinnedMessages[1].id,
              equals(secondMessageId),
            );
          },
        );

        test(
          "should update 'channel.state.pinnedMessages' and should remove message from pinned messages if updatedMessage.pinned is false",
          () async {
            const messageId = 'test-message-id';
            final pinnedMessage = Message(
              id: messageId,
              user: client.state.currentUser,
              pinned: true,
            );

            final pinEvent = createUpdateMessageEvent(pinnedMessage);
            client.addEvent(pinEvent);

            // Wait for the pin event to get processed
            await Future.delayed(Duration.zero);

            expect(channel.state?.pinnedMessages.length, equals(1));
            expect(channel.state?.pinnedMessages.first.id, equals(messageId));

            final unpinnedMessage = pinnedMessage.copyWith(pinned: false);
            final unpinEvent = createUpdateMessageEvent(unpinnedMessage);
            client.addEvent(unpinEvent);

            // Wait for the unpin event to get processed
            await Future.delayed(Duration.zero);

            expect(channel.state?.pinnedMessages, isEmpty);
          },
        );

        // A `message.updated` event for a message outside the loaded window
        // would otherwise upsert into the sorted list — creating a phantom
        // entry with a gap. The guard is "id not in the loaded list", and
        // is independent of `isUpToDate` — even at the latest page we may
        // have paginated past older history and receive an event for a
        // message no longer in memory.
        group('when message is outside the loaded window', () {
          test(
            'should NOT insert unknown message into `messages` list',
            () async {
              // Simulate "we have the latest page but not older history":
              // seed the tail messages.
              final tail = List.generate(
                3,
                (i) => Message(
                  id: 'tail-$i',
                  user: client.state.currentUser,
                  text: 'tail $i',
                  createdAt: DateTime.utc(2026, 6, 1).add(Duration(seconds: i)),
                ),
              );
              channel.state!.updateChannelState(
                channel.state!.channelState.copyWith(messages: tail),
              );
              expect(channel.state!.messages, hasLength(3));

              // Event for a message on an older page we don't have loaded.
              final olderPageEdit = Message(
                id: 'older-page-msg',
                user: client.state.currentUser,
                text: 'edited on older page',
                createdAt: DateTime.utc(2025, 1, 1),
              );
              client.addEvent(createUpdateMessageEvent(olderPageEdit));
              await Future.delayed(Duration.zero);

              // Tail is unchanged, no phantom entry inserted at position 0.
              expect(channel.state!.messages.map((m) => m.id), ['tail-0', 'tail-1', 'tail-2']);
              expect(channel.state!.pinnedMessages, isEmpty);
            },
          );

          test(
            'should update message in place when it IS in the loaded window',
            () async {
              const messageId = 'known';
              final seeded = Message(
                id: messageId,
                user: client.state.currentUser,
                text: 'old',
                createdAt: DateTime.utc(2026),
              );
              channel.state!.updateChannelState(
                channel.state!.channelState.copyWith(messages: [seeded]),
              );
              channel.state!.isUpToDate = false;

              final edited = seeded.copyWith(text: 'new');
              client.addEvent(createUpdateMessageEvent(edited));
              await Future.delayed(Duration.zero);

              final stored = channel.state!.messages.singleWhere((m) => m.id == messageId);
              expect(stored.text, equals('new'));
            },
          );

          test(
            'should still add to pinnedMessages when pinned:true even if not in loaded window',
            () async {
              channel.state!.isUpToDate = false;
              expect(channel.state!.messages, isEmpty);
              expect(channel.state!.pinnedMessages, isEmpty);

              const messageId = 'pin-me';
              final pinned = Message(
                id: messageId,
                user: client.state.currentUser,
                pinned: true,
              );
              client.addEvent(createUpdateMessageEvent(pinned));
              await Future.delayed(Duration.zero);

              expect(channel.state!.messages, isEmpty);
              expect(channel.state!.pinnedMessages.length, equals(1));
              expect(channel.state!.pinnedMessages.first.id, equals(messageId));
            },
          );

          test(
            'should NOT insert unknown reply into threads[parentId]',
            () async {
              const parentId = 'parent-1';
              final knownReply = Message(
                id: 'known-reply',
                parentId: parentId,
                user: client.state.currentUser,
                createdAt: DateTime.utc(2026),
              );
              // Populate threads[parentId] via addNewMessage's thread-only path.
              channel.state!.addNewMessage(knownReply);
              await Future.delayed(Duration.zero);
              expect(channel.state!.threads[parentId], hasLength(1));

              channel.state!.isUpToDate = false;

              final phantomReply = Message(
                id: 'other-reply',
                parentId: parentId,
                user: client.state.currentUser,
                text: 'edited',
                createdAt: DateTime.utc(2026, 1, 2),
              );
              client.addEvent(createUpdateMessageEvent(phantomReply));
              await Future.delayed(Duration.zero);

              expect(channel.state!.threads[parentId]!.map((m) => m.id), ['known-reply']);
            },
          );

          test(
            'should NOT create phantom threads[parentId] entry for unloaded thread',
            () async {
              const parentId = 'unloaded-parent';
              // The thread was never paged in, so there's no entry for it.
              expect(channel.state!.threads.containsKey(parentId), isFalse);

              channel.state!.isUpToDate = false;

              final phantomReply = Message(
                id: 'phantom-reply',
                parentId: parentId,
                user: client.state.currentUser,
                text: 'edited',
                createdAt: DateTime.utc(2026, 1, 2),
              );
              client.addEvent(createUpdateMessageEvent(phantomReply));
              await Future.delayed(Duration.zero);

              // The dropped reply must not leave behind an empty thread entry.
              expect(channel.state!.threads.containsKey(parentId), isFalse);
            },
          );

          test(
            'should still expire activeLiveLocations for out-of-window message',
            () async {
              final liveLocation = Location(
                channelCid: channel.cid,
                userId: 'user1',
                messageId: 'loc-msg',
                latitude: 40.7128,
                longitude: -74.0060,
                createdByDeviceId: 'device1',
                endAt: DateTime.now().add(const Duration(hours: 1)),
              );

              // Seed only activeLiveLocations, keeping `messages` empty —
              // the exact "message is outside the loaded window" scenario.
              channel.state!.updateChannelState(
                ChannelState(
                  channel: channel.state!.channelState.channel,
                  activeLiveLocations: [liveLocation],
                ),
              );
              channel.state!.isUpToDate = false;
              expect(channel.state!.messages, isEmpty);
              expect(channel.state!.activeLiveLocations, hasLength(1));

              // A message.updated that expires the live location.
              final expiredMessage = Message(
                id: 'loc-msg',
                text: 'Live location shared',
                sharedLocation: liveLocation.copyWith(
                  endAt: DateTime.now().subtract(const Duration(minutes: 1)),
                ),
              );
              client.addEvent(createUpdateMessageEvent(expiredMessage));
              await Future.delayed(Duration.zero);

              expect(channel.state!.messages, isEmpty);
              expect(channel.state!.activeLiveLocations, isEmpty);
            },
          );
        });
      },
    );

    // A reply with `show_in_channel = true` is mirrored into both `messages`
    // and `threads[parentId]`. When the thread isn't loaded (fresh hydration,
    // user never opened the thread) the channel-level copy is the only place
    // locally-cached fields like `ownReactions`/`poll` survive — so reaction
    // and message-update events for such replies must still find it.
    group(
      'reply events with `show_in_channel = true` and unloaded thread',
      () {
        const channelId = 'test-channel-id';
        const channelType = 'test-channel-type';
        const replyId = 'mirrored-reply-id';
        const parentId = 'parent-message-id';
        // Pinned createdAt keeps oldIndex lookups stable in `updateMessage`.
        final createdAt = DateTime.utc(2026, 1, 1);
        late Channel channel;

        setUp(() {
          final channelState = _generateChannelState(
            channelId,
            channelType,
            mockChannelConfig: true,
            ownCapabilities: const [ChannelCapability.readEvents],
          );
          channel = Channel.fromState(client, channelState);
        });

        tearDown(() => channel.dispose());

        // Seeds a single reply into the channel-level `messages` while leaving
        // `threads[parentId]` empty — the exact regression scenario.
        Message seedMirroredReply({
          List<Reaction> ownReactions = const [],
          Poll? poll,
        }) {
          final reply = Message(
            id: replyId,
            parentId: parentId,
            showInChannel: true,
            user: client.state.currentUser,
            createdAt: createdAt,
            ownReactions: ownReactions,
            poll: poll,
            pollId: poll?.id,
          );
          channel.state!.updateChannelState(
            channel.state!.channelState.copyWith(messages: [reply]),
          );
          return reply;
        }

        test(
          '`reaction.new` from another user preserves `ownReactions`',
          () async {
            final ownReaction = Reaction(
              type: 'like',
              messageId: replyId,
              user: client.state.currentUser,
            );
            seedMirroredReply(ownReactions: [ownReaction]);
            // Pre-condition: thread is not loaded.
            expect(channel.state!.threads, isEmpty);

            // Server reaction events don't echo back the recipient's own
            // reactions, so the listener must pull them from the cached copy.
            final otherUserReaction = Reaction(
              type: 'love',
              messageId: replyId,
              user: User(id: 'other-user'),
            );
            client.addEvent(
              Event(
                cid: channel.cid,
                type: EventType.reactionNew,
                reaction: otherUserReaction,
                message: Message(
                  id: replyId,
                  parentId: parentId,
                  showInChannel: true,
                  user: client.state.currentUser,
                  createdAt: createdAt,
                  latestReactions: [otherUserReaction],
                ),
              ),
            );

            await Future.delayed(Duration.zero);

            final stored = channel.state!.messages.firstWhere((it) => it.id == replyId);
            expect(stored.ownReactions, [ownReaction]);
          },
        );

        test(
          '`reaction.deleted` strips only the removed reaction',
          () async {
            final kept = Reaction(
              type: 'like',
              messageId: replyId,
              user: client.state.currentUser,
            );
            final removed = Reaction(
              type: 'love',
              messageId: replyId,
              user: client.state.currentUser,
            );
            seedMirroredReply(ownReactions: [kept, removed]);
            expect(channel.state!.threads, isEmpty);

            client.addEvent(
              Event(
                cid: channel.cid,
                type: EventType.reactionDeleted,
                reaction: removed,
                message: Message(
                  id: replyId,
                  parentId: parentId,
                  showInChannel: true,
                  user: client.state.currentUser,
                  createdAt: createdAt,
                ),
              ),
            );

            await Future.delayed(Duration.zero);

            final stored = channel.state!.messages.firstWhere((it) => it.id == replyId);
            expect(stored.ownReactions, [kept]);
          },
        );

        test(
          '`message.updated` preserves `poll`, `pollId`, and `ownReactions`',
          () async {
            final ownReaction = Reaction(
              type: 'like',
              messageId: replyId,
              user: client.state.currentUser,
            );
            // Partial server updates can omit poll/pollId/ownReactions; the
            // cached copy is what backfills them.
            final poll = Poll(
              id: 'poll-1',
              name: 'Pick one',
              options: const [
                PollOption(text: 'A'),
                PollOption(text: 'B'),
              ],
            );
            seedMirroredReply(ownReactions: [ownReaction], poll: poll);
            expect(channel.state!.threads, isEmpty);

            client.addEvent(
              Event(
                cid: channel.cid,
                type: EventType.messageUpdated,
                message: Message(
                  id: replyId,
                  parentId: parentId,
                  showInChannel: true,
                  user: client.state.currentUser,
                  createdAt: createdAt,
                  text: 'edited',
                ),
              ),
            );

            await Future.delayed(Duration.zero);

            final stored = channel.state!.messages.firstWhere((it) => it.id == replyId);
            expect(stored.ownReactions, [ownReaction]);
            expect(stored.poll?.id, poll.id);
            expect(stored.pollId, poll.id);
          },
        );
      },
    );

    // A `message.deleted` event for a message outside the loaded window
    // must not upsert a "deleted" record into the sorted list — that would
    // create a phantom entry with a gap. Pinned + live-location
    // side-effects must still fire.
    group(
      EventType.messageDeleted,
      () {
        const channelId = 'test-channel-id';
        const channelType = 'test-channel-type';
        late Channel channel;

        setUp(() {
          final channelState = _generateChannelState(
            channelId,
            channelType,
            mockChannelConfig: true,
            ownCapabilities: const [ChannelCapability.readEvents],
          );
          channel = Channel.fromState(client, channelState);
        });

        tearDown(() => channel.dispose());

        Event createDeleteMessageEvent(Message message, {bool hardDelete = false}) {
          return Event(
            cid: channel.cid,
            type: EventType.messageDeleted,
            message: message.copyWith(
              type: MessageType.deleted,
              deletedAt: DateTime.timestamp(),
            ),
            hardDelete: hardDelete,
          );
        }

        // Same design as the `messageUpdated` guards: the check is
        // "message-in-loaded-window" and is independent of `isUpToDate` —
        // an event for a message on an older, unloaded page must not be
        // turned into a phantom "deleted" record inserted into the sorted
        // list.
        group('when message is outside the loaded window', () {
          test(
            'soft delete does NOT insert phantom "deleted" record into messages',
            () async {
              final tail = List.generate(
                3,
                (i) => Message(
                  id: 'tail-$i',
                  user: client.state.currentUser,
                  text: 'tail $i',
                  createdAt: DateTime.utc(2026, 6, 1).add(Duration(seconds: i)),
                ),
              );
              channel.state!.updateChannelState(
                channel.state!.channelState.copyWith(messages: tail),
              );
              expect(channel.state!.messages, hasLength(3));

              final olderPage = Message(
                id: 'older-page-msg',
                user: client.state.currentUser,
                text: 'gone',
                createdAt: DateTime.utc(2025, 1, 1),
              );
              client.addEvent(createDeleteMessageEvent(olderPage));
              await Future.delayed(Duration.zero);

              expect(channel.state!.messages.map((m) => m.id), ['tail-0', 'tail-1', 'tail-2']);
            },
          );

          test(
            'soft delete marks message as deleted when it IS in the loaded window',
            () async {
              const messageId = 'known';
              final seeded = Message(
                id: messageId,
                user: client.state.currentUser,
                text: 'hi',
                createdAt: DateTime.utc(2026),
              );
              channel.state!.updateChannelState(
                channel.state!.channelState.copyWith(messages: [seeded]),
              );
              channel.state!.isUpToDate = false;

              client.addEvent(createDeleteMessageEvent(seeded));
              await Future.delayed(Duration.zero);

              final stored = channel.state!.messages.singleWhere((m) => m.id == messageId);
              expect(stored.type, equals(MessageType.deleted));
              expect(stored.deletedAt, isNotNull);
            },
          );

          test(
            'soft delete unpins a pinned-but-not-in-window message via _pinIsValid',
            () async {
              const messageId = 'pinned-msg';
              final pinned = Message(
                id: messageId,
                user: client.state.currentUser,
                pinned: true,
                createdAt: DateTime.utc(2026),
              );
              // Seed only the pinnedMessages list — message absent from
              // the main `messages` window.
              channel.state!.updateChannelState(
                channel.state!.channelState.copyWith(pinnedMessages: [pinned]),
              );
              channel.state!.isUpToDate = false;
              expect(channel.state!.messages, isEmpty);
              expect(channel.state!.pinnedMessages, hasLength(1));

              client.addEvent(createDeleteMessageEvent(pinned));
              await Future.delayed(Duration.zero);

              expect(channel.state!.messages, isEmpty);
              expect(channel.state!.pinnedMessages, isEmpty);
            },
          );

          test(
            'soft delete still clears activeLiveLocations even when message not in window',
            () async {
              final liveLocation = Location(
                channelCid: channel.cid,
                userId: 'user1',
                messageId: 'loc-msg',
                latitude: 40.7128,
                longitude: -74.0060,
                createdByDeviceId: 'device1',
                endAt: DateTime.now().add(const Duration(hours: 1)),
              );

              // Seed only activeLiveLocations, keeping `messages` empty.
              channel.state!.updateChannelState(
                ChannelState(
                  channel: channel.state!.channelState.channel,
                  activeLiveLocations: [liveLocation],
                ),
              );
              channel.state!.isUpToDate = false;
              expect(channel.state!.messages, isEmpty);
              expect(channel.state!.activeLiveLocations, hasLength(1));

              final locationMessage = Message(
                id: 'loc-msg',
                text: 'Live location shared',
                sharedLocation: liveLocation,
              );
              client.addEvent(createDeleteMessageEvent(locationMessage));
              await Future.delayed(Duration.zero);

              expect(channel.state!.messages, isEmpty);
              expect(channel.state!.activeLiveLocations, isEmpty);
            },
          );

          test(
            'hard delete is a no-op when message is not in the loaded window',
            () async {
              channel.state!.isUpToDate = false;
              expect(channel.state!.messages, isEmpty);

              final phantom = Message(
                id: 'phantom',
                user: client.state.currentUser,
                text: 'gone',
                createdAt: DateTime.utc(2026),
              );
              client.addEvent(createDeleteMessageEvent(phantom, hardDelete: true));
              await Future.delayed(Duration.zero);

              expect(channel.state!.messages, isEmpty);
              expect(channel.state!.pinnedMessages, isEmpty);
            },
          );
        });
      },
    );

    group('Member Events', () {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      late Channel channel;

      setUp(() {
        final channelState = _generateChannelState(channelId, channelType);
        channel = Channel.fromState(client, channelState);
      });

      tearDown(() {
        channel.dispose();
      });

      test(
        'should update membership when member is updated and is current user',
        () async {
          final currentUser = client.state.currentUser;
          final currentMember = Member(user: currentUser);
          final now = DateTime.now();

          // Setup initial membership
          channel.state?.updateChannelState(
            channel.state!.channelState.copyWith(
              members: [currentMember],
              membership: currentMember,
            ),
          );

          // Verify initial state
          expect(channel.membership, isNotNull);
          expect(channel.membership?.channelRole, isNull);
          expect(channel.membership?.isModerator, false);
          expect(channel.isPinned, isFalse);
          expect(channel.isArchived, isFalse);

          // Create updated member with same userId but updated properties
          final updatedMember = currentMember.copyWith(
            channelRole: 'moderator',
            isModerator: true,
            pinnedAt: now,
            archivedAt: now,
          );

          // Create member updated event
          final memberUpdatedEvent = Event(
            cid: channel.cid,
            type: EventType.memberUpdated,
            user: currentUser,
            member: updatedMember,
          );

          // Dispatch event
          client.addEvent(memberUpdatedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify membership is updated with new properties
          expect(channel.membership, isNotNull);
          expect(channel.membership?.userId, equals(currentUser?.id));
          expect(channel.membership?.channelRole, equals('moderator'));
          expect(channel.membership?.isModerator, isTrue);
          expect(channel.isPinned, isTrue);
          expect(channel.isArchived, isTrue);
        },
      );

      test(
        'should update membership user when any event containing user is updated',
        () async {
          final currentUser = client.state.currentUser;
          final currentMember = Member(user: currentUser);

          // Setup initial membership
          channel.state?.updateChannelState(
            channel.state!.channelState.copyWith(
              members: [currentMember],
              membership: currentMember,
            ),
          );

          // Verify initial state
          expect(channel.membership, isNotNull);
          expect(channel.membership?.user?.id, equals(currentUser?.id));
          expect(channel.membership?.user?.role, equals(currentUser?.role));

          // Create updated user with same userId but updated properties
          final updatedUser = currentUser?.copyWith(role: 'moderator');

          // Create any event with same updated user as membership.
          final anyEvent = Event(
            cid: channel.cid,
            type: EventType.any,
            user: updatedUser,
          );

          // Dispatch event
          client.addEvent(anyEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify membership is updated with new properties
          expect(channel.membership, isNotNull);
          expect(channel.membership?.user?.id, equals(updatedUser?.id));
          expect(channel.membership?.user?.role, equals(updatedUser?.role));
        },
      );
    });

    group('Read Events', () {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      late Channel channel;

      setUp(() {
        final channelState = _generateChannelState(
          channelId,
          channelType,
          mockChannelConfig: true,
        );

        channel = Channel.fromState(client, channelState);
      });

      tearDown(() {
        channel.dispose();
      });

      test('should update read state on message read event', () async {
        final currentUser = User(id: 'test-user');
        final currentRead = Read(
          user: currentUser,
          lastRead: DateTime(2020),
          unreadMessages: 10,
        );

        // Setup initial read state
        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            read: [currentRead],
          ),
        );

        // Verify initial state
        final read = channel.state?.read.first;
        expect(read?.user.id, 'test-user');
        expect(read?.unreadMessages, 10);
        expect(read?.lastReadMessageId, isNull);
        expect(read?.lastRead.isAtSameMomentAs(DateTime(2020)), isTrue);

        // Create message read event
        final messageReadEvent = Event(
          cid: channel.cid,
          type: EventType.messageRead,
          user: currentUser,
          createdAt: DateTime(2022),
          unreadMessages: 0,
          lastReadMessageId: 'message-123',
        );

        // Dispatch event
        client.addEvent(messageReadEvent);

        // Wait for event to be processed
        await Future.delayed(Duration.zero);

        // Verify read state is updated
        final updatedRead = channel.state?.read.first;
        expect(updatedRead?.user.id, 'test-user');
        expect(updatedRead?.unreadMessages, 0);
        expect(updatedRead?.lastReadMessageId, 'message-123');
        expect(updatedRead?.lastRead.isAtSameMomentAs(DateTime(2022)), isTrue);
      });

      test(
        'should add a new read state if not exist on message read event',
        () async {
          // Create the current read state
          final currentUser = User(id: 'test-user');

          // Verify initial state
          final read = channel.state?.read;
          expect(read, isEmpty);

          // Create mark read notification event
          final markReadEvent = Event(
            cid: channel.cid,
            type: EventType.messageRead,
            user: currentUser,
            createdAt: DateTime(2022),
            unreadMessages: 0,
            lastReadMessageId: 'message-123',
          );

          // Dispatch event
          client.addEvent(markReadEvent);

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Verify read list has not changed
          final updated = channel.state?.read;
          expect(updated?.length, 1);
          expect(updated?.any((r) => r.user.id == currentUser.id), isTrue);
        },
      );

      test(
        'should not update channel read state on thread message read event',
        () async {
          final currentUser = User(id: 'test-user');
          final currentRead = Read(
            user: currentUser,
            lastRead: DateTime(2020),
            unreadMessages: 10,
            lastReadMessageId: 'channel-msg-1',
          );

          // Setup initial channel read state
          channel.state?.updateChannelState(
            channel.state!.channelState.copyWith(
              read: [currentRead],
            ),
          );

          // Verify initial state
          final read = channel.state?.read.first;
          expect(read?.unreadMessages, 10);
          expect(read?.lastReadMessageId, 'channel-msg-1');
          expect(read?.lastRead.isAtSameMomentAs(DateTime(2020)), isTrue);

          // Create a thread-scoped message.read event (thread != null)
          final threadMessageReadEvent = Event(
            cid: channel.cid,
            type: EventType.messageRead,
            user: currentUser,
            createdAt: DateTime(2022),
            lastReadMessageId: 'thread-reply-99',
            thread: Thread(
              channelCid: channel.cid!,
              parentMessageId: 'parent-msg-1',
              createdByUserId: currentUser.id,
              replyCount: 3,
              participantCount: 2,
            ),
          );

          // Dispatch event
          client.addEvent(threadMessageReadEvent);

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Channel read state must be untouched — thread reads
          // must not clobber the channel-level Read.
          final after = channel.state?.read.first;
          expect(after?.unreadMessages, 10);
          expect(after?.lastReadMessageId, 'channel-msg-1');
          expect(after?.lastRead.isAtSameMomentAs(DateTime(2020)), isTrue);
        },
      );

      test('should update read state on notification mark unread event', () async {
        // Create the current read state
        final currentUser = User(id: 'test-user');
        final currentRead = Read(
          user: currentUser,
          lastRead: DateTime(2020),
          unreadMessages: 10,
        );

        // Setup initial read state
        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            read: [currentRead],
          ),
        );

        // Verify initial state
        final read = channel.state?.read.first;
        expect(read?.user.id, 'test-user');
        expect(read?.unreadMessages, 10);
        expect(read?.lastReadMessageId, isNull);
        expect(read?.lastRead.isAtSameMomentAs(DateTime(2020)), isTrue);

        // Create mark unread notification event
        final markUnreadEvent = Event(
          cid: channel.cid,
          type: EventType.notificationMarkUnread,
          user: currentUser,
          lastReadAt: DateTime(2019),
          unreadMessages: 15,
          lastReadMessageId: 'message-100',
        );

        // Dispatch event
        client.addEvent(markUnreadEvent);

        // Wait for event to be processed
        await Future.delayed(Duration.zero);

        // Verify read state is updated
        final updatedRead = channel.state?.read.first;
        expect(updatedRead?.user.id, 'test-user');
        expect(updatedRead?.unreadMessages, 15);
        expect(updatedRead?.lastReadMessageId, 'message-100');
        expect(updatedRead?.lastRead.isAtSameMomentAs(DateTime(2019)), isTrue);
      });

      test(
        'should add a new read state if not exist on notification mark unread',
        () async {
          // Verify initial state
          final read = channel.state?.read;
          expect(read, isEmpty);

          // Create event for non-existing user
          final markUnreadEvent = Event(
            cid: channel.cid,
            type: EventType.notificationMarkUnread,
            user: User(id: 'non-existing-user'),
            lastReadAt: DateTime(2019),
            unreadMessages: 15,
            lastReadMessageId: 'message-100',
          );

          // Dispatch event
          client.addEvent(markUnreadEvent);

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Verify read list has not changed
          final updated = channel.state?.read;
          expect(updated?.length, 1);
          expect(updated?.any((r) => r.user.id == 'non-existing-user'), isTrue);
        },
      );

      test(
        'should preserve delivery info on message read event',
        () async {
          final currentUser = User(id: 'test-user');
          final currentRead = Read(
            user: currentUser,
            lastRead: DateTime(2020),
            unreadMessages: 10,
            lastDeliveredAt: DateTime(2021),
            lastDeliveredMessageId: 'delivered-msg-456',
          );

          // Setup initial read state with delivery info
          channel.state?.updateChannelState(
            channel.state!.channelState.copyWith(
              read: [currentRead],
            ),
          );

          // Verify initial state
          final read = channel.state?.read.first;
          expect(read?.lastDeliveredAt, isNotNull);
          expect(
            read?.lastDeliveredAt?.isAtSameMomentAs(DateTime(2021)),
            isTrue,
          );
          expect(read?.lastDeliveredMessageId, 'delivered-msg-456');

          // Create message read event (doesn't include delivery info)
          final messageReadEvent = Event(
            cid: channel.cid,
            type: EventType.messageRead,
            user: currentUser,
            createdAt: DateTime(2022),
            unreadMessages: 0,
            lastReadMessageId: 'message-123',
          );

          // Dispatch event
          client.addEvent(messageReadEvent);

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Verify read state is updated but delivery info is preserved
          final updatedRead = channel.state?.read.first;
          expect(updatedRead?.user.id, 'test-user');
          expect(updatedRead?.unreadMessages, 0);
          expect(updatedRead?.lastReadMessageId, 'message-123');
          expect(
            updatedRead?.lastRead.isAtSameMomentAs(DateTime(2022)),
            isTrue,
          );
          // Delivery info should be preserved
          expect(updatedRead?.lastDeliveredAt, isNotNull);
          expect(
            updatedRead?.lastDeliveredAt?.isAtSameMomentAs(DateTime(2021)),
            isTrue,
          );
          expect(updatedRead?.lastDeliveredMessageId, 'delivered-msg-456');
        },
      );

      test(
        'should reconcile delivery when message read event is from current user',
        () async {
          final currentUser = client.state.currentUser;
          final updatedUser = currentUser?.copyWith(id: 'current-user-id');

          client.state.updateUser(updatedUser);
          addTearDown(() => client.state.updateUser(currentUser));

          when(
            () => client.channelDeliveryReporter.reconcileDelivery([channel]),
          ).thenAnswer((_) => Future.value());

          // Create message read event from current user
          final messageReadEvent = Event(
            cid: channel.cid,
            type: EventType.messageRead,
            user: currentUser,
            createdAt: DateTime(2022),
            unreadMessages: 0,
            lastReadMessageId: 'message-123',
          );

          // Dispatch event
          client.addEvent(messageReadEvent);

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Verify reconcileDelivery was called
          verify(
            () => client.channelDeliveryReporter.reconcileDelivery([channel]),
          ).called(1);
        },
      );

      test('should update read state on message delivered event', () async {
        final currentUser = User(id: 'test-user');
        final distantPast = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
        final currentRead = Read(
          user: currentUser,
          lastRead: distantPast,
          unreadMessages: 5,
        );

        // Setup initial read state
        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            read: [currentRead],
          ),
        );

        // Verify initial state has no delivery info
        final read = channel.state?.read.first;
        expect(read?.user.id, 'test-user');
        expect(read?.lastDeliveredAt, isNull);
        expect(read?.lastDeliveredMessageId, isNull);

        // Create message delivered event
        final messageDeliveredEvent = Event(
          cid: channel.cid,
          type: EventType.messageDelivered,
          user: currentUser,
          lastDeliveredAt: DateTime(2022),
          lastDeliveredMessageId: 'message-456',
        );

        // Dispatch event
        client.addEvent(messageDeliveredEvent);

        // Wait for event to be processed
        await Future.delayed(Duration.zero);

        // Verify delivery state is updated
        final updatedRead = channel.state?.read.first;
        expect(updatedRead?.user.id, 'test-user');
        expect(updatedRead?.lastDeliveredAt, isNotNull);
        expect(
          updatedRead?.lastDeliveredAt?.isAtSameMomentAs(DateTime(2022)),
          isTrue,
        );
        expect(updatedRead?.lastDeliveredMessageId, 'message-456');
      });

      test(
        'should add a new read state if not exist on message delivered event',
        () async {
          final newUser = User(id: 'new-user');
          final distantPast = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

          // Verify initial state
          final read = channel.state?.read;
          expect(read, isEmpty);

          // Create message delivered event for new user
          final messageDeliveredEvent = Event(
            cid: channel.cid,
            type: EventType.messageDelivered,
            user: newUser,
            lastDeliveredAt: DateTime(2022),
            lastDeliveredMessageId: 'message-789',
          );

          // Dispatch event
          client.addEvent(messageDeliveredEvent);

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Verify read state was created with delivery info
          final updated = channel.state?.read;
          expect(updated?.length, 1);
          final newRead = updated?.first;
          expect(newRead?.user.id, 'new-user');
          expect(newRead?.lastDeliveredAt, isNotNull);
          expect(
            newRead?.lastDeliveredAt?.isAtSameMomentAs(DateTime(2022)),
            isTrue,
          );
          expect(newRead?.lastDeliveredMessageId, 'message-789');
          // lastRead should default to distantPast
          expect(
            newRead?.lastRead.isAtSameMomentAs(distantPast),
            isTrue,
          );
        },
      );

      test(
        'should preserve read info on message delivered event',
        () async {
          final currentUser = User(id: 'test-user');
          final currentRead = Read(
            user: currentUser,
            lastRead: DateTime(2020),
            unreadMessages: 10,
            lastReadMessageId: 'read-msg-123',
          );

          // Setup initial read state
          channel.state?.updateChannelState(
            channel.state!.channelState.copyWith(
              read: [currentRead],
            ),
          );

          // Verify initial state
          final read = channel.state?.read.first;
          expect(read?.lastRead.isAtSameMomentAs(DateTime(2020)), isTrue);
          expect(read?.unreadMessages, 10);
          expect(read?.lastReadMessageId, 'read-msg-123');

          // Create message delivered event (doesn't include read info)
          final messageDeliveredEvent = Event(
            cid: channel.cid,
            type: EventType.messageDelivered,
            user: currentUser,
            lastDeliveredAt: DateTime(2022),
            lastDeliveredMessageId: 'delivered-msg-456',
          );

          // Dispatch event
          client.addEvent(messageDeliveredEvent);

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Verify delivery state is updated but read info is preserved
          final updatedRead = channel.state?.read.first;
          expect(updatedRead?.user.id, 'test-user');
          expect(
            updatedRead?.lastDeliveredAt?.isAtSameMomentAs(DateTime(2022)),
            isTrue,
          );
          expect(updatedRead?.lastDeliveredMessageId, 'delivered-msg-456');
          // Read info should be preserved
          expect(
            updatedRead?.lastRead.isAtSameMomentAs(DateTime(2020)),
            isTrue,
          );
          expect(updatedRead?.unreadMessages, 10);
          expect(updatedRead?.lastReadMessageId, 'read-msg-123');
        },
      );

      test(
        'should reconcile delivery when message delivered event is from current user',
        () async {
          final currentUser = client.state.currentUser;
          final updatedUser = currentUser?.copyWith(id: 'current-user-id');

          client.state.updateUser(updatedUser);
          addTearDown(() => client.state.updateUser(currentUser));

          when(
            () => client.channelDeliveryReporter.reconcileDelivery([channel]),
          ).thenAnswer((_) => Future.value());

          // Create message delivered event from current user
          final messageDeliveredEvent = Event(
            cid: channel.cid,
            type: EventType.messageDelivered,
            user: currentUser,
            lastDeliveredAt: DateTime(2022),
            lastDeliveredMessageId: 'message-456',
          );

          // Dispatch event
          client.addEvent(messageDeliveredEvent);

          // Wait for event to be processed
          await Future.delayed(Duration.zero);

          // Verify reconcileDelivery was called
          verify(
            () => client.channelDeliveryReporter.reconcileDelivery([channel]),
          ).called(1);
        },
      );
    });

    group('Draft events', () {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      late Channel channel;

      setUp(() {
        final channelState = _generateChannelState(channelId, channelType);
        channel = Channel.fromState(client, channelState);
      });

      tearDown(() {
        channel.dispose();
      });

      test('should handle draft.updated event for channel drafts', () async {
        // Verify initial state
        expect(channel.state?.draft, isNull);

        // Create Draft
        final draft = Draft(
          channelCid: channel.cid!,
          createdAt: DateTime.now(),
          message: DraftMessage(text: 'test message'),
        );

        // Create draft.updated event
        final draftUpdatedEvent = Event(
          cid: channel.cid,
          type: EventType.draftUpdated,
          draft: draft,
        );

        // Dispatch event
        client.addEvent(draftUpdatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Verify channel draft was updated
        expect(channel.state?.draft, isNotNull);
        expect(channel.state?.draft?.message.text, 'test message');
      });

      test('should handle draft.updated event for thread drafts', () async {
        const threadParentMessageId = 'thread-parent-id';

        // Setup initial state with a regular message
        channel.state?.updateMessage(
          Message(
            id: threadParentMessageId,
            user: client.state.currentUser,
          ),
        );

        // Verify initial state
        expect(channel.state?.threadDraft(threadParentMessageId), isNull);

        // Create thread Draft
        final draft = Draft(
          channelCid: channel.cid!,
          createdAt: DateTime.now(),
          parentId: threadParentMessageId,
          message: DraftMessage(text: 'thread reply'),
        );

        // Create draft.updated event
        final draftUpdatedEvent = Event(
          cid: channel.cid,
          type: EventType.draftUpdated,
          draft: draft,
        );

        // Dispatch event
        client.addEvent(draftUpdatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Verify thread draft was updated
        final threadDraft = channel.state?.threadDraft(threadParentMessageId);
        expect(threadDraft, isNotNull);
        expect(threadDraft?.message.text, 'thread reply');
      });

      test('should handle draft.deleted event for channel drafts', () async {
        // Setup initial state with a draft
        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            draft: Draft(
              channelCid: channel.cid!,
              createdAt: DateTime.now(),
              message: DraftMessage(text: 'test message'),
            ),
          ),
        );

        // Verify initial state
        final draft = channel.state?.draft;
        expect(draft, isNotNull);
        expect(draft?.message.text, 'test message');

        // Create draft.deleted event
        final draftUpdatedEvent = Event(
          cid: channel.cid,
          type: EventType.draftDeleted,
          draft: draft,
        );

        // Dispatch event
        client.addEvent(draftUpdatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Verify channel draft was updated
        expect(channel.state?.draft, isNull);
      });

      test('should handle draft.deleted event for thread drafts', () async {
        const threadParentMessageId = 'thread-parent-id';

        // Setup initial state with a thread draft
        channel.state?.updateMessage(
          Message(
            id: threadParentMessageId,
            user: client.state.currentUser,
            draft: Draft(
              channelCid: channel.cid!,
              createdAt: DateTime.now(),
              parentId: threadParentMessageId,
              message: DraftMessage(text: 'thread reply'),
            ),
          ),
        );

        // Verify initial state
        final threadDraft = channel.state?.threadDraft(threadParentMessageId);
        expect(threadDraft, isNotNull);
        expect(threadDraft?.message.text, 'thread reply');

        // Create draft.deleted event
        final draftDeletedEvent = Event(
          cid: channel.cid,
          type: EventType.draftDeleted,
          draft: threadDraft,
        );

        // Dispatch event
        client.addEvent(draftDeletedEvent);

        // Allow event to be processed
        await Future.delayed(Duration.zero);

        // Verify thread draft was removed
        expect(channel.state?.threadDraft(threadParentMessageId), isNull);
      });

      test(
        'should update current channel draft if draft.updated event is emitted',
        () async {
          // Setup initial state with a draft
          final initialDraft = Draft(
            channelCid: channel.cid!,
            createdAt: DateTime.now(),
            message: DraftMessage(text: 'test message'),
          );

          channel.state?.updateChannelState(
            channel.state!.channelState.copyWith(
              draft: initialDraft,
            ),
          );

          // Verify initial state
          expect(channel.state?.draft, isNotNull);
          expect(channel.state?.draft?.message.text, 'test message');

          // Create Draft
          final updatedDraft = initialDraft.copyWith(
            message: DraftMessage(text: 'updated message'),
          );

          // Create draft.updated event
          final draftUpdatedEvent = Event(
            cid: channel.cid,
            type: EventType.draftUpdated,
            draft: updatedDraft,
          );

          // Dispatch event
          client.addEvent(draftUpdatedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify channel draft was updated
          expect(channel.state?.draft, isNotNull);
          expect(channel.state?.draft?.message.text, 'updated message');
        },
      );

      test(
        'should update current thread draft if draft.updated event is emitted',
        () async {
          const threadParentMessageId = 'thread-parent-id';

          // Setup initial state with a thread draft
          final initialDraft = Draft(
            channelCid: channel.cid!,
            createdAt: DateTime.now(),
            parentId: threadParentMessageId,
            message: DraftMessage(text: 'thread reply'),
          );

          channel.state?.updateMessage(
            Message(
              id: threadParentMessageId,
              user: client.state.currentUser,
              draft: initialDraft,
            ),
          );

          // Verify initial state
          final draft = channel.state?.threadDraft(threadParentMessageId);
          expect(draft, isNotNull);
          expect(draft?.message.text, 'thread reply');

          // Create Draft
          final updatedDraft = initialDraft.copyWith(
            message: DraftMessage(text: 'updated thread reply'),
          );

          // Create draft.updated event
          final draftUpdatedEvent = Event(
            cid: channel.cid,
            type: EventType.draftUpdated,
            draft: updatedDraft,
          );

          // Dispatch event
          client.addEvent(draftUpdatedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify thread draft was updated
          final threadDraft = channel.state?.threadDraft(threadParentMessageId);
          expect(threadDraft, isNotNull);
          expect(threadDraft?.message.text, 'updated thread reply');
        },
      );
    });

    group('Reminder events', () {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      late Channel channel;

      setUp(() {
        final channelState = _generateChannelState(channelId, channelType);
        channel = Channel.fromState(client, channelState);
      });

      tearDown(() {
        channel.dispose();
      });

      test('should handle reminder.created event', () async {
        const messageId = 'test-message-id';

        // Setup initial state with a message without reminder
        final message = Message(
          id: messageId,
          user: client.state.currentUser,
          text: 'Test message',
        );

        channel.state?.updateMessage(message);

        // Verify initial state - no reminder
        final initialMessage = channel.state?.messages.firstWhere(
          (m) => m.id == messageId,
        );
        expect(initialMessage?.reminder, isNull);

        // Create reminder
        final reminder = MessageReminder(
          messageId: messageId,
          channelCid: channel.cid!,
          userId: 'test-user-id',
          remindAt: DateTime.now().add(const Duration(days: 30)),
        );

        // Create reminder.created event
        final reminderCreatedEvent = Event(
          cid: channel.cid,
          type: EventType.reminderCreated,
          reminder: reminder,
        );

        // Dispatch event
        client.addEvent(reminderCreatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Verify message reminder was added
        final updatedMessage = channel.state?.messages.firstWhere(
          (m) => m.id == messageId,
        );
        expect(updatedMessage?.reminder, isNotNull);
        expect(updatedMessage?.reminder?.messageId, messageId);
        expect(updatedMessage?.reminder?.remindAt, reminder.remindAt);
      });

      test('should handle reminder.updated event', () async {
        const messageId = 'test-message-id';

        // Setup initial state with a message with existing reminder
        final remindAt = DateTime.now().add(const Duration(days: 30));
        final initialReminder = MessageReminder(
          messageId: messageId,
          channelCid: channel.cid!,
          userId: 'test-user-id',
          remindAt: remindAt,
        );

        final message = Message(
          id: messageId,
          user: client.state.currentUser,
          text: 'Test message',
          reminder: initialReminder,
        );

        channel.state?.updateMessage(message);

        // Verify initial state
        final initialMessage = channel.state?.messages.firstWhere(
          (m) => m.id == messageId,
        );
        expect(initialMessage?.reminder, isNotNull);
        expect(initialMessage?.reminder?.remindAt, remindAt);

        // Create updated reminder
        final updatedRemindAt = remindAt.add(const Duration(days: 15));
        final updatedReminder = initialReminder.copyWith(
          remindAt: updatedRemindAt,
          updatedAt: DateTime.now(),
        );

        // Create reminder.updated event
        final reminderUpdatedEvent = Event(
          cid: channel.cid,
          type: EventType.reminderUpdated,
          reminder: updatedReminder,
        );

        // Dispatch event
        client.addEvent(reminderUpdatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Verify message reminder was updated
        final updatedMessage = channel.state?.messages.firstWhere(
          (m) => m.id == messageId,
        );
        expect(updatedMessage?.reminder, isNotNull);
        expect(updatedMessage?.reminder?.messageId, messageId);
        expect(updatedMessage?.reminder?.remindAt, updatedRemindAt);
      });

      test('should handle reminder.deleted event', () async {
        const messageId = 'test-message-id';

        // Setup initial state with a message with existing reminder
        final remindAt = DateTime.now().add(const Duration(days: 30));
        final initialReminder = MessageReminder(
          messageId: messageId,
          channelCid: channel.cid!,
          userId: 'test-user-id',
          remindAt: remindAt,
        );

        final message = Message(
          id: messageId,
          user: client.state.currentUser,
          text: 'Test message',
          reminder: initialReminder,
        );

        channel.state?.updateMessage(message);

        // Verify initial state
        final initialMessage = channel.state?.messages.firstWhere(
          (m) => m.id == messageId,
        );
        expect(initialMessage?.reminder, isNotNull);

        // Create reminder.deleted event
        final reminderDeletedEvent = Event(
          cid: channel.cid,
          type: EventType.reminderDeleted,
          reminder: initialReminder,
        );

        // Dispatch event
        client.addEvent(reminderDeletedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Verify message reminder was removed
        final updatedMessage = channel.state?.messages.firstWhere(
          (m) => m.id == messageId,
        );
        expect(updatedMessage?.reminder, isNull);
      });

      test('should handle reminder.created event for thread messages', () async {
        const messageId = 'test-message-id';
        const parentId = 'test-parent-id';

        // Setup initial state with a thread message without reminder
        final threadMessage = Message(
          id: messageId,
          parentId: parentId,
          user: client.state.currentUser,
          text: 'Thread message',
          // `Message.createdAt` falls back to `DateTime.now()` per call when
          // not provided, which breaks merge/sort keyed on createdAt.
          createdAt: DateTime.now(),
        );

        channel.state?.updateMessage(threadMessage);

        // Verify initial state - no reminder
        final initialMessage = channel.state?.threads[parentId]?.firstWhere(
          (m) => m.id == messageId,
        );
        expect(initialMessage?.reminder, isNull);

        // Create reminder
        final remindAt = DateTime.now().add(const Duration(days: 30));
        final reminder = MessageReminder(
          messageId: messageId,
          channelCid: channel.cid!,
          userId: 'test-user-id',
          remindAt: remindAt,
        );

        // Create reminder.created event
        final reminderCreatedEvent = Event(
          cid: channel.cid,
          type: EventType.reminderCreated,
          reminder: reminder,
        );

        // Dispatch event
        client.addEvent(reminderCreatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Verify thread message reminder was added
        final updatedMessage = channel.state?.threads[parentId]?.firstWhere(
          (m) => m.id == messageId,
        );
        expect(updatedMessage?.reminder, isNotNull);
        expect(updatedMessage?.reminder?.messageId, messageId);
        expect(updatedMessage?.reminder?.remindAt, reminder.remindAt);
      });

      test('should handle reminder.updated event for thread messages', () async {
        const messageId = 'test-message-id';
        const parentId = 'test-parent-id';

        // Setup initial state with a thread message with existing reminder
        final remindAt = DateTime.now().add(const Duration(days: 30));
        final initialReminder = MessageReminder(
          messageId: messageId,
          channelCid: channel.cid!,
          userId: 'test-user-id',
          remindAt: remindAt,
        );

        final threadMessage = Message(
          id: messageId,
          parentId: parentId,
          user: client.state.currentUser,
          text: 'Thread message',
          reminder: initialReminder,
          // `Message.createdAt` falls back to `DateTime.now()` per call when
          // not provided, which breaks merge/sort keyed on createdAt.
          createdAt: DateTime.now(),
        );

        channel.state?.updateMessage(threadMessage);

        // Verify initial state
        final initialMessage = channel.state?.threads[parentId]?.firstWhere(
          (m) => m.id == messageId,
        );
        expect(initialMessage?.reminder, isNotNull);
        expect(initialMessage?.reminder?.remindAt, remindAt);

        // Create updated reminder
        final updatedRemindAt = remindAt.add(const Duration(days: 15));
        final updatedReminder = initialReminder.copyWith(
          remindAt: updatedRemindAt,
          updatedAt: DateTime.now(),
        );

        // Create reminder.updated event
        final reminderUpdatedEvent = Event(
          cid: channel.cid,
          type: EventType.reminderUpdated,
          reminder: updatedReminder,
        );

        // Dispatch event
        client.addEvent(reminderUpdatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Verify thread message reminder was updated
        final updatedMessage = channel.state?.threads[parentId]?.firstWhere(
          (m) => m.id == messageId,
        );
        expect(updatedMessage?.reminder, isNotNull);
        expect(updatedMessage?.reminder?.messageId, messageId);
        expect(updatedMessage?.reminder?.remindAt, updatedRemindAt);
      });

      test('should handle reminder.deleted event for thread messages', () async {
        const messageId = 'test-message-id';
        const parentId = 'test-parent-id';

        // Setup initial state with a thread message with existing reminder
        final remindAt = DateTime.now().add(const Duration(days: 30));
        final initialReminder = MessageReminder(
          messageId: messageId,
          channelCid: channel.cid!,
          userId: 'test-user-id',
          remindAt: remindAt,
        );

        final threadMessage = Message(
          id: messageId,
          parentId: parentId,
          user: client.state.currentUser,
          text: 'Thread message',
          reminder: initialReminder,
          // Explicit `createdAt` so `Message.createdAt` is deterministic
          // across reads — without one it falls back to `DateTime.now()`
          // on every call, which breaks any sort/merge keyed on createdAt.
          createdAt: DateTime.now(),
        );

        channel.state?.updateMessage(threadMessage);

        // Verify initial state
        final initialMessage = channel.state?.threads[parentId]?.firstWhere(
          (m) => m.id == messageId,
        );
        expect(initialMessage?.reminder, isNotNull);

        // Create reminder.deleted event
        final reminderDeletedEvent = Event(
          cid: channel.cid,
          type: EventType.reminderDeleted,
          reminder: initialReminder,
        );

        // Dispatch event
        client.addEvent(reminderDeletedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Verify thread message reminder was removed
        final updatedMessage = channel.state?.threads[parentId]?.firstWhere(
          (m) => m.id == messageId,
        );
        expect(updatedMessage?.reminder, isNull);
      });
    });

    group('Location events', () {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      late Channel channel;

      setUp(() {
        final channelState = _generateChannelState(channelId, channelType);
        channel = Channel.fromState(client, channelState);
      });

      tearDown(() {
        channel.dispose();
      });

      test('should handle location.shared event', () async {
        // Verify initial state
        expect(channel.state?.activeLiveLocations, isEmpty);

        // Create live location
        final liveLocation = Location(
          channelCid: channel.cid,
          userId: 'user1',
          messageId: 'msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.now().add(const Duration(hours: 1)),
        );

        final locationMessage = Message(
          id: 'msg1',
          text: 'Live location shared',
          sharedLocation: liveLocation,
        );

        // Create location.shared event
        final locationSharedEvent = Event(
          cid: channel.cid,
          type: EventType.locationShared,
          message: locationMessage,
        );

        // Dispatch event
        client.addEvent(locationSharedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Check if message was added
        final messages = channel.state?.messages;
        final message = messages?.firstWhere((m) => m.id == 'msg1');
        expect(message, isNotNull);

        // Check if active live location was updated
        final activeLiveLocations = channel.state?.activeLiveLocations;
        expect(activeLiveLocations, hasLength(1));
        expect(activeLiveLocations?.first.messageId, equals('msg1'));
      });

      test('should handle location.updated event', () async {
        // Setup initial state with location message
        final liveLocation = Location(
          channelCid: channel.cid,
          userId: 'user1',
          messageId: 'msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.now().add(const Duration(hours: 1)),
        );

        final locationMessage = Message(
          id: 'msg1',
          text: 'Live location shared',
          sharedLocation: liveLocation,
        );

        // Add initial message
        channel.state?.addNewMessage(locationMessage);

        // Create updated location
        final updatedLocation = liveLocation.copyWith(
          latitude: 40.7500, // Updated latitude
          longitude: -74.1000, // Updated longitude
        );

        final updatedMessage = locationMessage.copyWith(
          sharedLocation: updatedLocation,
        );

        // Create location.updated event
        final locationUpdatedEvent = Event(
          cid: channel.cid,
          type: EventType.locationUpdated,
          message: updatedMessage,
        );

        // Dispatch event
        client.addEvent(locationUpdatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Check if message was updated
        final messages = channel.state?.messages;
        final message = messages?.firstWhere((m) => m.id == 'msg1');
        expect(message?.sharedLocation?.latitude, equals(40.7500));
        expect(message?.sharedLocation?.longitude, equals(-74.1000));

        // Check if active live location was updated
        final activeLiveLocations = channel.state?.activeLiveLocations;
        expect(activeLiveLocations, hasLength(1));
        expect(activeLiveLocations?.first.latitude, equals(40.7500));
        expect(activeLiveLocations?.first.longitude, equals(-74.1000));
      });

      test('should handle location.expired event', () async {
        // Setup initial state with location message
        final liveLocation = Location(
          channelCid: channel.cid,
          userId: 'user1',
          messageId: 'msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.now().add(const Duration(hours: 1)),
        );

        final locationMessage = Message(
          id: 'msg1',
          text: 'Live location shared',
          sharedLocation: liveLocation,
        );

        // Add initial message
        channel.state?.addNewMessage(locationMessage);
        expect(channel.state?.activeLiveLocations, hasLength(1));

        // Create expired location
        final expiredLocation = liveLocation.copyWith(
          endAt: DateTime.now().subtract(const Duration(hours: 1)),
        );

        final expiredMessage = locationMessage.copyWith(
          sharedLocation: expiredLocation,
        );

        // Create location.expired event
        final locationExpiredEvent = Event(
          cid: channel.cid,
          type: EventType.locationExpired,
          message: expiredMessage,
        );

        // Dispatch event
        client.addEvent(locationExpiredEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Check if message was updated
        final messages = channel.state?.messages;
        final message = messages?.firstWhere((m) => m.id == 'msg1');
        expect(message?.sharedLocation?.isExpired, isTrue);

        // Check if active live location was removed
        expect(channel.state?.activeLiveLocations, isEmpty);
      });

      test('should not add static location to active locations', () async {
        final staticLocation = Location(
          channelCid: channel.cid,
          userId: 'user1',
          messageId: 'msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          // No endAt - static location
        );

        final staticMessage = Message(
          id: 'msg1',
          text: 'Static location shared',
          sharedLocation: staticLocation,
        );

        // Create location.shared event
        final locationSharedEvent = Event(
          cid: channel.cid,
          type: EventType.locationShared,
          message: staticMessage,
        );

        // Dispatch event
        client.addEvent(locationSharedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Check if message was added
        final messages = channel.state?.messages;
        final message = messages?.firstWhere((m) => m.id == 'msg1');
        expect(message?.sharedLocation, isNotNull);

        // Check if active live location was NOT updated (should remain empty)
        expect(channel.state?.activeLiveLocations, isEmpty);
      });

      test(
        'should update active locations when location message is deleted',
        () async {
          final liveLocation = Location(
            channelCid: channel.cid,
            userId: 'user1',
            messageId: 'msg1',
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device1',
            endAt: DateTime.now().add(const Duration(hours: 1)),
          );

          final locationMessage = Message(
            id: 'msg1',
            text: 'Live location shared',
            sharedLocation: liveLocation,
          );

          // Verify initial state
          channel.state?.addNewMessage(locationMessage);
          expect(channel.state?.activeLiveLocations, hasLength(1));

          final messageDeletedEvent = Event(
            type: EventType.messageDeleted,
            cid: channel.cid,
            message: locationMessage.copyWith(
              type: MessageType.deleted,
              deletedAt: DateTime.timestamp(),
            ),
          );

          // Dispatch event
          client.addEvent(messageDeletedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify active locations are updated
          expect(channel.state?.activeLiveLocations, isEmpty);
        },
      );

      test('should merge locations with same key', () async {
        final liveLocation = Location(
          channelCid: channel.cid,
          userId: 'user1',
          messageId: 'msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.now().add(const Duration(hours: 1)),
        );

        final locationMessage = Message(
          id: 'msg1',
          text: 'Live location shared',
          sharedLocation: liveLocation,
        );

        // Add initial location for setup
        channel.state?.addNewMessage(locationMessage);
        expect(channel.state?.activeLiveLocations, hasLength(1));

        // Create new location with same user, channel, and device
        final newLocation = Location(
          channelCid: channel.cid,
          userId: 'user1', // Same user
          messageId: 'msg2', // Different message
          latitude: 40.7500,
          longitude: -74.1000,
          createdByDeviceId: 'device1', // Same device
          endAt: DateTime.now().add(const Duration(hours: 2)),
        );

        final newMessage = Message(
          id: 'msg2',
          text: 'Updated location',
          sharedLocation: newLocation,
        );

        // Create location.shared event for the new message
        final locationSharedEvent = Event(
          cid: channel.cid,
          type: EventType.locationShared,
          message: newMessage,
        );

        // Dispatch event
        client.addEvent(locationSharedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Should still have only one active location (merged)
        final activeLiveLocations = channel.state?.activeLiveLocations;
        expect(activeLiveLocations, hasLength(1));
        expect(activeLiveLocations?.first.messageId, equals('msg2'));
        expect(activeLiveLocations?.first.latitude, equals(40.7500));
      });

      test(
        'should handle multiple active locations from different devices',
        () async {
          final liveLocation = Location(
            channelCid: channel.cid,
            userId: 'user1',
            messageId: 'msg1',
            latitude: 40.7128,
            longitude: -74.0060,
            createdByDeviceId: 'device1',
            endAt: DateTime.now().add(const Duration(hours: 1)),
          );

          final locationMessage = Message(
            id: 'msg1',
            text: 'Live location shared',
            sharedLocation: liveLocation,
          );

          // Add first location for setup
          channel.state?.addNewMessage(locationMessage);
          expect(channel.state?.activeLiveLocations, hasLength(1));

          // Create location from different device
          final location2 = Location(
            channelCid: channel.cid,
            userId: 'user1', // Same user
            messageId: 'msg2',
            latitude: 34.0522,
            longitude: -118.2437,
            createdByDeviceId: 'device2', // Different device
            endAt: DateTime.now().add(const Duration(hours: 1)),
          );

          final message2 = Message(
            id: 'msg2',
            text: 'Location from device 2',
            sharedLocation: location2,
          );

          // Create location.shared event for the second message
          final locationSharedEvent = Event(
            cid: channel.cid,
            type: EventType.locationShared,
            message: message2,
          );

          // Dispatch event
          client.addEvent(locationSharedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Should have two active locations
          expect(channel.state?.activeLiveLocations, hasLength(2));
        },
      );

      test('should handle location messages in threads', () async {
        final parentMessage = Message(
          id: 'parent1',
          text: 'Thread parent',
        );

        // Add parent message first for setup
        channel.state?.addNewMessage(parentMessage);

        final liveLocation = Location(
          channelCid: channel.cid,
          userId: 'user1',
          messageId: 'thread-msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.now().add(const Duration(hours: 1)),
        );

        final threadLocationMessage = Message(
          id: 'thread-msg1',
          text: 'Live location in thread',
          parentId: 'parent1',
          sharedLocation: liveLocation,
        );

        // Create location.shared event for the thread message
        final locationSharedEvent = Event(
          cid: channel.cid,
          type: EventType.locationShared,
          message: threadLocationMessage,
        );

        // Dispatch event
        client.addEvent(locationSharedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Check if thread message was added
        final thread = channel.state?.threads['parent1'];
        expect(thread, contains(threadLocationMessage));

        // Check if location was added to active locations
        final activeLiveLocations = channel.state?.activeLiveLocations;
        expect(activeLiveLocations, hasLength(1));
        expect(activeLiveLocations?.first.messageId, equals('thread-msg1'));
      });

      test('should update thread location messages', () async {
        final parentMessage = Message(
          id: 'parent1',
          text: 'Thread parent',
        );

        final liveLocation = Location(
          channelCid: channel.cid,
          userId: 'user1',
          messageId: 'thread-msg1',
          latitude: 40.7128,
          longitude: -74.0060,
          createdByDeviceId: 'device1',
          endAt: DateTime.now().add(const Duration(hours: 1)),
        );

        final threadLocationMessage = Message(
          id: 'thread-msg1',
          text: 'Live location in thread',
          parentId: 'parent1',
          sharedLocation: liveLocation,
        );

        // Add messages
        channel.state?.addNewMessage(parentMessage);
        channel.state?.addNewMessage(threadLocationMessage);

        // Update the location
        final updatedLocation = liveLocation.copyWith(
          latitude: 40.7500,
          longitude: -74.1000,
        );

        final updatedThreadMessage = threadLocationMessage.copyWith(
          sharedLocation: updatedLocation,
        );

        // Create location.updated event for the thread message
        final locationUpdatedEvent = Event(
          cid: channel.cid,
          type: EventType.locationUpdated,
          message: updatedThreadMessage,
        );

        // Dispatch event
        client.addEvent(locationUpdatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Check if thread message was updated
        final thread = channel.state?.threads['parent1'];
        final threadMessage = thread?.firstWhere((m) => m.id == 'thread-msg1');
        expect(threadMessage?.sharedLocation?.latitude, equals(40.7500));
        expect(threadMessage?.sharedLocation?.longitude, equals(-74.1000));

        // Check if active location was updated
        final activeLiveLocations = channel.state?.activeLiveLocations;
        expect(activeLiveLocations, hasLength(1));
        expect(activeLiveLocations?.first.latitude, equals(40.7500));
        expect(activeLiveLocations?.first.longitude, equals(-74.1000));
      });
    });

    group('Channel push preference events', () {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      late Channel channel;

      setUp(() {
        final channelState = _generateChannelState(channelId, channelType);
        channel = Channel.fromState(client, channelState);
      });

      tearDown(() {
        channel.dispose();
      });

      test('should handle channel.push_preference.updated event', () async {
        // Verify initial state
        expect(channel.state?.channelState.pushPreferences, isNull);

        // Create channel push preference
        final channelPushPreference = ChannelPushPreference(
          chatLevel: ChatLevel.mentions,
          disabledUntil: DateTime.now().add(const Duration(hours: 1)),
        );

        // Create channel.push_preference.updated event
        final channelPushPreferenceUpdatedEvent = Event(
          cid: channel.cid,
          type: EventType.channelPushPreferenceUpdated,
          channelPushPreference: channelPushPreference,
        );

        // Dispatch event
        client.addEvent(channelPushPreferenceUpdatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Verify channel push preferences were updated
        final updatedPreferences = channel.state?.channelState.pushPreferences;
        expect(updatedPreferences, isNotNull);
        expect(updatedPreferences?.chatLevel, ChatLevel.mentions);
        expect(
          updatedPreferences?.disabledUntil,
          channelPushPreference.disabledUntil,
        );
      });

      test('should update existing channel push preferences', () async {
        // Set initial push preferences
        const initialPushPreference = ChannelPushPreference(
          chatLevel: ChatLevel.all,
        );

        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            pushPreferences: initialPushPreference,
          ),
        );

        // Verify initial state
        final pushPreferences = channel.state?.channelState.pushPreferences;
        expect(pushPreferences?.chatLevel, ChatLevel.all);
        expect(pushPreferences?.disabledUntil, isNull);

        // Create updated channel push preference
        final updatedPushPreference = ChannelPushPreference(
          chatLevel: ChatLevel.none,
          disabledUntil: DateTime.now().add(const Duration(hours: 2)),
        );

        // Create channel.push_preference.updated event
        final channelPushPreferenceUpdatedEvent = Event(
          cid: channel.cid,
          type: EventType.channelPushPreferenceUpdated,
          channelPushPreference: updatedPushPreference,
        );

        // Dispatch event
        client.addEvent(channelPushPreferenceUpdatedEvent);

        // Wait for the event to be processed
        await Future.delayed(Duration.zero);

        // Verify channel push preferences were updated
        final updatedPreferences = channel.state?.channelState.pushPreferences;
        expect(updatedPreferences?.chatLevel, ChatLevel.none);
        expect(
          updatedPreferences?.disabledUntil,
          updatedPushPreference.disabledUntil,
        );
      });
    });

    group('User messages deleted event', () {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      late Channel channel;
      late MockPersistenceClient persistenceClient;

      setUp(() {
        persistenceClient = MockPersistenceClient();
        when(() => client.chatPersistenceClient).thenReturn(persistenceClient);
        when(
          () => persistenceClient.deleteMessagesFromUser(
            cid: any(named: 'cid'),
            userId: any(named: 'userId'),
            hardDelete: any(named: 'hardDelete'),
            deletedAt: any(named: 'deletedAt'),
          ),
        ).thenAnswer((_) async {});
        when(() => persistenceClient.deleteMessageByIds(any())).thenAnswer((_) async {});
        when(() => persistenceClient.deletePinnedMessageByIds(any())).thenAnswer((_) async {});
        when(() => persistenceClient.getChannelThreads(any())).thenAnswer((_) async => <String, List<Message>>{});

        final channelState = _generateChannelState(channelId, channelType);
        channel = Channel.fromState(client, channelState);
      });

      tearDown(() {
        channel.dispose();
      });

      test(
        'should soft delete all messages from user when hardDelete is false',
        () async {
          // Setup: Add messages from different users
          final user1 = User(id: 'user-1', name: 'User 1');
          final user2 = User(id: 'user-2', name: 'User 2');

          final message1 = Message(
            id: 'msg-1',
            text: 'Message from user 1',
            user: user1,
          );
          final message2 = Message(
            id: 'msg-2',
            text: 'Another message from user 1',
            user: user1,
          );
          final message3 = Message(
            id: 'msg-3',
            text: 'Message from user 2',
            user: user2,
          );

          channel.state?.addNewMessage(message1);
          channel.state?.addNewMessage(message2);
          channel.state?.addNewMessage(message3);

          // Verify initial state
          expect(channel.state?.messages.length, equals(3));
          expect(
            channel.state?.messages.where((m) => m.user?.id == 'user-1').length,
            equals(2),
          );
          expect(
            channel.state?.messages.where((m) => m.user?.id == 'user-2').length,
            equals(1),
          );

          // Create user.messages.deleted event (soft delete)
          final deletedAt = DateTime.now();
          final userMessagesDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.userMessagesDeleted,
            user: user1,
            hardDelete: false,
            createdAt: deletedAt,
          );

          // Dispatch event
          client.addEvent(userMessagesDeletedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify user1's messages are soft deleted
          expect(channel.state?.messages.length, equals(3));
          final deletedMessages = channel.state?.messages.where((m) => m.user?.id == 'user-1').toList();
          expect(deletedMessages?.length, equals(2));
          for (final message in deletedMessages!) {
            expect(message.type, equals(MessageType.deleted));
            expect(message.deletedAt, isNotNull);
            expect(message.state.isDeleted, isTrue);
          }

          // Verify user2's message is unaffected
          final user2Message = channel.state?.messages.firstWhere((m) => m.id == 'msg-3');
          expect(user2Message?.type, isNot(MessageType.deleted));
          expect(user2Message?.deletedAt, isNull);
        },
      );

      test(
        'should hard delete all messages from user when hardDelete is true',
        () async {
          // Setup: Add messages from different users
          final user1 = User(id: 'user-1', name: 'User 1');
          final user2 = User(id: 'user-2', name: 'User 2');

          final message1 = Message(
            id: 'msg-1',
            text: 'Message from user 1',
            user: user1,
          );
          final message2 = Message(
            id: 'msg-2',
            text: 'Another message from user 1',
            user: user1,
          );
          final message3 = Message(
            id: 'msg-3',
            text: 'Message from user 2',
            user: user2,
          );

          channel.state?.addNewMessage(message1);
          channel.state?.addNewMessage(message2);
          channel.state?.addNewMessage(message3);

          // Verify initial state
          expect(channel.state?.messages.length, equals(3));

          // Create user.messages.deleted event (hard delete)
          final userMessagesDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.userMessagesDeleted,
            user: user1,
            hardDelete: true,
          );

          // Dispatch event
          client.addEvent(userMessagesDeletedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify user1's messages are removed
          expect(channel.state?.messages.length, equals(1));
          expect(
            channel.state?.messages.any((m) => m.user?.id == 'user-1'),
            isFalse,
          );

          // Verify user2's message still exists
          final user2Message = channel.state?.messages.firstWhere((m) => m.id == 'msg-3');
          expect(user2Message, isNotNull);
          expect(user2Message?.user?.id, equals('user-2'));
        },
      );

      test(
        'should handle thread messages from user',
        () async {
          // Setup: Add parent and thread messages
          final user1 = User(id: 'user-1', name: 'User 1');
          final user2 = User(id: 'user-2', name: 'User 2');

          final parentMessage = Message(
            id: 'parent-msg',
            text: 'Parent message',
            user: user2,
          );
          final threadMessage1 = Message(
            id: 'thread-msg-1',
            text: 'Thread message from user 1',
            user: user1,
            parentId: 'parent-msg',
          );
          final threadMessage2 = Message(
            id: 'thread-msg-2',
            text: 'Another thread message from user 1',
            user: user1,
            parentId: 'parent-msg',
          );

          channel.state?.addNewMessage(parentMessage);
          channel.state?.addNewMessage(threadMessage1);
          channel.state?.addNewMessage(threadMessage2);

          // Verify initial state
          expect(channel.state?.messages.length, equals(1));
          expect(channel.state?.threads['parent-msg']?.length, equals(2));

          // Create user.messages.deleted event (soft delete)
          final userMessagesDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.userMessagesDeleted,
            user: user1,
            hardDelete: false,
          );

          // Dispatch event
          client.addEvent(userMessagesDeletedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify thread messages are soft deleted
          final threadMessages = channel.state?.threads['parent-msg'];
          expect(threadMessages?.length, equals(2));
          for (final message in threadMessages!) {
            expect(message.type, equals(MessageType.deleted));
            expect(message.state.isDeleted, isTrue);
          }

          // Verify parent message is unaffected
          final parent = channel.state?.messages.first;
          expect(parent?.type, isNot(MessageType.deleted));
        },
      );

      test(
        'should do nothing when user is null',
        () async {
          // Setup: Add messages
          final user1 = User(id: 'user-1', name: 'User 1');
          final message1 = Message(
            id: 'msg-1',
            text: 'Message from user 1',
            user: user1,
          );

          channel.state?.addNewMessage(message1);

          // Verify initial state
          expect(channel.state?.messages.length, equals(1));

          // Create user.messages.deleted event without user
          final userMessagesDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.userMessagesDeleted,
            hardDelete: false,
          );

          // Dispatch event
          client.addEvent(userMessagesDeletedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify messages are unaffected
          expect(channel.state?.messages.length, equals(1));
          expect(
            channel.state?.messages.first.type,
            isNot(MessageType.deleted),
          );
        },
      );

      test(
        'should handle empty message list',
        () async {
          // Setup: Empty channel
          expect(channel.state?.messages.length, equals(0));

          // Create user.messages.deleted event
          final userMessagesDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.userMessagesDeleted,
            user: User(id: 'user-1'),
            hardDelete: false,
          );

          // Dispatch event - should not throw
          client.addEvent(userMessagesDeletedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify state is still empty
          expect(channel.state?.messages.length, equals(0));
        },
      );

      test(
        'should delete messages from persistence when hardDelete is true',
        () async {
          // Setup: Add messages from different users
          final user1 = User(id: 'user-1', name: 'User 1');
          final user2 = User(id: 'user-2', name: 'User 2');

          final message1 = Message(
            id: 'msg-1',
            text: 'Message from user 1',
            user: user1,
          );
          final message2 = Message(
            id: 'msg-2',
            text: 'Another message from user 1',
            user: user1,
          );
          final message3 = Message(
            id: 'msg-3',
            text: 'Message from user 2',
            user: user2,
          );

          channel.state?.addNewMessage(message1);
          channel.state?.addNewMessage(message2);
          channel.state?.addNewMessage(message3);

          // Verify initial state
          expect(channel.state?.messages.length, equals(3));

          // Create user.messages.deleted event (hard delete)
          final userMessagesDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.userMessagesDeleted,
            user: user1,
            hardDelete: true,
          );

          // Dispatch event
          client.addEvent(userMessagesDeletedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify messages are removed from persistence
          verify(
            () => persistenceClient.deleteMessageByIds(['msg-1', 'msg-2']),
          ).called(1);
          verify(
            () => persistenceClient.deletePinnedMessageByIds(['msg-1', 'msg-2']),
          ).called(1);

          // Verify user1's messages are removed from state
          expect(channel.state?.messages.length, equals(1));
          expect(
            channel.state?.messages.any((m) => m.user?.id == 'user-1'),
            isFalse,
          );
        },
      );

      test(
        'should not delete from persistence when hardDelete is false',
        () async {
          // Setup: Add messages
          final user1 = User(id: 'user-1', name: 'User 1');
          final message1 = Message(
            id: 'msg-1',
            text: 'Message from user 1',
            user: user1,
          );

          channel.state?.addNewMessage(message1);

          // Create user.messages.deleted event (soft delete)
          final userMessagesDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.userMessagesDeleted,
            user: user1,
            hardDelete: false,
          );

          // Dispatch event
          client.addEvent(userMessagesDeletedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify persistence deletion methods were NOT called
          verifyNever(() => persistenceClient.deleteMessageByIds(any()));
          verifyNever(() => persistenceClient.deletePinnedMessageByIds(any()));

          // Verify message is soft deleted (still in state)
          expect(channel.state?.messages.length, equals(1));
          expect(channel.state?.messages.first.type, equals(MessageType.deleted));
        },
      );

      test(
        'should delete all user messages including those only in storage',
        () async {
          final user1 = User(id: 'user-1', name: 'User 1');
          final user2 = User(id: 'user-2', name: 'User 2');

          final stateMessage1 = Message(
            id: 'msg-1',
            text: 'Message from user 1 in state',
            user: user1,
            pinned: true,
          );
          final stateMessage2 = Message(
            id: 'msg-2',
            text: 'Message from user 2 in state',
            user: user2,
          );
          final stateThreadMessage1 = Message(
            id: 'thread-msg-1',
            text: 'Thread message from user 1 in state',
            user: user1,
            parentId: 'msg-1',
          );
          final stateThreadMessage2 = Message(
            id: 'thread-msg-2',
            text: 'Another thread message from user 2 in state',
            user: user2,
            parentId: 'msg-1',
          );

          // Load the state with only 2 messages and 1 thread with 2 replies.
          // Note: In reality, storage may contain many more user1 messages
          // (e.g., older messages not loaded into state yet), but the delete
          // operation should remove ALL of them from storage.
          channel.state?.addNewMessage(stateMessage1);
          channel.state?.addNewMessage(stateMessage2);
          channel.state?.addNewMessage(stateThreadMessage1);
          channel.state?.addNewMessage(stateThreadMessage2);

          // Verify initial state has only 2 messages and 1 thread with 2 replies
          expect(channel.state?.messages.length, equals(2));
          expect(channel.state?.threads['msg-1']?.length, equals(2));

          // Create user.messages.deleted event (hard delete)
          final userMessagesDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.userMessagesDeleted,
            user: user1,
            hardDelete: true,
          );

          // Dispatch event
          client.addEvent(userMessagesDeletedEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify user1's messages are removed from state
          expect(channel.state?.messages.length, equals(1));
          expect(channel.state?.threads['msg-1']?.length, equals(1));

          expect(
            channel.state?.messages.any((m) => m.user?.id == 'user-1'),
            isFalse,
          );

          expect(
            channel.state?.threads['msg-1']?.any((m) => m.user?.id == 'user-1'),
            isFalse,
          );

          // Verify persistence delete was called - this handles ALL messages
          // in storage (both those in state AND those only in storage)
          verify(
            () => persistenceClient.deleteMessagesFromUser(
              cid: channel.cid,
              userId: user1.id,
              hardDelete: true,
              deletedAt: any(named: 'deletedAt'),
            ),
          ).called(1);

          // Verify in-state messages were also removed from state's persistence
          final capturedIds =
              verify(
                    () => persistenceClient.deleteMessageByIds(captureAny()),
                  ).captured.first
                  as List<String>;

          expect(
            capturedIds,
            containsAll([
              'msg-1', // state message
              'thread-msg-1', // state thread message
            ]),
          );
        },
      );

      test(
        'should delete every authored message across threads without '
        'cross-thread leakage (regression: _updateThreadMessages)',
        () async {
          // user-1 authors a top-level message AND replies in two different
          // threads (owned by user-2). The user.messages.deleted flow
          // collects everything from user-1 across channel + threads and
          // routes it through a single _updateMessages batch — historically
          // this batch was passed unfiltered to every affected thread's
          // merge, so replies to thread A leaked into thread B and v.v.
          final user1 = User(id: 'user-1', name: 'User 1');
          final user2 = User(id: 'user-2', name: 'User 2');

          final parentA = Message(id: 'parent-A', text: 'Thread A', user: user2);
          final parentB = Message(id: 'parent-B', text: 'Thread B', user: user2);

          final topLevelFromUser1 = Message(
            id: 'top-1',
            text: 'user-1 top-level message',
            user: user1,
          );
          final replyA = Message(
            id: 'reply-A',
            text: 'user-1 reply in thread A',
            user: user1,
            parentId: 'parent-A',
          );
          final replyB = Message(
            id: 'reply-B',
            text: 'user-1 reply in thread B',
            user: user1,
            parentId: 'parent-B',
          );

          channel.state?.addNewMessage(parentA);
          channel.state?.addNewMessage(parentB);
          channel.state?.addNewMessage(topLevelFromUser1);
          channel.state?.addNewMessage(replyA);
          channel.state?.addNewMessage(replyB);

          // Initial state: each thread has exactly its own reply.
          expect(
            channel.state?.threads['parent-A']?.map((m) => m.id),
            equals(['reply-A']),
          );
          expect(
            channel.state?.threads['parent-B']?.map((m) => m.id),
            equals(['reply-B']),
          );

          // Trigger the multi-thread batch via user.messages.deleted.
          final userMessagesDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.userMessagesDeleted,
            user: user1,
            hardDelete: false,
          );
          client.addEvent(userMessagesDeletedEvent);
          await Future.delayed(Duration.zero);

          // 1) Thread membership is preserved — no cross-thread leakage.
          //    Without the fix, replyB would leak into thread A and v.v.
          expect(
            channel.state?.threads['parent-A']?.map((m) => m.id),
            equals(['reply-A']),
            reason: 'thread A must not contain replies from thread B',
          );
          expect(
            channel.state?.threads['parent-B']?.map((m) => m.id),
            equals(['reply-B']),
            reason: 'thread B must not contain replies from thread A',
          );

          // 2) Every message authored by user-1 is soft-deleted — top-level
          //    AND in both threads. The fix must not narrow this scope.
          expect(
            channel.state?.messages.firstWhere((m) => m.id == 'top-1').type,
            equals(MessageType.deleted),
            reason: 'top-level user-1 message must be deleted',
          );
          expect(
            channel.state?.threads['parent-A']?.first.type,
            equals(MessageType.deleted),
            reason: 'thread A reply from user-1 must be deleted',
          );
          expect(
            channel.state?.threads['parent-B']?.first.type,
            equals(MessageType.deleted),
            reason: 'thread B reply from user-1 must be deleted',
          );

          // 3) Other users' messages are unaffected.
          expect(
            channel.state?.messages.firstWhere((m) => m.id == 'parent-A').type,
            isNot(MessageType.deleted),
          );
          expect(
            channel.state?.messages.firstWhere((m) => m.id == 'parent-B').type,
            isNot(MessageType.deleted),
          );
        },
      );
    });
  });

  group('ChannelReadHelper', () {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    late final client = MockStreamChatClient();

    // A date in the distant past (Unix epoch), useful for representing old dates
    final distantPast = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

    setUpAll(() {
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
    });

    test('userReadOf should return read for specific user', () {
      final now = DateTime.now();
      final user1 = User(id: 'user-1', name: 'User 1');
      final user2 = User(id: 'user-2', name: 'User 2');

      final reads = [
        Read(user: user1, lastRead: now),
        Read(user: user2, lastRead: now.add(const Duration(minutes: 1))),
      ];

      final channelState = _generateChannelState(channelId, channelType);
      final channel = Channel.fromState(client, channelState);
      addTearDown(channel.dispose);

      channel.state!.updateChannelState(
        ChannelState(channel: channelState.channel, read: reads),
      );

      final user1Read = channel.state!.userReadOf(userId: 'user-1');
      expect(user1Read, isNotNull);
      expect(user1Read!.user.id, 'user-1');
      expect(user1Read.lastRead, now);

      final user2Read = channel.state!.userReadOf(userId: 'user-2');
      expect(user2Read, isNotNull);
      expect(user2Read!.user.id, 'user-2');

      final nonExistentRead = channel.state!.userReadOf(userId: 'user-3');
      expect(nonExistentRead, isNull);
    });

    test('userReadOf should return null when userId is null', () {
      final channelState = _generateChannelState(channelId, channelType);
      final channel = Channel.fromState(client, channelState);
      addTearDown(channel.dispose);

      final read = channel.state!.userReadOf(userId: null);
      expect(read, isNull);
    });

    test(
      'userReadStreamOf should emit read updates for specific user',
      () async {
        final now = DateTime.now();
        final user1 = User(id: 'user-1', name: 'User 1');

        final channelState = _generateChannelState(channelId, channelType);
        final channel = Channel.fromState(client, channelState);
        addTearDown(channel.dispose);

        final readStream = channel.state!.userReadStreamOf(userId: 'user-1');

        expectLater(
          readStream,
          emitsInOrder([
            isNull, // initial state
            isA<Read>().having((r) => r.user.id, 'userId', 'user-1'),
          ]),
        );

        // Update with read
        channel.state!.updateChannelState(
          ChannelState(
            channel: channelState.channel,
            read: [Read(user: user1, lastRead: now)],
          ),
        );
      },
    );

    test('readsOf should return reads that have marked message as read', () {
      final now = DateTime.now();
      final sender = User(id: 'sender-id', name: 'Sender');
      final user1 = User(id: 'user-1', name: 'User 1');
      final user2 = User(id: 'user-2', name: 'User 2');
      final user3 = User(id: 'user-3', name: 'User 3');

      final message = Message(
        id: 'msg-1',
        text: 'Test message',
        user: sender,
        createdAt: now,
      );

      final reads = [
        // user1 has read the message
        Read(user: user1, lastRead: now.add(const Duration(seconds: 1))),
        // user2 has not read the message yet
        Read(user: user2, lastRead: distantPast),
        // user3 has read the message
        Read(user: user3, lastRead: now.add(const Duration(seconds: 2))),
        // sender should be excluded
        Read(user: sender, lastRead: now.add(const Duration(seconds: 10))),
      ];

      final channelState = _generateChannelState(channelId, channelType);
      final channel = Channel.fromState(client, channelState);
      addTearDown(channel.dispose);

      channel.state!.updateChannelState(
        ChannelState(channel: channelState.channel, read: reads),
      );

      final messageReads = channel.state!.readsOf(message: message);
      expect(messageReads.length, 2);
      expect(messageReads.map((r) => r.user.id), containsAll(['user-1', 'user-3']));
      expect(messageReads.map((r) => r.user.id), isNot(contains('user-2')));
      expect(messageReads.map((r) => r.user.id), isNot(contains('sender-id')));
    });

    test('readsOfStream should emit read updates for a message', () async {
      final now = DateTime.now();
      final sender = User(id: 'sender-id', name: 'Sender');
      final user1 = User(id: 'user-1', name: 'User 1');

      final message = Message(
        id: 'msg-1',
        text: 'Test message',
        user: sender,
        createdAt: now,
      );

      final channelState = _generateChannelState(channelId, channelType);
      final channel = Channel.fromState(client, channelState);
      addTearDown(channel.dispose);

      final readsStream = channel.state!.readsOfStream(message: message);

      expectLater(
        readsStream,
        emitsInOrder([
          isEmpty, // initial state
          hasLength(1), // after adding read
        ]),
      );

      // Update with read
      channel.state!.updateChannelState(
        ChannelState(
          channel: channelState.channel,
          read: [Read(user: user1, lastRead: now.add(const Duration(seconds: 1)))],
        ),
      );
    });

    test('deliveriesOf should return reads that have delivered the message', () {
      final now = DateTime.now();
      final sender = User(id: 'sender-id', name: 'Sender');
      final user1 = User(id: 'user-1', name: 'User 1');
      final user2 = User(id: 'user-2', name: 'User 2');
      final user3 = User(id: 'user-3', name: 'User 3');
      final user4 = User(id: 'user-4', name: 'User 4');

      final message = Message(
        id: 'msg-1',
        text: 'Test message',
        user: sender,
        createdAt: now,
      );

      final reads = [
        // user1 has delivered the message
        Read(
          user: user1,
          lastRead: distantPast,
          lastDeliveredAt: now.add(const Duration(seconds: 1)),
        ),
        // user2 has not delivered the message yet (lastDeliveredAt is before message)
        Read(
          user: user2,
          lastRead: distantPast,
          lastDeliveredAt: distantPast,
        ),
        // user3 has no lastDeliveredAt
        Read(
          user: user3,
          lastRead: distantPast,
        ),
        // user4 has read the message (implicitly delivered)
        Read(
          user: user4,
          lastRead: now.add(const Duration(seconds: 1)),
        ),
        // sender should be excluded
        Read(
          user: sender,
          lastRead: now.add(const Duration(seconds: 10)),
          lastDeliveredAt: now.add(const Duration(seconds: 10)),
        ),
      ];

      final channelState = _generateChannelState(channelId, channelType);
      final channel = Channel.fromState(client, channelState);
      addTearDown(channel.dispose);

      channel.state!.updateChannelState(
        ChannelState(channel: channelState.channel, read: reads),
      );

      final deliveries = channel.state!.deliveriesOf(message: message);
      expect(deliveries.length, 2);
      expect(deliveries.map((r) => r.user.id), containsAll(['user-1', 'user-4']));
      expect(deliveries.map((r) => r.user.id), isNot(contains('user-2')));
      expect(deliveries.map((r) => r.user.id), isNot(contains('user-3')));
      expect(deliveries.map((r) => r.user.id), isNot(contains('sender-id')));
    });

    test('deliveriesOfStream should emit delivery updates for a message', () async {
      final now = DateTime.now();
      final sender = User(id: 'sender-id', name: 'Sender');
      final user1 = User(id: 'user-1', name: 'User 1');

      final message = Message(
        id: 'msg-1',
        text: 'Test message',
        user: sender,
        createdAt: now,
      );

      final channelState = _generateChannelState(channelId, channelType);
      final channel = Channel.fromState(client, channelState);
      addTearDown(channel.dispose);

      final deliveriesStream = channel.state!.deliveriesOfStream(message: message);

      expectLater(
        deliveriesStream,
        emitsInOrder([
          isEmpty, // initial state
          hasLength(1), // after adding delivery
        ]),
      );

      // Update with delivery
      channel.state!.updateChannelState(
        ChannelState(
          channel: channelState.channel,
          read: [
            Read(
              user: user1,
              lastRead: distantPast,
              lastDeliveredAt: now.add(const Duration(seconds: 1)),
            ),
          ],
        ),
      );
    });
  });

  group('ChannelCapabilityCheck', () {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    late final client = MockStreamChatClient();

    setUpAll(() {
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
    });

    /// Parameterized test for channel capability extension properties
    void testCapability(
      String capabilityName,
      ChannelCapability capability,
      bool Function(Channel) getterMethod,
    ) {
      test('can$capabilityName returns false when capability is absent', () {
        final channelState = _generateChannelState(channelId, channelType);
        final channel = Channel.fromState(client, channelState);
        expect(getterMethod(channel), false);
      });

      test('can$capabilityName returns true when capability is present', () {
        final channelState = _generateChannelState(
          channelId,
          channelType,
          ownCapabilities: [capability],
        );
        final channel = Channel.fromState(client, channelState);
        expect(getterMethod(channel), true);
      });
    }

    // Test all channel capabilities using the parameterized function
    testCapability(
      'SendMessage',
      ChannelCapability.sendMessage,
      (channel) => channel.canSendMessage,
    );

    testCapability(
      'SendReply',
      ChannelCapability.sendReply,
      (channel) => channel.canSendReply,
    );

    testCapability(
      'SendRestrictedVisibilityMessage',
      ChannelCapability.sendRestrictedVisibilityMessage,
      (channel) => channel.canSendRestrictedVisibilityMessage,
    );

    testCapability(
      'SendReaction',
      ChannelCapability.sendReaction,
      (channel) => channel.canSendReaction,
    );

    testCapability(
      'SendLinks',
      ChannelCapability.sendLinks,
      (channel) => channel.canSendLinks,
    );

    testCapability(
      'CreateAttachment',
      ChannelCapability.createAttachment,
      (channel) => channel.canCreateAttachment,
    );

    testCapability(
      'FreezeChannel',
      ChannelCapability.freezeChannel,
      (channel) => channel.canFreezeChannel,
    );

    testCapability(
      'SetChannelCooldown',
      ChannelCapability.setChannelCooldown,
      (channel) => channel.canSetChannelCooldown,
    );

    testCapability(
      'LeaveChannel',
      ChannelCapability.leaveChannel,
      (channel) => channel.canLeaveChannel,
    );

    testCapability(
      'JoinChannel',
      ChannelCapability.joinChannel,
      (channel) => channel.canJoinChannel,
    );

    testCapability(
      'PinMessage',
      ChannelCapability.pinMessage,
      (channel) => channel.canPinMessage,
    );

    testCapability(
      'DeleteAnyMessage',
      ChannelCapability.deleteAnyMessage,
      (channel) => channel.canDeleteAnyMessage,
    );

    testCapability(
      'DeleteOwnMessage',
      ChannelCapability.deleteOwnMessage,
      (channel) => channel.canDeleteOwnMessage,
    );

    testCapability(
      'UpdateAnyMessage',
      ChannelCapability.updateAnyMessage,
      (channel) => channel.canUpdateAnyMessage,
    );

    testCapability(
      'UpdateOwnMessage',
      ChannelCapability.updateOwnMessage,
      (channel) => channel.canUpdateOwnMessage,
    );

    testCapability(
      'SearchMessages',
      ChannelCapability.searchMessages,
      (channel) => channel.canSearchMessages,
    );

    testCapability(
      'SendTypingEvents',
      ChannelCapability.sendTypingEvents,
      (channel) => channel.canSendTypingEvents,
    );

    testCapability(
      'UploadFile',
      ChannelCapability.uploadFile,
      (channel) => channel.canUploadFile,
    );

    testCapability(
      'DeleteChannel',
      ChannelCapability.deleteChannel,
      (channel) => channel.canDeleteChannel,
    );

    testCapability(
      'UpdateChannel',
      ChannelCapability.updateChannel,
      (channel) => channel.canUpdateChannel,
    );

    testCapability(
      'UpdateChannelMembers',
      ChannelCapability.updateChannelMembers,
      (channel) => channel.canUpdateChannelMembers,
    );

    testCapability(
      'UpdateThread',
      ChannelCapability.updateThread,
      (channel) => channel.canUpdateThread,
    );

    testCapability(
      'QuoteMessage',
      ChannelCapability.quoteMessage,
      (channel) => channel.canQuoteMessage,
    );

    testCapability(
      'BanChannelMembers',
      ChannelCapability.banChannelMembers,
      (channel) => channel.canBanChannelMembers,
    );

    testCapability(
      'FlagMessage',
      ChannelCapability.flagMessage,
      (channel) => channel.canFlagMessage,
    );

    testCapability(
      'MuteChannel',
      ChannelCapability.muteChannel,
      (channel) => channel.canMuteChannel,
    );

    testCapability(
      'SendCustomEvents',
      ChannelCapability.sendCustomEvents,
      (channel) => channel.canSendCustomEvents,
    );

    testCapability(
      'ReceiveReadEvents',
      ChannelCapability.readEvents,
      (channel) => channel.canReceiveReadEvents,
    );

    testCapability(
      'ReceiveConnectEvents',
      ChannelCapability.connectEvents,
      (channel) => channel.canReceiveConnectEvents,
    );

    testCapability(
      'UseTypingEvents',
      ChannelCapability.typingEvents,
      (channel) => channel.canUseTypingEvents,
    );

    testCapability(
      'InSlowMode',
      ChannelCapability.slowMode,
      (channel) => channel.isInSlowMode,
    );

    testCapability(
      'SkipSlowMode',
      ChannelCapability.skipSlowMode,
      (channel) => channel.canSkipSlowMode,
    );

    testCapability(
      'SendPoll',
      ChannelCapability.sendPoll,
      (channel) => channel.canSendPoll,
    );

    testCapability(
      'CastPollVote',
      ChannelCapability.castPollVote,
      (channel) => channel.canCastPollVote,
    );

    testCapability(
      'QueryPollVotes',
      ChannelCapability.queryPollVotes,
      (channel) => channel.canQueryPollVotes,
    );

    testCapability(
      'ShareLocation',
      ChannelCapability.shareLocation,
      (channel) => channel.canShareLocation,
    );

    testCapability(
      'NotifyChannel',
      ChannelCapability.notifyChannel,
      (channel) => channel.canNotifyChannel,
    );

    testCapability(
      'NotifyHere',
      ChannelCapability.notifyHere,
      (channel) => channel.canNotifyHere,
    );

    testCapability(
      'NotifyRole',
      ChannelCapability.notifyRole,
      (channel) => channel.canNotifyRole,
    );

    testCapability(
      'NotifyGroup',
      ChannelCapability.notifyGroup,
      (channel) => channel.canNotifyGroup,
    );

    test('returns correct values with multiple capabilities', () {
      final channelState = _generateChannelState(
        channelId,
        channelType,
        ownCapabilities: [
          ChannelCapability.sendMessage,
          ChannelCapability.sendReply,
          ChannelCapability.deleteOwnMessage,
        ],
      );

      final channel = Channel.fromState(client, channelState);
      expect(channel.canSendMessage, true);
      expect(channel.canSendReply, true);
      expect(channel.canDeleteOwnMessage, true);
      expect(channel.canDeleteAnyMessage, false);
      expect(channel.canUpdateChannel, false);
    });
  });

  group('Channel State Validation and Cooldown', () {
    late final client = MockStreamChatClient();
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';

    setUpAll(() {
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

    group('Non-initialized channel state validation', () {
      test(
        'should throw StateError when accessing cooldown on non-initialized channel',
        () {
          final channel = Channel(client, channelType, channelId);
          expect(() => channel.cooldown, throwsA(isA<StateError>()));
        },
      );

      test(
        'should throw StateError when accessing getRemainingCooldown on non-initialized channel',
        () {
          final channel = Channel(client, channelType, channelId);
          expect(channel.getRemainingCooldown, throwsA(isA<StateError>()));
        },
      );

      test(
        'should throw StateError when accessing cooldownStream on non-initialized channel',
        () {
          final channel = Channel(client, channelType, channelId);
          expect(() => channel.cooldownStream, throwsA(isA<StateError>()));
        },
      );
    });

    group('Initialized channel cooldown functionality', () {
      late Channel channel;

      setUp(() {
        final channelState = _generateChannelState(channelId, channelType);
        channel = Channel.fromState(client, channelState);
      });

      tearDown(() => channel.dispose());

      test(
        'should return default cooldown value of 0 for initialized channel',
        () => expect(channel.cooldown, equals(0)),
      );

      test('should return custom cooldown value when set in channel model', () {
        final channelWithCooldown = ChannelModel(
          id: channelId,
          type: channelType,
          cooldown: 30,
        );

        final stateWithCooldown = ChannelState(channel: channelWithCooldown);
        final testChannel = Channel.fromState(client, stateWithCooldown);
        addTearDown(testChannel.dispose);

        expect(testChannel.cooldown, equals(30));
      });

      test('should return 0 remaining cooldown when no cooldown is set', () {
        expect(channel.getRemainingCooldown(), equals(0));
      });

      test('should return cooldown stream with default value', () {
        expectLater(channel.cooldownStream.take(1), emits(0));
      });
    });

    group('Thread reply cooldown', () {
      const currentUserId = 'test-user-id'; // matches FakeClientState default
      const cooldownDuration = 30; // seconds

      Channel _buildChannelWithCooldown() {
        final channelModel = ChannelModel(
          id: channelId,
          type: channelType,
          cooldown: cooldownDuration,
          ownCapabilities: [ChannelCapability.slowMode],
        );
        final state = ChannelState(channel: channelModel);
        final ch = Channel.fromState(client, state);
        // isUpToDate is seeded true by default
        return ch;
      }

      test(
        'should return positive cooldown after current user sends a thread reply',
        () {
          final ch = _buildChannelWithCooldown();
          addTearDown(ch.dispose);

          // Simulate a thread reply by the current user sent just now.
          final threadReply = Message(
            id: 'thread-reply-1',
            parentId: 'parent-msg-1',
            showInChannel: false,
            createdAt: DateTime.timestamp(),
            user: User(id: currentUserId),
          );
          ch.state!.updateThreadInfo('parent-msg-1', [threadReply]);

          expect(ch.getRemainingCooldown(), greaterThan(0));
        },
      );

      test(
        'should return 0 cooldown when thread reply was sent outside the cooldown window',
        () {
          final ch = _buildChannelWithCooldown();
          addTearDown(ch.dispose);

          // Reply sent cooldownDuration+5 seconds ago — outside the window.
          final oldReply = Message(
            id: 'thread-reply-old',
            parentId: 'parent-msg-1',
            showInChannel: false,
            createdAt: DateTime.timestamp().subtract(
              const Duration(seconds: cooldownDuration + 5),
            ),
            user: User(id: currentUserId),
          );
          ch.state!.updateThreadInfo('parent-msg-1', [oldReply]);

          expect(ch.getRemainingCooldown(), equals(0));
        },
      );

      test(
        'should not trigger cooldown for a thread reply from another user',
        () {
          final ch = _buildChannelWithCooldown();
          addTearDown(ch.dispose);

          final otherUserReply = Message(
            id: 'thread-reply-other',
            parentId: 'parent-msg-1',
            showInChannel: false,
            createdAt: DateTime.timestamp(),
            user: User(id: 'other-user-id'),
          );
          ch.state!.updateThreadInfo('parent-msg-1', [otherUserReply]);

          expect(ch.getRemainingCooldown(), equals(0));
        },
      );

      test(
        'should clear cooldown when the most-recent own message is hard-deleted',
        () {
          final ch = _buildChannelWithCooldown();
          addTearDown(ch.dispose);

          final ownMessage = Message(
            id: 'msg-1',
            createdAt: DateTime.timestamp(),
            user: User(id: currentUserId),
          );
          ch.state!.updateMessage(ownMessage);
          expect(ch.getRemainingCooldown(), greaterThan(0));

          ch.state!.deleteMessage(ownMessage, hardDelete: true);
          expect(ch.getRemainingCooldown(), equals(0));
        },
      );

      test(
        'currentUserLastMessageAtStream emits a new timestamp when own message is added',
        () async {
          final ch = _buildChannelWithCooldown();
          addTearDown(ch.dispose);

          final emissions = <DateTime?>[];
          final sub = ch.currentUserLastMessageAtStream.listen(emissions.add);
          addTearDown(sub.cancel);

          // Let the seed emission settle.
          await Future<void>.delayed(Duration.zero);
          final seededLast = emissions.last;

          ch.state!.updateMessage(
            Message(
              id: 'msg-1',
              createdAt: DateTime.timestamp(),
              user: User(id: currentUserId),
            ),
          );
          await Future<void>.delayed(Duration.zero);

          expect(emissions.last, isNotNull);
          expect(emissions.last, isNot(equals(seededLast)));
        },
      );

      test(
        'getRemainingCooldown uses the explicit [lastMessageAt] override',
        () {
          final ch = _buildChannelWithCooldown();
          addTearDown(ch.dispose);

          // No messages in state, so the default path returns 0.
          expect(ch.getRemainingCooldown(), equals(0));

          // Override pointing inside the cooldown window → positive remaining.
          final recent = DateTime.timestamp().subtract(const Duration(seconds: 5));
          expect(ch.getRemainingCooldown(lastMessageAt: recent), greaterThan(0));

          // Override pointing outside the window → 0.
          final old = DateTime.timestamp().subtract(
            const Duration(seconds: cooldownDuration + 5),
          );
          expect(ch.getRemainingCooldown(lastMessageAt: old), equals(0));
        },
      );

      test(
        'currentUserLastMessageAt picks the latest across channel messages and threads',
        () {
          final ch = _buildChannelWithCooldown();
          addTearDown(ch.dispose);

          final older = DateTime.timestamp().subtract(const Duration(seconds: 20));
          final newer = DateTime.timestamp().subtract(const Duration(seconds: 5));

          // Older message in the main channel.
          ch.state!.updateMessage(
            Message(
              id: 'msg-1',
              createdAt: older,
              user: User(id: currentUserId),
            ),
          );
          // Newer reply in a thread.
          ch.state!.updateThreadInfo('parent-msg-1', [
            Message(
              id: 'thread-reply-1',
              parentId: 'parent-msg-1',
              showInChannel: false,
              createdAt: newer,
              user: User(id: currentUserId),
            ),
          ]);

          // Should pick the newer thread reply, not the older channel message.
          final result = ch.currentUserLastMessageAt;
          expect(result, isNotNull);
          expect(result!.isAtSameMomentAs(newer), isTrue);
        },
      );
    });

    group('Disposed channel state validation', () {
      late Channel channel;

      setUp(() {
        final channelState = _generateChannelState(channelId, channelType);
        channel = Channel.fromState(client, channelState);
      });

      test(
        'should throw StateError when accessing cooldown after disposal',
        () {
          // First verify it works when initialized
          expect(channel.cooldown, equals(0));

          // Dispose the channel
          channel.dispose();

          // Now accessing cooldown should throw
          expect(() => channel.cooldown, throwsA(isA<StateError>()));
        },
      );

      test(
        'should throw StateError when accessing getRemainingCooldown after disposal',
        () {
          // First verify it works when initialized
          expect(channel.getRemainingCooldown(), equals(0));

          // Dispose the channel
          channel.dispose();

          // Now accessing getRemainingCooldown should throw
          expect(channel.getRemainingCooldown, throwsA(isA<StateError>()));
        },
      );

      test(
        'should throw StateError when accessing cooldownStream after disposal',
        () {
          // First verify it works when initialized
          expectLater(channel.cooldownStream.take(1), emits(0));

          // Dispose the channel
          channel.dispose();

          // Now accessing cooldownStream should throw
          expect(() => channel.cooldownStream, throwsA(isA<StateError>()));
        },
      );

      test(
        'should handle race condition scenario - initialization then quick disposal',
        () {
          // This test simulates the race condition that was causing the production crash
          final channelState = _generateChannelState(channelId, channelType);
          final raceChannel = Channel.fromState(client, channelState);

          // Verify it works initially
          expect(raceChannel.cooldown, equals(0));

          // Simulate quick disposal (like what happens with rapid navigation)
          raceChannel.dispose();

          // This should throw StateError instead of crashing with null check operator
          expect(() => raceChannel.cooldown, throwsA(isA<StateError>()));

          expect(raceChannel.getRemainingCooldown, throwsA(isA<StateError>()));
        },
      );
    });

    group('Channel message count events', () {
      const channelId = 'test-channel-id';
      const channelType = 'test-channel-type';
      late Channel channel;

      setUp(() {
        final channelState = _generateChannelState(channelId, channelType);
        channel = Channel.fromState(client, channelState);
      });

      tearDown(() {
        channel.dispose();
      });

      test(
        'should update channel messageCount when event contains channelMessageCount',
        () async {
          // Verify initial state - no messageCount
          expect(channel.messageCount, isNull);

          // Create event with channelMessageCount
          final messageCountEvent = Event(
            cid: channel.cid,
            type: EventType.messageNew,
            channelMessageCount: 42,
          );

          // Dispatch event
          client.addEvent(messageCountEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify channel messageCount was updated
          expect(channel.messageCount, equals(42));
        },
      );

      test(
        'should update channel messageCount from message.new and message.deleted events',
        () async {
          // Test with message.new event - count increases
          final messageNewEvent = Event(
            cid: channel.cid,
            type: EventType.messageNew,
            message: Message(
              id: 'new-message-1',
              text: 'Hello world!',
              user: User(id: 'user-1'),
            ),
            channelMessageCount: 1,
          );

          client.addEvent(messageNewEvent);
          await Future.delayed(Duration.zero);
          expect(channel.messageCount, equals(1));

          // Test with another message.new event - count increases
          final messageNewEvent2 = Event(
            cid: channel.cid,
            type: EventType.messageNew,
            message: Message(
              id: 'new-message-2',
              text: 'Second message',
              user: User(id: 'user-2'),
            ),
            channelMessageCount: 2,
          );

          client.addEvent(messageNewEvent2);
          await Future.delayed(Duration.zero);
          expect(channel.messageCount, equals(2));

          // Test with message.deleted event - count decreases
          final messageDeletedEvent = Event(
            cid: channel.cid,
            type: EventType.messageDeleted,
            message: Message(
              id: 'new-message-1',
              text: 'Hello world!',
              user: User(id: 'user-1'),
            ),
            channelMessageCount: 1,
          );

          client.addEvent(messageDeletedEvent);
          await Future.delayed(Duration.zero);
          expect(channel.messageCount, equals(1));
        },
      );

      test(
        'should preserve other channel properties when updating messageCount',
        () async {
          // Set initial channel state with some properties
          final initialChannel = channel.state?.channelState.channel?.copyWith(
            extraData: {'name': 'Test Channel'},
            memberCount: 5,
            frozen: true,
          );

          if (initialChannel != null) {
            channel.state?.updateChannelState(
              channel.state!.channelState.copyWith(channel: initialChannel),
            );
          }

          // Verify initial state
          expect(channel.name, 'Test Channel');
          expect(channel.memberCount, equals(5));
          expect(channel.frozen, equals(true));
          expect(channel.messageCount, isNull);

          // Update messageCount via event
          final messageCountEvent = Event(
            cid: channel.cid,
            type: EventType.messageNew,
            channelMessageCount: 100,
          );

          client.addEvent(messageCountEvent);
          await Future.delayed(Duration.zero);

          // Verify messageCount was updated while preserving other properties
          expect(channel.messageCount, equals(100));
          expect(channel.name, 'Test Channel');
          expect(channel.memberCount, equals(5));
          expect(channel.frozen, equals(true));
        },
      );

      test(
        'should provide messageCountStream for reactive updates',
        () async {
          expectLater(
            channel.messageCountStream.distinct(),
            emitsInOrder([null, 1, 5, 10]),
          );

          // Update messageCount multiple times
          final counts = [1, 5, 10];
          for (final count in counts) {
            final event = Event(
              cid: channel.cid,
              type: EventType.messageNew,
              message: Message(
                id: 'msg-$count',
                text: 'Message $count',
                user: User(id: 'user-1'),
              ),
              channelMessageCount: count,
            );

            client.addEvent(event);
            await Future.delayed(Duration.zero);
          }
        },
      );
    });
  });

  group('Channel filterTags', () {
    late final client = MockStreamChatClient();
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';

    setUpAll(() {
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
    });

    test('should return filterTags from channel state', () {
      final channelModel = ChannelModel(
        id: channelId,
        type: channelType,
        filterTags: ['tag1', 'tag2'],
      );

      final channelState = ChannelState(channel: channelModel);
      final testChannel = Channel.fromState(client, channelState);
      addTearDown(testChannel.dispose);

      expect(testChannel.filterTags, equals(['tag1', 'tag2']));
    });

    test('should update filterTags when channel state is updated', () {
      final channelModel = ChannelModel(
        id: channelId,
        type: channelType,
        filterTags: ['tag1', 'tag2'],
      );

      final channelState = ChannelState(channel: channelModel);
      final testChannel = Channel.fromState(client, channelState);
      addTearDown(testChannel.dispose);

      expect(testChannel.filterTags, equals(['tag1', 'tag2']));

      final updatedChannel = channelModel.copyWith(
        filterTags: ['tag3', 'tag4', 'tag5'],
      );

      testChannel.state?.updateChannelState(
        testChannel.state!.channelState.copyWith(channel: updatedChannel),
      );

      expect(testChannel.filterTags, equals(['tag3', 'tag4', 'tag5']));
    });
  });

  group('Typing Indicator', () {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    late final client = MockStreamChatClient();

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
    });

    test(
      ".keystore should return if we don't have the capability",
      () async {
        final channelState = _generateChannelState(
          channelId,
          channelType,
          ownCapabilities: [], // no typingEvents capability
        );

        final channel = Channel.fromState(client, channelState);
        addTearDown(channel.dispose);

        final typingEvent = Event(type: EventType.typingStart);

        await expectLater(channel.keyStroke(), completes);

        verifyNever(
          () => client.sendEvent(
            channelId,
            channelType,
            any(that: isSameEventAs(typingEvent)),
          ),
        );
      },
    );

    test(
      '.keystore should return when user privacy settings is disabled',
      () async {
        final currentUser = client.state.currentUser;
        final updatedUser = currentUser?.copyWith(
          privacySettings: const PrivacySettings(
            typingIndicators: TypingIndicators(enabled: false),
          ),
        );

        client.state.updateUser(updatedUser);
        addTearDown(() => client.state.updateUser(currentUser));

        final channelState = _generateChannelState(
          channelId,
          channelType,
          ownCapabilities: [ChannelCapability.typingEvents],
        );

        final channel = Channel.fromState(client, channelState);
        addTearDown(channel.dispose);

        final typingEvent = Event(type: EventType.typingStart);

        await expectLater(channel.keyStroke(), completes);

        verifyNever(
          () => client.sendEvent(
            channelId,
            channelType,
            any(that: isSameEventAs(typingEvent)),
          ),
        );
      },
    );

    test(
      ".keystore should send 'typingStart' event if there is not already a typingEvent or the difference between the two is > 3 seconds",
      () async {
        final channelState = _generateChannelState(
          channelId,
          channelType,
          ownCapabilities: [ChannelCapability.typingEvents],
        );

        final channel = Channel.fromState(client, channelState);
        addTearDown(channel.dispose);

        final startTypingEvent = Event(type: EventType.typingStart);
        final stopTypingEvent = Event(type: EventType.typingStop);

        when(
          () => client.sendEvent(
            channelId,
            channelType,
            any(that: isSameEventAs(startTypingEvent)),
          ),
        ).thenAnswer((_) async => EmptyResponse());

        when(
          () => client.sendEvent(
            channelId,
            channelType,
            any(that: isSameEventAs(stopTypingEvent)),
          ),
        ).thenAnswer((_) async => EmptyResponse());

        await expectLater(channel.keyStroke(), completes);

        verify(
          () => client.sendEvent(
            channelId,
            channelType,
            any(that: isSameEventAs(startTypingEvent)),
          ),
        ).called(1);

        verify(
          () => client.sendEvent(
            channelId,
            channelType,
            any(that: isSameEventAs(stopTypingEvent)),
          ),
        ).called(1);
      },
    );

    test(
      ".startTyping should return if we don't have the capability",
      () async {
        final channelState = _generateChannelState(
          channelId,
          channelType,
          ownCapabilities: [], // no typingEvents capability
        );

        final channel = Channel.fromState(client, channelState);
        addTearDown(channel.dispose);

        final typingStartEvent = Event(type: EventType.typingStart);

        await expectLater(channel.startTyping(), completes);

        verifyNever(
          () => client.sendEvent(
            channelId,
            channelType,
            any(that: isSameEventAs(typingStartEvent)),
          ),
        );
      },
    );

    test(
      '.startTyping should return when user privacy settings is disabled',
      () async {
        final currentUser = client.state.currentUser;
        final updatedUser = currentUser?.copyWith(
          privacySettings: const PrivacySettings(
            typingIndicators: TypingIndicators(enabled: false),
          ),
        );

        client.state.updateUser(updatedUser);
        addTearDown(() => client.state.updateUser(currentUser));

        final channelState = _generateChannelState(
          channelId,
          channelType,
          ownCapabilities: [ChannelCapability.typingEvents],
        );

        final channel = Channel.fromState(client, channelState);
        addTearDown(channel.dispose);

        final typingStartEvent = Event(type: EventType.typingStart);

        await expectLater(channel.startTyping(), completes);

        verifyNever(
          () => client.sendEvent(
            channelId,
            channelType,
            any(that: isSameEventAs(typingStartEvent)),
          ),
        );
      },
    );

    test(".startTyping should send 'typingStart' successfully", () async {
      final channelState = _generateChannelState(
        channelId,
        channelType,
        ownCapabilities: [ChannelCapability.typingEvents],
      );

      final channel = Channel.fromState(client, channelState);
      addTearDown(channel.dispose);

      final typingStartEvent = Event(type: EventType.typingStart);

      when(
        () => client.sendEvent(
          channelId,
          channelType,
          any(that: isSameEventAs(typingStartEvent)),
        ),
      ).thenAnswer((_) async => EmptyResponse());

      await expectLater(channel.startTyping(), completes);

      verify(
        () => client.sendEvent(
          channelId,
          channelType,
          any(that: isSameEventAs(typingStartEvent)),
        ),
      ).called(1);
    });

    test(".stopTyping should return if we don't have the capability", () async {
      final channelState = _generateChannelState(
        channelId,
        channelType,
        ownCapabilities: [], // no typingEvents capability
      );

      final channel = Channel.fromState(client, channelState);
      addTearDown(channel.dispose);

      final typingStopEvent = Event(type: EventType.typingStop);

      await expectLater(channel.stopTyping(), completes);

      verifyNever(
        () => client.sendEvent(
          channelId,
          channelType,
          any(that: isSameEventAs(typingStopEvent)),
        ),
      );
    });

    test(
      '.stopTyping should return when user privacy settings is disabled',
      () async {
        final currentUser = client.state.currentUser;
        final updatedUser = currentUser?.copyWith(
          privacySettings: const PrivacySettings(
            typingIndicators: TypingIndicators(enabled: false),
          ),
        );

        client.state.updateUser(updatedUser);
        addTearDown(() => client.state.updateUser(currentUser));

        final channelState = _generateChannelState(
          channelId,
          channelType,
          ownCapabilities: [ChannelCapability.typingEvents],
        );

        final channel = Channel.fromState(client, channelState);
        addTearDown(channel.dispose);

        final typingStopEvent = Event(type: EventType.typingStop);

        await expectLater(channel.stopTyping(), completes);

        verifyNever(
          () => client.sendEvent(
            channelId,
            channelType,
            any(that: isSameEventAs(typingStopEvent)),
          ),
        );
      },
    );

    test(".stopTyping should send 'typingStop' successfully", () async {
      final channelState = _generateChannelState(
        channelId,
        channelType,
        ownCapabilities: [ChannelCapability.typingEvents],
      );

      final channel = Channel.fromState(client, channelState);
      addTearDown(channel.dispose);

      final typingStopEvent = Event(type: EventType.typingStop);

      when(
        () => client.sendEvent(
          channelId,
          channelType,
          any(that: isSameEventAs(typingStopEvent)),
        ),
      ).thenAnswer((_) async => EmptyResponse());

      await expectLater(channel.stopTyping(), completes);

      verify(
        () => client.sendEvent(
          channelId,
          channelType,
          any(that: isSameEventAs(typingStopEvent)),
        ),
      ).called(1);
    });
  });

  group('Read Receipts', () {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    late final client = MockStreamChatClient();

    setUpAll(() {
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
    });

    test(
      ".markRead should throw if we don't have the capability",
      () async {
        final channelState = _generateChannelState(
          channelId,
          channelType,
          ownCapabilities: [], // no readEvents capability
        );

        final channel = Channel.fromState(client, channelState);
        addTearDown(channel.dispose);

        await expectLater(
          channel.markRead(messageId: 'message-id-123'),
          throwsA(isA<StreamChatError>()),
        );
      },
    );

    test(
      '.markRead should succeed if we have the capability',
      () async {
        final channelState = _generateChannelState(
          channelId,
          channelType,
          ownCapabilities: [ChannelCapability.readEvents],
        );

        final channel = Channel.fromState(client, channelState);
        addTearDown(channel.dispose);

        when(
          () => client.markChannelRead(
            channelId,
            channelType,
            messageId: 'message-id-123',
          ),
        ).thenAnswer((_) async => EmptyResponse());

        await expectLater(
          channel.markRead(messageId: 'message-id-123'),
          completes,
        );

        verify(
          () => client.markChannelRead(
            channelId,
            channelType,
            messageId: 'message-id-123',
          ),
        ).called(1);
      },
    );

    test(
      ".markUnread should throw if we don't have the capability",
      () async {
        final channelState = _generateChannelState(
          channelId,
          channelType,
          ownCapabilities: [], // no readEvents capability
        );

        final channel = Channel.fromState(client, channelState);
        addTearDown(channel.dispose);

        await expectLater(
          channel.markUnread('message-id-123'),
          throwsA(isA<StreamChatError>()),
        );
      },
    );

    test(
      '.markUnread should succeed if we have the capability',
      () async {
        final channelState = _generateChannelState(
          channelId,
          channelType,
          ownCapabilities: [ChannelCapability.readEvents],
        );

        final channel = Channel.fromState(client, channelState);
        addTearDown(channel.dispose);

        when(
          () => client.markChannelUnread(
            channelId,
            channelType,
            'message-id-123',
          ),
        ).thenAnswer((_) async => EmptyResponse());

        await expectLater(
          channel.markUnread('message-id-123'),
          completes,
        );

        verify(
          () => client.markChannelUnread(
            channelId,
            channelType,
            'message-id-123',
          ),
        ).called(1);
      },
    );

    test(
      ".markUnreadByTimestamp should throw if we don't have the capability",
      () async {
        final channelState = _generateChannelState(
          channelId,
          channelType,
          ownCapabilities: [], // no readEvents capability
        );

        final channel = Channel.fromState(client, channelState);
        addTearDown(channel.dispose);

        final timestamp = DateTime.parse('2024-01-01T00:00:00Z');

        await expectLater(
          channel.markUnreadByTimestamp(timestamp),
          throwsA(isA<StreamChatError>()),
        );
      },
    );

    test(
      '.markUnreadByTimestamp should succeed if we have the capability',
      () async {
        final channelState = _generateChannelState(
          channelId,
          channelType,
          ownCapabilities: [ChannelCapability.readEvents],
        );

        final channel = Channel.fromState(client, channelState);
        addTearDown(channel.dispose);

        final timestamp = DateTime.parse('2024-01-01T00:00:00Z');

        when(
          () => client.markChannelUnreadByTimestamp(
            channelId,
            channelType,
            timestamp,
          ),
        ).thenAnswer((_) async => EmptyResponse());

        await expectLater(
          channel.markUnreadByTimestamp(timestamp),
          completes,
        );

        verify(
          () => client.markChannelUnreadByTimestamp(
            channelId,
            channelType,
            timestamp,
          ),
        ).called(1);
      },
    );

    test(
      ".markThreadRead should throw if we don't have the capability",
      () async {
        final channelState = _generateChannelState(
          channelId,
          channelType,
          ownCapabilities: [], // no readEvents capability
        );

        final channel = Channel.fromState(client, channelState);
        addTearDown(channel.dispose);

        await expectLater(
          channel.markThreadRead('thread-id-123'),
          throwsA(isA<StreamChatError>()),
        );
      },
    );

    test(
      '.markThreadRead should succeed if we have the capability',
      () async {
        final channelState = _generateChannelState(
          channelId,
          channelType,
          ownCapabilities: [ChannelCapability.readEvents],
        );

        final channel = Channel.fromState(client, channelState);
        addTearDown(channel.dispose);

        when(
          () => client.markThreadRead(
            channelId,
            channelType,
            'thread-id-123',
          ),
        ).thenAnswer((_) async => EmptyResponse());

        await expectLater(
          channel.markThreadRead('thread-id-123'),
          completes,
        );

        verify(
          () => client.markThreadRead(
            channelId,
            channelType,
            'thread-id-123',
          ),
        ).called(1);
      },
    );

    test(
      ".markThreadUnread should throw if we don't have the capability",
      () async {
        final channelState = _generateChannelState(
          channelId,
          channelType,
          ownCapabilities: [], // no readEvents capability
        );

        final channel = Channel.fromState(client, channelState);
        addTearDown(channel.dispose);

        await expectLater(
          channel.markThreadUnread('thread-id-123'),
          throwsA(isA<StreamChatError>()),
        );
      },
    );

    test(
      '.markThreadUnread should succeed if we have the capability',
      () async {
        final channelState = _generateChannelState(
          channelId,
          channelType,
          ownCapabilities: [ChannelCapability.readEvents],
        );

        final channel = Channel.fromState(client, channelState);
        addTearDown(channel.dispose);

        when(
          () => client.markThreadUnread(
            channelId,
            channelType,
            'thread-id-123',
          ),
        ).thenAnswer((_) async => EmptyResponse());

        await expectLater(
          channel.markThreadUnread('thread-id-123'),
          completes,
        );

        verify(
          () => client.markThreadUnread(
            channelId,
            channelType,
            'thread-id-123',
          ),
        ).called(1);
      },
    );
  });

  group('updateChannelState identity guard', () {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    late final client = MockStreamChatClient();

    setUpAll(() {
      when(() => client.detachedLogger(any())).thenAnswer((invocation) {
        final name = invocation.positionalArguments.first;
        return _createLogger(name);
      });
      when(() => client.retryPolicy).thenReturn(
        RetryPolicy(
          shouldRetry: (_, __, ___) => false,
          delayFactor: Duration.zero,
        ),
      );
      when(() => client.state).thenReturn(FakeClientState());
      when(() => client.logger).thenReturn(_createLogger('mock-client-logger'));
      when(
        () => client.channelDeliveryReporter.submitForDelivery(any()),
      ).thenAnswer((_) async {});
    });

    Channel _seededChannel() {
      final base = _generateChannelState(channelId, channelType);
      final now = DateTime.now();
      final seeded = base.copyWith(
        messages: [
          Message(id: 'm1', text: '1', createdAt: now),
          Message(id: 'm2', text: '2', createdAt: now.add(const Duration(seconds: 1))),
          Message(id: 'm3', text: '3', createdAt: now.add(const Duration(seconds: 2))),
        ],
      );
      return Channel.fromState(client, seeded);
    }

    test(
      'preserves messages reference when updatedState.messages is null',
      () {
        final channel = _seededChannel();
        addTearDown(channel.dispose);

        final before = channel.state!.messages;
        channel.state!.updateChannelState(
          ChannelState(channel: channel.state!.channelState.channel),
        );
        final after = channel.state!.messages;

        expect(identical(before, after), isTrue);
      },
    );

    test(
      'preserves messages reference when updatedState.messages is identical',
      () {
        final channel = _seededChannel();
        addTearDown(channel.dispose);

        final before = channel.state!.messages;
        // copyWith without messages keeps the same `messages` reference, so
        // updateChannelState should hit the identity-guard fast path.
        channel.state!.updateChannelState(
          channel.state!.channelState.copyWith(
            read: [
              Read(
                user: User(id: 'me'),
                lastRead: DateTime.now(),
                unreadMessages: 1,
              ),
            ],
          ),
        );
        final after = channel.state!.messages;

        expect(identical(before, after), isTrue);
      },
    );

    test(
      'still merges messages when updatedState.messages is a different list',
      () {
        final channel = _seededChannel();
        addTearDown(channel.dispose);

        final newMessage = Message(
          id: 'm4',
          text: '4',
          createdAt: DateTime.now().add(const Duration(seconds: 10)),
        );
        channel.state!.updateChannelState(
          ChannelState(
            channel: channel.state!.channelState.channel,
            messages: [newMessage],
          ),
        );

        expect(
          channel.state!.messages.map((m) => m.id),
          ['m1', 'm2', 'm3', 'm4'],
        );
      },
    );

    test('cold-path merge interleaves new messages in sorted order', () {
      final channel = _seededChannel();
      addTearDown(channel.dispose);

      final base = channel.state!.messages.first.createdAt;
      // Incoming list is sorted ascending by createdAt and slots between
      // the existing m1, m2, m3.
      final incoming = [
        Message(
          id: 'm1.5',
          text: 'between m1 and m2',
          createdAt: base.add(const Duration(milliseconds: 500)),
        ),
        Message(
          id: 'm2.5',
          text: 'between m2 and m3',
          createdAt: base.add(const Duration(milliseconds: 1500)),
        ),
      ];
      channel.state!.updateChannelState(
        ChannelState(
          channel: channel.state!.channelState.channel,
          messages: incoming,
        ),
      );

      expect(
        channel.state!.messages.map((m) => m.id),
        ['m1', 'm1.5', 'm2', 'm2.5', 'm3'],
      );
    });

    test('cold-path merge runs syncWith on overlapping ids', () {
      final channel = _seededChannel();
      addTearDown(channel.dispose);

      final localStamp = DateTime.now();
      // Seed m2 with a localCreatedAt that the incoming version doesn't
      // carry, so we can verify syncWith fired during the merge.
      channel.state!.updateMessage(
        Message(
          id: 'm2',
          text: '2',
          createdAt: channel.state!.messages.firstWhere((m) => m.id == 'm2').createdAt,
        ).copyWith(localCreatedAt: localStamp),
      );

      final incoming = [
        Message(
          id: 'm2',
          text: '2 (server)',
          createdAt: channel.state!.messages.firstWhere((m) => m.id == 'm2').createdAt,
        ),
      ];
      channel.state!.updateChannelState(
        ChannelState(
          channel: channel.state!.channelState.channel,
          messages: incoming,
        ),
      );

      final m2 = channel.state!.messages.firstWhere((m) => m.id == 'm2');
      expect(m2.text, '2 (server)');
      // Local-only field carried over by syncWith during the merge.
      expect(m2.localCreatedAt, localStamp);
    });
  });

  group('updateMessage quoted-rewrite', () {
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    late final client = MockStreamChatClient();

    setUpAll(() {
      when(() => client.detachedLogger(any())).thenAnswer((invocation) {
        final name = invocation.positionalArguments.first;
        return _createLogger(name);
      });
      when(() => client.retryPolicy).thenReturn(
        RetryPolicy(
          shouldRetry: (_, __, ___) => false,
          delayFactor: Duration.zero,
        ),
      );
      when(() => client.state).thenReturn(FakeClientState());
      when(() => client.logger).thenReturn(_createLogger('mock-client-logger'));
      when(
        () => client.channelDeliveryReporter.submitForDelivery(any()),
      ).thenAnswer((_) async {});
    });

    Channel _seededChannel({required List<Message> messages}) {
      final base = _generateChannelState(channelId, channelType);
      return Channel.fromState(client, base.copyWith(messages: messages));
    }

    test(
      'rewrites quotedMessage on every quoter when target is deleted',
      () {
        final now = DateTime.now();
        final target = Message(id: 'target', text: 'hi', createdAt: now);
        final quoter1 = Message(
          id: 'q1',
          text: 'reply',
          quotedMessageId: 'target',
          quotedMessage: target,
          createdAt: now.add(const Duration(seconds: 1)),
        );
        final unrelated = Message(
          id: 'u1',
          text: 'other',
          createdAt: now.add(const Duration(seconds: 2)),
        );
        final quoter2 = Message(
          id: 'q2',
          text: 'reply2',
          quotedMessageId: 'target',
          quotedMessage: target,
          createdAt: now.add(const Duration(seconds: 3)),
        );

        final channel = _seededChannel(messages: [target, quoter1, unrelated, quoter2]);
        addTearDown(channel.dispose);

        final unrelatedBefore = channel.state!.messages.firstWhere((m) => m.id == 'u1');

        final deleted = target.copyWith(
          type: MessageType.deleted,
          deletedAt: now.add(const Duration(seconds: 5)),
        );
        channel.state!.updateMessage(deleted);

        final after = channel.state!.messages;
        final q1After = after.firstWhere((m) => m.id == 'q1');
        final q2After = after.firstWhere((m) => m.id == 'q2');
        final uAfter = after.firstWhere((m) => m.id == 'u1');

        expect(q1After.quotedMessage?.deletedAt, isNotNull);
        expect(q1After.quotedMessage?.type, MessageType.deleted);
        expect(q2After.quotedMessage?.deletedAt, isNotNull);
        expect(q2After.quotedMessage?.type, MessageType.deleted);
        // Unrelated messages must not be rebuilt by the rewrite.
        expect(identical(uAfter, unrelatedBefore), isTrue);
      },
    );

    test(
      'preserves messages reference when no message quotes the deleted one',
      () {
        final now = DateTime.now();
        final target = Message(id: 'target', text: 'hi', createdAt: now);
        final unrelated = Message(
          id: 'u1',
          text: 'other',
          createdAt: now.add(const Duration(seconds: 1)),
        );

        final channel = _seededChannel(messages: [target, unrelated]);
        addTearDown(channel.dispose);

        final deleted = target.copyWith(
          type: MessageType.deleted,
          deletedAt: now.add(const Duration(seconds: 5)),
        );
        channel.state!.updateMessage(deleted);

        // No message quotes `target`, so `updateIf` short-circuits and the
        // remaining messages keep their identities (only `target` itself was
        // replaced by `sortedUpsert`).
        final unrelatedAfter = channel.state!.messages.firstWhere((m) => m.id == 'u1');
        expect(identical(unrelatedAfter, unrelated), isTrue);
      },
    );

    test(
      'does not rewrite quotes when an existing quoted target is updated '
      'without being deleted',
      () {
        final now = DateTime.now();
        final target = Message(id: 'target', text: 'original', createdAt: now);
        final quoter = Message(
          id: 'q1',
          text: 'reply',
          quotedMessageId: 'target',
          quotedMessage: target,
          createdAt: now.add(const Duration(seconds: 1)),
        );

        final channel = _seededChannel(messages: [target, quoter]);
        addTearDown(channel.dispose);

        final quoterBefore = channel.state!.messages.firstWhere((m) => m.id == 'q1');

        // Plain text update — not a deletion.
        channel.state!.updateMessage(target.copyWith(text: 'edited'));

        final quoterAfter = channel.state!.messages.firstWhere((m) => m.id == 'q1');
        // `updateIf` is gated on `message.isDeleted`, so the quoter must keep
        // its identity (no allocation, no quoted-message overwrite).
        expect(identical(quoterAfter, quoterBefore), isTrue);
      },
    );
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

  group('Message enrichment preservation on merge', () {
    late final client = MockStreamChatClient();
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    late Channel channel;

    setUpAll(() {
      registerFallbackValue(FakeMessage());
      registerFallbackValue(<Message>[]);

      when(() => client.detachedLogger(any())).thenAnswer((invocation) {
        final name = invocation.positionalArguments.first;
        return _createLogger(name);
      });

      when(() => client.logger).thenReturn(_createLogger('mock-client-logger'));

      final clientState = FakeClientState();
      when(() => client.state).thenReturn(clientState);

      final retryPolicy = RetryPolicy(
        shouldRetry: (_, __, ___) => false,
        delayFactor: Duration.zero,
      );
      when(() => client.retryPolicy).thenReturn(retryPolicy);
    });

    setUp(() {
      final channelState = _generateChannelState(channelId, channelType);
      channel = Channel.fromState(client, channelState);
    });

    tearDown(() {
      channel.dispose();
      clearInteractions(client);
    });

    test(
      'preserves the `poll` on a quotedMessage when the server omits it during '
      're-sync (regression: poll quote disappears after foregrounding)',
      () async {
        final pollUser = User(id: 'poll-author');
        final poll = Poll(
          id: 'poll-1',
          name: 'Pizza or pasta?',
          options: const [
            PollOption(id: 'opt-1', text: 'Pizza'),
            PollOption(id: 'opt-2', text: 'Pasta'),
          ],
          createdById: pollUser.id,
        );

        final pollMessage = Message(
          id: 'poll-msg-1',
          poll: poll,
          pollId: poll.id,
          user: pollUser,
          createdAt: DateTime.utc(2026, 4, 29, 10),
        );

        final replyToPoll = Message(
          id: 'reply-1',
          text: 'Voting now',
          quotedMessageId: pollMessage.id,
          quotedMessage: pollMessage,
          user: User(id: 'reply-user'),
          createdAt: DateTime.utc(2026, 4, 29, 11),
        );

        // Seed channel state with the fully-enriched messages (mirrors what
        // the local DB load produces).
        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            messages: [pollMessage, replyToPoll],
          ),
        );

        // Simulate a re-sync from the API: the server echoes the reply with
        // a `quoted_message` that has only `poll_id` (no `poll` object).
        // Constructed directly (not via copyWith) because copyWith cannot
        // clear `poll` — see Message.copyWith.
        final strippedPollSnapshot = Message(
          id: pollMessage.id,
          pollId: pollMessage.pollId,
          user: pollUser,
          createdAt: pollMessage.createdAt,
        );
        final reSyncedReply = replyToPoll.copyWith(quotedMessage: strippedPollSnapshot);

        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            messages: [reSyncedReply],
          ),
        );

        final mergedReply = channel.state?.messages.firstWhere((it) => it.id == replyToPoll.id);

        expect(mergedReply, isNotNull);
        expect(mergedReply!.quotedMessage, isNotNull);
        expect(mergedReply.quotedMessage!.id, pollMessage.id);
        expect(mergedReply.quotedMessage!.poll, isNotNull);
        expect(mergedReply.quotedMessage!.poll!.id, poll.id);
        expect(mergedReply.quotedMessage!.poll!.name, poll.name);
      },
    );

    test(
      'preserves a nested quotedMessage (poll) two levels deep when the '
      'server omits it during re-sync (regression: quote-of-quote of a poll '
      'disappears completely after foregrounding)',
      () async {
        final pollUser = User(id: 'poll-author');
        final poll = Poll(
          id: 'poll-2',
          name: 'Coffee or tea?',
          options: const [
            PollOption(id: 'opt-a', text: 'Coffee'),
            PollOption(id: 'opt-b', text: 'Tea'),
          ],
          createdById: pollUser.id,
        );

        final pollMessage = Message(
          id: 'poll-msg-2',
          poll: poll,
          pollId: poll.id,
          user: pollUser,
          createdAt: DateTime.utc(2026, 4, 29, 10),
        );

        final replyToPoll = Message(
          id: 'reply-A',
          text: 'My pick',
          quotedMessageId: pollMessage.id,
          quotedMessage: pollMessage,
          user: User(id: 'user-a'),
          createdAt: DateTime.utc(2026, 4, 29, 11),
        );

        final replyToReply = Message(
          id: 'reply-B',
          text: 'Same here',
          quotedMessageId: replyToPoll.id,
          quotedMessage: replyToPoll,
          user: User(id: 'user-b'),
          createdAt: DateTime.utc(2026, 4, 29, 12),
        );

        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            messages: [pollMessage, replyToPoll, replyToReply],
          ),
        );

        // Simulate the server response where:
        // - replyA's nested quoted poll is missing the `poll` object.
        // - replyB's nested quoted replyA is missing its own `quoted_message`
        //   (the server typically does not nest two levels deep).
        // Stripped poll snapshot is constructed directly because copyWith
        // cannot clear `poll` — see Message.copyWith.
        final strippedPollSnapshot = Message(
          id: pollMessage.id,
          pollId: pollMessage.pollId,
          user: pollUser,
          createdAt: pollMessage.createdAt,
        );
        final strippedReplyA = replyToPoll.copyWith(quotedMessage: null);

        final reSyncedReplyA = replyToPoll.copyWith(quotedMessage: strippedPollSnapshot);
        final reSyncedReplyB = replyToReply.copyWith(quotedMessage: strippedReplyA);

        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            messages: [pollMessage, reSyncedReplyA, reSyncedReplyB],
          ),
        );

        final mergedReplyA = channel.state?.messages.firstWhere((it) => it.id == replyToPoll.id);
        final mergedReplyB = channel.state?.messages.firstWhere((it) => it.id == replyToReply.id);

        // First-level quote (reply A's quote of the poll) must keep the poll.
        expect(mergedReplyA?.quotedMessage?.poll, isNotNull);
        expect(mergedReplyA?.quotedMessage?.poll?.id, poll.id);

        // Second-level quote (reply B's quote of reply A) must keep reply A's
        // own nested quotedMessage so the poll preview still resolves.
        expect(mergedReplyB?.quotedMessage, isNotNull);
        expect(mergedReplyB?.quotedMessage?.id, replyToPoll.id);
        expect(mergedReplyB?.quotedMessage?.quotedMessage, isNotNull);
        expect(mergedReplyB?.quotedMessage?.quotedMessage?.id, pollMessage.id);
        expect(mergedReplyB?.quotedMessage?.quotedMessage?.poll, isNotNull);
        expect(mergedReplyB?.quotedMessage?.quotedMessage?.poll?.id, poll.id);
      },
    );

    test(
      'still preserves quotedMessage when the updated payload has no '
      'quoted_message at all (existing behavior should not regress)',
      () async {
        final pollUser = User(id: 'poll-author');
        final poll = Poll(
          id: 'poll-3',
          name: 'Beach or mountains?',
          options: const [
            PollOption(id: 'opt-x', text: 'Beach'),
            PollOption(id: 'opt-y', text: 'Mountains'),
          ],
          createdById: pollUser.id,
        );

        final pollMessage = Message(
          id: 'poll-msg-3',
          poll: poll,
          pollId: poll.id,
          user: pollUser,
          createdAt: DateTime.utc(2026, 4, 29, 10),
        );

        final replyToPoll = Message(
          id: 'reply-3',
          text: 'Definitely beach',
          quotedMessageId: pollMessage.id,
          quotedMessage: pollMessage,
          user: User(id: 'reply-user'),
          createdAt: DateTime.utc(2026, 4, 29, 11),
        );

        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            messages: [pollMessage, replyToPoll],
          ),
        );

        // Simulate an update event that touches the reply but doesn't echo
        // the nested quoted_message at all (only quotedMessageId is set).
        final reSyncedReply = Message(
          id: replyToPoll.id,
          text: 'Definitely beach (edited)',
          quotedMessageId: pollMessage.id,
          user: replyToPoll.user,
          createdAt: replyToPoll.createdAt,
        );

        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            messages: [reSyncedReply],
          ),
        );

        final mergedReply = channel.state?.messages.firstWhere((it) => it.id == replyToPoll.id);

        expect(mergedReply, isNotNull);
        expect(mergedReply!.text, 'Definitely beach (edited)');
        expect(mergedReply.quotedMessage, isNotNull);
        expect(mergedReply.quotedMessage!.poll?.id, poll.id);
      },
    );

    test(
      'preserves the top-level `poll` when the server emits a `message.updated`'
      ' that omits the `poll` object (regression: poll disappears from the '
      'parent message after a thread reply is added)',
      () async {
        final pollUser = User(id: 'poll-author');
        final poll = Poll(
          id: 'poll-thread',
          name: 'What is for lunch?',
          options: const [
            PollOption(id: 'opt-1', text: 'Burgers'),
            PollOption(id: 'opt-2', text: 'Salads'),
          ],
          createdById: pollUser.id,
        );

        final pollMessage = Message(
          id: 'parent-poll-msg',
          poll: poll,
          pollId: poll.id,
          user: pollUser,
          createdAt: DateTime.utc(2026, 4, 29, 10),
          replyCount: 0,
        );

        // Seed channel state with the fully-enriched parent poll message.
        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            messages: [pollMessage],
          ),
        );

        // Simulate the `message.updated` event the backend fires for the
        // parent after a thread reply is added: bookkeeping fields are bumped
        // (`reply_count`, `updated_at`) but the `poll` object is omitted from
        // the payload — only `pollId` is set. Constructed directly because
        // copyWith cannot clear `poll` — see Message.copyWith.
        final strippedParentUpdate = Message(
          id: pollMessage.id,
          pollId: pollMessage.pollId,
          user: pollUser,
          createdAt: pollMessage.createdAt,
          replyCount: 1,
          updatedAt: DateTime.utc(2026, 4, 29, 11),
        );

        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.messageUpdated,
            message: strippedParentUpdate,
          ),
        );

        // Wait for the event to be processed.
        await Future.delayed(Duration.zero);

        final merged = channel.state?.messages.firstWhere((it) => it.id == pollMessage.id);

        // Parent poll message must remain in the channel state after a thread reply.
        expect(merged, isNotNull);
        // Bookkeeping fields from the event should still apply.
        expect(merged!.replyCount, 1);
        // Locally-known poll must be preserved when the server omits it from a
        // `message.updated` payload (e.g. when a thread reply bumps reply_count).
        expect(merged.poll, isNotNull);
        expect(merged.poll!.id, poll.id);
        expect(merged.poll!.name, poll.name);
        expect(merged.pollId, poll.id);
      },
    );

    test(
      'still uses the updated `poll` when the server includes one in '
      '`message.updated` (poll edits should not be reverted to the locally '
      'cached version)',
      () async {
        final pollUser = User(id: 'poll-author');
        final poll = Poll(
          id: 'poll-edit',
          name: 'Initial name',
          options: const [
            PollOption(id: 'opt-1', text: 'Original A'),
          ],
          createdById: pollUser.id,
        );

        final pollMessage = Message(
          id: 'edit-parent',
          poll: poll,
          pollId: poll.id,
          user: pollUser,
          createdAt: DateTime.utc(2026, 4, 29, 10),
        );

        channel.state?.updateChannelState(
          channel.state!.channelState.copyWith(
            messages: [pollMessage],
          ),
        );

        final updatedPoll = poll.copyWith(name: 'Edited name');
        final updatedParent = pollMessage.copyWith(poll: updatedPoll, updatedAt: DateTime.utc(2026, 4, 29, 12));

        client.addEvent(
          Event(
            cid: channel.cid,
            type: EventType.messageUpdated,
            message: updatedParent,
          ),
        );

        await Future.delayed(Duration.zero);

        final merged = channel.state?.messages.firstWhere((it) => it.id == pollMessage.id);

        // Server-echoed poll must override the locally cached one — poll edits
        // should not be reverted by the local-fallback merge.
        expect(merged?.poll, isNotNull);
        expect(merged?.poll?.name, 'Edited name');
      },
    );
  });
}
