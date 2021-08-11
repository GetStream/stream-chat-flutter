import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/client/channel.dart';
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
    const channelCid = '$channelType:$channelId';
    late Channel channel;

    setUpAll(() {
      // detached loggers
      when(() => client.detachedLogger(any())).thenAnswer((invocation) {
        final name = invocation.positionalArguments.first;
        return _createLogger(name);
      });

      // client logger
      when(() => client.logger).thenReturn(_createLogger('mock-client-logger'));
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
      expect(
        channel.name,
        channelCid,
        reason: 'if name is not set then use channel id',
      );

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

  // TODO : test all persistence related logic in this group
  group('Initialized Channel with Persistence', () {
    late final client = MockStreamChatClientWithPersistence();
    const channelId = 'test-channel-id';
    const channelType = 'test-channel-type';
    const channelCid = '$channelType:$channelId';
    late Channel channel;

    setUpAll(() {
      // Fallback values
      registerFallbackValue<Message>(FakeMessage());
      registerFallbackValue<List<Message>>(<Message>[]);
      registerFallbackValue<AttachmentFile>(FakeAttachmentFile());

      // detached loggers
      when(() => client.detachedLogger(any())).thenAnswer((invocation) {
        final name = invocation.positionalArguments.first;
        return _createLogger(name);
      });

      final retryPolicy = RetryPolicy(
        shouldRetry: (_, __, ___) => false,
        retryTimeout: (_, __, ___) => Duration.zero,
      );
      when(() => client.retryPolicy).thenReturn(retryPolicy);

      final event = Event(type: 'event.local');
      when(() => client.on(any(), any(), any(), any()))
          .thenAnswer((_) => Stream.value(event));

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
      registerFallbackValue<Message>(FakeMessage());
      registerFallbackValue<AttachmentFile>(FakeAttachmentFile());
      registerFallbackValue<Event>(FakeEvent());

      // detached loggers
      when(() => client.detachedLogger(any())).thenAnswer((invocation) {
        final name = invocation.positionalArguments.first;
        return _createLogger(name);
      });

      final retryPolicy = RetryPolicy(
        shouldRetry: (_, __, ___) => false,
        retryTimeout: (_, __, ___) => Duration.zero,
      );
      when(() => client.retryPolicy).thenReturn(retryPolicy);

      final event = Event(type: 'event.local');
      when(() => client.on(any(), any(), any(), any()))
          .thenAnswer((_) => Stream.value(event));

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
        final message = Message(id: 'test-message-id');

        final sendMessageResponse = SendMessageResponse()..message = message;

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
                message.copyWith(status: MessageSendingStatus.sending),
                matchSendingStatus: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(status: MessageSendingStatus.sent),
                matchSendingStatus: true,
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
            file: AttachmentFile(size: 33 * index, path: 'test-file-path'),
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
            )).thenAnswer((_) async => sendImageResponse);

        when(() => client.sendFile(
              any(),
              channelId,
              channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
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
          ));

        expectLater(
          // skipping first seed message list -> [] messages
          channel.state?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(status: MessageSendingStatus.sending),
                matchSendingStatus: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(status: MessageSendingStatus.sent),
                matchSendingStatus: true,
              ),
            ],
          ]),
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
            )).called(2);

        verify(() => client.sendFile(
              any(),
              channelId,
              channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
            )).called(1);

        verify(() => client.sendMessage(
              any(that: isSameMessageAs(message)),
              channelId,
              channelType,
            )).called(1);
      });
    });

    group('`.updateMessage`', () {
      test('should work fine', () async {
        final message = Message(id: 'test-message-id');

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
                message.copyWith(status: MessageSendingStatus.updating),
                matchSendingStatus: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(status: MessageSendingStatus.sent),
                matchSendingStatus: true,
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
            file: AttachmentFile(size: 33 * index, path: 'test-file-path'),
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
            )).thenAnswer((_) async => sendImageResponse);

        when(() => client.sendFile(
              any(),
              channelId,
              channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((_) async => sendFileResponse);

        when(() => client.updateMessage(
              any(that: isSameMessageAs(message)),
            )).thenAnswer((_) async => UpdateMessageResponse()
          ..message = message.copyWith(
            attachments: attachments
                .map((it) =>
                    it.copyWith(uploadState: const UploadState.success()))
                .toList(growable: false),
          ));

        expectLater(
          // skipping first seed message list -> [] messages
          channel.state?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(status: MessageSendingStatus.updating),
                matchSendingStatus: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(status: MessageSendingStatus.sent),
                matchSendingStatus: true,
              ),
            ],
          ]),
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
            )).called(2);

        verify(() => client.sendFile(
              any(),
              channelId,
              channelType,
              onSendProgress: any(named: 'onSendProgress'),
              cancelToken: any(named: 'cancelToken'),
            )).called(1);

        verify(() => client.updateMessage(
              any(that: isSameMessageAs(message)),
            )).called(1);
      });
    });

    test('`.partialUpdateMessage`', () async {
      final message = Message(id: 'test-message-id');

      const set = {'text': 'Update Message text'};
      const unset = ['pinExpires'];

      final updateMessageResponse = UpdateMessageResponse()
        ..message = message.copyWith(text: set['text'], pinExpires: null);

      when(
        () => client.partialUpdateMessage(message.id, set: set, unset: unset),
      ).thenAnswer((_) async => updateMessageResponse);

      channel.state?.messagesStream.skip(1).listen(print);

      expectLater(
        // skipping first seed message list -> [] messages
        channel.state?.messagesStream.skip(1),
        emitsInOrder([
          [
            isSameMessageAs(
              updateMessageResponse.message.copyWith(
                status: MessageSendingStatus.sent,
              ),
              matchText: true,
              matchSendingStatus: true,
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
        final message = Message(id: messageId);

        when(() => client.deleteMessage(messageId))
            .thenAnswer((_) async => EmptyResponse());

        expectLater(
          // skipping first seed message list -> [] messages
          channel.state?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(status: MessageSendingStatus.deleting),
                matchSendingStatus: true,
              ),
            ],
            [
              isSameMessageAs(
                message.copyWith(status: MessageSendingStatus.sent),
                matchSendingStatus: true,
              ),
            ],
          ]),
        );

        final res = await channel.deleteMessage(message);

        expect(res, isNotNull);

        verify(() => client.deleteMessage(messageId)).called(1);
      });

      test(
        '''should directly update the state with message as deleted if the state is sending or failed''',
        () async {
          const messageId = 'test-message-id';
          final message = Message(
            id: messageId,
            status: MessageSendingStatus.sending,
          );

          expectLater(
            // skipping first seed message list -> [] messages
            channel.state?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(status: MessageSendingStatus.sent),
                  matchSendingStatus: true,
                ),
              ],
            ]),
          );

          final res = await channel.deleteMessage(message);

          expect(res, isNotNull);
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
            status: MessageSendingStatus.sent,
          ));

        expectLater(
          // skipping first seed message list -> [] messages
          channel.state?.messagesStream.skip(1),
          emitsInOrder([
            [
              isSameMessageAs(
                message.copyWith(status: MessageSendingStatus.sent),
                matchSendingStatus: true,
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
              status: MessageSendingStatus.sent,
            ));

          expectLater(
            // skipping first seed message list -> [] messages
            channel.state?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(status: MessageSendingStatus.sent),
                  matchSendingStatus: true,
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
              status: MessageSendingStatus.sent,
            ));

          expectLater(
            // skipping first seed message list -> [] messages
            channel.state?.messagesStream.skip(1),
            emitsInOrder([
              [
                isSameMessageAs(
                  message.copyWith(status: MessageSendingStatus.sent),
                  matchSendingStatus: true,
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
        ..message = message.copyWith(
          pinned: false,
          status: MessageSendingStatus.sent,
        ));

      expectLater(
        // skipping first seed message list -> [] messages
        channel.state?.messagesStream.skip(1),
        emitsInOrder([
          [
            isSameMessageAs(
              message.copyWith(status: MessageSendingStatus.sent),
              matchSendingStatus: true,
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
        final message = Message(id: 'test-message-id');

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
                  status: MessageSendingStatus.sent,
                  reactionCounts: {type: 1},
                  reactionScores: {type: 1},
                  latestReactions: [reaction],
                  ownReactions: [reaction],
                ),
                matchReactions: true,
                matchSendingStatus: true,
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
        'should restore previous message if `client.sendReaction` throws',
        () async {
          const type = 'test-reaction-type';
          final message = Message(id: 'test-message-id');

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
                    status: MessageSendingStatus.sent,
                    reactionCounts: {type: 1},
                    reactionScores: {type: 1},
                    latestReactions: [reaction],
                    ownReactions: [reaction],
                  ),
                  matchReactions: true,
                  matchSendingStatus: true,
                ),
              ],
              [
                isSameMessageAs(
                  message,
                  matchReactions: true,
                  matchSendingStatus: true,
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
                  newMessage.copyWith(status: MessageSendingStatus.sent),
                  matchReactions: true,
                  matchSendingStatus: true,
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
                  status: MessageSendingStatus.sent,
                  latestReactions: [],
                  ownReactions: [],
                ),
                matchReactions: true,
                matchSendingStatus: true,
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
                    status: MessageSendingStatus.sent,
                    latestReactions: [],
                    ownReactions: [],
                  ),
                  matchReactions: true,
                  matchSendingStatus: true,
                ),
              ],
              [
                isSameMessageAs(
                  message,
                  matchReactions: true,
                  matchSendingStatus: true,
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

      final res = await channel.update(channelData, updateMessage);

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

      final res = await channel.addMembers(memberIds, message);

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

      final res = await channel.inviteMembers(memberIds, message);

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

      final res = await channel.removeMembers(memberIds, message);

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
                matchSendingStatus: true,
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
      expect(client.state.totalUnreadCount, 0);

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

    test('`.banUser`', () async {
      const userId = 'test-user-id';
      const options = {'key': 'value'};

      when(() => client.banUser(
            userId,
            {'type': channelType, 'id': channelId, ...options},
          )).thenAnswer((_) async => EmptyResponse());

      final res = await channel.banUser(userId, options);

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

      final res = await channel.unbanUser(userId);

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

    test('`.on`', () async {
      const eventType = 'test.event';
      final event = Event(type: eventType, cid: channelCid);

      when(() => client.on(eventType, any(), any(), any()))
          .thenAnswer((_) => Stream.value(event));

      expectLater(channel.on(eventType), emitsInOrder([event]));

      verify(() => client.on(eventType, any(), any(), any())).called(1);
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
          '''should send `typingStart` event if there is not already a typingEvent or the difference between the two is >= 2 seconds''',
          () async {
            final typingEvent = Event(type: EventType.typingStart);

            when(() => channel.config?.typingEvents).thenReturn(true);

            when(() => client.sendEvent(
                  channelId,
                  channelType,
                  any(that: isSameEventAs(typingEvent)),
                )).thenAnswer((_) async => EmptyResponse());

            await channel.keyStroke();

            verify(() => client.sendEvent(
                  channelId,
                  channelType,
                  any(that: isSameEventAs(typingEvent)),
                )).called(1);
          },
        );
      },
    );

    group('`.stopTyping`', () {
      test('should return if `config.typingEvents` is false', () async {
        when(() => channel.config?.typingEvents).thenReturn(false);

        final typingStopEvent = Event(type: EventType.typingStop);

        await channel.keyStroke();

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
  });
}
