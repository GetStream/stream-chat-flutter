import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../scheduled_messages_strings.dart';
import '../scheduled_messages_utils.dart';
import 'scheduled_message_edit_composer.dart';

/// A pushed screen listing the current user's scheduled messages.
///
/// It lists the messages in the channel [cid], the replies in the thread of
/// [parentId], or those in every channel when both are null.
class ScheduledMessagesScreen extends StatelessWidget {
  const ScheduledMessagesScreen({super.key, this.cid, this.parentId});

  /// The channel whose scheduled messages are listed.
  final String? cid;

  /// The ID of the message whose thread's scheduled replies are listed.
  ///
  /// When set, [cid] is ignored.
  final String? parentId;

  @override
  Widget build(BuildContext context) {
    return StreamScaffold(
      backgroundColor: context.streamColorScheme.backgroundApp,
      appBar: StreamAppBar(title: const Text(ScheduledMessagesStrings.title)),
      body: ScheduledMessagesPage(cid: cid, parentId: parentId),
    );
  }
}

/// The current user's scheduled messages, with the actions on each.
///
/// It lists the messages in the channel [cid], the replies in the thread of
/// [parentId], or those in every channel when both are null.
class ScheduledMessagesPage extends StatefulWidget {
  const ScheduledMessagesPage({super.key, this.cid, this.parentId});

  /// The channel whose scheduled messages are listed.
  final String? cid;

  /// The ID of the message whose thread's scheduled replies are listed.
  ///
  /// When set, [cid] is ignored.
  final String? parentId;

  @override
  State<ScheduledMessagesPage> createState() => _ScheduledMessagesPageState();
}

class _ScheduledMessagesPageState extends State<ScheduledMessagesPage> {
  // The scheduled message being edited in the composer under the list.
  ScheduledMessage? _editing;

  void _startEdit(ScheduledMessage scheduledMessage) => setState(() => _editing = scheduledMessage);

  void _closeEdit() => setState(() => _editing = null);

