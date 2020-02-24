import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

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
    return CircleAvatar(
      radius: radius,
      backgroundImage: user.extraData.containsKey('image')
          ? CachedNetworkImageProvider(user.extraData['image'] as String)
          : null,
      child: user.extraData.containsKey('image')
          ? null
          : Text(user?.extraData?.containsKey('name') ?? false
              ? user.extraData['name'][0]
              : ''),
    );
  }
}
