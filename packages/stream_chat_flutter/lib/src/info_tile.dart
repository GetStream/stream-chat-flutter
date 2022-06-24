import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

/// {@macro info_tile}
@Deprecated("Use 'StreamInfoTile' instead")
typedef InfoTile = StreamInfoTile;

/// {@template info_tile}
/// Tile to display a message, used in stream chat to display connection status
/// {@endtemplate}
class StreamInfoTile extends StatelessWidget {
  /// Constructor for creating an [StreamInfoTile] widget
  const StreamInfoTile({
    super.key,
    required this.message,
    required this.child,
    required this.showMessage,
    this.tileAnchor,
    this.childAnchor,
    this.textStyle,
    this.backgroundColor,
  });

  /// String to display
  final String message;

  /// Widget to display over
  final Widget child;

  /// Flag to show message
  final bool showMessage;

  /// Anchor for tile - [portalAnchor] for [PortalEntry]
  final Alignment? tileAnchor;

  /// Alignment for child - [childAnchor] for [PortalEntry]
  final Alignment? childAnchor;

  /// [TextStyle] for message
  final TextStyle? textStyle;

  /// Background color for tile
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final chatThemeData = StreamChatTheme.of(context);
    return PortalTarget(
      visible: showMessage,
      anchor: Aligned(
        follower: tileAnchor ?? Alignment.topCenter,
        target: childAnchor ?? Alignment.bottomCenter,
      ),
      portalFollower: Container(
        height: 25,
        color: backgroundColor ??
            chatThemeData.colorTheme.textLowEmphasis.withOpacity(0.9),
        child: Center(
          child: Text(
            message,
            style: textStyle ??
                chatThemeData.textTheme.body.copyWith(
                  color: Colors.white,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      child: child,
    );
  }
}
