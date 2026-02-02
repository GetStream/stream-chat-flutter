import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamChatContextMenuItem}
/// Builds a context menu item according to Stream design specification.
/// {@endtemplate}
class StreamChatContextMenuItem extends StatelessWidget {
  /// {@macro streamChatContextMenuItem}
  const StreamChatContextMenuItem({
    super.key,
    this.child,
    this.leading,
    this.title,
    this.onClick,
  });

  /// The child widget for this menu item. Usually a [DesktopReactionPicker].
  ///
  /// Leave null in order to use the default menu item widget.
  final Widget? child;

  /// The widget to lead the menu item with. Usually an [Icon].
  ///
  /// If [child] is specified, this will be ignored.
  final Widget? leading;

  /// The title of the menu item. Usually a [Text].
  ///
  /// If [child] is specified, this will be ignored.
  final Widget? title;

  /// The action to perform when the menu item is clicked.
  ///
  /// If [child] is specified, this will be ignored.
  final VoidCallback? onClick;

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: StreamChatTheme.of(context).messageListViewTheme.backgroundColor ??
          Theme.of(context).scaffoldBackgroundColor,
      child: child ??
          ListTile(
            dense: true,
            leading: leading,
            title: title,
            onTap: onClick,
          ),
    );
  }
}
