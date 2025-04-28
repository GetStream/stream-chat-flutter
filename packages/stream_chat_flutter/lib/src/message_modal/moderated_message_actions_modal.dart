import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/icons/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/message_action/message_action.dart';
import 'package:stream_chat_flutter/src/misc/adaptive_dialog_action.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template moderatedMessageActionsModal}
/// A modal that is shown when a message is flagged by moderation policies.
///
/// This modal allows users to:
/// - Send the message anyway, overriding the moderation warning
/// - Edit the message to comply with community guidelines
/// - Delete the message
///
/// The modal provides clear guidance to users about the moderation issue
/// and options to address it.
/// {@endtemplate}
class ModeratedMessageActionsModal extends StatelessWidget {
  /// {@macro moderatedMessageActionsModal}
  const ModeratedMessageActionsModal({
    super.key,
    required this.message,
    required this.messageActions,
  });

  /// The message object that actions will be performed on.
  ///
  /// This is the message the user selected to see available actions.
  final Message message;

  /// List of custom actions that will be displayed in the modal.
  ///
  /// Each action is represented by a [StreamMessageAction] object which defines
  /// the action's appearance and behavior.
  final Set<StreamMessageAction> messageActions;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final textTheme = theme.textTheme;
    final colorTheme = theme.colorTheme;

    final actions = <Widget>[
      ...messageActions.map(
        (action) => AdaptiveDialogAction(
          onPressed: switch (action.onTap) {
            final onTap? => () => onTap.call(message),
            _ => null,
          },
          isDestructiveAction: action.isDestructive,
          child: action.title ?? const Empty(),
        ),
      ),
    ];

    return AlertDialog.adaptive(
      clipBehavior: Clip.antiAlias,
      backgroundColor: colorTheme.barsBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon: const StreamSvgIcon(icon: StreamSvgIcons.flag),
      iconColor: colorTheme.accentPrimary,
      title: Text(context.translations.moderationReviewModalTitle),
      titleTextStyle: textTheme.headline.copyWith(
        color: colorTheme.textHighEmphasis,
      ),
      content: Text(
        context.translations.moderationReviewModalDescription,
        textAlign: TextAlign.center,
      ),
      contentTextStyle: textTheme.body.copyWith(
        color: colorTheme.textLowEmphasis,
      ),
      actions: actions,
      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowAlignment: OverflowBarAlignment.center,
    );
  }
}
