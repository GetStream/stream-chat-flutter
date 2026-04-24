import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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
    final colorScheme = context.streamColorScheme;

    final actions = [
      StreamButton(
        type: .ghost,
        style: .secondary,
        size: .small,
        label: context.translations.cancelLabel.toUpperCase(),
        onTap: () => Navigator.of(context).maybePop(false),
      ),
      StreamButton(
        type: .ghost,
        style: .destructive,
        size: .small,
        label: context.translations.endLabel.toUpperCase(),
        onTap: () => Navigator.of(context).maybePop(true),
      ),
    ];

    return AlertDialog(
      actions: actions,
      title: Text(context.translations.endVoteConfirmationTitle),
      content: Text(context.translations.endVoteConfirmationMessage),
      backgroundColor: colorScheme.backgroundElevation1,
    );
  }
}
