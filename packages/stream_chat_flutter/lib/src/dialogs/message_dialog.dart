import 'package:fluent_ui/fluent_ui.dart' as fui;
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/platform_widgets/platform_dialog.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A platform-aware dialog that displays a message to a user. Falls back to a
/// generic error message if no [titleText] and [messageText] are specified.
///
/// If using this dialog to display the default generic error, be sure NOT to
/// specify a [titleText] and [messageText] so the fallback strings can be used.
class MessageDialog extends StatelessWidget {
  /// Builds an [MessageDialog].
  const MessageDialog({
    Key? key,
    this.titleText,
    this.messageText,
    this.showMessage = true,
  }) : super(key: key);

  /// The optional error message title to use.
  final String? titleText;

  /// The optional error message to use.
  final String? messageText;

  /// TODO(Groovin): document me
  final bool? showMessage;

  @override
  Widget build(BuildContext context) {
    return PlatformDialog(
      appIcon: const FlutterLogo(),
      titleWidget: Text(
        titleText ?? context.translations.somethingWentWrongError,
      ),
      message: showMessage!
          ? Text(
              messageText ??
                  context.translations.operationCouldNotBeCompletedText,
            )
          : null,
      primaryButton: PushButton(
        buttonSize: ButtonSize.large,
        color: StreamChatTheme.of(context).colorTheme.accentPrimary,
        child: Text(context.translations.okLabel),
        onPressed: () => Navigator.of(context).pop(),
      ),
      windowsActions: [
        fui.Button(
          style: fui.ButtonStyle(
            backgroundColor: fui.ButtonState.all(
              StreamChatTheme.of(context).colorTheme.accentPrimary,
            ),
          ),
          child: Text(context.translations.okLabel),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
      title: titleText ?? context.translations.somethingWentWrongError,
      linuxActions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(context.translations.okLabel),
        ),
      ],
      child: Text(
        messageText ?? context.translations.operationCouldNotBeCompletedText,
      ),
    );
  }
}
