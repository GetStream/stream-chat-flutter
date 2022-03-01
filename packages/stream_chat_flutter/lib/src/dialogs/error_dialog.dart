import 'package:fluent_ui/fluent_ui.dart' as fui;
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/platform_widgets/platform_dialog.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A platform-aware dialog that displays a generic error message to the user
/// when something goes wrong.
///
/// Can be customized to show more specific error messages.
class ErrorDialog extends StatelessWidget {
  /// Builds an [ErrorDialog].
  const ErrorDialog({
    Key? key,
    this.titleText,
    this.messageText,
  }) : super(key: key);

  /// The optional error message title to use.
  final String? titleText;

  /// The optional error message to use.
  final String? messageText;

  @override
  Widget build(BuildContext context) => PlatformDialog(
        appIcon: const FlutterLogo(),
        titleWidget: Text(
          titleText ?? context.translations.somethingWentWrongError,
        ),
        message: Text(
          messageText ?? context.translations.operationCouldNotBeCompletedText,
        ),
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
