import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

const _channelId = 'test-channel-id';
const _channelType = 'test-channel-type';
const _channelCid = '$_channelType:$_channelId';

ChannelState Function(ChannelState) _seedChannel({
  List<String>? filterTags,
}) {
  return (_) => createDefaultChannelState(
    channel: createDefaultChannelModel(
      cid: _channelCid,
      filterTags: filterTags,
    ),
  );
}

void main() {
  group('Channel filterTags', () {
    channelTest(
      'should return filterTags from channel state',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(filterTags: ['tag1', 'tag2']),
      ),
      body: (tester) async {
        expect(tester.channel.filterTags, equals(['tag1', 'tag2']));
      },
    );

    channelTest(
      'should update filterTags when channel state is updated',
      channelType: _channelType,
      channelId: _channelId,
      setUp: (tester) => tester.watch(
        modifyResponse: _seedChannel(filterTags: ['tag1', 'tag2']),
      ),
      body: (tester) async {
        expect(tester.channel.filterTags, equals(['tag1', 'tag2']));

        final channelModel = tester.channelState!.channelState.channel!;
        final updatedChannel = channelModel.copyWith(
          filterTags: ['tag3', 'tag4', 'tag5'],
        );

        tester.channelState?.updateChannelState(
          tester.channelState!.channelState.copyWith(channel: updatedChannel),
        );

        expect(tester.channel.filterTags, equals(['tag3', 'tag4', 'tag5']));
      },
    );
  });
}
