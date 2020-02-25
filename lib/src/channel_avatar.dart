import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

class ChannelAvatar extends StatelessWidget {
  const ChannelAvatar({
    Key key,
    @required this.channel,
    this.radius = 20,
  }) : super(key: key);

  final Channel channel;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: channel.extraData.containsKey('image')
          ? CachedNetworkImageProvider(channel.extraData['image'])
          : null,
      child: channel.extraData.containsKey('image')
          ? null
          : Text(channel.extraData.containsKey('name')
              ? channel.extraData['name'][0]
              : ''),
    );
  }
}
