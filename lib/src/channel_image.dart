import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

class ChannelImage extends StatelessWidget {
  const ChannelImage({
    Key key,
    @required this.channel,
    this.radius = 20,
  }) : super(key: key);

  final Channel channel;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
        stream: channel.extraDataStream,
        initialData: channel.extraData,
        builder: (context, snapshot) {
          return CircleAvatar(
            radius: radius,
            backgroundImage: snapshot.data?.containsKey('image') ?? false
                ? CachedNetworkImageProvider(snapshot.data['image'])
                : null,
            child: snapshot.data?.containsKey('image') ?? false
                ? null
                : Text(snapshot.data?.containsKey('name') ?? false
                    ? snapshot.data['name'][0]
                    : ''),
          );
        });
  }
}
