import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../scheduled_messages_utils.dart';

/// Called with the message composed in the edit sheet. Resolves to whether
/// the sheet is done and closes.
typedef EditScheduledMessageCallback = Future<bool> Function(BuildContext context, Message message);

/// Opens a sheet to edit [scheduledMessage] with the message composer of
/// [channel], prefilled with [message].
///
/// Tapping ✓ calls [onSave], and long-pressing it calls [onSaveLongPress]. A
/// failure shows why, and keeps the sheet open with the message as it is.
Future<void> showEditScheduledMessageSheet({
  required BuildContext context,
  required Channel channel,
  required ScheduledMessage scheduledMessage,
  required Message message,
  required String title,
  required EditScheduledMessageCallback onSave,
  EditScheduledMessageCallback? onSaveLongPress,
}) {
  return showStreamSheet<void>(
    context: context,
    isDismissible: true,
    builder: (_, _) => _EditScheduledMessageSheet(
      channel: channel,
      scheduledMessage: scheduledMessage,
      message: message,
      title: title,
      onSave: onSave,
      onSaveLongPress: onSaveLongPress,
    ),
  );
}

class _EditScheduledMessageSheet extends StatefulWidget {
  const _EditScheduledMessageSheet({
    required this.channel,
    required this.scheduledMessage,
    required this.message,
    required this.title,
    required this.onSave,
    this.onSaveLongPress,
  });

  final Channel channel;
  final ScheduledMessage scheduledMessage;
  final Message message;
  final String title;
  final EditScheduledMessageCallback onSave;
  final EditScheduledMessageCallback? onSaveLongPress;

  @override
  State<_EditScheduledMessageSheet> createState() => _EditScheduledMessageSheetState();
}

class _EditScheduledMessageSheetState extends State<_EditScheduledMessageSheet> {
  late final StreamMessageComposerController _controller;

  // Shows the sheet's errors above it, rather than on the page behind it.
  final _errors = StreamSnackbarMessenger();

  // Whether a request is in flight, during which ✓ is disabled.
  var _isSaving = false;

  @override
  void initState() {
    super.initState();
    _controller = StreamMessageComposerController(message: widget.message);
  }

  @override
  void dispose() {
    _controller.dispose();
    _errors.dispose();
    super.dispose();
  }

  Future<void> _save(EditScheduledMessageCallback onSave) async {
    final navigator = Navigator.of(context);
    final fallback = context.translations.genericErrorText;

    setState(() => _isSaving = true);
    try {
      final isDone = await onSave(context, _controller.value);
      if (isDone) return navigator.pop();
    } catch (error, stackTrace) {
      debugPrint('Could not save the scheduled message: $error\n$stackTrace');
      final description = describeScheduleError(error, fallback: fallback);
      _errors.show(StreamSnackbar(message: Text(description), variant: .error));
    }

    if (mounted) setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    final translations = context.translations;
    final scheduledFor = translations.scheduledMessageScheduledForText(
      scheduledAt: widget.scheduledMessage.scheduledAt,
    );

    // ✓ saves the message instead of sending it, in this sheet only.
    final builders = StreamComponentFactory.of(context);
    final saveButton = StreamComponentBuilders(
      extensions: streamChatComponentBuilders(
        messageComposerInputTrailing: (context, props) => _SaveButton(
          controller: props.controller,
          isSaving: _isSaving,
          onPressed: () => _save(widget.onSave),
          onLongPress: switch (widget.onSaveLongPress) {
            final onSaveLongPress? => () => _save(onSaveLongPress),
            null => null,
          },
        ),
      ),
    );

    // The composer only edits the scheduled message, so it keeps no draft.
    final config = StreamChatConfiguration.of(context).copyWith(draftMessagesEnabled: false);

    return StreamSnackbarPopup.withState(
      messenger: _errors,
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: SafeArea(
          child: Column(
            mainAxisSize: .min,
            children: [
              StreamSheetHeader(
                title: Text(widget.title),
                subtitle: Text(scheduledFor),
              ),
              StreamChatConfiguration(
                data: config,
                child: StreamComponentFactory(
                  builders: builders.copyWith(
                    extensions: {...builders.extensions, ...saveButton.extensions},
                  ),
                  child: StreamChannel(
                    channel: widget.channel,
                    child: StreamMessageComposer(
                      messageComposerController: _controller,
                      autofocus: true,
                      // Attachments upload on send, which the sheet doesn't do.
                      // The ones the message already has can still be removed.
                      disableAttachments: true,
                      // Sending would post the message, so only ✓ saves it.
                      enableVoiceRecording: false,
                      sendMessageKeyPredicate: (_, _) => false,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// The composer's ✓, which saves the message while it can be sent.
class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.controller,
    required this.isSaving,
    required this.onPressed,
    this.onLongPress,
  });

  final StreamMessageComposerController controller;
  final bool isSaving;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, _, _) {
        final canSave = controller.canSend && !isSaving;

        return StreamButton.icon(
          icon: Icon(context.streamIcons.checkmark),
          size: StreamButtonSize.small,
          tooltip: context.translations.accessibility.saveEditTooltip,
          onPressed: canSave ? onPressed : null,
          onLongPress: canSave ? onLongPress : null,
        );
      },
    );
  }
}
