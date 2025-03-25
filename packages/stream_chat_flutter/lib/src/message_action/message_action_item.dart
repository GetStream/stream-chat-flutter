import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_action/message_action.dart';
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
  }) : _custom = null;

  /// Creates a action item with a custom child widget instead of the default
  /// icon and title.
  const StreamMessageActionItem.custom({
    super.key,
    required this.message,
    required this.action,
    required Widget child,
  }) : _custom = child;

  /// The message associated with this action item.
  final Message message;

  /// The underlying action that this item represents.
  final StreamMessageAction action;

  // A custom child widget to use instead of the default icon and title.
  //
  // If null, the default icon and title will be used.
  final Widget? _custom;

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

    final titleTextStyle = action.titleTextStyle ?? textTheme.body;
    final backgroundColor = action.backgroundColor ?? colorTheme.barsBg;

    return InkWell(
      key: ValueKey(action.type),
      onTap: switch (action.onTap) {
        final onTap? => () => onTap(message),
        _ => null,
      },
      child: Ink(
        color: backgroundColor,
        child: IconTheme.merge(
          data: IconThemeData(color: iconColor),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 9,
              horizontal: 16,
            ),
            child: switch (_custom) {
              final custom? => custom,
              _ => Row(
                  spacing: 16,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (action.leading case final leading?) leading,
                    if (action.title case final title?)
                      DefaultTextStyle(
                        style: titleTextStyle.copyWith(
                          color: titleTextColor,
                        ),
                        child: title,
                      ),
                  ],
                ),
            },
          ),
        ),
      ),
    );
  }
}
