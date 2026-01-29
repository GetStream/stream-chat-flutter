import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// WidgetBuilder for [StreamUserAvatar].
typedef StreamUserAvatarBuilder =
    Widget Function(
      BuildContext context,
      User user,
      // ignore: avoid_positional_boolean_parameters
      bool isSelected,
    );

/// {@template streamUserAvatar}
/// Displays a user's avatar.
/// {@endtemplate}
class StreamUserAvatar extends StatelessWidget {
  /// {@macro streamUserAvatar}
  const StreamUserAvatar({
    super.key,
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
    this.placeholder,
  });

  /// User whose avatar is to be displayed
  final User user;

  /// Alignment of the online indicator
  ///
  /// Defaults to `Alignment.topRight`
  final Alignment onlineIndicatorAlignment;

  /// Sizing constraints of the avatar
  final BoxConstraints? constraints;

  /// [BorderRadius] of the image
  final BorderRadius? borderRadius;

  /// Sizing constraints of the online indicator
  final BoxConstraints? onlineIndicatorConstraints;

  /// {@macro onUserAvatarTap}
  final OnUserAvatarPress? onTap;

  /// {@macro onUserAvatarTap}
  final OnUserAvatarPress? onLongPress;

  /// Flag for showing online status
  ///
  /// Defaults to `true`
  final bool showOnlineStatus;

  /// Flag for if avatar is selected
  ///
  /// Defaults to `false`
  final bool selected;

  /// Color of selection
  final Color? selectionColor;

  /// Selection thickness around the avatar
  ///
  /// Defaults to `4`
  final double selectionThickness;

  /// {@macro placeholderUserImage}
  final PlaceholderUserImage? placeholder;

  @override
  Widget build(BuildContext context) {
    final streamChatTheme = StreamChatTheme.of(context);
    final colorTheme = streamChatTheme.colorTheme;
    final avatarTheme = streamChatTheme.ownMessageTheme.avatarTheme;
    final streamChatConfig = StreamChatConfiguration.of(context);

    final effectivePlaceholder = switch (placeholder) {
      final placeholder? => placeholder,
      _ => streamChatConfig.placeholderUserImage,
    };

    final effectiveBorderRadius = borderRadius ?? avatarTheme?.borderRadius;

    final backupGradientAvatar = ClipRRect(
      borderRadius: effectiveBorderRadius ?? BorderRadius.zero,
      child: streamChatConfig.defaultUserImage(context, user),
    );

    Widget avatar = FittedBox(
      fit: BoxFit.cover,
      child: Container(
        constraints: constraints ?? avatarTheme?.constraints,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final imageUrl = user.image;
            if (imageUrl == null || imageUrl.isEmpty) {
              return backupGradientAvatar;
            }

            // Calculate optimal thumbnail size for the avatar
            final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
            final thumbnailSize = constraints.biggest * devicePixelRatio;

            int? cacheWidth, cacheHeight;
            if (thumbnailSize.isFinite && !thumbnailSize.isEmpty) {
              cacheWidth = thumbnailSize.width.round();
              cacheHeight = thumbnailSize.height.round();
            }

            return CachedNetworkImage(
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
              imageUrl: imageUrl,
              errorWidget: (_, __, ___) => backupGradientAvatar,
              placeholder: switch (effectivePlaceholder) {
                final holder? => (context, __) => holder(context, user),
                _ => null,
              },
              imageBuilder: (context, imageProvider) => DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: effectiveBorderRadius,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: ResizeImage(
                      imageProvider,
                      width: cacheWidth,
                      height: cacheHeight,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );

    if (selected) {
      avatar = ClipRRect(
        borderRadius: (effectiveBorderRadius ?? BorderRadius.zero) + BorderRadius.circular(selectionThickness),
        child: Container(
          constraints: constraints ?? avatarTheme?.constraints,
          color: selectionColor ?? colorTheme.accentPrimary,
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
                  color: colorTheme.barsBg,
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    constraints:
                        onlineIndicatorConstraints ??
                        const BoxConstraints.tightFor(
                          width: 8,
                          height: 8,
                        ),
                    child: Material(
                      shape: const CircleBorder(),
                      color: colorTheme.accentInfo,
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
