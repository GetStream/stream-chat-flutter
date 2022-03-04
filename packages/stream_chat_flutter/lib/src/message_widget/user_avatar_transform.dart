import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class UserAvatarTransform extends StatelessWidget {
  const UserAvatarTransform({
    Key? key,
    required this.translateUserAvatar,
    required this.messageTheme,
    required this.message,
    this.userAvatarBuilder,
    this.onUserAvatarTap,
  }) : super(key: key);

  /// Center user avatar with bottom of the message
  final bool translateUserAvatar;

  /// The message theme
  final MessageThemeData messageTheme;

  /// Widget builder for building user avatar
  final Widget Function(BuildContext, User)? userAvatarBuilder;
  final Message message;

  /// The function called when tapping on UserAvatar
  final void Function(User)? onUserAvatarTap;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(
        0,
        translateUserAvatar
            ? (messageTheme.avatarTheme?.constraints.maxHeight ?? 40) / 2
            : 0,
      ),
      child: userAvatarBuilder?.call(context, message.user!) ??
          UserAvatar(
            user: message.user!,
            onTap: onUserAvatarTap,
            constraints: messageTheme.avatarTheme!.constraints,
            borderRadius: messageTheme.avatarTheme!.borderRadius,
            showOnlineStatus: false,
          ),
    );
  }
}
