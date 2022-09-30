import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template messageDialog}
/// A dialog that displays a message to a user. Falls back to a
/// generic error message if no [titleText] and [messageText] are specified.
///
/// If using this dialog to display the default generic error, be sure NOT to
/// specify a [titleText] and [messageText] so the fallback strings can be used.
/// {@endtemplate}
class MessageDialog extends StatelessWidget {
  /// {@macro messageDialog}
  const MessageDialog({
    super.key,
    this.titleText,
    this.messageText,
  });

  /// The optional error message title to use.
  final String? titleText;

  /// The optional error message to use.
  final String? messageText;

  @override
  Widget build(BuildContext context) {
    final streamTheme = StreamChatTheme.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: streamTheme.colorTheme.appBg,
      title: Text(titleText ?? context.translations.somethingWentWrongError),
      content: messageText != null
          ? Text(
              messageText ??
                  context.translations.operationCouldNotBeCompletedText,
            )
          : null,
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            foregroundColor: streamTheme.colorTheme.accentPrimary,
          ),
          child: Text(context.translations.okLabel),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
