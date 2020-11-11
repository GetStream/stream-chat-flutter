import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

import '../stream_chat_flutter.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    Key key,
    @required this.user,
    this.constraints,
    this.onlineIndicatorConstraints,
    this.onTap,
    this.showOnlineStatus = true,
    this.borderRadius,
  }) : super(key: key);

  final User user;
  final BoxConstraints constraints;
  final BorderRadius borderRadius;
  final BoxConstraints onlineIndicatorConstraints;
  final void Function(User) onTap;
  final bool showOnlineStatus;

  @override
  Widget build(BuildContext context) {
    final hasImage = user.extraData?.containsKey('image') == true &&
        user.extraData['image'] != null &&
        user.extraData['image'] != '';
    return GestureDetector(
      onTap: onTap != null
          ? () {
              if (onTap != null) {
                onTap(user);
              }
            }
          : null,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: borderRadius ??
                StreamChatTheme.of(context)
                    .ownMessageTheme
                    .avatarTheme
                    .borderRadius,
            child: Container(
              constraints: constraints ??
                  StreamChatTheme.of(context)
                      .ownMessageTheme
                      .avatarTheme
                      .constraints,
              decoration: BoxDecoration(
                color: StreamChatTheme.of(context).accentColor,
              ),
              child: hasImage
                  ? CachedNetworkImage(
                      imageUrl: user.extraData['image'],
                      errorWidget: (_, __, ___) {
                        return Center(
                          child: Text(
                            user.extraData?.containsKey('name') ?? false
                                ? user.extraData['name'][0]
                                : '',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                      fit: BoxFit.cover,
                    )
                  : StreamChatTheme.of(context).defaultUserImage(context, user),
            ),
          ),
          if (showOnlineStatus && user.online == true)
            Positioned(
              top: 0,
              right: 0,
              child: Material(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(2.0),
                    constraints: onlineIndicatorConstraints ??
                        BoxConstraints.tightFor(
                          width: 12,
                          height: 12,
                        ),
                    child: Material(
                      shape: CircleBorder(),
                      color: Color(0xff20E070),
                    ),
                  ),
                ),
                shape: CircleBorder(),
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
