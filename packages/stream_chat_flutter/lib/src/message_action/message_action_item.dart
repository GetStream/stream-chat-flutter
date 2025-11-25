import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_action/message_action.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

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
    required this.action,
    this.onTap,
  });

  /// The underlying action that this item represents.
  final StreamMessageAction action;

  /// Called when the user taps this action item.
  ///
  /// This callback provides the tap handling for the action item, and is
  /// typically used to execute the associated action or dismiss menus.
  final OnMessageActionTap? onTap;

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
      onTap: switch (onTap) {
        final onTap? => () => onTap(action.action),
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
            child: Row(
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
          ),
        ),
      ),
    );
  }
}
