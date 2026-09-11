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
    '`.mute`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
    body: (tester) async {
      tester.mockApi(
        (api) => api.moderation.muteChannel(_channelCid),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.channel.mute();

      expect(res, isNotNull);

      tester.verifyApi(
        (api) => api.moderation.muteChannel(_channelCid),
      );
    },
  );

  channelTest(
    '`.mute with expiration`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
    body: (tester) async {
      const expiration = Duration(seconds: 3);

      tester
        ..mockApi(
          (api) => api.moderation.muteChannel(_channelCid, expiration: expiration),
          result: createDefaultEmptyResponse(),
        )
        ..mockApi(
          (api) => api.moderation.unmuteChannel(_channelCid),
          result: createDefaultEmptyResponse(),
        );

      final res = await tester.channel.mute(expiration: expiration);

      expect(res, isNotNull);

      tester.verifyApi(
        (api) => api.moderation.muteChannel(_channelCid, expiration: expiration),
      );

      // wait for expiration
      await Future.delayed(expiration);
      tester.verifyApi((api) => api.moderation.unmuteChannel(_channelCid));
    },
  );

  channelTest(
    '`.unmute`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
    body: (tester) async {
      tester.mockApi(
        (api) => api.moderation.unmuteChannel(_channelCid),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.channel.unmute();

      expect(res, isNotNull);

      tester.verifyApi(
        (api) => api.moderation.unmuteChannel(_channelCid),
      );
    },
  );

  channelTest(
    '`.enableSlowMode`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
    body: (tester) async {
      const cooldown = 10;

      final channelModel = ChannelModel(
        cid: _channelCid,
        cooldown: cooldown,
      );

      tester.mockApi(
        (api) => api.channel.enableSlowdown(_channelId, _channelType, cooldown),
        result: createDefaultPartialUpdateChannelResponse(channel: channelModel),
      );

      final res = await tester.channel.enableSlowMode(cooldownInterval: 10);

      expect(res, isNotNull);

      tester.verifyApi(
        (api) => api.channel.enableSlowdown(_channelId, _channelType, cooldown),
      );
    },
  );

  channelTest(
    '`.disableSlowMode`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
    body: (tester) async {
      final channelModel = ChannelModel(
        cid: _channelCid,
      );

      tester.mockApi(
        (api) => api.channel.disableSlowdown(_channelId, _channelType),
        result: createDefaultPartialUpdateChannelResponse(channel: channelModel),
      );

      final res = await tester.channel.disableSlowMode();

      expect(res, isNotNull);

      tester.verifyApi(
        (api) => api.channel.disableSlowdown(_channelId, _channelType),
      );
    },
  );

  channelTest(
    '`.banUser`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
    body: (tester) async {
      const userId = 'test-user-id';
      const options = {'key': 'value'};

      tester.mockApi(
        (api) => api.moderation.banUser(
          userId,
          options: {'type': _channelType, 'id': _channelId, ...options},
        ),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.channel.banMember(userId, options);

      expect(res, isNotNull);

      tester.verifyApi(
        (api) => api.moderation.banUser(
          userId,
          options: {'type': _channelType, 'id': _channelId, ...options},
        ),
      );
    },
  );

  channelTest(
    '`.unbanUser`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
    body: (tester) async {
      const userId = 'test-user-id';

      tester.mockApi(
        (api) => api.moderation.unbanUser(
          userId,
          options: {'type': _channelType, 'id': _channelId},
        ),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.channel.unbanMember(userId);

      expect(res, isNotNull);

      tester.verifyApi(
        (api) => api.moderation.unbanUser(
          userId,
          options: {'type': _channelType, 'id': _channelId},
        ),
      );
    },
  );

  channelTest(
    '`.shadowBan`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
    body: (tester) async {
      const userId = 'test-user-id';
      const options = {'key': 'value'};

      tester.mockApi(
        (api) => api.moderation.banUser(
          userId,
          options: {'shadow': true, 'type': _channelType, 'id': _channelId, ...options},
        ),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.channel.shadowBan(userId, options);

      expect(res, isNotNull);

      tester.verifyApi(
        (api) => api.moderation.banUser(
          userId,
          options: {'shadow': true, 'type': _channelType, 'id': _channelId, ...options},
        ),
      );
    },
  );

  channelTest(
    '`.removeShadowBan`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
    body: (tester) async {
      const userId = 'test-user-id';

      tester.mockApi(
        (api) => api.moderation.unbanUser(
          userId,
          options: {'shadow': true, 'type': _channelType, 'id': _channelId},
        ),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.channel.removeShadowBan(userId);

      expect(res, isNotNull);

      tester.verifyApi(
        (api) => api.moderation.unbanUser(
          userId,
          options: {'shadow': true, 'type': _channelType, 'id': _channelId},
        ),
      );
    },
  );
}
