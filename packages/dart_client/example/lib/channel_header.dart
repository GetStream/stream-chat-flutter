import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:timeago/timeago.dart' as timeago;

import './channel_name_text.dart';
import 'channel_image.dart';
import 'stream_channel.dart';

class ChannelHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final VoidCallback onBackPressed;

  ChannelHeader({
    Key key,
    this.showBackButton = true,
    this.onBackPressed,
  })  : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final streamChat = StreamChannel.of(context);
    return AppBar(
      leading: showBackButton ? _buildBackButton(context) : Container(),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: ChannelImage(channel: streamChat.channel),
        ),
      ],
      centerTitle: true,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ChannelNameText(
            channel: streamChat.channel,
          ),
          _buildLastActive(context, streamChat.channel),
        ],
      ),
    );
  }

  StatelessWidget _buildLastActive(BuildContext context, Channel channel) {
    return (channel.lastMessageAt != null)
        ? Text(
            'Active ${timeago.format(channel.lastMessageAt)}',
            style: Theme.of(context).textTheme.caption,
          )
        : Container();
  }

  Padding _buildBackButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: RawMaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        elevation: 0,
        highlightElevation: 0,
        focusElevation: 0,
        disabledElevation: 0,
        hoverElevation: 0,
        onPressed: () {
          if (onBackPressed != null) {
            onBackPressed();
          } else {
            Navigator.of(context).pop();
          }
        },
        fillColor: Colors.black.withOpacity(.1),
        padding: EdgeInsets.all(4),
        child: Icon(
          Icons.arrow_back_ios,
          size: 15,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  final Size preferredSize;
}
