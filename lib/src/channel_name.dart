import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

class ChannelName extends StatelessWidget {
  const ChannelName({
    Key key,
    @required this.channel,
    this.textStyle,
  }) : super(key: key);

  final Channel channel;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: channel.extraDataStream,
      initialData: channel.extraData,
      builder: (context, snapshot) {
        return Text(
          snapshot.data != null
              ? (snapshot.data['name'] ?? channel.cid)
              : channel.cid,
          style: textStyle,
        );
      },
    );
  }
}
