import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/components/avatar/stream_user_avatar.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// A widget that displays multiple user avatars in a grid layout.
///
/// [StreamUserAvatarGroup] arranges user avatars in a 2x2 grid pattern,
/// typically used for displaying group channel participants. It supports
/// two sizes and automatically handles overflow with a badge indicator.
///
/// The group automatically handles:
/// - Grid layout for up to 4 user avatars
/// - Overflow indicator showing remaining count for additional users
/// - Deterministic color assignment for each user avatar
/// - Consistent sizing across all child avatars
///
/// {@tool snippet}
///
/// Basic usage with a list of users:
///
/// ```dart
/// StreamUserAvatarGroup(users: groupMembers)
/// ```
/// {@end-tool}
///
/// {@tool snippet}
///
/// With custom size:
///
/// ```dart
/// StreamUserAvatarGroup(
///   users: groupMembers,
///   size: StreamAvatarGroupSize.xl,
/// )
/// ```
/// {@end-tool}
///
/// ## Theming
///
/// [StreamUserAvatarGroup] uses [StreamAvatarThemeData] for styling the child
/// avatars. Individual user avatars use deterministic colors from
/// [StreamColorScheme.avatarPalette].
///
/// See also:
///
///  * [StreamAvatarGroupSize], which defines the available size variants.
///  * [StreamUserAvatar], which is used to display individual user avatars.
///  * [StreamAvatarGroup], the underlying group component.
class StreamUserAvatarGroup extends StatelessWidget {
  /// Creates a Stream user avatar group.
  ///
  /// If [users] is empty, returns an empty [SizedBox].
  const StreamUserAvatarGroup({
    super.key,
    required this.users,
    this.size,
  });

  /// The list of users whose avatars are displayed.
  final Iterable<User> users;

  /// The size of the avatar group.
  ///
  /// If null, defaults to [StreamAvatarGroupSize.lg].
  final StreamAvatarGroupSize? size;

  @override
  Widget build(BuildContext context) {
    return StreamAvatarGroup(
      size: size,
      children: users.map(
        (user) => StreamUserAvatar(
          user: user,
          showOnlineIndicator: false,
        ),
      ),
    );
  }
}
