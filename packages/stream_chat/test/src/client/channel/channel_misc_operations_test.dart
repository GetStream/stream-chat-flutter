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
    '`.deleteFile`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
    body: (tester) async {
      const url = 'test-file-url';

      tester.mockApi(
        (api) => api.fileUploader.deleteFile(url, _channelId, _channelType),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.channel.deleteFile(url);

      expect(res, isNotNull);

      tester.verifyApi(
        (api) => api.fileUploader.deleteFile(url, _channelId, _channelType),
      );
    },
  );

  channelTest(
    '`.deleteImage`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
    body: (tester) async {
      const url = 'test-image-url';

      tester.mockApi(
        (api) => api.fileUploader.deleteImage(url, _channelId, _channelType),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.channel.deleteImage(url);

      expect(res, isNotNull);

      tester.verifyApi(
        (api) => api.fileUploader.deleteImage(url, _channelId, _channelType),
      );
    },
  );

  channelTest(
    '`.stopAIResponse`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
    body: (tester) async {
      final stopAIEvent = Event(type: EventType.aiIndicatorStop);

      tester.mockApi(
        (api) => api.channel.sendEvent(
          _channelId,
          _channelType,
          any(that: isSameEventAs(stopAIEvent)),
        ),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.channel.stopAIResponse();

      expect(res, isNotNull);

      tester.verifyApi(
        (api) => api.channel.sendEvent(
          _channelId,
          _channelType,
          any(that: isSameEventAs(stopAIEvent)),
        ),
      );
    },
  );

  channelTest(
    '`.sendEvent`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
    body: (tester) async {
      final event = Event(type: 'event.local');

      tester.mockApi(
        (api) => api.channel.sendEvent(
          _channelId,
          _channelType,
          any(that: isSameEventAs(event)),
        ),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.channel.sendEvent(event);

      expect(res, isNotNull);

      tester.verifyApi(
        (api) => api.channel.sendEvent(
          _channelId,
          _channelType,
          any(that: isSameEventAs(event)),
        ),
      );
    },
  );
}
