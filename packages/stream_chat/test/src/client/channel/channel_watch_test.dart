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

// Builds the channel already initialized from state — the `.watch` tests
// exercise `queryChannel` themselves, so they cannot seed through
// `tester.watch()` without polluting the call counts they verify.
Channel _buildInitializedChannel(StreamChatClient client) {
  return Channel.fromState(
    client,
    createDefaultChannelState(
      channel: createDefaultChannelModel(
        cid: _channelCid,
        config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
        ownCapabilities: [ChannelCapability.readEvents],
      ),
    ),
  );
}

void main() {
  group('`.watch`', () {
    channelTest(
      'should work fine',
      channelType: _channelType,
      channelId: _channelId,
      build: _buildInitializedChannel,
      body: (tester) async {
        tester.mockApi(
          (api) => api.channel.queryChannel(
            _channelType,
            channelId: _channelId,
            channelData: tester.channel.extraData,
            state: true,
            watch: true,
            presence: false,
          ),
          result: createDefaultChannelState(
            channel: createDefaultChannelModel(cid: _channelCid),
          ),
        );

        final res = await tester.channel.watch();

        expect(res, isNotNull);
        expect(res.channel, isNotNull);
        expect(res.channel?.cid, _channelCid);

        tester.verifyApi(
          (api) => api.channel.queryChannel(
            _channelType,
            channelId: _channelId,
            channelData: tester.channel.extraData,
            state: true,
            watch: true,
            presence: false,
          ),
        );
      },
    );

    channelTest(
      'a successful retry after a failed init reconciles '
      '`initialized` and `state`',
      channelType: _channelType,
      channelId: _channelId,
      body: (tester) async {
        final freshChannel = tester.channel;

        tester.mockApiFailureOnce(
          (api) => api.channel.queryChannel(
            _channelType,
            channelId: _channelId,
            channelData: freshChannel.extraData,
            state: true,
            watch: true,
            presence: false,
          ),
          error: createDefaultNetworkError(errorCode: ChatErrorCode.inputError),
          result: createDefaultChannelState(
            channel: createDefaultChannelModel(cid: _channelCid),
          ),
        );

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
      },
    );

    channelTest(
      'should rethrow if `.query` throws',
      channelType: _channelType,
      channelId: _channelId,
      build: _buildInitializedChannel,
      body: (tester) async {
        tester.mockApiFailure(
          (api) => api.channel.queryChannel(
            _channelType,
            channelId: _channelId,
            channelData: tester.channel.extraData,
            state: true,
            watch: true,
            presence: false,
          ),
          error: createDefaultNetworkError(errorCode: ChatErrorCode.inputError),
        );

        try {
          await tester.channel.watch();
        } catch (e) {
          expect(e, isA<StreamChatNetworkError>());
        }

        tester.verifyApi(
          (api) => api.channel.queryChannel(
            _channelType,
            channelId: _channelId,
            channelData: tester.channel.extraData,
            state: true,
            watch: true,
            presence: false,
          ),
        );
      },
    );
  });

  channelTest(
    '`.stopWatching`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
    body: (tester) async {
      tester.mockApi(
        (api) => api.channel.stopWatching(_channelId, _channelType),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.channel.stopWatching();

      expect(res, isNotNull);

      tester.verifyApi(
        (api) => api.channel.stopWatching(_channelId, _channelType),
      );
    },
  );
}
