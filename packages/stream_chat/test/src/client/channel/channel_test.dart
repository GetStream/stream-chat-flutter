// ignore_for_file: lines_longer_than_80_chars, cascade_invocations, deprecated_member_use_from_same_package, avoid_redundant_argument_values

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';

import '../../fakes.dart';
import '../../matchers.dart';
import '../../mocks.dart';
import 'channel_test_utils.dart';

void main() {
  group('Non-Initialized Channel', () {
    late final client = MockStreamChatClient();
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    late Channel channel;

    setUpAll(() {
      // detached loggers
      when(() => client.detachedLogger(any())).thenAnswer((invocation) {
        final name = invocation.positionalArguments.first;
        return createLogger(name);
      });

      // client logger
      when(() => client.logger).thenReturn(createLogger('mock-client-logger'));

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
        return createLogger(name);
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
      final channelState = generateChannelState(channelId, channelType);
      when(() => client.chatPersistenceClient.getChannelStateByCid(channelCid)).thenAnswer((_) async => channelState);
      when(() => client.chatPersistenceClient.updateMessages(channelCid, any())).thenAnswer((_) => Future.value());

      // client logger
      when(() => client.logger).thenReturn(createLogger('mock-client-logger'));
    });

    // Setting up a initialized channel
    setUp(() {
      final channelState = generateChannelState(channelId, channelType);
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
        return createLogger(name);
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
      when(() => client.logger).thenReturn(createLogger('mock-client-logger'));

      // mock channel delivery reporter
      when(
        () => client.channelDeliveryReporter.submitForDelivery(any()),
      ).thenAnswer((_) async {});
    });

    // Setting up a initialized channel
    setUp(() {
      final channelState = generateChannelState(
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
              type: StreamChatNetworkErrorType.cancel,
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
              type: StreamChatNetworkErrorType.cancel,
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
              type: StreamChatNetworkErrorType.cancel,
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
              type: StreamChatNetworkErrorType.cancel,
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

        // A soft delete only updates a message already in the loaded window,
        // so seed it first — a delete must never insert a phantom record.
        channel.state?.addNewMessage(message);

        expectLater(
          // skip the seeded message -> [message]
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

        // A soft delete only updates a message already in the loaded window,
        // so seed it first — a delete must never insert a phantom record.
        channel.state?.addNewMessage(message);

        expectLater(
          // skip the seeded message -> [message]
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
          (_) async => generateChannelState(channelId, channelType),
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

      test('a successful retry after a failed init reconciles '
          '`initialized` and `state`', () async {
        final freshChannel = Channel(client, channelType, channelId);
        addTearDown(freshChannel.dispose);

        var attempts = 0;
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
        ).thenAnswer((_) async {
          if (++attempts == 1) {
            throw StreamChatNetworkError(ChatErrorCode.inputError);
          }
          return generateChannelState(channelId, channelType);
        });

        // First init fails: `initialized` errors and `state` stays null.
        // Attach the expectation before watch() so the error is handled.
        final firstInit = expectLater(
          freshChannel.initialized,
          throwsA(isA<StreamChatNetworkError>()),
        );
        await expectLater(
          freshChannel.watch(),
          throwsA(isA<StreamChatNetworkError>()),
        );
        await firstInit;
        expect(freshChannel.state, isNull);

        // Retrying resets the completer; the successful watch initializes the
        // channel and `initialized`/`state` agree again.
        await freshChannel.watch();
        expect(freshChannel.state, isNotNull);
        await expectLater(freshChannel.initialized, completion(isTrue));
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

    test('`.getReplies` keeps the parent message out of the thread', () async {
      const parentId = 'test-parent-id';

      // Some backends return the parent as the first message of the oldest
      // page. It is rendered from its own copy, so it must not also become a
      // reply — otherwise the thread shows its root twice.
      final messages = [
        Message(id: parentId),
        ...List.generate(
          3,
          (index) => Message(id: 'test-message-id-$index', parentId: parentId),
        ),
      ];

      when(() => client.getReplies(parentId)).thenAnswer(
        (_) async => QueryRepliesResponse()..messages = messages,
      );

      await channel.getReplies(parentId);

      final threadMessages = channel.state!.threads[parentId];
      expect(threadMessages, isNotNull);
      expect(threadMessages!.length, messages.length - 1);
      expect(threadMessages.any((it) => it.id == parentId), isFalse);
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
        final channelState = generateChannelState(channelId, channelType);

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

        final stateWithMessages = generateChannelState(
          channelId,
          channelType,
        ).copyWith(messages: initialMessages);

        channel.state!.updateChannelState(stateWithMessages);
        expect(channel.state!.messages, hasLength(3));

        final newState =
            generateChannelState(
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

        final stateWithMessages = generateChannelState(
          channelId,
          channelType,
        ).copyWith(messages: initialMessages);

        channel.state!.updateChannelState(stateWithMessages);
        expect(channel.state!.messages, hasLength(3));

        final targetDate = DateTime.now();
        final newState =
            generateChannelState(
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
          final channelState = generateChannelState(channelId, channelType);

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
          final channelState = generateChannelState(channelId, channelType);

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
  });

  group('Channel State Validation and Cooldown', () {
    late final client = MockStreamChatClient();
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';

    setUpAll(() {
      // detached loggers
      when(() => client.detachedLogger(any())).thenAnswer((invocation) {
        final name = invocation.positionalArguments.first;
        return createLogger(name);
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
      when(() => client.logger).thenReturn(createLogger('mock-client-logger'));

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
        final channelState = generateChannelState(channelId, channelType);
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
        final channelState = generateChannelState(channelId, channelType);
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
          final channelState = generateChannelState(channelId, channelType);
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
  });

  group('Channel filterTags', () {
    late final client = MockStreamChatClient();
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';

    setUpAll(() {
      // detached loggers
      when(() => client.detachedLogger(any())).thenAnswer((invocation) {
        final name = invocation.positionalArguments.first;
        return createLogger(name);
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
      when(() => client.logger).thenReturn(createLogger('mock-client-logger'));
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
        return createLogger(name);
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
      when(() => client.logger).thenReturn(createLogger('mock-client-logger'));
    });

    test(
      ".keystore should return if we don't have the capability",
      () async {
        final channelState = generateChannelState(
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

        final channelState = generateChannelState(
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
        final channelState = generateChannelState(
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
        final channelState = generateChannelState(
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

        final channelState = generateChannelState(
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
      final channelState = generateChannelState(
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
      final channelState = generateChannelState(
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

        final channelState = generateChannelState(
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
      final channelState = generateChannelState(
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
        return createLogger(name);
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
      when(() => client.logger).thenReturn(createLogger('mock-client-logger'));
    });

    test(
      ".markRead should throw if we don't have the capability",
      () async {
        final channelState = generateChannelState(
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
        final channelState = generateChannelState(
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
        final channelState = generateChannelState(
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
        final channelState = generateChannelState(
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
        final channelState = generateChannelState(
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
        final channelState = generateChannelState(
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
        final channelState = generateChannelState(
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
        final channelState = generateChannelState(
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
        final channelState = generateChannelState(
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
        final channelState = generateChannelState(
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
        return createLogger(name);
      });

      when(() => client.logger).thenReturn(createLogger('mock-client-logger'));

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
      final channelState = generateChannelState(channelId, channelType);
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
