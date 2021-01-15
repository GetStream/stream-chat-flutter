import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

class ChannelNameText extends StatelessWidget {
  const ChannelNameText({
    Key key,
    this.channel,
  }) : super(key: key);

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return Text(
      channel.extraData['name'] as String ?? channel.config.name,
      style: Theme.of(context).textTheme.body2,
    );
  }
}
