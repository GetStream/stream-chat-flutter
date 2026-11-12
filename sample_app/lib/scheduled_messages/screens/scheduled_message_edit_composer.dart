import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../scheduled_messages_strings.dart';
import '../scheduled_messages_utils.dart';

/// Called with the message composed in a [ScheduledMessageEditComposer].
/// Resolves to whether the edit is done.
typedef ScheduledMessageEditCallback = Future<bool> Function(BuildContext context, Message message);

/// A composer that edits [scheduledMessage] of [channel], starting from
/// [message].
///
/// ✓ calls [onSave], and a long press on it [onSaveLongPress]. [onClose] is
/// called once the edit is done or canceled. When the scheduled message is no
/// longer listed, ✓ is disabled and a notice says it was already sent.
class ScheduledMessageEditComposer extends StatefulWidget {
  const ScheduledMessageEditComposer({
    super.key,
    required this.channel,
    required this.scheduledMessage,
    required this.message,
    required this.onSave,
    required this.onClose,
    this.onSaveLongPress,
  });

  /// The loaded channel the scheduled message is sent to.
  final Channel channel;

  /// The scheduled message being edited.
  final ScheduledMessage scheduledMessage;

  /// The message the composer starts from.
  final Message message;

  /// Called when ✓ is tapped.
  final ScheduledMessageEditCallback onSave;

  /// Called when ✓ is long-pressed.
  final ScheduledMessageEditCallback? onSaveLongPress;

  /// Called once the edit is done or canceled.
  final VoidCallback onClose;

  @override
  State<ScheduledMessageEditComposer> createState() => _ScheduledMessageEditComposerState();
}

class _ScheduledMessageEditComposerState extends State<ScheduledMessageEditComposer> {
  // In edit mode, so the composer shows what is being edited, with ✕.
  late final StreamMessageComposerController _controller;

  // Shows the composer's notices above it.
  final _notices = StreamSnackbarMessenger();

  StreamSubscription<List<ScheduledMessage>>? _scheduledMessagesSubscription;

  // Whether a request is in flight, during which ✓ is disabled.
  var _isSaving = false;

  // Whether the scheduled message is no longer listed, such as once it is sent.
  var _isGone = false;

  @override
  void initState() {
    super.initState();
    _controller = StreamMessageComposerController()..editMessage(widget.message);
    _controller.addListener(_onComposerChanged);

    final clientState = widget.channel.client.state;
    _scheduledMessagesSubscription = clientState.scheduledMessagesStream.listen(_onScheduledMessages);
  }

  @override
  void dispose() {
    _scheduledMessagesSubscription?.cancel();
    _controller
      ..removeListener(_onComposerChanged)
      ..dispose();
    _notices.dispose();
    super.dispose();
  }

  // ✕ ends the edit without saving.
  void _onComposerChanged() {
    if (!_controller.isEditing) widget.onClose();
  }

  void _onScheduledMessages(List<ScheduledMessage> scheduledMessages) {
    // A save can remove it, as scheduling a failed one again does.
    if (_isGone || _isSaving) return;

    final isListed = scheduledMessages.any((it) => it.id == widget.scheduledMessage.id);
    if (isListed) return;

    setState(() => _isGone = true);
    _notices.show(StreamSnackbar(message: const Text(ScheduledMessagesStrings.alreadySentError)));
  }

  Future<void> _save(ScheduledMessageEditCallback onSave) async {
    final fallback = context.translations.genericErrorText;

    setState(() => _isSaving = true);
    try {
      final isDone = await onSave(context, _controller.value);
      if (isDone) return widget.onClose();
    } catch (error, stackTrace) {
      debugPrint('Could not save the scheduled message: $error\n$stackTrace');
      final description = describeScheduleError(error, fallback: fallback);
      _notices.show(StreamSnackbar(message: Text(description), variant: .error));
    }

    if (mounted) setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    // ✓ saves the scheduled message instead of updating a sent one, here only.
    final builders = StreamComponentFactory.of(context);
    final saveButton = StreamComponentBuilders(
      extensions: streamChatComponentBuilders(
        messageComposerInputTrailing: (context, props) => _SaveButton(
          controller: props.controller,
          isEnabled: !_isSaving && !_isGone,
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
      messenger: _notices,
      child: StreamChatConfiguration(
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
              // Attachments upload on send, which saving doesn't do. The ones
              // the message already has can still be removed.
              disableAttachments: true,
              // Sending would update a sent message, so only ✓ saves it.
              enableVoiceRecording: false,
              sendMessageKeyPredicate: (_, _) => false,
            ),
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
    required this.isEnabled,
    required this.onPressed,
    this.onLongPress,
  });

  final StreamMessageComposerController controller;
  final bool isEnabled;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, _, _) {
        final canSave = controller.canSend && isEnabled;

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
