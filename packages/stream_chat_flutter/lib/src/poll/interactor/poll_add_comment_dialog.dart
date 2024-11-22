import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/poll/stream_poll_text_field.dart';
import 'package:stream_chat_flutter/src/theme/poll_interactor_theme.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';

/// {@template showPollAddCommentDialog}
/// Shows a dialog that allows the user to add a poll comment.
///
/// Optionally, you can provide an [initialValue] to pre-fill the text field.
/// {@endtemplate}
Future<String?> showPollAddCommentDialog({
  required BuildContext context,
  String initialValue = '',
}) =>
    showDialog<String?>(
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
    final theme = StreamChatTheme.of(context);
    final pollInteractorTheme = StreamPollInteractorTheme.of(context);

    final actions = [
      TextButton(
        onPressed: Navigator.of(context).pop,
        style: TextButton.styleFrom(
          textStyle: theme.textTheme.headlineBold,
          foregroundColor: theme.colorTheme.accentPrimary,
          disabledForegroundColor: theme.colorTheme.disabled,
        ),
        child: Text(context.translations.cancelLabel.toUpperCase()),
      ),
      TextButton(
        onPressed: switch (_comment == widget.initialValue) {
          true => null,
          false => () => Navigator.of(context).pop(_comment),
        },
        style: TextButton.styleFrom(
          textStyle: theme.textTheme.headlineBold,
          foregroundColor: theme.colorTheme.accentPrimary,
          disabledForegroundColor: theme.colorTheme.disabled,
        ),
        child: Text(context.translations.sendLabel.toUpperCase()),
      ),
    ];

    return AlertDialog(
      title: Text(
        switch (widget.initialValue.isEmpty) {
          true => context.translations.addACommentLabel,
          false => context.translations.updateYourCommentLabel,
        },
        style: pollInteractorTheme.pollActionDialogTitleStyle,
      ),
      actions: actions,
      titlePadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(16),
      actionsPadding: const EdgeInsets.all(8),
      backgroundColor: theme.colorTheme.appBg,
      content: StreamPollTextField(
        autoFocus: true,
        initialValue: _comment,
        hintText: context.translations.enterYourCommentLabel,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        style: pollInteractorTheme.pollActionDialogTextFieldStyle,
        fillColor: pollInteractorTheme.pollActionDialogTextFieldFillColor,
        borderRadius: pollInteractorTheme.pollActionDialogTextFieldBorderRadius,
        onChanged: (value) => setState(() => _comment = value),
      ),
    );
  }
}
