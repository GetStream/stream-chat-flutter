import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/components/avatar/stream_user_avatar.dart';
import 'package:stream_chat_flutter/src/components/avatar/stream_user_avatar_group.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// A circular avatar component for displaying a channel's image.
///
/// [StreamChannelAvatar] displays a channel's image or an appropriate fallback
/// based on the channel type. It supports channel images, user avatars for
/// 1-1 conversations, and group avatars for multi-member channels.
///
/// The avatar automatically handles:
/// - Reactive updates when channel image changes via [Channel.imageStream]
/// - Fallback to member avatars when no channel image is set
/// - Deterministic color assignment for member avatars
///
/// {@tool snippet}
///
/// Basic usage with a channel:
///
/// ```dart
/// StreamChannelAvatar(channel: channel)
/// ```
/// {@end-tool}
///
/// {@tool snippet}
///
/// With custom size:
///
/// ```dart
/// StreamChannelAvatar(
///   channel: channel,
///   size: StreamAvatarGroupSize.xl,
/// )
/// ```
/// {@end-tool}
///
/// ## Theming
///
/// [StreamChannelAvatar] uses [StreamAvatarThemeData] for default styling.
/// Member avatars within the channel avatar use deterministic colors from
/// [StreamColorScheme.avatarPalette].
///
/// See also:
///
///  * [StreamAvatarGroupSize], which defines the available size variants.
///  * [StreamAvatarThemeData], which provides theme-level customization.
///  * [StreamUserAvatar], which is used to display individual member avatars.
class StreamChannelAvatar extends StatelessWidget {
  /// Creates a Stream channel avatar.
  const StreamChannelAvatar({
    super.key,
    this.size,
    required this.channel,
    this.showShadow = false,
  });

  /// The channel whose avatar is displayed.
  final Channel channel;

  /// The size of the channel avatar.
  ///
  /// If null, defaults to [StreamAvatarGroupSize.lg].
  final StreamAvatarGroupSize? size;

  /// Whether to show a drop shadow around the avatar.
  ///
  /// Defaults to false. The shadow style is determined by
  /// [StreamAvatarThemeData.boxShadow], falling back to
  /// [StreamBoxShadow.elevation3].
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    assert(channel.state != null, 'Channel ${channel.id} is not initialized');

    final effectiveSize = size ?? StreamAvatarGroupSize.lg;

    return BetterStreamBuilder(
      stream: channel.imageStream,
      initialData: channel.image,
      builder: (context, channelImage) => StreamAvatar(
        imageUrl: channelImage,
        size: _avatarSizeForAvatarGroupSize(effectiveSize),
        showShadow: showShadow,
        placeholder: (_) => const _StreamChannelAvatarPlaceholder(),
      ),
      noDataBuilder: (context) => BetterStreamBuilder(
        stream: channel.state!.membersStream,
        initialData: channel.state!.members,
        builder: (context, members) {
          final users = members.map((it) => it.user!).toList();
          final currentUserId = channel.client.state.currentUser?.id;

          if (channel.isDistinct && users.length == 2) {
            final otherUser = users.firstWhere(
              (u) => u.id != currentUserId,
              orElse: () => users.first,
            );
            return StreamUserAvatar(
              user: otherUser,
              size: _avatarSizeForAvatarGroupSize(effectiveSize),
              // TODO: make this configurable when the online state is shown.
              showOnlineIndicator: otherUser.online,
              showShadow: showShadow,
            );
          }

          return StreamUserAvatarGroup(
            size: effectiveSize,
            users: users.sortedBy((it) => it.id == currentUserId ? 1 : 0),
            showShadow: showShadow,
          );
        },
      ),
    );
  }

  // Maps [StreamAvatarGroupSize] to corresponding [StreamAvatarSize].
  //
  // Used when displaying a single channel image avatar.
  StreamAvatarSize _avatarSizeForAvatarGroupSize(
    StreamAvatarGroupSize size,
  ) => switch (size) {
    .lg => StreamAvatarSize.lg,
    .xl => StreamAvatarSize.xl,
    .xxl => StreamAvatarSize.xxl,
  };
}

// Placeholder widget for [StreamChannelAvatar].
//
// Displays a team icon as a fallback when the channel image fails to load.
class _StreamChannelAvatarPlaceholder extends StatelessWidget {
  const _StreamChannelAvatarPlaceholder();

  @override
  Widget build(BuildContext context) => Icon(context.streamIcons.users);
}
