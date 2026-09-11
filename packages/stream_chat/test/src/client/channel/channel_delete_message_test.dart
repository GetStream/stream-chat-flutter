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
  group('`.deleteMessage`', () {
    channelTest(
      'should work fine',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        const messageId = 'test-message-id';
        final message = Message(
          id: messageId,
          createdAt: DateTime.utc(2021, 3),
          state: MessageState.sent,
        );

        tester.mockApi(
          (api) => api.message.deleteMessage(messageId, hard: false),
          result: createDefaultEmptyResponse(),
        );

        // A soft delete only updates a message already in the loaded window,
        // so seed it first — a delete must never insert a phantom record.
        tester.channelState?.addNewMessage(message);

        final messagesEmits = expectLater(
          // skip the seeded message -> [message]
          tester.channelState?.messagesStream.skip(1),
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

        final res = await tester.channel.deleteMessage(message);

        expect(res, isNotNull);

        await messagesEmits;

        tester.verifyApi(
          (api) => api.message.deleteMessage(messageId, hard: false),
        );
      },
    );

    channelTest(
      'should delete attachments for hard delete',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
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
          createdAt: DateTime.utc(2021, 3),
          state: MessageState.sent,
        );

        tester
          ..mockApi(
            (api) => api.message.deleteMessage(messageId, hard: true),
            result: createDefaultEmptyResponse(),
          )
          ..mockApi(
            (api) => api.fileUploader.deleteImage(any(), _channelId, _channelType),
            result: createDefaultEmptyResponse(),
          )
          ..mockApi(
            (api) => api.fileUploader.deleteFile(any(), _channelId, _channelType),
            result: createDefaultEmptyResponse(),
          );

        final res = await tester.channel.deleteMessage(message, hard: true);
        expect(res, isNotNull);

        tester
          ..verifyApi(
            (api) => api.message.deleteMessage(messageId, hard: true),
          )
          ..verifyApiCalled(
            (api) => api.fileUploader.deleteImage(any(), _channelId, _channelType),
            times: 2,
          )
          ..verifyApi(
            (api) => api.fileUploader.deleteFile(any(), _channelId, _channelType),
          );
      },
    );

    channelTest(
      'should hard delete the message if the state is sending or failed',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        const messageId = 'test-message-id';
        final message = Message(
          id: messageId,
          text: 'Hello World!',
          state: MessageState.sending,
        );

        final messagesEmits = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
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
        tester.channelState?.addNewMessage(message);

        final res = await tester.channel.deleteMessage(message);

        expect(res, isNotNull);

        await messagesEmits;

        tester.verifyNeverCalled(
          (api) => api.message.deleteMessage(messageId, hard: false),
        );
      },
    );
  });

  group('`.deleteMessageForMe`', () {
    channelTest(
      'should work fine',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        const messageId = 'test-message-id';
        final message = Message(
          id: messageId,
          createdAt: DateTime.utc(2021, 3),
          state: MessageState.sent,
        );

        tester.mockApi(
          (api) => api.message.deleteMessage(messageId, deleteForMe: true),
          result: createDefaultEmptyResponse(),
        );

        // A soft delete only updates a message already in the loaded window,
        // so seed it first — a delete must never insert a phantom record.
        tester.channelState?.addNewMessage(message);

        final messagesEmits = expectLater(
          // skip the seeded message -> [message]
          tester.channelState?.messagesStream.skip(1),
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

        final res = await tester.channel.deleteMessageForMe(message);

        expect(res, isNotNull);

        await messagesEmits;

        tester.verifyApi(
          (api) => api.message.deleteMessage(messageId, deleteForMe: true),
        );
      },
    );

    channelTest(
      'should hard delete the message if the state is sending or failed',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
      body: (tester) async {
        const messageId = 'test-message-id';
        final message = Message(
          id: messageId,
          text: 'Hello World!',
          state: MessageState.sending,
        );

        final messagesEmits = expectLater(
          // skipping first seed message list -> [] messages
          tester.channelState?.messagesStream.skip(1),
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
        tester.channelState?.addNewMessage(message);

        final res = await tester.channel.deleteMessageForMe(message);

        expect(res, isNotNull);

        await messagesEmits;

        tester.verifyNeverCalled(
          (api) => api.message.deleteMessage(messageId, deleteForMe: true),
        );
      },
    );
  });
}
