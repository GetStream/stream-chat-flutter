// ignore_for_file: lines_longer_than_80_chars

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/client/retry_policy.dart';
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
      final newChannelInstance =
          Channel(client, channelType, channelId, image: newImage);

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
      final newChannelInstance =
          Channel(client, channelType, channelId, name: newName);

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
      when(() => client.chatPersistenceClient.getChannelThreads(channelCid))
          .thenAnswer((_) async => channelThreads);
      final channelState = _generateChannelState(channelId, channelType);
      when(() => client.chatPersistenceClient.getChannelStateByCid(channelCid))
          .thenAnswer((_) async => channelState);
      when(() => client.chatPersistenceClient.updateMessages(channelCid, any()))
          .thenAnswer((_) => Future.value());

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
    });

    // Setting up a initialized channel
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
          user: client.state.currentUser,
        );

        final sendMessageResponse = SendMessageResponse()
          ..message = message.copyWith(state: MessageState.sent);

        when(() => client.sendMessage(
              any(that: isSameMessageAs(message)),
              channelId,
              channelType,
            )).thenAnswer((_) async => sendMessageResponse);

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

        verify(() => client.sendMessage(
              any(that: isSameMessageAs(message)),
              channelId,
              channelType,
            )).called(1);
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

        when(() => client.sendImage(
              any(),
              channelId,
              channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            )).thenAnswer((_) async => sendImageResponse);

        when(() => client.sendFile(
              any(),
              channelId,
              channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            )).thenAnswer((_) async => sendFileResponse);

        when(() => client.sendMessage(
              any(that: isSameMessageAs(message)),
              channelId,
              channelType,
            )).thenAnswer((_) async => SendMessageResponse()
          ..message = message.copyWith(
            attachments: attachments
                .map((it) =>
                    it.copyWith(uploadState: const UploadState.success()))
                .toList(growable: false),
            state: MessageState.sent,
          ));

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
                    attachments: [
                      ...attachments.map((it) => it.copyWith(
                          uploadState: const UploadState.preparing()))
                    ],
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
                    attachments: [...attachments]..[0] =
                          attachments[0].copyWith(
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
                    attachments: [
                      ...attachments.map((it) =>
                          it.copyWith(uploadState: const UploadState.success()))
                    ],
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
                    attachments: [
                      ...attachments.map((it) =>
                          it.copyWith(uploadState: const UploadState.success()))
                    ],
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

        verify(() => client.sendImage(
              any(),
              channelId,
              channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            )).called(2);

        verify(() => client.sendFile(
              any(),
              channelId,
              channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            )).called(1);

        verify(() => client.sendMessage(
              any(that: isSameMessageAs(message)),
              channelId,
              channelType,
            )).called(1);
      });
    });

    group('`.createDraft`', () {
      final draftMessage = DraftMessage(text: 'Draft message text');

      setUp(() {
        when(() => client.createDraft(
              draftMessage,
              channelId,
              channelType,
            )).thenAnswer(
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

        verify(() => channel.client.createDraft(
              draftMessage,
              channelId,
              channelType,
            )).called(1);
      });
    });

    group('`.getDraft`', () {
      final draftMessage = DraftMessage(text: 'Draft message text');

      setUp(() {
        when(() => client.getDraft(
              channelId,
              channelType,
              parentId: any(named: 'parentId'),
            )).thenAnswer(
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

        verify(() => channel.client.getDraft(
              channelId,
              channelType,
            )).called(1);
      });

      test('with parentId should pass parentId to client', () async {
        const parentId = 'parent-123';
        final res = await channel.getDraft(parentId: parentId);

        expect(res, isNotNull);
        expect(res.draft.message, draftMessage);

        verify(() => channel.client.getDraft(
              channelId,
              channelType,
              parentId: parentId,
            )).called(1);
      });
    });

    group('`.deleteDraft`', () {
      setUp(() {
        when(() => client.deleteDraft(
              channelId,
              channelType,
              parentId: any(named: 'parentId'),
            )).thenAnswer((_) async => EmptyResponse());
      });

      test('should call client.deleteDraft', () async {
        final res = await channel.deleteDraft();

        expect(res, isNotNull);

        verify(() => channel.client.deleteDraft(
              channelId,
              channelType,
            )).called(1);
      });

      test('with parentId should pass parentId to client', () async {
        const parentId = 'parent-123';
        final res = await channel.deleteDraft(parentId: parentId);

        expect(res, isNotNull);

        verify(() => channel.client.deleteDraft(
              channelId,
              channelType,
              parentId: parentId,
            )).called(1);
      });
    });

    group('`.updateMessage`', () {
      test('should work fine', () async {
        final message = Message(
          id: 'test-message-id',
          state: MessageState.sent,
        );

        final updateMessageResponse = UpdateMessageResponse()
          ..message = message;

        when(() => client.updateMessage(any(that: isSameMessageAs(message))))
            .thenAnswer((_) async => updateMessageResponse);

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

        verify(() => client.updateMessage(
              any(that: isSameMessageAs(message)),
            )).called(1);
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

        when(() => client.sendImage(
              any(),
              channelId,
              channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            )).thenAnswer((_) async => sendImageResponse);

        when(() => client.sendFile(
              any(),
              channelId,
              channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            )).thenAnswer((_) async => sendFileResponse);

        when(() => client.updateMessage(
              any(that: isSameMessageAs(message)),
            )).thenAnswer((_) async => UpdateMessageResponse()
          ..message = message.copyWith(
            state: MessageState.sent,
            attachments: attachments
                .map((it) =>
                    it.copyWith(uploadState: const UploadState.success()))
                .toList(growable: false),
          ));

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
                    attachments: [
                      ...attachments.map((it) => it.copyWith(
                          uploadState: const UploadState.preparing()))
                    ],
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
                    attachments: [...attachments]..[0] =
                          attachments[0].copyWith(
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
                    attachments: [
                      ...attachments.map((it) =>
                          it.copyWith(uploadState: const UploadState.success()))
                    ],
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
                    attachments: [
                      ...attachments.map((it) =>
                          it.copyWith(uploadState: const UploadState.success()))
                    ],
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

        verify(() => client.sendImage(
              any(),
              channelId,
              channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            )).called(2);

        verify(() => client.sendFile(
              any(),
              channelId,
              channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
              extraData: any(named: 'extraData'),
            )).called(1);

        verify(() => client.updateMessage(
              any(that: isSameMessageAs(message)),
            )).called(1);
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

    group('`.deleteMessage`', () {
      test('should work fine', () async {
        const messageId = 'test-message-id';
        final message = Message(
          id: messageId,
          createdAt: DateTime.now(),
          state: MessageState.sent,
        );

        when(() => client.deleteMessage(messageId))
            .thenAnswer((_) async => EmptyResponse());

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
          attachments: attachments,
          id: messageId,
          createdAt: DateTime.now(),
          state: MessageState.sent,
        );

        when(() => client.deleteMessage(messageId, hard: true))
            .thenAnswer((_) async => EmptyResponse());

        when(() => client.deleteImage(any(), channelId, channelType))
            .thenAnswer((_) async => EmptyResponse());

        when(() => client.deleteFile(any(), channelId, channelType))
            .thenAnswer((_) async => EmptyResponse());

        final res = await channel.deleteMessage(message, hard: true);

        expect(res, isNotNull);

        verify(() => client.deleteMessage(messageId, hard: true)).called(1);
        verify(() => client.deleteImage(
              any(),
              channelId,
              channelType,
            )).called(2);
      });

      test(
        '''should directly update the state with message as deleted if the state is sending or failed''',
        () async {
          const messageId = 'test-message-id';
          final message = Message(
            id: messageId,
          );

          expectLater(
            // skipping first seed message list -> [] messages
            channel.state?.messagesStream.skip(1),
            emitsInOrder([
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
          verifyNever(() => client.deleteMessage(messageId));
        },
      );
    });

    group('`.pinMessage`', () {
      test('should work fine without passing timeoutOrExpirationDate',
          () async {
        final message = Message(id: 'test-message-id');

        when(() => client.partialUpdateMessage(
              message.id,
              set: any(named: 'set'),
              unset: any(named: 'unset'),
            )).thenAnswer((_) async => UpdateMessageResponse()
          ..message = message.copyWith(
            pinned: true,
            pinExpires: null,
          ));

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

        verify(() => client.partialUpdateMessage(
              message.id,
              set: any(named: 'set'),
              unset: any(named: 'unset'),
            )).called(1);
      });

      test(
        'should work fine if passed timeoutOrExpirationDate as num(seconds)',
        () async {
          final message = Message(id: 'test-message-id');
          const timeoutOrExpirationDate = 300; // 300 seconds

          when(() => client.partialUpdateMessage(
                message.id,
                set: any(named: 'set'),
                unset: any(named: 'unset'),
              )).thenAnswer((_) async => UpdateMessageResponse()
            ..message = message.copyWith(
              pinned: true,
              pinExpires: DateTime.now().add(
                const Duration(seconds: timeoutOrExpirationDate),
              ),
            ));

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

          verify(() => client.partialUpdateMessage(
                message.id,
                set: any(named: 'set'),
                unset: any(named: 'unset'),
              )).called(1);
        },
      );

      test(
        'should work fine if passed timeoutOrExpirationDate as DateTime',
        () async {
          final message = Message(id: 'test-message-id');
          final timeoutOrExpirationDate =
              DateTime.now().add(const Duration(days: 3)); // 3 days

          when(() => client.partialUpdateMessage(
                message.id,
                set: any(named: 'set'),
                unset: any(named: 'unset'),
              )).thenAnswer((_) async => UpdateMessageResponse()
            ..message = message.copyWith(
              pinned: true,
              pinExpires: timeoutOrExpirationDate,
            ));

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

          verify(() => client.partialUpdateMessage(
                message.id,
                set: any(named: 'set'),
                unset: any(named: 'unset'),
              )).called(1);
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

      when(() => client.partialUpdateMessage(
            message.id,
            set: {'pinned': false},
          )).thenAnswer((_) async => UpdateMessageResponse()
        ..message = message.copyWith(pinned: false));

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

      verify(() => client.partialUpdateMessage(
            message.id,
            set: {'pinned': false},
          )).called(1);
    });

    group('`.search`', () {
      final filter = Filter.in_('cid', const [channelCid]);

      test('should work fine with `query`', () async {
        const query = 'test-search-query';
        const sort = [SortOption('test-sort-field')];
        const pagination = PaginationParams();

        final results = List.generate(3, (index) => GetMessageResponse());

        when(() => client.search(
              filter,
              query: query,
              sort: any(named: 'sort'),
              paginationParams: any(named: 'paginationParams'),
            )).thenAnswer(
          (_) async => SearchMessagesResponse()..results = results,
        );

        final res = await channel.search(
          query: query,
          sort: sort,
          paginationParams: pagination,
        );

        expect(res, isNotNull);
        expect(res.results.length, results.length);

        verify(() => client.search(
              filter,
              query: query,
              sort: any(named: 'sort'),
              paginationParams: any(named: 'paginationParams'),
            )).called(1);
      });

      test('should work fine with `messageFilters`', () async {
        final messageFilters = Filter.query('key', 'text');
        const sort = [SortOption('test-sort-field')];
        const pagination = PaginationParams();

        final results = List.generate(3, (index) => GetMessageResponse());

        when(() => client.search(
              filter,
              messageFilters: messageFilters,
              sort: any(named: 'sort'),
              paginationParams: any(named: 'paginationParams'),
            )).thenAnswer(
          (_) async => SearchMessagesResponse()..results = results,
        );

        final res = await channel.search(
          sort: sort,
          paginationParams: pagination,
          messageFilters: messageFilters,
        );

        expect(res, isNotNull);
        expect(res.results.length, results.length);

        verify(() => client.search(
              filter,
              messageFilters: messageFilters,
              sort: any(named: 'sort'),
              paginationParams: any(named: 'paginationParams'),
            )).called(1);
      });
    });

    test('`.deleteFile`', () async {
      const url = 'test-file-url';

      when(() => client.deleteFile(url, channelId, channelType,
              cancelToken: any(named: 'cancelToken')))
          .thenAnswer((_) async => EmptyResponse());

      final res = await channel.deleteFile(url);

      expect(res, isNotNull);

      verify(() => client.deleteFile(url, channelId, channelType,
          cancelToken: any(named: 'cancelToken'))).called(1);
    });

    test('`.deleteImage`', () async {
      const url = 'test-image-url';

      when(() => client.deleteImage(url, channelId, channelType,
              cancelToken: any(named: 'cancelToken')))
          .thenAnswer((_) async => EmptyResponse());

      final res = await channel.deleteImage(url);

      expect(res, isNotNull);

      verify(() => client.deleteImage(url, channelId, channelType,
          cancelToken: any(named: 'cancelToken'))).called(1);
    });

    test('`.stopAIResponse`', () async {
      final stopAIEvent = Event(type: EventType.aiIndicatorStop);

      when(() => client.sendEvent(
            channelId,
            channelType,
            any(that: isSameEventAs(stopAIEvent)),
          )).thenAnswer((_) async => EmptyResponse());

      final res = await channel.stopAIResponse();

      expect(res, isNotNull);

      verify(() => client.sendEvent(
            channelId,
            channelType,
            any(that: isSameEventAs(stopAIEvent)),
          )).called(1);
    });

    test('`.sendEvent`', () async {
      final event = Event(type: 'event.local');

      when(() => client.sendEvent(channelId, channelType, event))
          .thenAnswer((_) async => EmptyResponse());

      final res = await channel.sendEvent(event);

      expect(res, isNotNull);

      verify(() => client.sendEvent(channelId, channelType, event)).called(1);
    });

    group('`.sendReaction`', () {
      test('should work fine', () async {
        const type = 'test-reaction-type';
        final message = Message(
          id: 'test-message-id',
          state: MessageState.sent,
        );

        final reaction = Reaction(type: type, messageId: message.id);

        when(() => client.sendReaction(message.id, type)).thenAnswer(
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
                  reactionCounts: {type: 1},
                  reactionScores: {type: 1},
                  latestReactions: [reaction],
                  ownReactions: [reaction],
                ),
                matchReactions: true,
                matchMessageState: true,
              ),
            ],
          ]),
        );

        final res = await channel.sendReaction(message, type);

        expect(res, isNotNull);
        expect(res.reaction.type, type);
        expect(res.reaction.messageId, message.id);

        verify(() => client.sendReaction(message.id, type)).called(1);
      });

      test('should work fine with score passed explicitly', () async {
        const type = 'test-reaction-type';
        final message = Message(
          id: 'test-message-id',
          state: MessageState.sent,
        );

        const score = 5;
        final reaction = Reaction(
          type: type,
          messageId: message.id,
          score: score,
        );

        when(() => client.sendReaction(
              message.id,
              type,
              score: score,
            )).thenAnswer(
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
                  reactionCounts: {type: 1},
                  reactionScores: {type: score},
                  latestReactions: [reaction],
                  ownReactions: [reaction],
                ),
                matchReactions: true,
                matchMessageState: true,
              ),
            ],
          ]),
        );

        final res = await channel.sendReaction(
          message,
          type,
          score: score,
        );

        expect(res, isNotNull);
        expect(res.reaction.type, type);
        expect(res.reaction.messageId, message.id);
        expect(res.reaction.score, score);

        verify(() => client.sendReaction(
              message.id,
              type,
              score: score,
            )).called(1);
      });

      test('should work fine with score passed explicitly and in extraData',
          () async {
        const type = 'test-reaction-type';
        final message = Message(
          id: 'test-message-id',
          state: MessageState.sent,
        );

        const score = 5;
        const extraDataScore = 3;
        const extraData = {
          'score': extraDataScore,
        };
        final reaction = Reaction(
          type: type,
          messageId: message.id,
          score: extraDataScore,
        );

        when(() => client.sendReaction(
              message.id,
              type,
              score: score,
              extraData: extraData,
            )).thenAnswer(
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
                  reactionCounts: {type: 1},
                  reactionScores: {type: extraDataScore},
                  latestReactions: [reaction],
                  ownReactions: [reaction],
                ),
                matchReactions: true,
                matchMessageState: true,
              ),
            ],
          ]),
        );

        final res = await channel.sendReaction(
          message,
          type,
          score: score,
          extraData: extraData,
        );

        expect(res, isNotNull);
        expect(res.reaction.type, type);
        expect(res.reaction.messageId, message.id);
        expect(
          res.reaction.score,
          extraDataScore,
        );

        verify(() => client.sendReaction(
              message.id,
              type,
              score: score,
              extraData: extraData,
            )).called(1);
      });

      test(
        'should restore previous message if `client.sendReaction` throws',
        () async {
          const type = 'test-reaction-type';
          final message = Message(
            id: 'test-message-id',
            state: MessageState.sent,
          );

          final reaction = Reaction(type: type, messageId: message.id);

          when(() => client.sendReaction(message.id, type))
              .thenThrow(StreamChatNetworkError(ChatErrorCode.inputError));

          expectLater(
            // skipping first seed message list -> [] messages
            channel.state?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sent,
                    reactionCounts: {type: 1},
                    reactionScores: {type: 1},
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
            await channel.sendReaction(message, type);
          } catch (e) {
            expect(e, isA<StreamChatNetworkError>());
          }

          verify(() => client.sendReaction(message.id, type)).called(1);
        },
      );

      test(
        '''should override previous reaction if present and `enforceUnique` is true''',
        () async {
          const userId = 'test-user-id';
          const messageId = 'test-message-id';
          const prevType = 'test-reaction-type';
          final prevReaction = Reaction(
            type: prevType,
            messageId: messageId,
            userId: userId,
          );
          final message = Message(
            id: messageId,
            ownReactions: [prevReaction],
            latestReactions: [prevReaction],
            reactionScores: const {prevType: 1},
            reactionCounts: const {prevType: 1},
            state: MessageState.sent,
          );

          const type = 'test-reaction-type-2';
          final newReaction = Reaction(
            type: type,
            messageId: messageId,
            userId: userId,
          );
          final newMessage = message.copyWith(
            ownReactions: [newReaction],
            latestReactions: [newReaction],
          );

          const enforceUnique = true;

          when(() => client.sendReaction(
                messageId,
                type,
                enforceUnique: enforceUnique,
              )).thenAnswer(
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
            type,
            enforceUnique: enforceUnique,
          );

          expect(res, isNotNull);
          expect(res.reaction.type, type);
          expect(res.reaction.messageId, messageId);

          verify(() => client.sendReaction(
                messageId,
                type,
                enforceUnique: enforceUnique,
              )).called(1);
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

        final reaction = Reaction(type: type, messageId: message.id);

        when(() => client.sendReaction(message.id, type)).thenAnswer(
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
                  reactionCounts: {type: 1},
                  reactionScores: {type: 1},
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

        final res = await channel.sendReaction(message, type);

        expect(res, isNotNull);
        expect(res.reaction.type, type);
        expect(res.reaction.messageId, message.id);

        verify(() => client.sendReaction(message.id, type)).called(1);
      });

      test(
        '''should restore previous thread message if `client.sendReaction` throws''',
        () async {
          const type = 'test-reaction-type';
          final message = Message(
            id: 'test-message-id',
            parentId: 'test-parent-id', // is thread message
            state: MessageState.sent,
          );

          final reaction = Reaction(type: type, messageId: message.id);

          when(() => client.sendReaction(message.id, type))
              .thenThrow(StreamChatNetworkError(ChatErrorCode.inputError));

          expectLater(
            // skipping first seed message list -> [] messages
            channel.state?.threadsStream
                .skip(1)
                .map((event) => event['test-parent-id']),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(
                    state: MessageState.sent,
                    reactionCounts: {type: 1},
                    reactionScores: {type: 1},
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
            await channel.sendReaction(message, type);
          } catch (e) {
            expect(e, isA<StreamChatNetworkError>());
          }

          verify(() => client.sendReaction(message.id, type)).called(1);
        },
      );

      test(
        '''should override previous thread reaction if present and `enforceUnique` is true''',
        () async {
          const userId = 'test-user-id';
          const messageId = 'test-message-id';
          const parentId = 'test-parent-id';
          const prevType = 'test-reaction-type';
          final prevReaction = Reaction(
            type: prevType,
            messageId: messageId,
            userId: userId,
          );
          final message = Message(
            id: messageId,
            parentId: parentId,
            ownReactions: [prevReaction],
            latestReactions: [prevReaction],
            reactionScores: const {prevType: 1},
            reactionCounts: const {prevType: 1},
            state: MessageState.sent,
          );

          const type = 'test-reaction-type-2';
          final newReaction = Reaction(
            type: type,
            messageId: messageId,
            userId: userId,
          );
          final newMessage = message.copyWith(
            ownReactions: [newReaction],
            latestReactions: [newReaction],
          );

          const enforceUnique = true;

          when(() => client.sendReaction(
                messageId,
                type,
                enforceUnique: enforceUnique,
              )).thenAnswer(
            (_) async => SendReactionResponse()
              ..message = newMessage
              ..reaction = newReaction,
          );

          expectLater(
            // skipping first seed message list -> [] messages
            channel.state?.threadsStream
                .skip(1)
                .map((event) => event['test-parent-id']),
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
            type,
            enforceUnique: enforceUnique,
          );

          expect(res, isNotNull);
          expect(res.reaction.type, type);
          expect(res.reaction.messageId, messageId);

          verify(() => client.sendReaction(
                messageId,
                type,
                enforceUnique: enforceUnique,
              )).called(1);
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
          reactionScores: const {type: 1},
          reactionCounts: const {type: 1},
          state: MessageState.sent,
        );

        when(() => client.deleteReaction(messageId, type))
            .thenAnswer((_) async => EmptyResponse());

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
            reactionScores: const {type: 1},
            reactionCounts: const {type: 1},
            state: MessageState.sent,
          );

          when(() => client.deleteReaction(messageId, type))
              .thenThrow(StreamChatNetworkError(ChatErrorCode.inputError));

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
          reactionScores: const {type: 1},
          reactionCounts: const {type: 1},
          state: MessageState.sent,
        );

        when(() => client.deleteReaction(messageId, type))
            .thenAnswer((_) async => EmptyResponse());

        expectLater(
          // skipping first seed message list -> [] messages
          channel.state?.threadsStream
              .skip(1)
              .map((event) => event['test-parent-id']),
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
            reactionScores: const {type: 1},
            reactionCounts: const {type: 1},
            state: MessageState.sent,
          );

          when(() => client.deleteReaction(messageId, type))
              .thenThrow(StreamChatNetworkError(ChatErrorCode.inputError));

          expectLater(
            // skipping first seed message list -> [] messages
            channel.state?.threadsStream
                .skip(1)
                .map((event) => event['test-parent-id']),
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

      when(() => client.updateChannel(channelId, channelType, channelData,
          message: any(named: 'message'))).thenAnswer(
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

      verify(() => client.updateChannel(channelId, channelType, channelData,
          message: any(named: 'message'))).called(1);
    });

    test('`.updateImage`', () async {
      const image = 'https://getstream.io/new-image';

      final channelModel = ChannelModel(
        cid: channelCid,
        extraData: {'image': image},
      );

      when(() => client.updateChannelPartial(
            channelId,
            channelType,
            set: {'image': image},
          )).thenAnswer(
        (_) async => PartialUpdateChannelResponse()..channel = channelModel,
      );

      final res = await channel.updateImage(image);

      expect(res, isNotNull);
      expect(res.channel.extraData['image'], image);

      verify(() => client.updateChannelPartial(
            channelId,
            channelType,
            set: {'image': image},
          )).called(1);
    });

    test('`.updateName`', () async {
      const name = 'Name';

      final channelModel = ChannelModel(
        cid: channelCid,
        extraData: {'name': name},
      );

      when(() => client.updateChannelPartial(
            channelId,
            channelType,
            set: {'name': name},
          )).thenAnswer(
        (_) async => PartialUpdateChannelResponse()..channel = channelModel,
      );

      final res = await channel.updateName(name);

      expect(res, isNotNull);
      expect(res.channel.extraData['name'], name);

      verify(() => client.updateChannelPartial(
            channelId,
            channelType,
            set: {'name': name},
          )).called(1);
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

      when(() => client.updateChannelPartial(
            channelId,
            channelType,
            set: set,
            unset: unset,
          )).thenAnswer(
        (_) async => PartialUpdateChannelResponse()..channel = channelModel,
      );

      final res = await channel.updatePartial(set: set, unset: unset);

      expect(res, isNotNull);
      expect(res.channel.cid, channelModel.cid);
      expect(
        res.channel.extraData,
        {'coolness': 999, ...set},
      );

      verify(() => client.updateChannelPartial(
            channelId,
            channelType,
            set: set,
            unset: unset,
          )).called(1);
    });

    test('`.delete`', () async {
      when(() => client.deleteChannel(channelId, channelType))
          .thenAnswer((_) async => EmptyResponse());

      final res = await channel.delete();

      expect(res, isNotNull);

      verify(() => client.deleteChannel(channelId, channelType)).called(1);
    });

    test('`.truncate`', () async {
      when(() => client.truncateChannel(channelId, channelType))
          .thenAnswer((_) async => EmptyResponse());

      final res = await channel.truncate();

      expect(res, isNotNull);

      verify(() => client.truncateChannel(channelId, channelType)).called(1);
    });

    test('`.acceptInvite`', () async {
      final message = Message(id: 'test-message-id', text: 'Invite Accepted');

      final channelModel = ChannelModel(cid: channelCid);

      when(() => client.acceptChannelInvite(channelId, channelType,
          message: any(named: 'message'))).thenAnswer(
        (_) async => AcceptInviteResponse()
          ..channel = channelModel
          ..message = message,
      );

      final res = await channel.acceptInvite(message);

      expect(res, isNotNull);
      expect(res.channel.cid, channelModel.cid);
      expect(res.message?.id, message.id);

      verify(() => client.acceptChannelInvite(channelId, channelType,
          message: any(named: 'message'))).called(1);
    });

    test('`.rejectInvite`', () async {
      final message = Message(id: 'test-message-id', text: 'Invite Rejected');

      final channelModel = ChannelModel(cid: channelCid);

      when(() => client.rejectChannelInvite(channelId, channelType,
          message: any(named: 'message'))).thenAnswer(
        (_) async => RejectInviteResponse()
          ..channel = channelModel
          ..message = message,
      );

      final res = await channel.rejectInvite(message);

      expect(res, isNotNull);
      expect(res.channel.cid, channelModel.cid);
      expect(res.message?.id, message.id);

      verify(() => client.rejectChannelInvite(channelId, channelType,
          message: any(named: 'message'))).called(1);
    });

    test('`.addMembers`', () async {
      final members = List.generate(
        3,
        (index) => Member(userId: 'test-member-id-$index'),
      );
      final memberIds = members
          .map((it) => it.userId)
          .whereType<String>()
          .toList(growable: false);
      final message = Message(id: 'test-message-id', text: 'Members Added');

      final channelModel = ChannelModel(cid: channelCid);

      when(() => client.addChannelMembers(channelId, channelType, memberIds,
          message: any(named: 'message'))).thenAnswer(
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

      verify(() => client.addChannelMembers(channelId, channelType, memberIds,
          message: any(named: 'message'))).called(1);
    });

    test('`.inviteMembers`', () async {
      final members = List.generate(
        3,
        (index) => Member(userId: 'test-member-id-$index'),
      );
      final memberIds = members
          .map((it) => it.userId)
          .whereType<String>()
          .toList(growable: false);
      final message = Message(id: 'test-message-id', text: 'Members Invited');

      final channelModel = ChannelModel(cid: channelCid);

      when(() => client.inviteChannelMembers(channelId, channelType, memberIds,
          message: any(named: 'message'))).thenAnswer(
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

      verify(() => client.inviteChannelMembers(
          channelId, channelType, memberIds,
          message: any(named: 'message'))).called(1);
    });

    test('`.removeMembers`', () async {
      final members = List.generate(
        3,
        (index) => Member(userId: 'test-member-id-$index'),
      );
      final memberIds = members
          .map((it) => it.userId)
          .whereType<String>()
          .toList(growable: false);
      final message = Message(id: 'test-message-id', text: 'Members Removed');

      final channelModel = ChannelModel(cid: channelCid);

      when(() => client.removeChannelMembers(channelId, channelType, memberIds,
          message: any(named: 'message'))).thenAnswer(
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

      verify(() => client.removeChannelMembers(
          channelId, channelType, memberIds,
          message: any(named: 'message'))).called(1);
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

    test('`.markRead`', () async {
      const messageId = 'test-message-id';

      when(() => client.markChannelRead(channelId, channelType,
          messageId: messageId)).thenAnswer((_) async => EmptyResponse());

      final res = await channel.markRead(messageId: messageId);

      expect(res, isNotNull);

      verify(() => client.markChannelRead(channelId, channelType,
          messageId: messageId)).called(1);
    });

    group('`.watch`', () {
      test('should work fine', () async {
        when(() => client.queryChannel(
              channelType,
              channelId: channelId,
              watch: true,
              channelData: any(named: 'channelData'),
              messagesPagination: any(named: 'messagesPagination'),
              membersPagination: any(named: 'membersPagination'),
              watchersPagination: any(named: 'watchersPagination'),
            )).thenAnswer(
          (_) async => _generateChannelState(channelId, channelType),
        );

        final res = await channel.watch();

        expect(res, isNotNull);
        expect(res.channel, isNotNull);
        expect(res.channel?.cid, channelCid);

        verify(() => client.queryChannel(
              channelType,
              channelId: channelId,
              watch: true,
              channelData: any(named: 'channelData'),
              messagesPagination: any(named: 'messagesPagination'),
              membersPagination: any(named: 'membersPagination'),
              watchersPagination: any(named: 'watchersPagination'),
            )).called(1);
      });

      test('should rethrow if `.query` throws', () async {
        when(() => client.queryChannel(
              channelType,
              channelId: channelId,
              watch: true,
              channelData: any(named: 'channelData'),
              messagesPagination: any(named: 'messagesPagination'),
              membersPagination: any(named: 'membersPagination'),
              watchersPagination: any(named: 'watchersPagination'),
            )).thenThrow(StreamChatNetworkError(ChatErrorCode.inputError));

        try {
          await channel.watch();
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());
        }

        verify(() => client.queryChannel(
              channelType,
              channelId: channelId,
              watch: true,
              channelData: any(named: 'channelData'),
              messagesPagination: any(named: 'messagesPagination'),
              membersPagination: any(named: 'membersPagination'),
              watchersPagination: any(named: 'watchersPagination'),
            )).called(1);
      });
    });

    test('`.stopWatching`', () async {
      when(() => client.stopChannelWatching(channelId, channelType))
          .thenAnswer((_) async => EmptyResponse());

      final res = await channel.stopWatching();

      expect(res, isNotNull);

      verify(() => client.stopChannelWatching(channelId, channelType))
          .called(1);
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

      when(() => client.getMessagesById(channelId, channelType, messageIds))
          .thenAnswer(
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
    });

    test('`.queryMembers`', () async {
      final filter = Filter.in_('cid', const [channelCid]);

      final members = List.generate(
        3,
        (index) => Member(userId: 'test-user-id-$index'),
      );

      when(() => client.queryMembers(
            channelType,
            channelId: channelId,
            filter: filter,
            members: any(named: 'members'),
            sort: any(named: 'sort'),
            pagination: any(named: 'pagination'),
          )).thenAnswer((_) async => QueryMembersResponse()..members = members);

      final res = await channel.queryMembers(filter: filter);

      expect(res, isNotNull);
      expect(res.members.length, members.length);

      verify(() => client.queryMembers(
            channelType,
            channelId: channelId,
            filter: filter,
            members: any(named: 'members'),
            sort: any(named: 'sort'),
            pagination: any(named: 'pagination'),
          )).called(1);
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

      when(() => client.queryBannedUsers(
            filter: filter,
            sort: any(named: 'sort'),
            pagination: any(named: 'pagination'),
          )).thenAnswer((_) async => QueryBannedUsersResponse()..bans = bans);

      final res = await channel.queryBannedUsers();

      expect(res, isNotNull);
      expect(res.bans.length, bans.length);

      verify(() => client.queryBannedUsers(
            filter: filter,
            sort: any(named: 'sort'),
            pagination: any(named: 'pagination'),
          )).called(1);
    });

    test('`.mute`', () async {
      when(() => client.muteChannel(
            channelCid,
            expiration: any(named: 'expiration'),
          )).thenAnswer((_) async => EmptyResponse());

      final res = await channel.mute();

      expect(res, isNotNull);

      verify(() => client.muteChannel(
            channelCid,
            expiration: any(named: 'expiration'),
          )).called(1);
    });

    test('`.mute with expiration`', () async {
      const expiration = Duration(seconds: 3);

      when(() => client.muteChannel(
            channelCid,
            expiration: expiration,
          )).thenAnswer((_) async => EmptyResponse());

      when(() => client.unmuteChannel(channelCid))
          .thenAnswer((_) async => EmptyResponse());

      final res = await channel.mute(expiration: expiration);

      expect(res, isNotNull);

      verify(() => client.muteChannel(
            channelCid,
            expiration: expiration,
          )).called(1);

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

      when(() => client.enableSlowdown(
            channelId,
            channelType,
            cooldown,
          )).thenAnswer((_) async => PartialUpdateChannelResponse()
        ..channel = channelModel);

      final res = await channel.enableSlowMode(cooldownInterval: 10);

      expect(res, isNotNull);

      verify(() => client.enableSlowdown(
            channelId,
            channelType,
            cooldown,
          )).called(1);
    });

    test('`.disableSlowMode`', () async {
      final channelModel = ChannelModel(
        cid: channelCid,
      );

      when(() => client.disableSlowdown(
            channelId,
            channelType,
          )).thenAnswer((_) async => PartialUpdateChannelResponse()
        ..channel = channelModel);

      final res = await channel.disableSlowMode();

      expect(res, isNotNull);

      verify(() => client.disableSlowdown(channelId, channelType)).called(1);
    });

    test('`.banUser`', () async {
      const userId = 'test-user-id';
      const options = {'key': 'value'};

      when(() => client.banUser(
            userId,
            {'type': channelType, 'id': channelId, ...options},
          )).thenAnswer((_) async => EmptyResponse());

      final res = await channel.banMember(userId, options);

      expect(res, isNotNull);

      verify(() => client.banUser(
            userId,
            {'type': channelType, 'id': channelId, ...options},
          )).called(1);
    });

    test('`.unbanUser`', () async {
      const userId = 'test-user-id';

      when(() => client.unbanUser(userId, any()))
          .thenAnswer((_) async => EmptyResponse());

      final res = await channel.unbanMember(userId);

      expect(res, isNotNull);

      verify(() => client.unbanUser(userId, any())).called(1);
    });

    test('`.shadowBan`', () async {
      const userId = 'test-user-id';
      const options = {'key': 'value'};

      when(() => client.shadowBan(
            userId,
            {'type': channelType, 'id': channelId, ...options},
          )).thenAnswer((_) async => EmptyResponse());

      final res = await channel.shadowBan(userId, options);

      expect(res, isNotNull);

      verify(() => client.shadowBan(
            userId,
            {'type': channelType, 'id': channelId, ...options},
          )).called(1);
    });

    test('`.removeShadowBan`', () async {
      const userId = 'test-user-id';

      when(() => client.removeShadowBan(userId, any()))
          .thenAnswer((_) async => EmptyResponse());

      final res = await channel.removeShadowBan(userId);

      expect(res, isNotNull);

      verify(() => client.removeShadowBan(userId, any())).called(1);
    });

    test('`.hide`', () async {
      const clearHistory = true;

      when(() => client.hideChannel(
            channelId,
            channelType,
            clearHistory: clearHistory,
          )).thenAnswer((_) async => EmptyResponse());

      final res = await channel.hide(clearHistory: clearHistory);

      expect(res, isNotNull);

      verify(() => client.hideChannel(
            channelId,
            channelType,
            clearHistory: clearHistory,
          )).called(1);
    });

    test('`.show`', () async {
      when(() => client.showChannel(channelId, channelType))
          .thenAnswer((_) async => EmptyResponse());

      final res = await channel.show();

      expect(res, isNotNull);

      verify(() => client.showChannel(channelId, channelType)).called(1);
    });

    // testing archiving
    test('`.archive`', () async {
      when(() => client.archiveChannel(
          channelId: channelId, channelType: channelType)).thenAnswer(
        (_) async => FakePartialUpdateMemberResponse(),
      );

      final res = await channel.archive();

      expect(res, isNotNull);

      verify(() => client.archiveChannel(
          channelId: channelId, channelType: channelType)).called(1);
    });

    test('`.unarchive`', () async {
      when(() => client.unarchiveChannel(
          channelId: channelId, channelType: channelType)).thenAnswer(
        (_) async => FakePartialUpdateMemberResponse(),
      );

      final res = await channel.unarchive();

      expect(res, isNotNull);

      verify(() => client.unarchiveChannel(
          channelId: channelId, channelType: channelType)).called(1);
    });

    // testing pinning
    test('`.pin`', () async {
      when(() =>
              client.pinChannel(channelId: channelId, channelType: channelType))
          .thenAnswer((_) async => FakePartialUpdateMemberResponse());

      final res = await channel.pin();

      expect(res, isNotNull);

      verify(() =>
              client.pinChannel(channelId: channelId, channelType: channelType))
          .called(1);
    });

    test('`.unpin`', () async {
      when(() => client.unpinChannel(
              channelId: channelId, channelType: channelType))
          .thenAnswer((_) async => FakePartialUpdateMemberResponse());

      final res = await channel.unpin();

      expect(res, isNotNull);

      verify(() => client.unpinChannel(
          channelId: channelId, channelType: channelType)).called(1);
    });

    test('`.on`', () async {
      const eventType = 'test.event';
      final event = Event(type: eventType, cid: channelCid);

      Future.microtask(() => client.addEvent(event));

      return expectLater(channel.on(eventType), emitsInOrder([event]));
    });

    group(
      '`.keyStroke`',
      () {
        test('should return if `config.typingEvents` is false', () async {
          when(() => channel.config?.typingEvents).thenReturn(false);

          final typingEvent = Event(type: EventType.typingStart);

          await channel.keyStroke();

          verifyNever(() => client.sendEvent(
                channelId,
                channelType,
                any(that: isSameEventAs(typingEvent)),
              ));
        });

        test(
          '''should send `typingStart` event if there is not already a typingEvent or the difference between the two is > 3 seconds''',
          () async {
            final startTypingEvent = Event(type: EventType.typingStart);
            final stopTypingEvent = Event(type: EventType.typingStop);

            when(() => channel.config?.typingEvents).thenReturn(true);

            when(() => client.sendEvent(
                  channelId,
                  channelType,
                  any(that: isSameEventAs(startTypingEvent)),
                )).thenAnswer((_) async => EmptyResponse());
            when(() => client.sendEvent(
                  channelId,
                  channelType,
                  any(that: isSameEventAs(stopTypingEvent)),
                )).thenAnswer((_) async => EmptyResponse());

            await channel.keyStroke();

            verify(() => client.sendEvent(
                  channelId,
                  channelType,
                  any(that: isSameEventAs(startTypingEvent)),
                )).called(1);
            verify(() => client.sendEvent(
                  channelId,
                  channelType,
                  any(that: isSameEventAs(stopTypingEvent)),
                )).called(1);
          },
        );
      },
    );

    group('`.stopTyping`', () {
      test('should return if `config.typingEvents` is false', () async {
        when(() => channel.config?.typingEvents).thenReturn(false);

        final typingStopEvent = Event(type: EventType.typingStop);

        await channel.stopTyping();

        verifyNever(() => client.sendEvent(
              channelId,
              channelType,
              any(that: isSameEventAs(typingStopEvent)),
            ));
      });

      test('should send `typingStop` successfully', () async {
        final typingStopEvent = Event(type: EventType.typingStop);

        when(() => channel.config?.typingEvents).thenReturn(true);

        when(() => client.sendEvent(
              channelId,
              channelType,
              any(that: isSameEventAs(typingStopEvent)),
            )).thenAnswer((_) async => EmptyResponse());

        await channel.stopTyping();

        verify(() => client.sendEvent(
              channelId,
              channelType,
              any(that: isSameEventAs(typingStopEvent)),
            )).called(1);
      });
    });

    // This test verifies that stale error messages (error messages without bounce moderation)
    // are automatically cleaned up when we send a new message.
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

        when(() => client.sendMessage(any(), channelId, channelType))
            .thenAnswer((_) async => SendMessageResponse()
              ..message = newMessage.copyWith(state: MessageState.sent));

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

      test('should update read state on notification mark read event',
          () async {
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

        // Create mark read notification event
        final markReadEvent = Event(
          cid: channel.cid,
          type: EventType.notificationMarkRead,
          user: currentUser,
          createdAt: DateTime(2022),
          unreadMessages: 0,
          lastReadMessageId: 'message-123',
        );

        // Dispatch event
        client.addEvent(markReadEvent);

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
        'should add a new read state if not exist on notification mark read',
        () async {
          // Create the current read state
          final currentUser = User(id: 'test-user');

          // Verify initial state
          final read = channel.state?.read;
          expect(read, isEmpty);

          // Create mark read notification event
          final markReadEvent = Event(
            cid: channel.cid,
            type: EventType.notificationMarkRead,
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

      test('should update read state on notification mark unread event',
          () async {
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
}
