import 'package:fluent_ui/fluent_ui.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/platform_widgets/platform_dialog.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

///
class DeleteMessageDialog extends StatelessWidget {
  ///
  const DeleteMessageDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => PlatformDialog(
        title: Text(context.translations.deleteMessageLabel),
        appIcon: const FlutterLogo(),
        message: Text(context.translations.deleteMessageQuestion),
        primaryButton: PushButton(
          color: StreamChatTheme.of(context).colorTheme.accentPrimary,
          buttonSize: ButtonSize.large,
          child: Text(context.translations.deleteLabel),
          onPressed: () => Navigator.of(context).pop(true),
        ),
        secondaryButton: PushButton(
          color: MacosColors.unemphasizedSelectedTextBackgroundColor,
          buttonSize: ButtonSize.large,
          child: Text(context.translations.cancelLabel),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        actions: [
          Button(
            child: Text(context.translations.cancelLabel),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          Button(
            style: ButtonStyle(
              backgroundColor: ButtonState.all(
                StreamChatTheme.of(context).colorTheme.accentPrimary,
              ),
            ),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.translations.deleteLabel),
          ),
        ],
      );
}
