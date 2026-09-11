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
    '`.hide`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
    body: (tester) async {
      const clearHistory = true;

      tester.mockApi(
        (api) => api.channel.hideChannel(
          _channelId,
          _channelType,
          clearHistory: clearHistory,
        ),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.channel.hide(clearHistory: clearHistory);

      expect(res, isNotNull);

      tester.verifyApi(
        (api) => api.channel.hideChannel(
          _channelId,
          _channelType,
          clearHistory: clearHistory,
        ),
      );
    },
  );

  channelTest(
    '`.show`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
    body: (tester) async {
      tester.mockApi(
        (api) => api.channel.showChannel(_channelId, _channelType),
        result: createDefaultEmptyResponse(),
      );

      final res = await tester.channel.show();

      expect(res, isNotNull);

      tester.verifyApi(
        (api) => api.channel.showChannel(_channelId, _channelType),
      );
    },
  );

  // testing archiving
  channelTest(
    '`.archive`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
    body: (tester) async {
      tester.mockApi(
        (api) => api.channel.updateMemberPartial(
          channelId: _channelId,
          channelType: _channelType,
          set: {'archived': true},
        ),
        result: createDefaultPartialUpdateMemberResponse(),
      );

      final res = await tester.channel.archive();

      expect(res, isNotNull);

      tester.verifyApi(
        (api) => api.channel.updateMemberPartial(
          channelId: _channelId,
          channelType: _channelType,
          set: {'archived': true},
        ),
      );
    },
  );

  channelTest(
    '`.unarchive`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
    body: (tester) async {
      tester.mockApi(
        (api) => api.channel.updateMemberPartial(
          channelId: _channelId,
          channelType: _channelType,
          unset: ['archived'],
        ),
        result: createDefaultPartialUpdateMemberResponse(),
      );

      final res = await tester.channel.unarchive();

      expect(res, isNotNull);

      tester.verifyApi(
        (api) => api.channel.updateMemberPartial(
          channelId: _channelId,
          channelType: _channelType,
          unset: ['archived'],
        ),
      );
    },
  );

  // testing pinning
  channelTest(
    '`.pin`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
    body: (tester) async {
      tester.mockApi(
        (api) => api.channel.updateMemberPartial(
          channelId: _channelId,
          channelType: _channelType,
          set: {'pinned': true},
        ),
        result: createDefaultPartialUpdateMemberResponse(),
      );

      final res = await tester.channel.pin();

      expect(res, isNotNull);

      tester.verifyApi(
        (api) => api.channel.updateMemberPartial(
          channelId: _channelId,
          channelType: _channelType,
          set: {'pinned': true},
        ),
      );
    },
  );

  channelTest(
    '`.unpin`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
    body: (tester) async {
      tester.mockApi(
        (api) => api.channel.updateMemberPartial(
          channelId: _channelId,
          channelType: _channelType,
          unset: ['pinned'],
        ),
        result: createDefaultPartialUpdateMemberResponse(),
      );

      final res = await tester.channel.unpin();

      expect(res, isNotNull);

      tester.verifyApi(
        (api) => api.channel.updateMemberPartial(
          channelId: _channelId,
          channelType: _channelType,
          unset: ['pinned'],
        ),
      );
    },
  );

  channelTest(
    '`.on`',
    channelType: _channelType,
    channelId: _channelId,
    setUp: (tester) => tester.watch(modifyResponse: _seedChannel()),
    body: (tester) async {
      const eventType = 'test.event';
      final event = createDefaultEvent(type: eventType, cid: _channelCid);

      final eventReceived = expectLater(
        tester.channel.on(eventType),
        // The old suite asserted on the event instance itself, which held
        // because the event never left the process. Here it round-trips
        // through the real wire decode, so pin every field it carries.
        emitsInOrder([
          isA<Event>()
              .having((it) => it.type, 'type', event.type)
              .having((it) => it.cid, 'cid', event.cid)
              .having((it) => it.createdAt, 'createdAt', event.createdAt),
        ]),
      );

      await tester.emitEvent(event);

      await eventReceived;
    },
  );
}
