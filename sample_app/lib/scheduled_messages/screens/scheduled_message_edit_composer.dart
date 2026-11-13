import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../scheduled_messages_strings.dart';
import '../scheduled_messages_utils.dart';

/// A composer that edits [scheduledMessage], in the channel of the enclosing
/// [StreamChannel].
///
/// ✓ saves it at its time, or schedules a failed one again at a time picked in
/// a sheet. [onClose] is called once the edit is done or canceled.
class ScheduledMessageEditComposer extends StatefulWidget {
  const ScheduledMessageEditComposer({super.key, required this.scheduledMessage, required this.onClose});

  /// The scheduled message being edited.
  final ScheduledMessage scheduledMessage;

  /// Called once the edit is done or canceled.
  final VoidCallback onClose;

  @override
  State<ScheduledMessageEditComposer> createState() => _ScheduledMessageEditComposerState();
}

class _ScheduledMessageEditComposerState extends State<ScheduledMessageEditComposer> {
  late final _controller = StreamMessageComposerController()..editMessage(widget.scheduledMessage.toMessage());

  @override
  void initState() {
    super.initState();
    // ✕ ends the edit without saving.
    _controller.addListener(() {
      if (!_controller.isEditing) widget.onClose();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // The edit closes right away, and the list shows how saving it goes.
  Future<void> _save() async {
    final client = StreamChat.of(context).client;
    final channel = StreamChannel.of(context).channel;
    final messenger = StreamSnackbarMessenger.of(context);
    final fallback = context.translations.genericErrorText;
    final scheduledMessage = widget.scheduledMessage;
    final edited = _controller.value;

    final quotesDeletedMessage = ScheduledMessageRules.quotesDeletedMessage(edited, channel);

    // A failed one can't be changed, unless only its edit failed, so the edit
    // is scheduled again as a new message and the failed one is deleted.
    final isScheduledAgain = scheduledMessage.status == .failed && scheduledMessage.failureReason != .updateFailed;

    // Refused before the composer closes, so the text can still be fixed.
    void showRefusal(String refusal) {
      messenger.show(StreamSnackbar(message: Text(refusal), variant: .error));
    }

    if (ScheduledMessageRules.isCommand(edited, channel)) {
      showRefusal(ScheduledMessagesStrings.commandNotSchedulable);
      return;
    }

    // A message scheduled again leaves a deleted quote out instead, as the
    // composer can't remove it while editing.
    if (quotesDeletedMessage && !isScheduledAgain) {
      showRefusal(ScheduledMessagesStrings.quotedMessageDeleted);
      return;
    }

    if (!isScheduledAgain) {
      widget.onClose();
      try {
        // A failed reschedule left the new time on it, so saving retries the
        // move too.
        final scheduledAt = scheduledMessage.scheduledAt;
        await client.updateScheduledMessage(scheduledMessage.id, edited, scheduledAt: scheduledAt);
      } catch (error) {
        showScheduleError(messenger, error, fallback: fallback);
      }
      return;
    }

    final scheduledAt = await showStreamScheduleTimeSheet(context: context, channel: channel, message: edited);
    if (scheduledAt == null || !mounted) return;

    widget.onClose();
    final message = Message(
      text: edited.text,
      attachments: [...edited.attachments.where((it) => it.uploadState.isSuccess)],
      mentionedUsers: edited.mentionedUsers,
      quotedMessageId: quotesDeletedMessage ? null : edited.quotedMessageId,
      parentId: edited.parentId,
      showInChannel: edited.showInChannel,
      extraData: edited.extraData,
    );

    try {
      await channel.scheduleMessage(message, scheduledAt: scheduledAt);
    } catch (error) {
      showScheduleError(messenger, error, fallback: fallback);
      return;
    }

    try {
      await client.deleteScheduledMessage(scheduledMessage.id);
    } catch (_) {
      const notRemoved = Text(ScheduledMessagesStrings.failedOneNotRemoved);
      messenger.show(StreamSnackbar(message: notRemoved, variant: .error));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Canceling restores the empty message from before the edit, which would
    // otherwise delete the channel's draft as the composer goes away.
    final config = StreamChatConfiguration.of(context).copyWith(draftMessagesEnabled: false);

    return StreamChatConfiguration(
      data: config,
      child: StreamMessageComposer(
        messageComposerController: _controller,
        autofocus: true,
        onSendMessage: (_, _) => _save(),
        // Attachments upload on send, which saving doesn't do.
        disableAttachments: true,
      ),
    );
  }
}
