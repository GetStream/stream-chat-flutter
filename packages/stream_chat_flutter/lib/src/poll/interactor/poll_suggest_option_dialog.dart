import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/poll/stream_poll_text_field.dart';
import 'package:stream_chat_flutter/src/theme/poll_interactor_theme.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';

/// {@template pollSuggestOptionDialog}
/// A dialog that allows the user to suggest an option for a poll.
/// {@endtemplate}
class PollSuggestOptionDialog extends StatefulWidget {
  /// {@macro pollSuggestOptionDialog}
  const PollSuggestOptionDialog({
    super.key,
    this.initialOption = '',
  });

  /// Initial option to be displayed in the text field.
  ///
  /// Defaults to an empty string.
  final String initialOption;

  @override
  State<PollSuggestOptionDialog> createState() =>
      _PollSuggestOptionDialogState();
}

class _PollSuggestOptionDialogState extends State<PollSuggestOptionDialog> {
  late String _option = widget.initialOption;

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
        onPressed: switch (_option == widget.initialOption) {
          true => null,
          false => () => Navigator.of(context).pop(_option),
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
        context.translations.suggestAnOptionLabel,
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
        initialValue: _option,
        hintText: context.translations.enterANewOptionLabel,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        style: pollInteractorTheme.pollActionDialogTextFieldStyle,
        fillColor: pollInteractorTheme.pollActionDialogTextFieldFillColor,
        borderRadius: pollInteractorTheme.pollActionDialogTextFieldBorderRadius,
        onChanged: (value) => setState(() => _option = value),
      ),
    );
  }
}
