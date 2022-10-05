import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template deleteMessageDialog}
/// A dialog that asks the user to confirm that they want to
/// delete the selected message.
/// {@endtemplate}
class DeleteMessageDialog extends StatelessWidget {
  /// {@macro deleteMessageDialog}
  const DeleteMessageDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final streamTheme = StreamChatTheme.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: streamTheme.colorTheme.appBg,
      title: Text(context.translations.deleteMessageLabel),
      content: Text(context.translations.deleteMessageQuestion),
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
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(context.translations.deleteLabel),
        ),
      ],
    );
  }
}
