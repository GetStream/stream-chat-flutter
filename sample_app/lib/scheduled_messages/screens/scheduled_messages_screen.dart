import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../scheduled_messages_strings.dart';
import '../scheduled_messages_utils.dart';

/// A pushed screen listing the current user's scheduled messages.
///
/// It lists the replies in the thread of [parentId] when both [cid] and
/// [parentId] are set, the messages in the channel [cid] when only [cid] is,
/// and those in every channel when [cid] is null.
class ScheduledMessagesScreen extends StatelessWidget {
  const ScheduledMessagesScreen({super.key, this.cid, this.parentId});

  /// The channel whose scheduled messages are listed.
  ///
  /// Null lists those in every channel.
  final String? cid;

  /// The ID of the message whose thread's scheduled replies are listed.
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
/// It lists the replies in the thread of [parentId] when both [cid] and
/// [parentId] are set, the messages in the channel [cid] when only [cid] is,
/// and those in every channel when [cid] is null.
class ScheduledMessagesPage extends StatelessWidget {
  const ScheduledMessagesPage({super.key, this.cid, this.parentId});

  /// The channel whose scheduled messages are listed.
  ///
  /// Null lists those in every channel.
  final String? cid;

  /// The ID of the message whose thread's scheduled replies are listed.
  final String? parentId;

