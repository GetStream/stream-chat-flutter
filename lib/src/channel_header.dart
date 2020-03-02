import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/channel_name.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:timeago/timeago.dart' as timeago;

import './channel_name.dart';
import 'channel_image.dart';
import 'stream_channel.dart';

/// Channel header
///
/// [screenshot](https://github.com/GetStream/stream-chat-flutter/blob/master/screenshots/channel_header.png)
///
/// Usually you would use this widget as an [AppBar] inside a [Scaffold].
/// However you can also use it as a normal widget.
///
/// It shows the current [Channel] information.
///
/// Make sure to have a [StreamChannel] ancestor in order to provide the information about the channel.
/// Every part of the widget uses a [StreamBuilder] to render the channel information as soon as it updates.
///
/// By default the widget shows a backButton that calls [Navigator.pop].
/// You can disable this button using the [showBackButton] property of just override the behaviour
/// with [onBackPressed].
///
/// The widget components render the ui based on the first ancestor of type [StreamChatTheme] and on its [ChannelTheme.channelHeaderTheme] property.
/// Modify it to change the widget appearance.
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
      elevation: 1,
      leading: showBackButton ? _buildBackButton(context) : Container(),
      backgroundColor:
          StreamChatTheme.of(context).channelTheme.channelHeaderTheme.color,
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
            textStyle: StreamChatTheme.of(context)
                .channelTheme
                .channelHeaderTheme
                .title,
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
                style: StreamChatTheme.of(context)
                    .channelTheme
                    .channelHeaderTheme
                    .lastMessageAt,
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
