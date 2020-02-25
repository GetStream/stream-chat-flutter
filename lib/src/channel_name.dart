import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

class ChannelName extends StatelessWidget {
  const ChannelName({
    Key key,
    @required this.channel,
  }) : super(key: key);

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return Text(
      channel.extraData['name'] as String ?? channel.cid,
      style: Theme.of(context).textTheme.body2,
    );
  }
}
