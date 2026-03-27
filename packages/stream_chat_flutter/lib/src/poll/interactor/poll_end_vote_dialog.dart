import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';

/// {@template showPollEndVoteDialog}
/// Shows a dialog that allows the user to end vote for a poll.
///
/// See also:
///
///  * [PollEndVoteDialog], the dialog widget shown by this function.
///  * [StreamPollInteractor], which invokes this via [StreamPollInteractor.onEndVote].
/// {@endtemplate}
Future<bool?> showPollEndVoteDialog({
  required BuildContext context,
}) {
  return showDialog<bool?>(
    context: context,
    builder: (_) => const PollEndVoteDialog(),
  );
}

/// {@template pollEndVoteDialog}
/// A dialog that allows the user to end vote for a poll.
///
/// See also:
///
///  * [showPollEndVoteDialog], the convenience function to show this dialog.
///  * [StreamPollInteractor], the parent widget that triggers this dialog.
/// {@endtemplate}
class PollEndVoteDialog extends StatelessWidget {
  /// {@macro pollEndVoteDialog}
  const PollEndVoteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

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
        child: Text(context.translations.endLabel.toUpperCase()),
      ),
    ];

    return AlertDialog(
      title: Text(context.translations.endVoteConfirmationText),
      actions: actions,
      titlePadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(16),
      actionsPadding: const EdgeInsets.all(8),
      backgroundColor: theme.colorTheme.appBg,
    );
  }
}
