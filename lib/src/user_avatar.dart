import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

import '../stream_chat_flutter.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key key,
    @required this.user,
    this.radius = 16,
  }) : super(key: key);

  final User user;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      constraints:
          StreamChatTheme.of(context).ownMessageTheme.avatarTheme.constraints,
      decoration: BoxDecoration(
        borderRadius: StreamChatTheme.of(context)
            .ownMessageTheme
            .avatarTheme
            .borderRadius,
        color: StreamChatTheme.of(context).accentColor,
      ),
      child: user.extraData?.containsKey('image') ?? false
          ? CachedNetworkImage(
              imageUrl: user.extraData['image'],
              errorWidget: (_, __, ___) {
                return Center(
                  child: Text(user.extraData?.containsKey('name') ?? false
                      ? user.extraData['name'][0]
                      : ''),
                );
              },
              fit: BoxFit.cover,
            )
          : SizedBox(),
    );
  }
}
