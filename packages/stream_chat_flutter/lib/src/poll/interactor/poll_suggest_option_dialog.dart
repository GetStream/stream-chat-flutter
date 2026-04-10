import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// {@template showPollSuggestOptionDialog}
/// Shows a dialog that allows the user to suggest an option for a poll.
///
/// Optionally, you can provide an [initialOption] to pre-fill the text field.
///
/// See also:
///
///  * [PollSuggestOptionDialog], the dialog widget shown by this function.
///  * [StreamPollInteractor], which invokes this via
///    [StreamPollInteractor.onSuggestOption].
/// {@endtemplate}
Future<String?> showPollSuggestOptionDialog({
  required BuildContext context,
  String initialOption = '',
}) => showDialog<String?>(
  context: context,
  barrierDismissible: false,
  builder: (_) => PollSuggestOptionDialog(
    initialOption: initialOption,
  ),
);

/// {@template pollSuggestOptionDialog}
/// A dialog that allows the user to suggest an option for a poll.
///
/// Optionally, you can provide an [initialOption] to pre-fill the text field.
///
/// See also:
///
///  * [showPollSuggestOptionDialog], the convenience function to show this
///    dialog.
///  * [StreamPollInteractor], the parent widget that triggers this dialog.
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
  State<PollSuggestOptionDialog> createState() => _PollSuggestOptionDialogState();
}

class _PollSuggestOptionDialogState extends State<PollSuggestOptionDialog> {
  late String _option = widget.initialOption;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

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
        // style: pollInteractorTheme.pollActionDialogTitleStyle,
      ),
      actions: actions,
      titlePadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(16),
      actionsPadding: const EdgeInsets.all(8),
      backgroundColor: theme.colorTheme.appBg,
      content: StreamTextInput(
        autofocus: true,
        initialValue: _option,
        hintText: context.translations.enterANewOptionLabel,
        inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'^\s'))],
        style: const .new(contentPadding: .symmetric(vertical: 12, horizontal: 16)),
        onChanged: (value) => setState(() => _option = value),
      ),
    );
  }
}
