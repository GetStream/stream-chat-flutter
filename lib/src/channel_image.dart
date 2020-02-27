import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ChannelImage extends StatelessWidget {
  const ChannelImage({
    Key key,
    @required this.channel,
    this.size = 40,
  }) : super(key: key);

  final Channel channel;
  final double size;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
        stream: channel.extraDataStream,
        initialData: channel.extraData,
        builder: (context, snapshot) {
          return Container(
            padding: const EdgeInsets.all(4),
            constraints: StreamChatTheme.of(context)
                .channelPreviewTheme
                .avatarTheme
                .constraints,
            decoration: BoxDecoration(
              borderRadius: StreamChatTheme.of(context)
                  .channelPreviewTheme
                  .avatarTheme
                  .borderRadius,
              color: StreamChatTheme.of(context).accentColor,
            ),
            child: snapshot.data?.containsKey('image') ?? false
                ? CachedNetworkImage(
                    imageUrl: snapshot.data['image'],
                    errorWidget: (_, __, ___) {
                      return Center(
                        child: Text(snapshot.data?.containsKey('name') ?? false
                            ? snapshot.data['name'][0]
                            : ''),
                      );
                    },
                    fit: BoxFit.cover,
                  )
                : SizedBox(),
          );
        });
  }
}
