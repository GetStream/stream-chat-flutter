import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// /// {@template confirmationDialog}
/// A dialog that prompts the user to take an action or cancel.
/// {@endtemplate}
class ConfirmationDialog extends StatelessWidget {
  /// {@macro confirmationDialog}
  const ConfirmationDialog({
    super.key,
    required this.titleText,
    required this.promptText,
    required this.affirmativeText,
    required this.onConfirmation,
  });

  /// The text to use for the dialog title.
  final String titleText;

  /// The text to use for the dialog prompt.
  final String promptText;

  /// The text to use for the confirmation button.
  final String affirmativeText;

  /// The action to perform when the user confirms their choice.
  final VoidCallback onConfirmation;

  @override
  Widget build(BuildContext context) {
    final streamTheme = StreamChatTheme.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: streamTheme.colorTheme.appBg,
      title: Text(titleText),
      content: Text(promptText),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: streamTheme.colorTheme.accentPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(context.translations.cancelLabel),
        ),
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: streamTheme.colorTheme.accentPrimary,
          ),
          onPressed: () {
            onConfirmation.call();
            Navigator.of(context).pop(true);
          },
          child: Text(affirmativeText),
        ),
      ],
    );
  }
}
