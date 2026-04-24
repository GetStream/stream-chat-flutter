import 'package:flutter/material.dart';
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
    final colorScheme = context.streamColorScheme;

    final actions = [
      StreamButton(
        type: .ghost,
        style: .secondary,
        size: .small,
        label: context.translations.cancelLabel.toUpperCase(),
        onTap: Navigator.of(context).pop,
      ),
      StreamButton(
        type: .ghost,
        style: .primary,
        size: .small,
        label: context.translations.sendLabel.toUpperCase(),
        onTap: switch (_option == widget.initialOption) {
          true => null,
          false => () => Navigator.of(context).pop(_option),
        },
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
