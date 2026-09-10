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
      ownCapabilities: [ChannelCapability.readEvents],
    ),
  );
}

void main() {
  channelTest(
    '`.getReplies`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
    body: (tester) async {
      const parentId = 'test-parent-id';

      final messages = List.generate(
        3,
        (index) => Message(
          id: 'test-message-id-$index',
          parentId: parentId,
        ),
      );

      tester.mockApi(
        (api) => api.message.getReplies(parentId),
        result: createDefaultQueryRepliesResponse(messages: messages),
      );

      final res = await tester.channel.getReplies(parentId);

      expect(res, isNotNull);
      expect(res.messages.length, messages.length);
      expect(res.messages.every((it) => it.parentId == parentId), isTrue);

      tester.verifyApi((api) => api.message.getReplies(parentId));
    },
  );

  channelTest(
    '`.getReplies` keeps the parent message out of the thread',
    channelType: _channelType,
    channelId: _channelId,
    setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
    body: (tester) async {
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

      tester.mockApi(
        (api) => api.message.getReplies(parentId),
        result: createDefaultQueryRepliesResponse(messages: messages),
      );

      await tester.channel.getReplies(parentId);

      final threadMessages = tester.channelState!.threads[parentId];
      expect(threadMessages, isNotNull);
      expect(threadMessages!.length, messages.length - 1);
      expect(threadMessages.any((it) => it.id == parentId), isFalse);
    },
  );

  channelTest(
    '`.getReactions`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
    body: (tester) async {
      const messageId = 'test-message-id';

      final reactions = List.generate(
        3,
        (index) => Reaction(
          type: 'test-reaction-type-$index',
          messageId: messageId,
        ),
      );

      tester.mockApi(
        (api) => api.message.getReactions(messageId),
        result: createDefaultQueryReactionsResponse(reactions: reactions),
      );

      final res = await tester.channel.getReactions(messageId);

      expect(res, isNotNull);
      expect(res.reactions.length, reactions.length);
      expect(res.reactions.every((it) => it.messageId == messageId), isTrue);

      tester.verifyApi((api) => api.message.getReactions(messageId));
    },
  );

  channelTest(
    '`.getMessagesById`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
    body: (tester) async {
      final messages = List.generate(
        3,
        (index) => Message(id: 'test-message-id-$index'),
      );

      final messageIds = messages.map((it) => it.id).toList(growable: false);

      tester.mockApi(
        (api) => api.message.getMessagesById(_channelId, _channelType, messageIds),
        result: createDefaultGetMessagesByIdResponse(messages: messages),
      );

      final res = await tester.channel.getMessagesById(messageIds);

      expect(res, isNotNull);
      expect(res.messages.length, messageIds.length);

      tester.verifyApi(
        (api) => api.message.getMessagesById(_channelId, _channelType, messageIds),
      );
    },
  );

  channelTest(
    '`.translateMessage`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
    body: (tester) async {
      const messageId = 'test-message-id';
      const language = 'hi'; // Hindi
      const translatedMessageText = 'नमस्ते';

      final message = Message(id: messageId, text: 'Hello');
      tester.channelState!.updateMessage(message);

      final translatedMessage = message.copyWith(
        i18n: {'language': 'en', '${language}_text': translatedMessageText},
      );

      tester.mockApi(
        (api) => api.message.translateMessage(messageId, language),
        result: createDefaultTranslateMessageResponse(message: translatedMessage),
      );

      final res = await tester.channel.translateMessage(messageId, language);

      expect(res, isNotNull);
      expect(res.message.i18n, translatedMessage.i18n);

      // The translation is merged into the channel state, so callers don't
      // have to apply the response themselves.
      final stateMessage = tester.channelState!.messages.firstWhere((it) => it.id == messageId);
      expect(stateMessage.i18n, translatedMessage.i18n);

      tester.verifyApi((api) => api.message.translateMessage(messageId, language));
    },
  );
}
