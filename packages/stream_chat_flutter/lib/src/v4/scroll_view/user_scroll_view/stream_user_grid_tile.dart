import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A widget that displays a user.
///
/// This widget is intended to be used as a Tile in [StreamUserGridView]
///
/// It shows the user's avatar and name.
///
/// See also:
/// * [StreamUserGridView]
/// * [StreamUserAvatar]
class StreamUserGridTile extends StatelessWidget {
  /// Creates a new instance of [StreamUserGridTile] widget.
  const StreamUserGridTile({
    Key? key,
    required this.user,
    this.child,
    this.footer,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  /// The user to display.
  final User user;

  /// The widget to display in the body of the tile.
  final Widget? child;

  /// The widget to display in the footer of the tile.
  final Widget? footer;

  /// Called when the user taps this grid tile.
  final GestureTapCallback? onTap;

  /// Called when the user long-presses on this grid tile.
  final GestureLongPressCallback? onLongPress;

  /// Creates a copy of this tile but with the given fields replaced with
  /// the new values.
  StreamUserGridTile copyWith({
    Key? key,
    User? user,
    Widget? child,
    Widget? footer,
    GestureTapCallback? onTap,
    GestureLongPressCallback? onLongPress,
  }) =>
      StreamUserGridTile(
        key: key ?? this.key,
        user: user ?? this.user,
        footer: footer ?? this.footer,
        onTap: onTap ?? this.onTap,
        onLongPress: onLongPress ?? this.onLongPress,
        child: child ?? this.child,
      );

  @override
  Widget build(BuildContext context) {
    final child = this.child ??
        StreamUserAvatar(
          user: user,
          borderRadius: BorderRadius.circular(32),
          constraints: const BoxConstraints.tightFor(
            height: 64,
            width: 64,
          ),
          onlineIndicatorConstraints: const BoxConstraints.tightFor(
            height: 12,
            width: 12,
          ),
        );

    final footer = this.footer ??
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            user.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        );

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          child,
          const SizedBox(height: 4),
          footer,
        ],
      ),
    );
  }
}
