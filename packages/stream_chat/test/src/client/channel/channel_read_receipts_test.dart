import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

ChannelState Function(ChannelState) _seedChannel({
  List<ChannelCapability> ownCapabilities = const [],
}) {
  return (_) => createDefaultChannelState(
    channel: createDefaultChannelModel(
      cid: _channelCid,
      ownCapabilities: ownCapabilities,
    ),
  );
}

void main() {
  group('Read Receipts', () {
    channelTest(
      ".markRead should throw if we don't have the capability",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        // no readEvents capability
        modifyResponse: _seedChannel(ownCapabilities: []),
      ),
      body: (tester) async {
        await expectLater(
          tester.channel.markRead(messageId: 'message-id-123'),
          throwsA(isA<StreamChatError>()),
        );
      },
    );

    channelTest(
      '.markRead should succeed if we have the capability',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(
          ownCapabilities: [ChannelCapability.readEvents],
        ),
      ),
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.markRead(
            _channelId,
            _channelType,
            messageId: 'message-id-123',
          ),
          result: createDefaultEmptyResponse(),
        );

        await expectLater(
          tester.channel.markRead(messageId: 'message-id-123'),
          completes,
        );

        tester.verifyApi(
          (api) => api.channel.markRead(
            _channelId,
            _channelType,
            messageId: 'message-id-123',
          ),
        );
      },
    );

    channelTest(
      ".markUnread should throw if we don't have the capability",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        // no readEvents capability
        modifyResponse: _seedChannel(ownCapabilities: []),
      ),
      body: (tester) async {
        await expectLater(
          tester.channel.markUnread('message-id-123'),
          throwsA(isA<StreamChatError>()),
        );
      },
    );

    channelTest(
      '.markUnread should succeed if we have the capability',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(
          ownCapabilities: [ChannelCapability.readEvents],
        ),
      ),
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.markUnread(
            _channelId,
            _channelType,
            'message-id-123',
          ),
          result: createDefaultEmptyResponse(),
        );

        await expectLater(
          tester.channel.markUnread('message-id-123'),
          completes,
        );

        tester.verifyApi(
          (api) => api.channel.markUnread(
            _channelId,
            _channelType,
            'message-id-123',
          ),
        );
      },
    );

    channelTest(
      ".markUnreadByTimestamp should throw if we don't have the capability",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        // no readEvents capability
        modifyResponse: _seedChannel(ownCapabilities: []),
      ),
      body: (tester) async {
        final timestamp = DateTime.parse('2024-01-01T00:00:00Z');

        await expectLater(
          tester.channel.markUnreadByTimestamp(timestamp),
          throwsA(isA<StreamChatError>()),
        );
      },
    );

    channelTest(
      '.markUnreadByTimestamp should succeed if we have the capability',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(
          ownCapabilities: [ChannelCapability.readEvents],
        ),
      ),
      body: (tester) async {
        final timestamp = DateTime.parse('2024-01-01T00:00:00Z');

        tester.mockApi(
          (api) => api.channel.markUnreadByTimestamp(
            _channelId,
            _channelType,
            timestamp,
          ),
          result: createDefaultEmptyResponse(),
        );

        await expectLater(
          tester.channel.markUnreadByTimestamp(timestamp),
          completes,
        );

        tester.verifyApi(
          (api) => api.channel.markUnreadByTimestamp(
            _channelId,
            _channelType,
            timestamp,
          ),
        );
      },
    );

    channelTest(
      ".markThreadRead should throw if we don't have the capability",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        // no readEvents capability
        modifyResponse: _seedChannel(ownCapabilities: []),
      ),
      body: (tester) async {
        await expectLater(
          tester.channel.markThreadRead('thread-id-123'),
          throwsA(isA<StreamChatError>()),
        );
      },
    );

    channelTest(
      '.markThreadRead should succeed if we have the capability',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(
          ownCapabilities: [ChannelCapability.readEvents],
        ),
      ),
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.markThreadRead(
            _channelId,
            _channelType,
            'thread-id-123',
          ),
          result: createDefaultEmptyResponse(),
        );

        await expectLater(
          tester.channel.markThreadRead('thread-id-123'),
          completes,
        );

        tester.verifyApi(
          (api) => api.channel.markThreadRead(
            _channelId,
            _channelType,
            'thread-id-123',
          ),
        );
      },
    );

    channelTest(
      ".markThreadUnread should throw if we don't have the capability",
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        // no readEvents capability
        modifyResponse: _seedChannel(ownCapabilities: []),
      ),
      body: (tester) async {
        await expectLater(
          tester.channel.markThreadUnread('thread-id-123'),
          throwsA(isA<StreamChatError>()),
        );
      },
    );

    channelTest(
      '.markThreadUnread should succeed if we have the capability',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(
          ownCapabilities: [ChannelCapability.readEvents],
        ),
      ),
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.markThreadUnread(
            _channelId,
            _channelType,
            'thread-id-123',
          ),
          result: createDefaultEmptyResponse(),
        );

        await expectLater(
          tester.channel.markThreadUnread('thread-id-123'),
          completes,
        );

        tester.verifyApi(
          (api) => api.channel.markThreadUnread(
            _channelId,
            _channelType,
            'thread-id-123',
          ),
        );
      },
    );
  });
}
