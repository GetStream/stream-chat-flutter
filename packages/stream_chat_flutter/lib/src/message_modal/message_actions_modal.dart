import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_widget/reactions/reactions_align.dart';

import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamMessageActionsModal}
/// A modal that displays a list of actions that can be performed on a message.
///
/// This widget presents a customizable menu of actions for a message, such as
/// reply, edit, delete, etc., along with an optional reaction picker.
///
/// Typically used when a user long-presses on a message to see available
/// actions.
/// {@endtemplate}
class StreamMessageActionsModal extends StatelessWidget {
  /// {@macro streamMessageActionsModal}
  const StreamMessageActionsModal({
    super.key,
    required this.message,
    required this.messageActions,
    required this.messageWidget,
    this.reverse = false,
    this.showReactionPicker = false,
    this.reactionPickerBuilder = StreamReactionPicker.builder,
    this.onActionTap,
  });

  /// The message object that actions will be performed on.
  ///
  /// This is the message the user selected to see available actions.
  final Message message;

  /// List of custom actions that will be displayed in the modal.
  ///
  /// Each action is represented by a [StreamMessageAction] object which defines
  /// the action's appearance and behavior.
  final List<StreamMessageAction> messageActions;

  /// The widget representing the message being acted upon.
  ///
  /// This is typically displayed at the top of the modal as a reference for the
  /// user.
  final Widget messageWidget;

  /// Whether the message should be displayed in reverse direction.
  ///
  /// This affects how the modal and reactions are displayed and aligned.
  /// Set to `true` for right-aligned messages (typically the current user's).
  /// Set to `false` for left-aligned messages (typically other users').
  ///
  /// Defaults to `false`.
  final bool reverse;

  /// Controls whether to show the reaction picker at the top of the modal.
  ///
  /// When `true`, users can add reactions directly from the modal.
  /// When `false`, the reaction picker is hidden.
  ///
  /// Defaults to `false`.
  final bool showReactionPicker;

  /// {@macro reactionPickerBuilder}
  final ReactionPickerBuilder reactionPickerBuilder;

  /// Callback triggered when a message action is tapped.
  ///
  /// Provides the tapped [MessageAction] object to the callback.
  final OnMessageActionTap? onActionTap;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    final Widget? reactionPicker = switch (showReactionPicker) {
      false => null,
      true => LayoutBuilder(
          builder: (context, constraints) {
            final orientation = MediaQuery.of(context).orientation;
            final messageTheme = theme.getMessageTheme(reverse: reverse);
            final messageFontSize = messageTheme.messageTextStyle?.fontSize;

            final alignment = message.calculateReactionPickerAlignment(
              constraints: constraints,
              fontSize: messageFontSize,
              orientation: orientation,
              reverse: reverse,
            );

            final onReactionPicked = switch (onActionTap) {
              null => null,
              final onActionTap => (reaction) {
                  return onActionTap.call(
                    SelectReaction(message: message, reaction: reaction),
                  );
                },
            };

            return Align(
              alignment: alignment,
              child: reactionPickerBuilder(context, message, onReactionPicked),
            );
          },
        ),
    };

    return StreamMessageModal(
      alignment: switch (reverse) {
        true => Alignment.centerRight,
        false => Alignment.centerLeft,
      },
      headerBuilder: (context) {
        return Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget?>[
            reactionPicker,
            IgnorePointer(child: messageWidget),
          ].nonNulls.toList(growable: false),
        );
      },
      contentBuilder: (context) {
        final actions = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>{
            ...messageActions.map(
              (action) => StreamMessageActionItem(
                action: action,
                onTap: onActionTap,
              ),
            ),
          }.insertBetween(Divider(height: 1, color: theme.colorTheme.borders)),
        );

        return FractionallySizedBox(
          widthFactor: 0.78,
          child: Material(
            type: MaterialType.transparency,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: actions,
          ),
        );
      },
    );
  }
}
