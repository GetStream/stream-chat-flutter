import 'package:flutter/material.dart';
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
    this.alignment,
    this.showReactionPicker = false,
    this.leadingInset = 0,
  });

  /// The message object that actions will be performed on.
  ///
  /// This is the message the user selected to see available actions.
  final Message message;

  /// List of widgets that will be displayed as actions in the modal.
  ///
  /// Typically built by [StreamMessageActionsBuilder] and optionally modified
  /// by [StreamMessageItem.actionsBuilder]. Each item is rendered directly
  /// as a child of [StreamContextMenu].
  final List<Widget> messageActions;

  /// The widget representing the message being acted upon.
  ///
  /// This is typically displayed in the content section of the modal as a
  /// reference for the user.
  final Widget messageWidget;

  /// Alignment of the modal content.
  ///
  /// When null (the default), falls back to
  /// [StreamMessageLayout.alignmentDirectionalOf].
  final AlignmentGeometry? alignment;

  /// Controls whether to show the reaction picker at the top of the modal.
  ///
  /// When `true`, users can add reactions directly from the modal.
  /// When `false`, the reaction picker is hidden.
  ///
  /// Defaults to `false`.
  final bool showReactionPicker;

  /// Horizontal offset applied to the header (reaction picker) and footer (actions menu)
  /// to align them with the message bubble content rather than the full message row.
  ///
  /// Defaults to `0` (no offset).
  final double leadingInset;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final effectiveAlignment = alignment ?? StreamMessageLayout.alignmentDirectionalOf(context);

    void onReactionPicked(Reaction reaction) {
      final action = SelectReaction(message: message, reaction: reaction);
      return Navigator.pop(context, action);
    }

    final insetPadding = EdgeInsetsDirectional.only(start: leadingInset);

    return StreamMessageDialog(
      spacing: spacing.xs,
      alignment: effectiveAlignment,
      headerBuilder: switch (showReactionPicker) {
        true => (context) => Padding(
          padding: insetPadding,
          child: StreamMessageReactionPicker(
            message: message,
            onReactionPicked: onReactionPicked,
          ),
        ),
        false => null,
      },
      contentBuilder: (context) => IgnorePointer(child: messageWidget),
      footerBuilder: (context) => Padding(
        padding: insetPadding,
        child: StreamContextMenu(children: messageActions),
      ),
    );
  }
}
