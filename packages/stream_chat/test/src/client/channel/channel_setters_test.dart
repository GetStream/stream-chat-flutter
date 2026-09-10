import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

ChannelState _seedChannel(ChannelState _) => createDefaultChannelState(
  channel: createDefaultChannelModel(
    cid: _channelCid,
    config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
    ownCapabilities: [ChannelCapability.readEvents],
  ),
);

void main() {
  group('Non-Initialized Channel', () {
    channelTest(
      'should be able to set `extraData`',
      channelType: _channelType,
      channelId: _channelId,
      body: (tester) async {
        final channel = tester.channel;

        expect(channel.extraData.isEmpty, isTrue);

        expect(
          () => channel.extraData = {'name': 'test-channel-name'},
          returnsNormally,
        );

        expect(channel.extraData.isEmpty, isFalse);
        expect(channel.extraData.containsKey('name'), isTrue);
        expect(channel.extraData['name'], 'test-channel-name');
      },
    );

    channelTest(
      'should be able to get and set `image`',
      channelType: _channelType,
      channelId: _channelId,
      body: (tester) async {
        final channel = tester.channel;

        expect(channel.extraData.isEmpty, isTrue);

        const imageUrl = 'https://getstream.io/some-image';
        channel.image = imageUrl;

        expect(channel.image, imageUrl);
        expect(channel.extraData['image'], imageUrl);

        const newImage = 'https://getstream.io/new-image';
        final newChannelInstance = Channel(tester.client, _channelType, _channelId, image: newImage);

        expect(newChannelInstance.image, newImage);
        expect(newChannelInstance.extraData['image'], newImage);
      },
    );

    channelTest(
      'should be able to get and set `name`',
      channelType: _channelType,
      channelId: _channelId,
      body: (tester) async {
        final channel = tester.channel;

        expect(channel.extraData.isEmpty, isTrue);

        const name = 'Channel name';
        channel.name = name;

        expect(channel.name, name);
        expect(channel.extraData['name'], name);

        const newName = 'New channel name';
        final newChannelInstance = Channel(tester.client, _channelType, _channelId, name: newName);

        expect(newChannelInstance.name, newName);
        expect(newChannelInstance.extraData['name'], newName);
      },
    );

    channelTest(
      'setters remain usable after a failed watch()',
      channelType: _channelType,
      channelId: _channelId,
      body: (tester) async {
        final channel = tester.channel;

        // Make initialization fail.
        tester.mockApiFailure(
          (api) => api.channel.queryChannel(
            _channelType,
            channelId: _channelId,
            channelData: channel.extraData,
            state: true,
            watch: true,
            presence: false,
          ),
          error: createDefaultNetworkError(errorCode: ChatErrorCode.inputError),
        );

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
      },
    );
  });

  group('Initialized Channel', () {
    channelTest(
      'should throw if trying to set `extraData`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        try {
          tester.channel.extraData = {'name': 'test-channel-name'};
        } catch (e) {
          expect(e, isA<StateError>());
        }
      },
    );

    channelTest(
      'should throw if trying to set `image`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        try {
          tester.channel.image = 'https://stream.io/some-image';
        } catch (e) {
          expect(e, isA<StateError>());
        }
      },
    );

    channelTest(
      'should throw if trying to set `name`',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        try {
          tester.channel.name = 'New name';
        } catch (e) {
          expect(e, isA<StateError>());
        }
      },
    );
  });
}
