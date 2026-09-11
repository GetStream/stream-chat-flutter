import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

ChannelState _seedChannel(ChannelState _) => createDefaultChannelState(
  channel: createDefaultChannelModel(cid: _channelCid),
);

void main() {
  group('Channel updated events', () {
    channelTest(
      'merges the event channel into the current channel model',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.channelUpdated,
            channel: createDefaultChannelModel(
              cid: _channelCid,
              memberCount: 42,
              extraData: const {'name': 'updated-name'},
            ),
          ),
        );

        expect(tester.channel.memberCount, 42);
        expect(tester.channel.extraData['name'], 'updated-name');
      },
    );

    channelTest(
      'replaces the member list with the event members',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(modifyResponse: _seedChannel),
      body: (tester) async {
        tester.channelState!.updateChannelState(
          tester.channelState!.channelState.copyWith(
            members: [
              Member(userId: 'member-1'),
              Member(userId: 'member-2'),
            ],
          ),
        );

        await tester.emitEvent(
          createDefaultEvent(
            cid: tester.channel.cid,
            type: EventType.channelUpdated,
            channel: createDefaultChannelModel(
              cid: _channelCid,
              members: [Member(userId: 'member-3')],
            ),
          ),
        );

        expect(tester.channelState!.channelState.members?.map((m) => m.userId), ['member-3']);
      },
    );
  });
}
