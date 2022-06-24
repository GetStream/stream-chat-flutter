import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A widget that displays a user.
///
/// This widget is intended to be used as a Tile in
/// [StreamChannelGridView].
///
/// It shows the user's avatar and name.
///
/// See also:
/// * [StreamChannelGridView]
/// * [StreamUserAvatar]
class StreamChannelGridTile extends StatelessWidget {
  /// Creates a new instance of [StreamChannelGridTile] widget.
  const StreamChannelGridTile({
    super.key,
    required this.channel,
    this.child,
    this.footer,
    this.onTap,
    this.onLongPress,
  });

  /// The channel to display.
  final Channel channel;

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
  StreamChannelGridTile copyWith({
    Key? key,
    Channel? channel,
    Widget? child,
    Widget? footer,
    GestureTapCallback? onTap,
    GestureLongPressCallback? onLongPress,
  }) =>
      StreamChannelGridTile(
        key: key ?? this.key,
        channel: channel ?? this.channel,
        footer: footer ?? this.footer,
        onTap: onTap ?? this.onTap,
        onLongPress: onLongPress ?? this.onLongPress,
        child: child ?? this.child,
      );

  @override
  Widget build(BuildContext context) {
    final channelPreviewTheme = StreamChannelPreviewTheme.of(context);

    final child = this.child ??
        StreamChannelAvatar(
          channel: channel,
          borderRadius: BorderRadius.circular(32),
          constraints: const BoxConstraints.tightFor(
            height: 64,
            width: 64,
          ),
        );

    final footer = this.footer ??
        StreamChannelName(
          channel: channel,
          textStyle: channelPreviewTheme.titleStyle,
        );

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          child,
          footer,
        ],
      ),
    );
  }
}
