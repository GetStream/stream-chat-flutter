import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_core_flutter/chat.dart';

/// {@template showPollAddCommentDialog}
/// Shows a dialog that allows the user to add a poll comment.
///
/// Optionally, you can provide an [initialValue] to pre-fill the text field.
///
/// See also:
///
///  * [PollAddCommentDialog], the dialog widget shown by this function.
///  * [StreamPollInteractor], which invokes this via [StreamPollInteractor.onAddComment].
/// {@endtemplate}
Future<String?> showPollAddCommentDialog({
  required BuildContext context,
  String initialValue = '',
}) => showDialog<String?>(
  context: context,
  barrierDismissible: false,
  builder: (_) => PollAddCommentDialog(
    initialValue: initialValue,
  ),
);

/// {@template pollAddCommentDialog}
/// A dialog that allows the user to add or update a poll comment.
///
/// Optionally, you can provide an [initialValue] to pre-fill the text field.
///
/// See also:
///
///  * [showPollAddCommentDialog], the convenience function to show this dialog.
///  * [StreamPollInteractor], the parent widget that triggers this dialog.
/// {@endtemplate}
class PollAddCommentDialog extends StatefulWidget {
  /// {@macro pollAddCommentDialog}
  const PollAddCommentDialog({
    super.key,
    this.initialValue = '',
  });

  /// Initial answer to be displayed in the text field.
  ///
  /// Defaults to an empty string.
  final String initialValue;

  @override
  State<PollAddCommentDialog> createState() => _PollAddCommentDialogState();
}

class _PollAddCommentDialogState extends State<PollAddCommentDialog> {
  late String _comment = widget.initialValue;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;

    final actions = [
      StreamButton(
        type: .ghost,
        style: .secondary,
        size: .small,
        onPressed: Navigator.of(context).pop,
        child: Text(context.translations.cancelLabel),
      ),
      StreamButton(
        type: .solid,
        style: .primary,
        size: .small,
        onPressed: switch (_comment.trim()) {
          final comment when comment.isEmpty => null,
          final comment when comment == widget.initialValue => null,
          final comment => () => Navigator.of(context).pop(comment),
        },
        child: Text(context.translations.sendLabel),
      ),
    ];

    return AlertDialog(
      actions: actions,
      title: Text(
        switch (widget.initialValue.isEmpty) {
          true => context.translations.addACommentLabel,
          false => context.translations.updateYourCommentLabel,
        },
      ),
      backgroundColor: colorScheme.backgroundElevation1,
      content: StreamTextInput(
        autofocus: true,
        initialValue: _comment,
        hintText: context.translations.enterYourCommentLabel,
        onChanged: (value) => setState(() => _comment = value),
      ),
    );
  }
}
