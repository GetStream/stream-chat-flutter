import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_actions/message_action.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template streamMessageActionItem}
/// A widget that represents an action item within a message interface.
///
/// This widget is typically used in action menus or option lists related to
/// messages, providing a consistent appearance for selectable actions with an
/// optional icon and title.
/// {@endtemplate}
class StreamMessageActionItem extends StatelessWidget {
  /// {@macro streamMessageActionItem}
  const StreamMessageActionItem({
    super.key,
    required this.message,
    required this.action,
  });

  /// The message associated with this action item.
  final Message message;

  /// The underlying action that this item represents.
  final StreamMessageAction action;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final textTheme = theme.textTheme;
    final colorTheme = theme.colorTheme;

    final iconColor = switch (action.isDestructive) {
      true => action.iconColor ?? colorTheme.accentError,
      false => action.iconColor ?? colorTheme.textLowEmphasis,
    };

    final titleTextColor = switch (action.isDestructive) {
      true => action.titleTextColor ?? colorTheme.accentError,
      false => action.titleTextColor ?? colorTheme.textHighEmphasis,
    };

    return ListTile(
      key: ValueKey(action.type),
      title: action.title,
      leading: action.leading,
      iconColor: iconColor,
      textColor: titleTextColor,
      titleTextStyle: action.titleTextStyle ?? textTheme.body,
      tileColor: action.backgroundColor ?? colorTheme.barsBg,
      visualDensity: VisualDensity.compact,
      onTap: switch (action.onTap) {
        final onTap? => () => onTap(message),
        _ => null,
      },
    );
  }
}
