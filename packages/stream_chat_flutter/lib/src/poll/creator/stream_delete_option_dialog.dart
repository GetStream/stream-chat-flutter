import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/poll_creator_theme.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';

/// {@template showPollDeleteOptionDialog}
/// Shows a dialog that allows the user to confirm deletion of a poll option.
/// {@endtemplate}
Future<bool?> showPollDeleteOptionDialog({
  required BuildContext context,
}) {
  return showDialog<bool?>(
    context: context,
    builder: (_) => const PollDeleteOptionDialog(),
  );
}

/// {@template pollDeleteOptionDialog}
/// A dialog that allows the user to confirm deletion of a poll option.
/// {@endtemplate}
class PollDeleteOptionDialog extends StatelessWidget {
  /// {@macro pollDeleteOptionDialog}
  const PollDeleteOptionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final pollCreatorTheme = StreamPollCreatorTheme.of(context);

    final actions = [
      TextButton(
        onPressed: () => Navigator.of(context).maybePop(false),
        style: TextButton.styleFrom(
          textStyle: theme.textTheme.headlineBold,
          foregroundColor: theme.colorTheme.accentPrimary,
          disabledForegroundColor: theme.colorTheme.disabled,
        ),
        child: Text(context.translations.cancelLabel.toUpperCase()),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).maybePop(true),
        style: TextButton.styleFrom(
          textStyle: theme.textTheme.headlineBold,
          foregroundColor: theme.colorTheme.accentPrimary,
          disabledForegroundColor: theme.colorTheme.disabled,
        ),
        child: Text(context.translations.deleteLabel.toUpperCase()),
      ),
    ];

    return AlertDialog(
      title: Text(
        context.translations.deletePollOptionLabel,
        style: pollCreatorTheme.actionDialogTitleStyle,
      ),
      content: Text(
        context.translations.deletePollOptionQuestion,
        style: pollCreatorTheme.actionDialogContentStyle,
      ),
      actions: actions,
      titlePadding: const EdgeInsetsDirectional.fromSTEB(16, 24, 16, 4),
      contentPadding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      actionsPadding: const EdgeInsets.all(8),
      backgroundColor: theme.colorTheme.appBg,
    );
  }
}
