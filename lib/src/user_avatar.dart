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
    this.onLongPress,
    this.showOnlineStatus = true,
    this.borderRadius,
    this.onlineIndicatorAlignment = Alignment.topRight,
    this.selected = false,
    this.selectionColor = const Color(0xFF006CFF),
    this.selectionThickness = 4,
  }) : super(key: key);

  final User user;
  final Alignment onlineIndicatorAlignment;
  final BoxConstraints constraints;
  final BorderRadius borderRadius;
  final BoxConstraints onlineIndicatorConstraints;
  final void Function(User) onTap;
  final void Function(User) onLongPress;
  final bool showOnlineStatus;
  final bool selected;
  final Color selectionColor;
  final double selectionThickness;

  @override
  Widget build(BuildContext context) {
    final hasImage = user.extraData?.containsKey('image') == true &&
        user.extraData['image'] != null &&
        user.extraData['image'] != '';
    final streamChatTheme = StreamChatTheme.of(context);

    Widget avatar = ClipRRect(
      clipBehavior: Clip.antiAlias,
      borderRadius: borderRadius ??
          streamChatTheme.ownMessageTheme.avatarTheme.borderRadius,
      child: Container(
        constraints: constraints ??
            streamChatTheme.ownMessageTheme.avatarTheme.constraints,
        decoration: BoxDecoration(
          color: streamChatTheme.accentColor,
        ),
        child: hasImage
            ? CachedNetworkImage(
                filterQuality: FilterQuality.high,
                imageUrl: user.extraData['image'],
                errorWidget: (_, __, ___) {
                  return streamChatTheme.defaultUserImage(context, user);
                },
                fit: BoxFit.cover,
              )
            : streamChatTheme.defaultUserImage(context, user),
      ),
    );
    if (selected) {
      avatar = ClipRRect(
        borderRadius: (borderRadius ??
                streamChatTheme.ownMessageTheme.avatarTheme.borderRadius) +
            BorderRadius.circular(selectionThickness),
        child: Container(
          color: selectionColor,
          child: Padding(
            padding: EdgeInsets.all(selectionThickness),
            child: avatar,
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: onTap != null ? () => onTap(user) : null,
      onLongPress: onLongPress != null ? () => onLongPress(user) : null,
      child: Stack(
        children: <Widget>[
          avatar,
          if (showOnlineStatus && user.online == true)
            Positioned.fill(
              child: Align(
                alignment: onlineIndicatorAlignment,
                child: Material(
                  type: MaterialType.circle,
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
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
