import 'package:collection/collection.dart';
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
  _Edit? _edit;

  void _startEdit(_Edit edit) => setState(() => _edit = edit);

  void _closeEdit() => setState(() => _edit = null);

  @override
  Widget build(BuildContext context) {
    final edit = _edit;

    // Back ends an edit before it leaves the page.
    return PopScope(
      canPop: edit == null,
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
                emptyBuilder: (context) => const _NoScheduledMessages(),
              ),
            ),
          ),
          if (edit != null)
            ScheduledMessageEditComposer(
              key: ValueKey(edit.scheduledMessage.id),
              channel: edit.channel,
              scheduledMessage: edit.scheduledMessage,
              message: edit.message,
              onSave: edit.onSave,
              onSaveLongPress: edit.onSaveLongPress,
              onClose: _closeEdit,
            ),
        ],
      ),
    );
  }
}

// An edit of a scheduled message in the composer under the list.
typedef _Edit = ({
  Channel channel,
  ScheduledMessage scheduledMessage,
  Message message,
  ScheduledMessageEditCallback onSave,
  ScheduledMessageEditCallback onSaveLongPress,
});

// The empty list, with a hint on how to schedule a message.
class _NoScheduledMessages extends StatelessWidget {
  const _NoScheduledMessages();

  @override
  Widget build(BuildContext context) {
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    return Center(
      child: StreamScrollViewEmptyWidget(
        emptyIcon: Icon(context.streamIcons.clock),
        emptyTitle: Column(
          mainAxisSize: .min,
          children: [
            Text(
              context.translations.noScheduledMessagesText,
              style: textTheme.bodyEmphasis.copyWith(color: colorScheme.textPrimary),
            ),
            Text(
              ScheduledMessagesStrings.emptyDescription,
              textAlign: .center,
              style: textTheme.bodyDefault.copyWith(color: colorScheme.textSecondary),
            ),
          ],
        ),
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
  } catch (error, stackTrace) {
    debugPrint('Could not load the scheduled messages: $error\n$stackTrace');
    final description = describeScheduleError(error, fallback: fallback);
    messenger.show(StreamSnackbar(message: Text(description), variant: .error));
  }
}

Future<void> _openScheduledMessageActions(
  BuildContext context,
  ScheduledMessage scheduledMessage,
  void Function(_Edit edit) startEdit,
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
  void Function(_Edit edit) startEdit,
) async {
  return switch (action) {
    EditScheduledMessage(:final scheduledMessage) => _editScheduledMessage(context, scheduledMessage, startEdit),
    RetryScheduledMessage(:final scheduledMessage) => _retry(context, scheduledMessage),
    EditAndRescheduleMessage(:final scheduledMessage) => _editAndReschedule(context, scheduledMessage, startEdit),
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
  } catch (error, stackTrace) {
    debugPrint('Scheduled message action failed: $error\n$stackTrace');
    final description = describeScheduleError(error, fallback: fallback);
    messenger.show(StreamSnackbar(message: Text(description), variant: .error));
  }
}

Future<void> _editScheduledMessage(
  BuildContext context,
  ScheduledMessage scheduledMessage,
  void Function(_Edit edit) startEdit,
) async {
  final client = StreamChat.of(context).client;
  final messenger = StreamSnackbarMessenger.of(context);

  final channel = await _loadChannel(context, scheduledMessage);
  if (channel == null || !context.mounted) return;

  final message = await _prefill(context, client, scheduledMessage);
  if (message == null || !context.mounted) return;

  startEdit((
    channel: channel,
    scheduledMessage: scheduledMessage,
    message: message,
    // Keeps its time.
    onSave: (context, edited) async {
      await client.updateScheduledMessage(scheduledMessage, edited);
      messenger.show(StreamSnackbar(message: const Text(ScheduledMessagesStrings.updated), variant: .success));
      return true;
    },
    // A long press also moves it to another time.
    onSaveLongPress: (context, edited) async {
      final scheduledAt = await showStreamScheduleTimeSheet(
        context: context,
        channel: channel,
        message: edited,
        initialScheduledAt: scheduledMessage.scheduledAt,
      );
      if (scheduledAt == null) return false;

      await client.updateScheduledMessage(scheduledMessage, edited, scheduledAt: scheduledAt);
      messenger.show(StreamSnackbar(message: const Text(ScheduledMessagesStrings.rescheduled), variant: .success));
      return true;
    },
  ));
}

// The content of [scheduledMessage] for the composer, with its mentioned
// users and quoted message resolved. Shows why they couldn't be, and resolves
// to null.
Future<Message?> _prefill(
  BuildContext context,
  StreamChatClient client,
  ScheduledMessage scheduledMessage,
) async {
  final messenger = StreamSnackbarMessenger.of(context);
  final fallback = context.translations.genericErrorText;
  final content = scheduledMessage.message;

  try {
    final mentionedUsers = await _resolveMentionedUsers(client, content);
    final quotedMessage = await _resolveQuotedMessage(client, scheduledMessage);
    // The composer starts from a draft, not from a message already sent.
    return content.copyWith(
      mentionedUsers: mentionedUsers,
      quotedMessage: quotedMessage,
      state: const MessageState.initial(),
    );
  } catch (error) {
    final description = describeScheduleError(error, fallback: fallback);
    messenger.show(StreamSnackbar(message: Text(description), variant: .error));
    return null;
  }
}

// The channel [scheduledMessage] is sent to, loaded without watching it when
// it isn't loaded yet. Shows why it couldn't be loaded, and resolves to null.
Future<Channel?> _loadChannel(BuildContext context, ScheduledMessage scheduledMessage) async {
  final client = StreamChat.of(context).client;
  final cid = scheduledMessage.cid;
  if (client.state.channels[cid] case final channel?) return channel;

  final messenger = StreamSnackbarMessenger.of(context);
  final fallback = context.translations.genericErrorText;
  final ChannelModel(:id, :type) = ChannelModel(cid: cid);
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

Future<void> _editAndReschedule(
  BuildContext context,
  ScheduledMessage scheduledMessage,
  void Function(_Edit edit) startEdit,
) async {
  final client = StreamChat.of(context).client;
  final messenger = StreamSnackbarMessenger.of(context);

  final channel = await _loadChannel(context, scheduledMessage);
  if (channel == null || !context.mounted) return;

  final message = await _prefill(context, client, scheduledMessage);
  if (message == null || !context.mounted) return;

  Future<bool> scheduleAgain(BuildContext context, Message edited) async {
    final scheduledAt = await showStreamScheduleTimeSheet(context: context, channel: channel, message: edited);
    if (scheduledAt == null) return false;

    final isFailedOneRemoved = await _scheduleAgain(client, channel, scheduledMessage, scheduledAt, edited);
    messenger.show(StreamSnackbar(message: const Text(ScheduledMessagesStrings.scheduled), variant: .success));
    if (!isFailedOneRemoved) {
      messenger.show(
        StreamSnackbar(message: const Text(ScheduledMessagesStrings.failedOneNotRemoved), variant: .error),
      );
    }
    return true;
  }

  startEdit((
    channel: channel,
    scheduledMessage: scheduledMessage,
    message: message,
    onSave: scheduleAgain,
    onSaveLongPress: scheduleAgain,
  ));
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

  return _run(context, () async {
    await client.retryScheduledMessage(scheduledMessage);
    return ScheduledMessagesStrings.scheduled;
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
  } catch (error, stackTrace) {
    debugPrint('Could not delete the scheduled message: $error\n$stackTrace');
    final goneMessage = switch (error) {
      StreamChatNetworkError(scheduledMessageErrorReason: .scheduledMessageAlreadySent) =>
        ScheduledMessagesStrings.alreadySent,
      // Not found: sent at its time, or deleted elsewhere.
      StreamChatNetworkError(statusCode: 404) => ScheduledMessagesStrings.sentOrDeleted,
      _ => null,
    };
    if (goneMessage != null) {
      messenger.show(StreamSnackbar(message: Text(goneMessage)));
      return;
    }

    final description = describeScheduleError(error, fallback: translations.genericErrorText);
    messenger.show(StreamSnackbar(message: Text(description), variant: .error));
  }
}

// A failed scheduled message can't be changed, so [edited] is scheduled as a
// new message and the failed one is removed. Resolves to whether the failed
// one was removed.
Future<bool> _scheduleAgain(
  StreamChatClient client,
  Channel channel,
  ScheduledMessage scheduledMessage,
  DateTime scheduledAt,
  Message edited,
) async {
  // A quoted message that was deleted can't be quoted again.
  final quotedMessageId = switch (edited.quotedMessage) {
    final quoted? when !quoted.isDeleted => quoted.id,
    _ => null,
  };

  final message = Message(
    text: edited.text,
    attachments: edited.attachments,
    mentionedUsers: edited.mentionedUsers,
    quotedMessageId: quotedMessageId,
    parentId: edited.parentId,
    showInChannel: edited.showInChannel,
    extraData: edited.extraData,
  );

  await channel.scheduleMessage(message, scheduledAt: scheduledAt);

  try {
    await client.deleteScheduledMessage(scheduledMessage);
    return true;
  } catch (error, stackTrace) {
    // It is scheduled again either way; the failed one can be deleted later.
    debugPrint('Could not delete the failed scheduled message: $error\n$stackTrace');
    return false;
  }
}

// A scheduled message's mentioned users can have only their IDs set. With
// their names, a mention still in the text is kept when the message is sent
// again, and one that was removed is dropped.
Future<List<User>> _resolveMentionedUsers(StreamChatClient client, Message message) async {
  final ids = [for (final user in message.mentionedUsers) user.id];
  final missing = [...ids.where((id) => client.state.users[id] == null)];
  if (missing.isNotEmpty) await client.queryUsers(filter: Filter.in_('id', missing));

  return [for (final id in ids) client.state.users[id] ?? User(id: id)];
}

// A scheduled message's quoted message is identified by its ID only. It is
// looked up among the channel's loaded messages and the thread's, and
// fetched otherwise.
Future<Message?> _resolveQuotedMessage(StreamChatClient client, ScheduledMessage scheduledMessage) async {
  final content = scheduledMessage.message;
  final quotedMessageId = content.quotedMessageId;
  if (quotedMessageId == null) return null;

  final state = client.state.channels[scheduledMessage.cid]?.state;
  final loaded = [...?state?.messages, ...?state?.threads[content.parentId]];
  if (loaded.firstWhereOrNull((it) => it.id == quotedMessageId) case final quoted?) return quoted;

  try {
    final response = await client.getMessage(quotedMessageId);
    return response.message;
  } on StreamChatNetworkError catch (error) {
    // Only a quoted message that is gone is dropped; any other failure stops
    // the edit, so a network error doesn't lose the quote.
    if (error.statusCode == 404) return null;
    rethrow;
  }
}
