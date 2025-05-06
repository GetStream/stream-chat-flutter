import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/theme/poll_interactor_theme.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';

/// {@template showPollSuggestOptionDialog}
/// Shows a dialog that allows the user to end vote for a poll.
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
/// {@endtemplate}
class PollEndVoteDialog extends StatelessWidget {
  /// {@macro pollEndVoteDialog}
  const PollEndVoteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final pollInteractorTheme = StreamPollInteractorTheme.of(context);

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
      title: Text(
        context.translations.endVoteConfirmationText,
        style: pollInteractorTheme.pollActionDialogTitleStyle,
      ),
      actions: actions,
      titlePadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(16),
      actionsPadding: const EdgeInsets.all(8),
      backgroundColor: theme.colorTheme.appBg,
    );
  }
}
