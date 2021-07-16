import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// Widget that displays a user avatar
class UserAvatar extends StatelessWidget {
  /// Constructor to create a [UserAvatar]
  const UserAvatar({
    Key? key,
    required this.user,
    this.constraints,
    this.onlineIndicatorConstraints,
    this.onTap,
    this.onLongPress,
    this.showOnlineStatus = true,
    this.borderRadius,
    this.onlineIndicatorAlignment = Alignment.topRight,
    this.selected = false,
    this.selectionColor,
    this.selectionThickness = 4,
  }) : super(key: key);

  /// User whose avatar is to displayed
  final User user;

  /// Alignment of the online indicator
  final Alignment onlineIndicatorAlignment;

  /// Size of the avatar
  final BoxConstraints? constraints;

  /// [BorderRadius] of the image
  final BorderRadius? borderRadius;

  /// Size of the online indicator
  final BoxConstraints? onlineIndicatorConstraints;

  /// Callback when avatar is tapped
  final void Function(User)? onTap;

  /// Callback when avatar is long pressed
  final void Function(User)? onLongPress;

  /// Flag for showing online status
  final bool showOnlineStatus;

  /// Flag for if avatar is selected
  final bool selected;

  /// Color of selection
  final Color? selectionColor;

  /// Selection thickness around the avatar
  final double selectionThickness;

  @override
  Widget build(BuildContext context) {
    final hasImage = user.extraData.containsKey('image') &&
        user.extraData['image'] != null &&
        user.extraData['image'] != '';
    final streamChatTheme = StreamChatTheme.of(context);

    Widget avatar = FittedBox(
      fit: BoxFit.cover,
      child: ClipRRect(
        borderRadius: borderRadius ??
            streamChatTheme.ownMessageTheme.avatarTheme?.borderRadius,
        child: Container(
          constraints: constraints ??
              streamChatTheme.ownMessageTheme.avatarTheme?.constraints,
          decoration: BoxDecoration(
            color: streamChatTheme.colorTheme.accentPrimary,
          ),
          child: hasImage
              ? CachedNetworkImage(
                  filterQuality: FilterQuality.high,
                  // ignore: cast_nullable_to_non_nullable
                  imageUrl: user.extraData['image'] as String,
                  errorWidget: (_, __, ___) =>
                      streamChatTheme.defaultUserImage(context, user),
                  fit: BoxFit.cover,
                )
              : streamChatTheme.defaultUserImage(context, user),
        ),
      ),
    );

    if (selected) {
      avatar = ClipRRect(
        borderRadius: (borderRadius ??
                streamChatTheme.ownMessageTheme.avatarTheme?.borderRadius ??
                BorderRadius.zero) +
            BorderRadius.circular(selectionThickness),
        child: Container(
          constraints: constraints ??
              streamChatTheme.ownMessageTheme.avatarTheme?.constraints,
          color: selectionColor ?? streamChatTheme.colorTheme.accentPrimary,
          child: Padding(
            padding: EdgeInsets.all(selectionThickness),
            child: avatar,
          ),
        ),
      );
    }
    return GestureDetector(
      onTap: onTap != null ? () => onTap!(user) : null,
      onLongPress: onLongPress != null ? () => onLongPress!(user) : null,
      child: Stack(
        children: <Widget>[
          avatar,
          if (showOnlineStatus && user.online)
            Positioned.fill(
              child: Align(
                alignment: onlineIndicatorAlignment,
                child: Material(
                  type: MaterialType.circle,
                  color: streamChatTheme.colorTheme.barsBg,
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    constraints: onlineIndicatorConstraints ??
                        const BoxConstraints.tightFor(
                          width: 8,
                          height: 8,
                        ),
                    child: Material(
                      shape: const CircleBorder(),
                      color: streamChatTheme.colorTheme.accentInfo,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
