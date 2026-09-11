import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

Future<ChannelState> _seedChannel(ChannelTester tester) => tester.watch(
  modifyResponse: (_) => createDefaultChannelState(
    channel: createDefaultChannelModel(
      cid: _channelCid,
      config: createDefaultChannelConfig(readEvents: true, typingEvents: true),
      ownCapabilities: const [ChannelCapability.readEvents],
    ),
  ),
);

void main() {
  channelTest(
    '`.update`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: _seedChannel,
    body: (tester) async {
      const channelData = {
        'name': 'Stream Team',
        'profile_image': 'test-profile-image',
      };
      final updateMessage = Message(
        id: 'test-message-id',
        text: 'updated channel',
      );

      final channelModel = createDefaultChannelModel(
        cid: _channelCid,
        extraData: channelData,
      );

      tester.mockApi(
        (api) => api.channel.updateChannel(_channelId, _channelType, channelData, message: updateMessage),
        result: UpdateChannelResponse()
          ..channel = channelModel
          ..message = updateMessage,
      );

      final res = await tester.channel.update(
        channelData,
        updateMessage: updateMessage,
      );

      expect(res, isNotNull);
      expect(res.channel.cid, channelModel.cid);
      expect(res.channel.extraData, channelData);
      expect(res.message?.id, updateMessage.id);

      tester.verifyApi(
        (api) => api.channel.updateChannel(_channelId, _channelType, channelData, message: updateMessage),
      );
    },
  );

  channelTest(
    '`.updateImage`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: _seedChannel,
    body: (tester) async {
      const image = 'https://getstream.io/new-image';

      final channelModel = createDefaultChannelModel(
        cid: _channelCid,
        extraData: {'image': image},
      );

      tester.mockApi(
        (api) => api.channel.updateChannelPartial(
          _channelId,
          _channelType,
          set: {'image': image},
        ),
        result: createDefaultPartialUpdateChannelResponse(channel: channelModel),
      );

      final res = await tester.channel.updateImage(image);

      expect(res, isNotNull);
      expect(res.channel.extraData['image'], image);

      tester.verifyApi(
        (api) => api.channel.updateChannelPartial(
          _channelId,
          _channelType,
          set: {'image': image},
        ),
      );
    },
  );

  channelTest(
    '`.updateName`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: _seedChannel,
    body: (tester) async {
      const name = 'Name';

      final channelModel = createDefaultChannelModel(
        cid: _channelCid,
        extraData: {'name': name},
      );

      tester.mockApi(
        (api) => api.channel.updateChannelPartial(
          _channelId,
          _channelType,
          set: {'name': name},
        ),
        result: createDefaultPartialUpdateChannelResponse(channel: channelModel),
      );

      final res = await tester.channel.updateName(name);

      expect(res, isNotNull);
      expect(res.channel.extraData['name'], name);

      tester.verifyApi(
        (api) => api.channel.updateChannelPartial(
          _channelId,
          _channelType,
          set: {'name': name},
        ),
      );
    },
  );

  channelTest(
    '`.updatePartial`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: _seedChannel,
    body: (tester) async {
      const set = {
        'name': 'Stream Team',
        'profile_image': 'test-profile-image',
      };

      const unset = ['tag', 'last_name'];

      final channelModel = createDefaultChannelModel(
        cid: _channelCid,
        extraData: {
          'coolness': 999,
          ...set,
        },
      );

      tester.mockApi(
        (api) => api.channel.updateChannelPartial(
          _channelId,
          _channelType,
          set: set,
          unset: unset,
        ),
        result: createDefaultPartialUpdateChannelResponse(channel: channelModel),
      );

      final res = await tester.channel.updatePartial(set: set, unset: unset);

      expect(res, isNotNull);
      expect(res.channel.cid, channelModel.cid);
      expect(
        res.channel.extraData,
        {'coolness': 999, ...set},
      );

      tester.verifyApi(
        (api) => api.channel.updateChannelPartial(
          _channelId,
          _channelType,
          set: set,
          unset: unset,
        ),
      );
    },
  );

  channelTest(
    '`.delete`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: _seedChannel,
    body: (tester) async {
      tester.mockApi(
        (api) => api.channel.deleteChannel(_channelId, _channelType),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.channel.delete();

      expect(res, isNotNull);

      tester.verifyApi(
        (api) => api.channel.deleteChannel(_channelId, _channelType),
      );
    },
  );

  channelTest(
    '`.truncate`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: _seedChannel,
    body: (tester) async {
      tester.mockApi(
        (api) => api.channel.truncateChannel(_channelId, _channelType),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.channel.truncate();

      expect(res, isNotNull);

      tester.verifyApi(
        (api) => api.channel.truncateChannel(_channelId, _channelType),
      );
    },
  );
}
