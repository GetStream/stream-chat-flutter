import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

enum MarkerSize {
  xs(20),
  sm(24),
  md(32),
  lg(40),
  xl(64);

  const MarkerSize(this.value);

  final double value;
}

class LocationUserMarker extends StatelessWidget {
  const LocationUserMarker({
    super.key,
    this.user,
    this.size = MarkerSize.lg,
    required this.sharedLocation,
  });

  final User? user;
  final MarkerSize size;

  final Location sharedLocation;

  @override
  Widget build(BuildContext context) {
    if (user case final user? when sharedLocation.isLive) {
      const borderWidth = 4.0;

      final avatar = Material(
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        color: context.streamColorScheme.backgroundElevation1,
        child: Padding(
          padding: const EdgeInsets.all(borderWidth),
          child: StreamUserAvatar(
            size: _avatarSizeForMarkerSize(size),
            user: user,
            showOnlineIndicator: false,
          ),
        ),
      );

      if (sharedLocation.isExpired) return avatar;

      return AvatarGlow(
        glowColor: context.streamColorScheme.accentPrimary,
        child: avatar,
      );
    }

    return Icon(
      size: size.value,
      Icons.person_pin,
      color: context.streamColorScheme.accentPrimary,
    );
  }

  StreamAvatarSize _avatarSizeForMarkerSize(
    MarkerSize size,
  ) => switch (size) {
    .xs => StreamAvatarSize.xs,
    .sm => StreamAvatarSize.sm,
    .md => StreamAvatarSize.md,
    .lg => StreamAvatarSize.lg,
    .xl => StreamAvatarSize.xl,
  };
}
