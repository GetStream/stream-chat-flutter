import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_core_flutter/chat.dart';

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
        onPressed: switch (_option.trim()) {
          final option when option.isEmpty => null,
          final option when option == widget.initialOption => null,
          final option => () => Navigator.of(context).pop(option),
        },
        child: Text(context.translations.sendLabel),
      ),
    ];

    return AlertDialog(
      actions: actions,
      title: Text(context.translations.suggestAnOptionLabel),
      backgroundColor: colorScheme.backgroundElevation1,
      content: StreamTextInput(
        autofocus: true,
        initialValue: _option,
        hintText: context.translations.enterANewOptionLabel,
        onChanged: (value) => setState(() => _option = value),
      ),
    );
  }
}