  @override
  Widget build(BuildContext context) {
    final client = StreamChat.of(context).client;
    final editing = _editing;
    // The edit ends if its channel goes away.
    final editChannel = switch (editing) {
      final it? => client.state.channels[it.cid],
      null => null,
    };

    // Back ends an edit before it leaves the page.
    return PopScope(
      canPop: editChannel == null,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _closeEdit();
      },
      child: Column(
        children: [
          Expanded(
            child: RefreshIndicator.adaptive(
              onRefresh: () => _refresh(context),
              child: StreamScheduledMessageListView(
                cid: widget.cid,
                parentId: widget.parentId,
                physics: const AlwaysScrollableScrollPhysics(),
                onScheduledMessageTap: (it) => _openScheduledMessageActions(context, it, _startEdit),
              ),
            ),
          ),
          // Shows the composer's notices above it, also once it has closed.
          StreamSnackbarPopup(
            child: editing != null && editChannel != null
                ? StreamChannel(
                    key: ValueKey(editing.id),
                    channel: editChannel,
                    child: ScheduledMessageEditComposer(scheduledMessage: editing, onClose: _closeEdit),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// Reloads the scheduled messages, showing why when it fails.
Future<void> _refresh(BuildContext context) async {
  final client = StreamChat.of(context).client;
  final messenger = StreamSnackbarMessenger.of(context);
  final fallback = context.translations.genericErrorText;

  try {
    await client.loadScheduledMessages();
  } catch (error) {
    final description = describeScheduleError(error, fallback: fallback);
    messenger.show(StreamSnackbar(message: Text(description), variant: .error));
  }
}

Future<void> _openScheduledMessageActions(
  BuildContext context,
  ScheduledMessage scheduledMessage,
  ValueSetter<ScheduledMessage> startEdit,
) async {
  // A message being sent has no actions, so its sheet wouldn't open.
  final actions = StreamScheduledMessageActionsBuilder.buildActions(
    context: context,
    scheduledMessage: scheduledMessage,
  );
  if (actions.isEmpty) {
    final messenger = StreamSnackbarMessenger.of(context);
    messenger.show(StreamSnackbar(message: const Text(ScheduledMessagesStrings.stillSending)));
    return;
  }

  final action = await showStreamScheduledMessageActionsSheet(
    context: context,
    scheduledMessage: scheduledMessage,
  );

  if (action == null || !context.mounted) return;
  return _onScheduledMessageAction(context, action, startEdit);
}

Future<void> _onScheduledMessageAction(
  BuildContext context,
  ScheduledMessageAction action,
  ValueSetter<ScheduledMessage> startEdit,
) async {
  return switch (action) {
    EditScheduledMessage(:final scheduledMessage) => _edit(context, scheduledMessage, startEdit),
    RetryScheduledMessage(:final scheduledMessage) => _retry(context, scheduledMessage),
    EditAndRescheduleMessage(:final scheduledMessage) => _edit(context, scheduledMessage, startEdit),
    RescheduleMessage(:final scheduledMessage) => _reschedule(context, scheduledMessage),
    SendScheduledMessageNow(:final scheduledMessage) => _sendNow(context, scheduledMessage),
    CopyScheduledMessageText(:final scheduledMessage) => _copyText(context, scheduledMessage),
    DeleteScheduledMessage(:final scheduledMessage) => _maybeDelete(context, scheduledMessage),
  };
}

// Runs [call], showing the text it resolves to, or why it failed.
Future<void> _run(BuildContext context, Future<String> Function() call) async {
  final messenger = StreamSnackbarMessenger.of(context);
  final fallback = context.translations.genericErrorText;

  try {
    final done = await call();
    messenger.show(StreamSnackbar(message: Text(done), variant: .success));
  } catch (error) {
    final description = describeScheduleError(error, fallback: fallback);
    messenger.show(StreamSnackbar(message: Text(description), variant: .error));
  }
}

// Starts editing [scheduledMessage] once its channel is loaded.
Future<void> _edit(
  BuildContext context,
  ScheduledMessage scheduledMessage,
  ValueSetter<ScheduledMessage> startEdit,
) async {
  final client = StreamChat.of(context).client;
  final messenger = StreamSnackbarMessenger.of(context);
  final fallback = context.translations.genericErrorText;

  final channel = await _loadChannel(context, scheduledMessage);
  if (channel == null || !context.mounted) return;

  try {
    startEdit(await _withMentionedUsers(client, scheduledMessage));
  } catch (error) {
    final description = describeScheduleError(error, fallback: fallback);
    messenger.show(StreamSnackbar(message: Text(description), variant: .error));
  }
}

// [scheduledMessage] with the names of its mentioned users, which come with
// only their IDs. A mention whose name isn't known is dropped when it is
// saved, even if it is still in the text.
//
// TODO: Remove once scheduled messages come with their mentioned users resolved.
Future<ScheduledMessage> _withMentionedUsers(StreamChatClient client, ScheduledMessage scheduledMessage) async {
  final content = scheduledMessage.message;
  final ids = [for (final user in content.mentionedUsers) user.id];
  final missing = [...ids.where((id) => client.state.users[id] == null)];
  if (missing.isNotEmpty) await client.queryUsers(filter: Filter.in_('id', missing));

  final mentionedUsers = [for (final id in ids) client.state.users[id] ?? User(id: id)];
  return scheduledMessage.copyWith(message: content.copyWith(mentionedUsers: mentionedUsers));
}

// The channel [scheduledMessage] is sent to, loaded without watching it when
// it isn't loaded yet. Shows why it couldn't be loaded, and resolves to null.
Future<Channel?> _loadChannel(BuildContext context, ScheduledMessage scheduledMessage) async {
  final client = StreamChat.of(context).client;
  final cid = scheduledMessage.cid;
  if (client.state.channels[cid] case final channel?) return channel;

  final messenger = StreamSnackbarMessenger.of(context);
  final fallback = context.translations.genericErrorText;
  final [type, id] = cid.split(':');
  final channel = client.channel(type, id: id);

  void showError(String description) {
    messenger.show(StreamSnackbar(message: Text(description), variant: .error));
  }

  try {
    await channel.query();
  } catch (error) {
    showError(describeScheduleError(error, fallback: fallback));
    return null;
  }

  // Offline, a query can answer from the cache without loading the channel.
  if (channel.state == null) {
    showError(fallback);
    return null;
  }

  return channel;
}

Future<void> _reschedule(BuildContext context, ScheduledMessage scheduledMessage) async {
  final client = StreamChat.of(context).client;

  final channel = await _loadChannel(context, scheduledMessage);
  if (channel == null || !context.mounted) return;

  final scheduledAt = await showStreamScheduleTimeSheet(
    context: context,
    channel: channel,
    message: scheduledMessage.message,
    initialScheduledAt: scheduledMessage.scheduledAt,
  );
  if (scheduledAt == null || !context.mounted) return;

  return _run(context, () async {
    await client.rescheduleMessage(scheduledMessage, scheduledAt: scheduledAt);
    return ScheduledMessagesStrings.rescheduled;
  });
}

Future<void> _retry(BuildContext context, ScheduledMessage scheduledMessage) {
  final client = StreamChat.of(context).client;

  final isEdit = scheduledMessage.failureReason == .updateFailed;

  return _run(context, () async {
    final scheduled = await client.retryScheduledMessage(scheduledMessage);
    // Null when its time had passed and it was sent right away.
    if (scheduled == null) return ScheduledMessagesStrings.sendingNow;
    return isEdit ? ScheduledMessagesStrings.updated : ScheduledMessagesStrings.scheduled;
  });
}

Future<void> _sendNow(BuildContext context, ScheduledMessage scheduledMessage) {
  final client = StreamChat.of(context).client;

  return _run(context, () async {
    await client.sendScheduledMessageNow(scheduledMessage);
    return ScheduledMessagesStrings.sendingNow;
  });
}

Future<void> _copyText(BuildContext context, ScheduledMessage scheduledMessage) async {
  final messenger = StreamSnackbarMessenger.of(context);

  await Clipboard.setData(ClipboardData(text: scheduledMessage.message.text ?? ''));
  messenger.show(StreamSnackbar(message: const Text(ScheduledMessagesStrings.copied), variant: .success));
}

Future<void> _maybeDelete(BuildContext context, ScheduledMessage scheduledMessage) async {
  final client = StreamChat.of(context).client;
  final translations = context.translations;
  final messenger = StreamSnackbarMessenger.of(context);

  final channelName = scheduledMessageChannelName(context, scheduledMessage);
  final confirmed = await showStreamDialog<bool>(
    context: context,
    builder: (context) => StreamMessageActionConfirmationModal(
      isDestructiveAction: true,
      title: const Text(ScheduledMessagesStrings.deleteQuestion),
      content: Text(
        ScheduledMessagesStrings.deleteDescription(channelName),
      ),
      cancelActionTitle: Text(translations.cancelLabel),
      confirmActionTitle: Text(translations.deleteLabel),
    ),
  );
  if (confirmed != true) return;

  try {
    await client.deleteScheduledMessage(scheduledMessage);
    messenger.show(StreamSnackbar(message: const Text(ScheduledMessagesStrings.deleted), variant: .success));
  } catch (error) {
    // Sent at its time, or deleted elsewhere.
    if (isScheduledMessageGone(error)) {
      final isSent =
          error is StreamChatNetworkError && error.scheduledMessageErrorReason == .scheduledMessageAlreadySent;
      final gone = isSent ? ScheduledMessagesStrings.alreadySent : ScheduledMessagesStrings.sentOrDeleted;
      messenger.show(StreamSnackbar(message: Text(gone)));
      return;
    }

    final description = describeScheduleError(error, fallback: translations.genericErrorText);
    messenger.show(StreamSnackbar(message: Text(description), variant: .error));
  }
}
