import 'package:meta/meta.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

Matcher isSameChannelAs(Channel targetChannel) =>
    _IsSameChannelAs(targetChannel: targetChannel);

class _IsSameChannelAs extends Matcher {
  const _IsSameChannelAs({
    @required this.targetChannel,
  }) : assert(targetChannel != null, '');

  final Channel targetChannel;

  @override
  bool matches(covariant Channel channel, Map matchState) =>
      channel.cid == targetChannel.cid;

  @override
  Description describe(Description description) =>
      description.add('is same channel as $targetChannel');
}

Matcher isSameChannelListAs(List<Channel> targetChannelList) =>
    _IsSameChannelListAs(targetChannelList: targetChannelList);

class _IsSameChannelListAs extends Matcher {
  const _IsSameChannelListAs({
    @required this.targetChannelList,
  }) : assert(targetChannelList != null, '');

  final List<Channel> targetChannelList;

  @override
  bool matches(covariant List<Channel> channelList, Map matchState) {
    bool matches = true;
    for (var i = 0; i < channelList.length; i++) {
      final channel = channelList[i];
      final targetChannel = targetChannelList[i];
      matches = isSameChannelAs(targetChannel).matches(channel, matchState);
      if (!matches) break;
    }
    return matches;
  }

  @override
  Description describe(Description description) =>
      description.add('is same channelList as $targetChannelList');
}