  @override
  Widget build(BuildContext context) {
    final client = StreamChat.of(context).client;
    // Opened from a channel the client has loaded.
    final channel = switch (cid) {
      final cid? => client.state.channels[cid],
      null => null,
    };

    return RefreshIndicator.adaptive(
      onRefresh: client.loadScheduledMessages,
      child: StreamScheduledMessageListView(
        channel: channel,
        parentId: parentId,
        physics: const AlwaysScrollableScrollPhysics(),
        onScheduledMessageTap: (scheduledMessage) {
          _openScheduledMessageActions(context, scheduledMessage);
        },
      ),
    );
  }
}

Future<void> _openScheduledMessageActions(
  BuildContext context,
  ScheduledMessage scheduledMessage,
) async {
  final action = await showStreamScheduledMessageActions(
    context,
    scheduledMessage: scheduledMessage,
  );

  if (action == null || !context.mounted) return;
  return _onScheduledMessageAction(context, action).ignore();
}

Future<void> _onScheduledMessageAction(
  BuildContext context,
  ScheduledMessageAction action,
) async {
  return switch (action) {
    EditScheduledMessage(:final scheduledMessage) => _editScheduledMessage(context, scheduledMessage),
    EditAndRescheduleMessage(:final scheduledMessage) => _editAndReschedule(context, scheduledMessage),
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

// The channel [scheduledMessage] is sent to, loaded or not.
Channel _channelOf(StreamChatClient client, ScheduledMessage scheduledMessage) {
  if (client.state.channels[scheduledMessage.cid] case final channel?) return channel;

  final ChannelModel(:id, :type) = ChannelModel(cid: scheduledMessage.cid);
  return client.channel(type, id: id);
}

Future<void> _editScheduledMessage(BuildContext context, ScheduledMessage scheduledMessage) async {
  final client = StreamChat.of(context).client;

  final text = await _showEditSheet(context, scheduledMessage.message);
  if (text == null || !context.mounted) return;

  return _run(context, () async {
    final content = scheduledMessage.message;
    final mentionedUsers = await _resolveMentionedUsers(client, content);
    final quotedMessage = await _resolveQuotedMessage(client, scheduledMessage);
    final edited = content.copyWith(
      text: text,
      mentionedUsers: mentionedUsers,
      quotedMessage: quotedMessage,
    );

    await client.updateScheduledMessage(scheduledMessage, edited);
    return ScheduledMessagesStrings.updated;
  });
}

Future<void> _editAndReschedule(BuildContext context, ScheduledMessage scheduledMessage) async {
  final client = StreamChat.of(context).client;

  final text = await _showEditSheet(context, scheduledMessage.message);
  if (text == null || !context.mounted) return;

  final messenger = StreamSnackbarMessenger.of(context);
  final channel = _channelOf(client, scheduledMessage);
  final time = await showStreamScheduleTimeSheet(
    context,
    channel: channel,
    message: scheduledMessage.message.copyWith(text: text),
    onSchedule: (scheduledAt) => _scheduleAgain(client, channel, scheduledMessage, scheduledAt, text: text),
  );
  if (time == null) return;

  messenger.show(StreamSnackbar(message: const Text(ScheduledMessagesStrings.scheduled), variant: .success));
}

Future<void> _reschedule(BuildContext context, ScheduledMessage scheduledMessage) async {
  final client = StreamChat.of(context).client;

  final messenger = StreamSnackbarMessenger.of(context);
  final time = await showStreamScheduleTimeSheet(
    context,
    channel: _channelOf(client, scheduledMessage),
    message: scheduledMessage.message,
    initialScheduledAt: scheduledMessage.scheduledAt,
    title: Text(context.translations.rescheduleMessageLabel),
    onSchedule: (scheduledAt) => client.rescheduleMessage(scheduledMessage, scheduledAt: scheduledAt),
  );
  if (time == null) return;

  messenger.show(StreamSnackbar(message: const Text(ScheduledMessagesStrings.scheduled), variant: .success));
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
    // A message that is gone was sent at its time, and leaves the list.
    final isGone = switch (error) {
      StreamChatNetworkError(statusCode: 404) => true,
      StreamChatNetworkError(scheduledMessageErrorReason: .scheduledMessageAlreadySent) => true,
      _ => false,
    };
    if (isGone) {
      messenger.show(StreamSnackbar(message: const Text(ScheduledMessagesStrings.alreadySent)));
      return;
    }

    final description = describeScheduleError(error, fallback: translations.genericErrorText);
    messenger.show(StreamSnackbar(message: Text(description), variant: .error));
  }
}

// A failed scheduled message can't be changed, so its content is scheduled
// again as a new message and the failed one is removed.
Future<void> _scheduleAgain(
  StreamChatClient client,
  Channel channel,
  ScheduledMessage scheduledMessage,
  DateTime scheduledAt, {
  String? text,
}) async {
  final content = scheduledMessage.message;

  // A quoted message that was deleted can't be quoted again.
  final quoted = await _resolveQuotedMessage(client, scheduledMessage);
  final quotedMessageId = switch (quoted) {
    final quoted? when !quoted.isDeleted => quoted.id,
    _ => null,
  };

  final message = Message(
    text: text ?? content.text,
    attachments: content.attachments,
    mentionedUsers: await _resolveMentionedUsers(client, content),
    quotedMessageId: quotedMessageId,
    parentId: content.parentId,
    showInChannel: content.showInChannel,
    extraData: content.extraData,
  );

  await channel.scheduleMessage(message, scheduledAt: scheduledAt);

  try {
    await client.deleteScheduledMessage(scheduledMessage);
  } catch (error) {
    // It is scheduled again either way; the failed one can be deleted later.
    debugPrint('Could not delete the failed scheduled message: $error');
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
  } catch (error) {
    debugPrint('Could not load the quoted message $quotedMessageId: $error');
    return null;
  }
}

Future<String?> _showEditSheet(BuildContext context, Message message) {
  return showStreamSheet<String>(
    context: context,
    isDismissible: true,
    builder: (_, _) => _EditSheet(text: message.text ?? ''),
  );
}

class _EditSheet extends StatefulWidget {
  const _EditSheet({required this.text});

  final String text;

  @override
  State<_EditSheet> createState() => _EditSheetState();
}

class _EditSheetState extends State<_EditSheet> {
  late final _controller = TextEditingController(text: widget.text)
    ..addListener(() {
      // The text changed, which enables or disables the save button.
      setState(() {});
    });

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final text = _controller.text.trim();

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: Column(
          mainAxisSize: .min,
          children: [
            StreamSheetHeader(
              title: const Text(ScheduledMessagesStrings.editScheduledMessage),
              trailing: StreamButton.icon(
                icon: Icon(context.streamIcons.checkmark),
                type: .solid,
                onPressed: text.isEmpty || text == widget.text ? null : () => Navigator.of(context).pop(text),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(spacing.md, spacing.xs, spacing.md, spacing.md),
              child: StreamTextInput(
                controller: _controller,
                autofocus: true,
                autocorrect: true,
                maxLines: 6,
                minLines: 1,
                hintText: ScheduledMessagesStrings.messageHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
