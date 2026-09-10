import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

ChannelState _seedChannel(ChannelState _) => createDefaultChannelState(
  channel: createDefaultChannelModel(cid: _channelCid),
);

void main() {
  group('Channel push preference events', () {
    channelTest(
      'should handle channel.push_preference.updated event',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        // Verify initial state
        expect(tester.channelState?.channelState.pushPreferences, isNull);

        // Create channel push preference
        final channelPushPreference = ChannelPushPreference(
          chatLevel: ChatLevel.mentions,
          disabledUntil: DateTime.utc(2021, 3),
        );

        // Dispatch channel.push_preference.updated event
        await tester.emitEvent(
          createDefaultEvent(
            type: EventType.channelPushPreferenceUpdated,
            cid: tester.channel.cid,
            channelPushPreference: channelPushPreference,
          ),
        );

        // Verify channel push preferences were updated
        final updatedPreferences = tester.channelState?.channelState.pushPreferences;
        expect(updatedPreferences, isNotNull);
        expect(updatedPreferences?.chatLevel, ChatLevel.mentions);
        expect(
          updatedPreferences?.disabledUntil,
          channelPushPreference.disabledUntil,
        );
      },
    );

    channelTest(
      'should update existing channel push preferences',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        // Set initial push preferences
        const initialPushPreference = ChannelPushPreference(
          chatLevel: ChatLevel.all,
        );

        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(
            pushPreferences: initialPushPreference,
          ),
        );

        // Verify initial state
        final pushPreferences = tester.channelState?.channelState.pushPreferences;
        expect(pushPreferences?.chatLevel, ChatLevel.all);
        expect(pushPreferences?.disabledUntil, isNull);

        // Create updated channel push preference
        final updatedPushPreference = ChannelPushPreference(
          chatLevel: ChatLevel.none,
          disabledUntil: DateTime.utc(2021, 4),
        );

        // Dispatch channel.push_preference.updated event
        await tester.emitEvent(
          createDefaultEvent(
            type: EventType.channelPushPreferenceUpdated,
            cid: tester.channel.cid,
            channelPushPreference: updatedPushPreference,
          ),
        );

        // Verify channel push preferences were updated
        final updatedPreferences = tester.channelState?.channelState.pushPreferences;
        expect(updatedPreferences?.chatLevel, ChatLevel.none);
        expect(
          updatedPreferences?.disabledUntil,
          updatedPushPreference.disabledUntil,
        );
      },
    );

    channelTest(
      'an event without a push preference is ignored',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        await tester.emitEvent(
          createDefaultEvent(type: EventType.channelPushPreferenceUpdated, cid: tester.channel.cid),
        );

        expect(tester.channelState?.channelState.pushPreferences, isNull);
      },
    );
  });
}
