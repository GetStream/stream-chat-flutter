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
          final emitted = <int?>[];
          final subscription = channel.messageCountStream.listen(emitted.add);
          addTearDown(subscription.cancel);
          await Future.delayed(Duration.zero);

          // Update messageCount multiple times, repeating one of the counts.
          final counts = [1, 5, 5, 10];
          for (final (index, count) in counts.indexed) {
            final event = Event(
              cid: channel.cid,
              type: EventType.messageNew,
              message: Message(
                id: 'msg-$index',
                text: 'Message $count',
                user: User(id: 'user-1'),
              ),
              channelMessageCount: count,
            );

            client.addEvent(event);
            await Future.delayed(Duration.zero);
          }

          // The repeated count should not be emitted twice.
          expect(emitted, equals([null, 1, 5, 10]));
        },
      );
    });

    group('Channel member count events', () {
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
        'should update channel memberCount when event contains channelMemberCount',
        () async {
          // Verify initial state - default memberCount
          expect(channel.memberCount, equals(0));

          // Create event with channelMemberCount
          final memberCountEvent = Event(
            cid: channel.cid,
            type: EventType.memberAdded,
            member: Member(
              userId: 'user-1',
              user: User(id: 'user-1'),
            ),
            channelMemberCount: 42,
          );

          // Dispatch event
          client.addEvent(memberCountEvent);

          // Wait for the event to be processed
          await Future.delayed(Duration.zero);

          // Verify channel memberCount was updated
          expect(channel.memberCount, equals(42));
        },
      );

      test(
        'should update channel memberCount from member.added and member.removed events',
        () async {
          // Test with member.added event - count increases
          final memberAddedEvent = Event(
            cid: channel.cid,
            type: EventType.memberAdded,
            member: Member(
              userId: 'user-1',
              user: User(id: 'user-1'),
            ),
            channelMemberCount: 1,
          );

          client.addEvent(memberAddedEvent);
          await Future.delayed(Duration.zero);
          expect(channel.memberCount, equals(1));
          expect(channel.state?.channelState.members?.map((it) => it.userId), equals(['user-1']));

          // Test with another member.added event - count increases
          final memberAddedEvent2 = Event(
            cid: channel.cid,
            type: EventType.memberAdded,
            member: Member(
              userId: 'user-2',
              user: User(id: 'user-2'),
            ),
            channelMemberCount: 2,
          );

          client.addEvent(memberAddedEvent2);
          await Future.delayed(Duration.zero);
          expect(channel.memberCount, equals(2));
          expect(
            channel.state?.channelState.members?.map((it) => it.userId),
            equals(['user-1', 'user-2']),
          );

          // Test with member.removed event - count decreases
          final memberRemovedEvent = Event(
            cid: channel.cid,
            type: EventType.memberRemoved,
            user: User(id: 'user-1'),
            channelMemberCount: 1,
          );

          client.addEvent(memberRemovedEvent);
          await Future.delayed(Duration.zero);
          expect(channel.memberCount, equals(1));
          expect(channel.state?.channelState.members?.map((it) => it.userId), equals(['user-2']));
        },
      );

      test(
        'should preserve other channel properties when updating memberCount',
        () async {
          // Set initial channel state with some properties
          final initialChannel = channel.state?.channelState.channel?.copyWith(
            extraData: {'name': 'Test Channel'},
            messageCount: 7,
            frozen: true,
          );

          if (initialChannel != null) {
            channel.state?.updateChannelState(
              channel.state!.channelState.copyWith(channel: initialChannel),
            );
          }

          // Verify initial state
          expect(channel.name, 'Test Channel');
          expect(channel.messageCount, equals(7));
          expect(channel.frozen, equals(true));
          expect(channel.memberCount, equals(0));

          // Update memberCount via event
          final memberCountEvent = Event(
            cid: channel.cid,
            type: EventType.memberAdded,
            member: Member(
              userId: 'user-1',
              user: User(id: 'user-1'),
            ),
            channelMemberCount: 100,
          );

          client.addEvent(memberCountEvent);
          await Future.delayed(Duration.zero);

          // Verify memberCount was updated while preserving other properties
          expect(channel.memberCount, equals(100));
          expect(channel.name, 'Test Channel');
          expect(channel.messageCount, equals(7));
          expect(channel.frozen, equals(true));
        },
      );

      test(
        'should not update memberCount when the event omits channelMemberCount',
        () async {
          // Seed a known member count.
          client.addEvent(
            Event(
              cid: channel.cid,
              type: EventType.memberAdded,
              member: Member(
                userId: 'user-1',
                user: User(id: 'user-1'),
              ),
              channelMemberCount: 5,
            ),
          );

          await Future.delayed(Duration.zero);
          expect(channel.memberCount, equals(5));

          // An event without the field should leave the count untouched.
          client.addEvent(
            Event(
              cid: channel.cid,
              type: EventType.memberAdded,
              member: Member(
                userId: 'user-2',
                user: User(id: 'user-2'),
              ),
            ),
          );

          await Future.delayed(Duration.zero);
          expect(channel.memberCount, equals(5));
        },
      );

      test(
        'should provide memberCountStream for reactive updates',
        () async {
          final emitted = <int?>[];
          final subscription = channel.memberCountStream.listen(emitted.add);
          addTearDown(subscription.cancel);
          await Future.delayed(Duration.zero);

          // Update memberCount multiple times, repeating one of the counts.
          final counts = [1, 5, 5, 10];
          for (final (index, count) in counts.indexed) {
            final event = Event(
              cid: channel.cid,
              type: EventType.memberAdded,
              member: Member(
                userId: 'user-$index',
                user: User(id: 'user-$index'),
              ),
              channelMemberCount: count,
            );

            client.addEvent(event);
            await Future.delayed(Duration.zero);
          }

          // The repeated count should not be emitted twice.
          expect(emitted, equals([0, 1, 5, 10]));
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
