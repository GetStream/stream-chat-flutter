import 'package:fluent_ui/fluent_ui.dart' as fui;
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart' as mui;
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/platform_widgets/platform_dialog.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A platform-aware dialog that asks the user to confirm that they want to
/// delete the selected message.
class DeleteMessageDialog extends StatelessWidget {
  /// Builds a [DeleteMessageDialog].
  const DeleteMessageDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformDialog(
      titleWidget: Text(context.translations.deleteMessageLabel),
      appIcon: const FlutterLogo(),
      message: Text(context.translations.deleteMessageQuestion),
      primaryButton: mui.PushButton(
        color: StreamChatTheme.of(context).colorTheme.accentPrimary,
        buttonSize: mui.ButtonSize.large,
        child: Text(context.translations.deleteLabel),
        onPressed: () => Navigator.of(context).pop(true),
      ),
      secondaryButton: mui.PushButton(
        color: mui.MacosColors.unemphasizedSelectedTextBackgroundColor,
        buttonSize: mui.ButtonSize.large,
        child: Text(context.translations.cancelLabel),
        onPressed: () => Navigator.of(context).pop(false),
      ),
      windowsActions: [
        fui.Button(
          child: Text(context.translations.cancelLabel),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        fui.Button(
          style: fui.ButtonStyle(
            backgroundColor: fui.ButtonState.all(
              StreamChatTheme.of(context).colorTheme.accentPrimary,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(context.translations.deleteLabel),
        ),
      ],
      title: context.translations.deleteMessageLabel,
      linuxActions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(context.translations.cancelLabel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(context.translations.deleteLabel),
        ),
      ],
      child: Text(context.translations.deleteMessageQuestion),
    );
  }
}
