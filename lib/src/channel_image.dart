import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

class ChannelImage extends StatelessWidget {
  const ChannelImage({
    Key key,
    @required this.channel,
  }) : super(key: key);

  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundImage: channel.extraData.containsKey('image')
          ? CachedNetworkImageProvider(channel.extraData['image'] as String)
          : null,
      child: channel.extraData.containsKey('image')
          ? null
          : Text(channel.config.name[0]),
    );
  }
}
