import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class LocationUserMarker extends StatelessWidget {
  const LocationUserMarker({
    super.key,
    this.user,
    this.markerSize = 40,
    required this.sharedLocation,
  });

  final User? user;
  final double markerSize;
  final Location sharedLocation;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final colorTheme = theme.colorTheme;

    if (user case final user? when sharedLocation.isLive) {
      const borderWidth = 4.0;

      final avatar = Material(
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        color: colorTheme.overlayDark,
        child: Padding(
          padding: const EdgeInsets.all(borderWidth),
          child: StreamUserAvatar(
            user: user,
            constraints: BoxConstraints.tightFor(
              width: markerSize,
              height: markerSize,
            ),
            showOnlineStatus: false,
          ),
        ),
      );

      if (sharedLocation.isExpired) return avatar;

      return AvatarGlow(
        glowColor: colorTheme.accentPrimary,
        child: avatar,
      );
    }

    return Icon(
      size: markerSize,
      Icons.person_pin,
      color: colorTheme.accentPrimary,
    );
  }
}
