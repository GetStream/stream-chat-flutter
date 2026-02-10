import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/components/avatar/stream_user_avatar.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// A widget that displays a stack of user avatars with overlap.
///
/// [StreamUserAvatarStack] displays multiple user avatars in a horizontal
/// stack, with each avatar partially overlapping the previous one. This is
/// useful for showing participants in a conversation, group members, or
/// any collection of users in a compact space.
///
/// The stack automatically handles:
/// - Displaying user avatars with deterministic colors
/// - Overflow handling with a badge showing remaining count
/// - Customizable overlap and maximum visible avatars
///
/// {@tool snippet}
///
/// Basic usage with a list of users:
///
/// ```dart
/// StreamUserAvatarStack(users: participants)
/// ```
/// {@end-tool}
///
/// {@tool snippet}
///
/// With custom max and size:
///
/// ```dart
/// StreamUserAvatarStack(
///   users: participants,
///   max: 3,
///   size: StreamAvatarStackSize.xs,
/// )
/// ```
/// {@end-tool}
///
/// {@tool snippet}
///
/// With custom overlap:
///
/// ```dart
/// StreamUserAvatarStack(
///   users: participants,
///   overlap: 0.5, // 50% overlap
/// )
/// ```
/// {@end-tool}
///
/// ## Theming
///
/// [StreamUserAvatarStack] uses [StreamAvatarThemeData] for default styling.
/// Individual user avatars use deterministic colors from
/// [StreamColorScheme.avatarPalette].
///
/// See also:
///
///  * [StreamAvatarStackSize], which defines the available size variants.
///  * [StreamUserAvatar], which is used to display individual user avatars.
///  * [StreamAvatarStack], the underlying stack component.
class StreamUserAvatarStack extends StatelessWidget {
  /// Creates a Stream user avatar stack.
  ///
  /// If [users] is empty, returns an empty [SizedBox].
  /// The [max] must be at least 2.
  const StreamUserAvatarStack({
    super.key,
    required this.users,
    this.size,
    this.overlap = 0.33,
    this.max = 5,
  }) : assert(max >= 2, 'max must be at least 2');

  /// The list of users whose avatars are displayed.
  final Iterable<User> users;

  /// The size of the avatar stack.
  ///
  /// If null, defaults to [StreamAvatarStackSize.sm].
  final StreamAvatarStackSize? size;

  /// How much each avatar overlaps the previous one, as a fraction of size.
  ///
  /// - `0.0`: No overlap (side by side)
  /// - `0.33`: 33% overlap (default)
  /// - `1.0`: Fully stacked
  final double overlap;

  /// Maximum number of avatars to display before showing overflow badge.
  ///
  /// When [users] exceeds this value, displays [max] avatars followed
  /// by a badge showing the overflow count (e.g., "+2").
  ///
  /// Must be at least 2. Defaults to 5.
  final int max;

  @override
  Widget build(BuildContext context) {
    return StreamAvatarStack(
      max: max,
      size: size,
      overlap: overlap,
      children: users.map(
        (user) => StreamUserAvatar(
          user: user,
          showOnlineIndicator: false,
        ),
      ),
    );
  }
}
