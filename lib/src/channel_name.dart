import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stream_chat/stream_chat.dart';

import '../stream_chat_flutter.dart';
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
    final client = StreamChat.of(context);
    final channel = this.channel ?? StreamChannel.of(context).channel;
    return LayoutBuilder(
      builder: (context, constraints) {
        return StreamBuilder<Map<String, dynamic>>(
          stream: channel.extraDataStream,
          initialData: channel.extraData,
          builder: (context, snapshot) {
            String title;
            if (snapshot.data['name'] == null) {
              final otherMembers = channel.state.members
                  .where((member) => member.userId != client.user.id);
              if (otherMembers.isNotEmpty) {
                final maxWidth = constraints.maxWidth;
                final maxChars = maxWidth / textStyle.fontSize;
                int currentChars = 0;
                final currentMembers = <Member>[];
                otherMembers.forEach((element) {
                  final newLength = currentChars + element.user.name.length;
                  if (newLength < maxChars) {
                    currentChars = newLength;
                    currentMembers.add(element);
                  }
                });

                final exceedingMembers =
                    otherMembers.length - currentMembers.length;
                title =
                    '${currentMembers.map((e) => e.user.name).join(', ')} ${exceedingMembers > 0 ? '+ $exceedingMembers' : ''}';
              } else {
                title = channel.id;
              }
            } else {
              title = snapshot.data['name'];
            }

            return Text(
              title,
              style: textStyle,
              overflow: TextOverflow.ellipsis,
            );
          },
        );
      },
    );
  }
}
