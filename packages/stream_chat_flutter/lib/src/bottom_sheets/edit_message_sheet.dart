import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils/utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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
                      child: StreamSvgIcon.edit(
                        color: streamChatThemeData.colorTheme.disabled,
                      ),
                    ),
                    Text(
                      context.translations.editMessageLabel,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      icon: StreamSvgIcon.closeSmall(),
                      onPressed: Navigator.of(context).pop,
                    ),
                  ],
                ),
              ),
              if (widget.editMessageInputBuilder != null)
                widget.editMessageInputBuilder!(context, widget.message)
              else
                StreamMessageInput(
                  messageInputController: controller,
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
