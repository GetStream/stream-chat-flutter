import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_core_flutter/chat.dart';

/// {@template showPollDeleteOptionDialog}
/// Shows a dialog that allows the user to confirm deletion of a poll option.
///
/// See also:
///
///  * [PollDeleteOptionDialog], the dialog widget shown by this function.
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
///
/// See also:
///
///  * [showPollDeleteOptionDialog], the convenience function to show this
///    dialog.
/// {@endtemplate}
class PollDeleteOptionDialog extends StatelessWidget {
  /// {@macro pollDeleteOptionDialog}
  const PollDeleteOptionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;

    final actions = [
      StreamButton(
        type: .ghost,
        style: .secondary,
        size: .small,
        onPressed: () => Navigator.of(context).maybePop(false),
        child: Text(context.translations.cancelLabel),
      ),
      StreamButton(
        type: .solid,
        style: .destructive,
        size: .small,
        onPressed: () => Navigator.of(context).maybePop(true),
        child: Text(context.translations.deleteLabel),
      ),
    ];

    return AlertDialog(
      actions: actions,
      title: Text(context.translations.deletePollOptionLabel),
      content: Text(context.translations.deletePollOptionQuestion),
      backgroundColor: colorScheme.backgroundElevation1,
    );
  }
}
