import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/channel_name.dart';
import 'package:timeago/timeago.dart' as timeago;

import './channel_name.dart';
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
    final channel = StreamChannel.of(context).channel;
    return AppBar(
      leading: showBackButton ? _buildBackButton(context) : Container(),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Stack(
            children: <Widget>[
              Center(child: ChannelImage(channel: channel)),
            ],
          ),
        ),
      ],
      centerTitle: true,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ChannelName(
            channel: channel,
          ),
          _buildLastActive(context, channel),
        ],
      ),
    );
  }

  Widget _buildLastActive(BuildContext context, Channel channel) {
    return StreamBuilder<DateTime>(
      stream: channel.lastMessageAtStream,
      initialData: channel.lastMessageAt,
      builder: (context, snapshot) {
        return (snapshot.data != null)
            ? Text(
                'Active ${timeago.format(snapshot.data)}',
                style: Theme.of(context).textTheme.caption,
              )
            : Container();
      },
    );
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
