import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/icons/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';

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
    this.onSendAnyway,
    this.onEditMessage,
    this.onDeleteMessage,
  });

  /// Callback function called when the user chooses to send the message
  /// despite the moderation warning.
  final VoidCallback? onSendAnyway;

  /// Callback function called when the user chooses to edit the message.
  final VoidCallback? onEditMessage;

  /// Callback function called when the user chooses to delete the message.
  final VoidCallback? onDeleteMessage;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final textTheme = theme.textTheme;
    final colorTheme = theme.colorTheme;

    final actions = <Widget>[
      TextButton(
        onPressed: onSendAnyway,
        style: TextButton.styleFrom(
          textStyle: theme.textTheme.body,
          foregroundColor: theme.colorTheme.accentPrimary,
          disabledForegroundColor: theme.colorTheme.disabled,
        ),
        child: Text(context.translations.sendAnywayLabel),
      ),
      TextButton(
        onPressed: onEditMessage,
        style: TextButton.styleFrom(
          textStyle: theme.textTheme.body,
          foregroundColor: theme.colorTheme.accentPrimary,
          disabledForegroundColor: theme.colorTheme.disabled,
        ),
        child: Text(context.translations.editMessageLabel),
      ),
      TextButton(
        onPressed: onDeleteMessage,
        style: TextButton.styleFrom(
          textStyle: theme.textTheme.body,
          foregroundColor: theme.colorTheme.accentPrimary,
          disabledForegroundColor: theme.colorTheme.disabled,
        ),
        child: Text(context.translations.deleteMessageLabel),
      ),
    ];

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: AlertDialog(
        clipBehavior: Clip.antiAlias,
        backgroundColor: colorTheme.appBg,
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
      ),
    );
  }
}
