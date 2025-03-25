import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_modal/message_modal.dart';
import 'package:stream_chat_flutter/src/message_widget/reactions/my_reaction_picker.dart';
import 'package:stream_chat_flutter/src/message_widget/reactions/reactions_align.dart';
import 'package:stream_chat_flutter/src/message_widget/reactions/reactions_card.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamMessageReactionsModal}
/// A modal that displays message reactions and allows users to add reactions.
///
/// This modal contains:
/// 1. A reaction picker (optional) that appears at the top
/// 2. The original message widget
/// 3. A display of all current reactions with user avatars
///
/// The modal uses [StreamMessageModal] as its base layout and customizes
/// both the header and content sections to display reaction-specific
/// information.
/// {@endtemplate}
class StreamMessageReactionsModal extends StatelessWidget {
  /// {@macro streamMessageReactionsModal}
  const StreamMessageReactionsModal({
    super.key,
    required this.message,
    required this.messageWidget,
    this.reverse = false,
    this.showReactionPicker = true,
    this.onReactionPicked,
    this.onUserAvatarTap,
  });

  /// The message for which to display and manage reactions.
  final Message message;

  /// The original message widget that will be displayed in the modal.
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
  final bool showReactionPicker;

  /// Callback triggered when a user adds or toggles a reaction.
  ///
  /// Provides the selected [Reaction] object to the callback.
  final OnReactionPicked? onReactionPicked;

  /// Callback triggered when a user avatar is tapped in the reactions list.
  ///
  /// Provides the [User] object associated with the tapped avatar.
  final void Function(User)? onUserAvatarTap;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final messageTheme = theme.getMessageTheme(reverse: reverse);

    final Widget? reactionPicker = switch (showReactionPicker) {
      false => null,
      true => LayoutBuilder(
          builder: (context, constraints) {
            final orientation = MediaQuery.of(context).orientation;
            final messageFontSize = messageTheme.messageTextStyle?.fontSize;

            final alignment = message.calculateReactionPickerAlignment(
              constraints: constraints,
              fontSize: messageFontSize,
              orientation: orientation,
              reverse: reverse,
            );

            return Align(
              alignment: alignment,
              child: StreamReactionPicker(
                message: message,
                onReactionPicked: onReactionPicked,
              ),
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
        final currentUser = StreamChat.of(context).currentUser;
        if (currentUser == null) return const Empty();

        final reactions = message.latestReactions;
        final hasReactions = reactions != null && reactions.isNotEmpty;
        if (!hasReactions) return const Empty();

        return FractionallySizedBox(
          widthFactor: 0.78,
          child: ReactionsCard(
            message: message,
            currentUser: currentUser,
            messageTheme: messageTheme,
            onUserAvatarTap: onUserAvatarTap,
          ),
        );
      },
    );
  }
}
