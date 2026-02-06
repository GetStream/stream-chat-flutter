import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// A circular avatar component for displaying a user's profile.
///
/// [StreamUserAvatar] displays a user's profile image or initials placeholder
/// when no image is available. It supports multiple sizes, deterministic
/// color assignment, and an optional online status indicator.
///
/// The avatar automatically handles:
/// - Displaying the user's profile image when available
/// - Showing user initials as a placeholder when no image exists
/// - Deterministic color assignment based on the user's ID
/// - Online status indicator positioning
///
/// {@tool snippet}
///
/// Basic usage with a user:
///
/// ```dart
/// StreamUserAvatar(user: currentUser)
/// ```
/// {@end-tool}
///
/// {@tool snippet}
///
/// With online indicator and custom size:
///
/// ```dart
/// StreamUserAvatar(
///   user: currentUser,
///   size: StreamAvatarSize.lg,
///   showOnlineIndicator: true,
/// )
/// ```
/// {@end-tool}
///
/// {@tool snippet}
///
/// With border for selection states:
///
/// ```dart
/// StreamUserAvatar(
///   user: selectedUser,
///   showBorder: true,
/// )
/// ```
/// {@end-tool}
///
/// ## Theming
///
/// [StreamUserAvatar] uses [StreamAvatarThemeData] for default styling. Colors
/// are automatically assigned based on the user's ID hash, selecting from
/// [StreamColorScheme.avatarPalette] for consistent user-specific colors.
///
/// See also:
///
///  * [StreamAvatarSize], which defines the available size variants.
///  * [StreamAvatarThemeData], which provides theme-level customization.
///  * [StreamColorScheme.avatarPalette], which provides colors for user avatars.
class StreamUserAvatar extends StatelessWidget {
  /// Creates a Stream user avatar.
  const StreamUserAvatar({
    super.key,
    this.size,
    required this.user,
    this.showBorder = true,
    this.showOnlineIndicator = true,
  });

  /// The user whose avatar is displayed.
  final User user;

  /// Whether to show a border around the avatar.
  ///
  /// Defaults to true. The border style is determined by
  /// [StreamAvatarThemeData.border].
  final bool showBorder;

  /// Whether to show the online status indicator.
  ///
  /// Defaults to true.
  final bool showOnlineIndicator;

  /// The size of the avatar.
  ///
  /// If null, uses [StreamAvatarThemeData.size], or falls back to
  /// [StreamAvatarSize.lg].
  final StreamAvatarSize? size;

  @override
  Widget build(BuildContext context) {
    final avatarTheme = context.streamAvatarTheme;
    final colorScheme = context.streamColorScheme;
    final avatarPalette = colorScheme.avatarPalette;

    final userHash = user.id.hashCode; // Ensure deterministic colors.
    final colorPair = avatarPalette[userHash % avatarPalette.length];

    final effectiveSize = size ?? avatarTheme.size ?? .lg;
    final effectiveBackgroundColor = avatarTheme.backgroundColor ?? colorPair.backgroundColor;
    final effectiveForegroundColor = avatarTheme.foregroundColor ?? colorPair.foregroundColor;

    final userAvatar = StreamAvatar(
      size: effectiveSize,
      imageUrl: user.image,
      showBorder: showBorder,
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      placeholder: (_) => _StreamUserAvatarPlaceholder(user: user, size: effectiveSize),
    );

    if (showOnlineIndicator) {
      final indicatorSize = _indicatorSizeForAvatarSize(effectiveSize);

      return StreamOnlineIndicator(
        size: indicatorSize,
        isOnline: user.online,
        alignment: AlignmentDirectional.topEnd,
        child: userAvatar,
      );
    }

    return userAvatar;
  }

  // Maps [StreamAvatarSize] to corresponding [StreamOnlineIndicatorSize].
  //
  // Ensures the online indicator scales appropriately with the avatar size.
  StreamOnlineIndicatorSize _indicatorSizeForAvatarSize(
    StreamAvatarSize size,
  ) => switch (size) {
    .xs || .sm => StreamOnlineIndicatorSize.sm,
    .md => StreamOnlineIndicatorSize.md,
    .lg => StreamOnlineIndicatorSize.lg,
    .xl => StreamOnlineIndicatorSize.xl,
  };
}

// Placeholder widget for [StreamUserAvatar].
//
// Displays user initials or a fallback person icon when no name is available.
// Shows full initials (up to 2 characters) for medium and larger sizes,
// and only the first initial for extra-small and small sizes.
class _StreamUserAvatarPlaceholder extends StatelessWidget {
  const _StreamUserAvatarPlaceholder({
    required this.user,
    required this.size,
  });

  final User user;
  final StreamAvatarSize size;

  @override
  Widget build(BuildContext context) {
    final userInitials = user.name.initials;
    if (userInitials != null && userInitials.isNotEmpty) {
      return switch (size) {
        .md || .lg || .xl => Text(userInitials),
        .xs || .sm => Text(userInitials.characters.first),
      };
    }

    return Icon(context.streamIcons.people);
  }
}
