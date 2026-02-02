import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template showEditMessageSheet}
/// Displays an interactive modal bottom sheet to edit a message.
/// {@endtemplate}
Future<T?> showEditMessageSheet<T extends Object?>({
  required BuildContext context,
  required Message message,
  required Channel channel,
  EditMessageInputBuilder? editMessageInputBuilder,
}) {
  final messageInputTheme = StreamMessageInputTheme.of(context);

  return showModalBottomSheet<T>(
    context: context,
    elevation: 2,
    isScrollControlled: true,
    clipBehavior: Clip.antiAlias,
    backgroundColor: messageInputTheme.inputBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    ),
    builder: (context) => EditMessageSheet(
      channel: channel,
      message: message,
      editMessageInputBuilder: editMessageInputBuilder,
    ),
  );
}

/// {@template editMessageSheet}
/// Allows a user to edit the selected message.
/// {@endtemplate}
class EditMessageSheet extends StatefulWidget {
  /// {@macro editMessageSheet}
  const EditMessageSheet({
    super.key,
    required this.message,
    required this.channel,
    this.editMessageInputBuilder,
  });

  /// {@macro editMessageInputBuilder}
  final EditMessageInputBuilder? editMessageInputBuilder;

  /// The message to edit.
  final Message message;

  /// The [StreamChannel] above this widget.
  final Channel channel;

  @override
  State<EditMessageSheet> createState() => _EditMessageSheetState();
}

class _EditMessageSheetState extends State<EditMessageSheet> {
  late final controller = StreamMessageInputController(
    message: widget.message,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final streamChatThemeData = StreamChatTheme.of(context);
    return KeyboardShortcutRunner(
      onEscapeKeypress: () => Navigator.of(context).pop(),
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: StreamChannel(
          channel: widget.channel,
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: StreamSvgIcon(
                        icon: StreamSvgIcons.edit,
                        color: streamChatThemeData.colorTheme.disabled,
                      ),
                    ),
                    Text(
                      context.translations.editMessageLabel,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: StreamSvgIcon(
                        icon: StreamSvgIcons.closeSmall,
                        color: streamChatThemeData.colorTheme.textLowEmphasis,
                      ),
                      onPressed: Navigator.of(context).pop,
                    ),
                  ],
                ),
              ),
              if (widget.editMessageInputBuilder != null)
                widget.editMessageInputBuilder!(context, widget.message)
              else
                StreamMessageInput(
                  elevation: 0,
                  messageInputController: controller,
                  // Disallow editing poll for now as it's not supported.
                  allowedAttachmentPickerTypes: [
                    ...AttachmentPickerType.values,
                  ]..remove(AttachmentPickerType.poll),
                  preMessageSending: (m) {
                    FocusScope.of(context).unfocus();
                    Navigator.of(context).pop();
                    return m;
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
