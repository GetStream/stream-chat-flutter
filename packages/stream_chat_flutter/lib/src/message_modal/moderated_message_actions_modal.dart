import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/adaptive_dialog_action.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/chat.dart';

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
  /// Each action is represented by a [StreamContextMenuAction] object.
  final List<StreamContextMenuAction> messageActions;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;

    final actions = <Widget>[
      ...messageActions.map(
        (action) => AdaptiveDialogAction(
          onPressed: () => Navigator.pop(context, action.props.value),
          isDestructiveAction: action.props.isDestructive,
          child: action.props.label,
        ),
      ),
    ];

    return AlertDialog.adaptive(
      clipBehavior: Clip.antiAlias,
      backgroundColor: colorScheme.backgroundElevation1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon: Icon(context.streamIcons.flag),
      iconColor: colorScheme.accentPrimary,
      title: Text(context.translations.moderationReviewModalTitle),
      titleTextStyle: context.streamTextTheme.headingMd.copyWith(
        color: colorScheme.textPrimary,
      ),
      content: Text(
        context.translations.moderationReviewModalDescription,
        textAlign: TextAlign.center,
      ),
      contentTextStyle: context.streamTextTheme.bodyDefault.copyWith(
        color: colorScheme.textSecondary,
      ),
      actions: actions,
      actionsAlignment: MainAxisAlignment.center,
      actionsOverflowAlignment: OverflowBarAlignment.center,
    );
  }
}
