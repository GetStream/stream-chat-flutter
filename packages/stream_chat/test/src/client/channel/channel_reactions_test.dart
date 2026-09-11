import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

ChannelState Function(ChannelState) _seedChannel() {
  return (_) => createDefaultChannelState(
    channel: createDefaultChannelModel(
      cid: _channelCid,
      config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
      ownCapabilities: const [ChannelCapability.readEvents],
    ),
  );
}

void main() {
  group('`.sendReaction`', () {
    channelTest(
      'should work fine',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
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
          user: tester.currentUser,
        );

        tester.mockApi(
          (api) => api.message.sendReaction(message.id, reaction),
          result: createDefaultSendReactionResponse(message: message, reaction: reaction),
        );

        final messagesEmission = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
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

        final res = await tester.channel.sendReaction(message, reaction);

        expect(res, isNotNull);
        expect(res.reaction.type, type);
        expect(res.reaction.messageId, message.id);
        expect(res.reaction.emojiCode, emojiCode);
        expect(res.reaction.score, score);

        tester.verifyApi((api) => api.message.sendReaction(message.id, reaction));

        await messagesEmission;
      },
    );

    channelTest(
      'should restore previous message if `client.sendReaction` throws',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        const type = 'test-reaction-type';
        final message = Message(
          id: 'test-message-id',
          state: MessageState.sent,
        );

        final reaction = Reaction(
          type: type,
          messageId: message.id,
          user: tester.currentUser,
        );

        tester.mockApiFailure(
          (api) => api.message.sendReaction(message.id, reaction),
          error: createDefaultNetworkError(errorCode: ChatErrorCode.inputError),
        );

        final messagesEmission = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
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
          await tester.channel.sendReaction(message, reaction);
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());
        }

        tester.verifyApi((api) => api.message.sendReaction(message.id, reaction));

        await messagesEmission;
      },
    );

    channelTest(
      'should override previous reaction if present and `enforceUnique` is true',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        const messageId = 'test-message-id';
        const prevType = 'test-reaction-type';
        final prevReaction = Reaction(
          type: prevType,
          messageId: messageId,
          user: tester.currentUser,
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
          user: tester.currentUser,
        );
        final newMessage = message.copyWith(
          ownReactions: [newReaction],
          latestReactions: [newReaction],
        );

        const enforceUnique = true;

        tester.mockApi(
          (api) => api.message.sendReaction(
            messageId,
            newReaction,
            enforceUnique: enforceUnique,
          ),
          result: createDefaultSendReactionResponse(message: newMessage, reaction: newReaction),
        );

        final messagesEmission = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
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

        final res = await tester.channel.sendReaction(
          message,
          newReaction,
          enforceUnique: enforceUnique,
        );

        expect(res, isNotNull);
        expect(res.reaction.type, type);
        expect(res.reaction.messageId, messageId);

        tester.verifyApi(
          (api) => api.message.sendReaction(
            messageId,
            newReaction,
            enforceUnique: enforceUnique,
          ),
        );

        await messagesEmission;
      },
    );
  });

  group('`.sendReaction in thread`', () {
    channelTest(
      'should work fine',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        const type = 'test-reaction-type';
        final message = Message(
          id: 'test-message-id',
          parentId: 'test-parent-id', // is thread message
          state: MessageState.sent,
        );

        final reaction = Reaction(
          type: type,
          messageId: message.id,
          user: tester.currentUser,
        );

        tester.mockApi(
          (api) => api.message.sendReaction(message.id, reaction),
          result: createDefaultSendReactionResponse(message: message, reaction: reaction),
        );

        final threadsEmission = expectLater(
          tester.channelState?.threadsStream
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

        final res = await tester.channel.sendReaction(message, reaction);

        expect(res, isNotNull);
        expect(res.reaction.type, type);
        expect(res.reaction.messageId, message.id);

        tester.verifyApi((api) => api.message.sendReaction(message.id, reaction));

        await threadsEmission;
      },
    );

    channelTest(
      'should restore previous thread message if `client.sendReaction` throws',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        const type = 'test-reaction-type';
        final message = Message(
          id: 'test-message-id',
          parentId: 'test-parent-id', // is thread message
          state: MessageState.sent,
          // `Message.createdAt` falls back to `DateTime.now()` per call
          // when not provided, which breaks merge/sort keyed on createdAt.
          createdAt: DateTime.utc(2021, 3),
        );

        final reaction = Reaction(
          type: type,
          messageId: message.id,
          user: tester.currentUser,
        );

        tester.mockApiFailure(
          (api) => api.message.sendReaction(message.id, reaction),
          error: createDefaultNetworkError(errorCode: ChatErrorCode.inputError),
        );

        final threadsEmission = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.threadsStream.skip(1).map((event) => event['test-parent-id']),
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
          await tester.channel.sendReaction(message, reaction);
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());
        }

        tester.verifyApi((api) => api.message.sendReaction(message.id, reaction));

        await threadsEmission;
      },
    );

    channelTest(
      'should override previous thread reaction if present and `enforceUnique` is true',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        const messageId = 'test-message-id';
        const parentId = 'test-parent-id';
        const prevType = 'test-reaction-type';
        final prevReaction = Reaction(
          type: prevType,
          messageId: messageId,
          user: tester.currentUser,
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
          user: tester.currentUser,
        );
        final newMessage = message.copyWith(
          ownReactions: [newReaction],
          latestReactions: [newReaction],
        );

        const enforceUnique = true;

        tester.mockApi(
          (api) => api.message.sendReaction(
            messageId,
            newReaction,
            enforceUnique: enforceUnique,
          ),
          result: createDefaultSendReactionResponse(message: newMessage, reaction: newReaction),
        );

        final threadsEmission = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.threadsStream.skip(1).map((event) => event['test-parent-id']),
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

        final res = await tester.channel.sendReaction(
          message,
          newReaction,
          enforceUnique: enforceUnique,
        );

        expect(res, isNotNull);
        expect(res.reaction.type, type);
        expect(res.reaction.messageId, messageId);

        tester.verifyApi(
          (api) => api.message.sendReaction(
            messageId,
            newReaction,
            enforceUnique: enforceUnique,
          ),
        );

        await threadsEmission;
      },
    );
  });

  group('`.deleteReaction`', () {
    channelTest(
      'should work fine',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
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

        tester.mockApi(
          (api) => api.message.deleteReaction(messageId, type),
          result: createDefaultEmptyResponse(),
        );

        final messagesEmission = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
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

        final res = await tester.channel.deleteReaction(message, reaction);

        expect(res, isNotNull);

        tester.verifyApi((api) => api.message.deleteReaction(messageId, type));

        await messagesEmission;
      },
    );

    channelTest(
      'should restore prev message state if `client.deleteReaction` throws',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
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

        tester.mockApiFailure(
          (api) => api.message.deleteReaction(messageId, type),
          error: createDefaultNetworkError(errorCode: ChatErrorCode.inputError),
        );

        final messagesEmission = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
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
          await tester.channel.deleteReaction(message, reaction);
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());
        }

        tester.verifyApi((api) => api.message.deleteReaction(messageId, type));

        await messagesEmission;
      },
    );
  });

  group('`.deleteReaction in thread`', () {
    channelTest(
      'should work fine',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
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
          createdAt: DateTime.utc(2021, 3),
        );

        tester.mockApi(
          (api) => api.message.deleteReaction(messageId, type),
          result: createDefaultEmptyResponse(),
        );

        final threadsEmission = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.threadsStream.skip(1).map((event) => event['test-parent-id']),
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

        final res = await tester.channel.deleteReaction(message, reaction);

        expect(res, isNotNull);

        tester.verifyApi((api) => api.message.deleteReaction(messageId, type));

        await threadsEmission;
      },
    );

    channelTest(
      'should restore prev message state if `client.deleteReaction` throws',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
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
          createdAt: DateTime.utc(2021, 3),
        );

        tester.mockApiFailure(
          (api) => api.message.deleteReaction(messageId, type),
          error: createDefaultNetworkError(errorCode: ChatErrorCode.inputError),
        );

        final threadsEmission = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.threadsStream.skip(1).map((event) => event['test-parent-id']),
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
          await tester.channel.deleteReaction(message, reaction);
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());
        }

        tester.verifyApi((api) => api.message.deleteReaction(messageId, type));

        await threadsEmission;
      },
    );
  });
}
