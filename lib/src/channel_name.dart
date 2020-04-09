import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

import 'stream_channel.dart';

/// It shows the current [Channel] name using a [Text] widget.
///
/// The widget uses a [StreamBuilder] to render the channel information image as soon as it updates.
class ChannelName extends StatelessWidget {
  /// Instantiate a new ChannelName
  const ChannelName({
    Key key,
    this.channel,
    this.textStyle,
  }) : super(key: key);

  /// The channel to show the name of
  final Channel channel;

  /// The style of the text displayed
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    final channel = this.channel ?? StreamChannel.of(context).channel;
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
