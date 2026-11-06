import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../widgets/scheduled_messages/schedule_message_sheet.dart';

/// A pushed screen listing the current user's scheduled messages.
///
/// It lists those in the channel [cid], or in every channel when [cid] is
/// null.
class ScheduledMessagesScreen extends StatelessWidget {
  const ScheduledMessagesScreen({super.key, this.cid});

  /// The channel whose scheduled messages are listed.
  ///
  /// Null lists those in every channel.
  final String? cid;

  @override
  Widget build(BuildContext context) {
    return StreamScaffold(
      backgroundColor: context.streamColorScheme.backgroundApp,
      appBar: StreamAppBar(title: const Text('Scheduled Messages')),
      body: ScheduledMessagesPage(cid: cid),
    );
  }
}

/// A list of the current user's scheduled messages.
///
/// They are listed by send time, failed ones included, each with the reason
/// it failed. It lists those in the channel [cid], or in every channel when
/// [cid] is null.
class ScheduledMessagesPage extends StatefulWidget {
  const ScheduledMessagesPage({super.key, this.cid});

  /// The channel whose scheduled messages are listed.
  ///
  /// Null lists those in every channel.
  final String? cid;

  @override
  State<ScheduledMessagesPage> createState() => _ScheduledMessagesPageState();
}

class _ScheduledMessagesPageState extends State<ScheduledMessagesPage> {
  late final _client = StreamChat.of(context).client;
  late final _controller = StreamScheduledMessageListController(client: _client, cid: widget.cid)
    ..addListener(_loadUnnamedChannels)
    ..doInitialLoad();

  final _requestedCids = <String>{};
  var _isLoadingMore = false;

  Future<void> _loadMore(String nextPageKey) async {
    if (_isLoadingMore) return;

    _isLoadingMore = true;
    try {
      await _controller.loadMore(nextPageKey);
    } finally {
      _isLoadingMore = false;
    }
  }

  // Shows the next page as the end of the list comes into view, or a way to
  // try again when it failed.
  Widget? _footer(String? nextPageKey, StreamChatError? error) {
    if (error != null) {
      return Padding(
        padding: EdgeInsets.all(context.streamSpacing.sm),
        child: Center(
          child: StreamButton(
            type: .outline,
            style: .secondary,
            size: .small,
            onPressed: _controller.retry,
            child: const Text("Couldn't load more. Try again"),
          ),
        ),
      );
    }

    if (nextPageKey == null) return null;

    WidgetsBinding.instance.addPostFrameCallback((_) => _loadMore(nextPageKey));
    return Padding(
      padding: EdgeInsets.all(context.streamSpacing.sm),
      child: Center(child: StreamLoadingSpinner()),
    );
  }

  // A channel without a name of its own is named after its members, which
  // only a loaded channel has.
  Future<void> _loadUnnamedChannels() async {
    if (_controller.value.isNotSuccess) return;

    final cids = {
      for (final it in _controller.currentItems)
        if (_client.state.channels[it.cid] == null && (it.channel?.name ?? '').isEmpty) it.cid,
    }.difference(_requestedCids);
    if (cids.isEmpty) return;

    _requestedCids.addAll(cids);
    try {
      await _client.queryChannelsOnline(filter: Filter.in_('cid', [...cids]), watch: false, messageLimit: 0);
      if (mounted) setState(() {});
    } catch (_) {
      // The rows keep showing the channel ID.
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_loadUnnamedChannels)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    return ValueListenableBuilder(
      valueListenable: _controller,
      builder: (context, value, _) => value.when(
        (items, nextPageKey, error) => switch (items.isEmpty) {
          true => Center(
            child: StreamScrollViewEmptyWidget(
              emptyIcon: Icon(icons.clock),
              emptyTitle: const Text('No scheduled messages'),
            ),
          ),
          false => RefreshIndicator.adaptive(
            onRefresh: () => _controller.refresh(resetValue: false),
            child: _ScheduledMessageList(
              scheduledMessages: items,
              footer: _footer(nextPageKey, error),
            ),
          ),
        },
        loading: () => Center(child: StreamLoadingSpinner()),
        error: (_) => Center(
          child: Column(
            mainAxisSize: .min,
            spacing: context.streamSpacing.sm,
            children: [
              Text(
                "Couldn't load scheduled messages",
                style: textTheme.bodyDefault.copyWith(color: colorScheme.textSecondary),
              ),
              StreamButton(
                type: .outline,
                style: .secondary,
                size: .small,
                onPressed: _controller.refresh,
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScheduledMessageList extends StatelessWidget {
  const _ScheduledMessageList({required this.scheduledMessages, this.footer});

  final List<ScheduledMessage> scheduledMessages;

  // The footer after the last row, for the next page.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final rows = scheduledMessages.sorted(_bySendTime);

    return ListView.builder(
      itemCount: rows.length + (footer == null ? 0 : 1),
      itemBuilder: (context, index) => switch (rows.elementAtOrNull(index)) {
        final scheduledMessage? => _ScheduledMessageTile(scheduledMessage: scheduledMessage),
        null => footer!,
      },
    );
  }

  // By send time; ones sent at the same time alphabetically by their text, and
  // then by ID.
  static int _bySendTime(ScheduledMessage a, ScheduledMessage b) {
    final byTime = a.scheduledAt.compareTo(b.scheduledAt);
    if (byTime != 0) return byTime;

    final aText = (a.message.text ?? '').toLowerCase();
    final bText = (b.message.text ?? '').toLowerCase();
    final byText = aText.compareTo(bText);
    if (byText != 0) return byText;

    return a.id.compareTo(b.id);
  }
}

class _ScheduledMessageTile extends StatelessWidget {
  const _ScheduledMessageTile({required this.scheduledMessage});

  final ScheduledMessage scheduledMessage;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    final isFailed = scheduledMessage.status == ScheduledMessageStatus.failed;
    final sendTime = formatScheduledTime(scheduledMessage.scheduledAt);

    final statusLine = switch (scheduledMessage.status) {
      ScheduledMessageStatus.sending => const _ProgressLine(label: 'Sending…'),
      ScheduledMessageStatus.failed => _FailureLine(reason: _failureText(scheduledMessage.failureReason)),
      _ => null,
    };

    return InkWell(
      onTap: switch (scheduledMessage.status) {
        ScheduledMessageStatus.sending => null,
        _ => () => _showActions(context, scheduledMessage),
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colorScheme.borderDefault)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.sm),
          child: Column(
            crossAxisAlignment: .start,
            spacing: spacing.xs,
            children: [
              Text(
                'Send $sendTime',
                style: textTheme.captionDefault.copyWith(
                  color: isFailed ? colorScheme.accentError : colorScheme.textTertiary,
                ),
              ),
              Row(
                crossAxisAlignment: .start,
                spacing: spacing.sm,
                children: [
                  _ChannelAvatar(scheduledMessage: scheduledMessage),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      spacing: spacing.xxs,
                      children: [
                        Text(
                          _channelName(context, scheduledMessage),
                          maxLines: 1,
                          overflow: .ellipsis,
                          style: textTheme.captionEmphasis.copyWith(color: colorScheme.textSecondary),
                        ),
                        DefaultTextStyle.merge(
                          maxLines: 1,
                          overflow: .ellipsis,
                          style: textTheme.bodyDefault,
                          child: StreamMessagePreviewText(message: scheduledMessage.message),
                        ),
                        ?statusLine,
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _failureText(ScheduledMessageFailureReason? reason) => switch (reason) {
    ScheduledMessageFailureReason.channelDeleted => 'This channel was deleted',
    ScheduledMessageFailureReason.channelFrozen => 'This channel is frozen',
    ScheduledMessageFailureReason.banned => "You can't send messages in this channel",
    ScheduledMessageFailureReason.noPermission => "You're no longer allowed to post here",
    ScheduledMessageFailureReason.moderationBlocked => 'Blocked by moderation',
    ScheduledMessageFailureReason.hookRejected => 'Rejected by the app',
    ScheduledMessageFailureReason.expired => 'Not sent: the service was delayed',
    ScheduledMessageFailureReason.invalidMessage => "The message no longer meets the app's limits. Edit it",
    ScheduledMessageFailureReason.pendingNotSupported => 'This channel now needs approval. Schedule it again',
    ScheduledMessageFailureReason.internalError => 'Something went wrong. Try again',
    _ => "Couldn't send. Try again",
  };
}

// The avatar of the channel a scheduled message is sent to.
class _ChannelAvatar extends StatelessWidget {
  const _ChannelAvatar({required this.scheduledMessage});

  final ScheduledMessage scheduledMessage;

  @override
  Widget build(BuildContext context) {
    final client = StreamChat.of(context).client;
    if (client.state.channels[scheduledMessage.cid] case final channel? when channel.state != null) {
      return StreamChannelAvatar(channel: channel, size: .xl);
    }

    // A channel that isn't loaded shows its image, if it has one.
    return StreamAvatar(
      imageUrl: scheduledMessage.channel?.extraData['image'].safeCast<String>(),
      size: .xl,
      placeholder: (context) => Icon(context.streamIcons.users),
    );
  }
}

// A line under the message saying it is on its way.
class _ProgressLine extends StatelessWidget {
  const _ProgressLine({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;

    return Row(
      spacing: context.streamSpacing.xxs,
      children: [
        StreamLoadingSpinner(size: .sm),
        Text(label, style: context.streamTextTheme.captionDefault.copyWith(color: colorScheme.textSecondary)),
      ],
    );
  }
}

// A line under the message saying why it could not be sent.
class _FailureLine extends StatelessWidget {
  const _FailureLine({required this.reason});

  final String reason;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;

    return Row(
      crossAxisAlignment: .start,
      spacing: context.streamSpacing.xxs,
      children: [
        Icon(context.streamIcons.exclamationTriangleFill, size: 16, color: colorScheme.accentError),
        Expanded(
          child: Text(
            reason,
            maxLines: 2,
            overflow: .ellipsis,
            style: context.streamTextTheme.captionDefault.copyWith(color: colorScheme.accentError),
          ),
        ),
      ],
    );
  }
}

String _channelName(BuildContext context, ScheduledMessage scheduledMessage) {
  final client = StreamChat.of(context).client;
  final name = switch (client.state.channels[scheduledMessage.cid]) {
    final loaded? => channelDisplayName(loaded),
    null => scheduledMessage.channel?.name,
  };

  return name ?? scheduledMessage.cid;
}

enum _Action { edit, reschedule, sendNow, delete }

Future<void> _showActions(BuildContext context, ScheduledMessage scheduledMessage) async {
  final icons = context.streamIcons;
  final isFailed = scheduledMessage.status == ScheduledMessageStatus.failed;
  final isChannelDeleted = scheduledMessage.failureReason == ScheduledMessageFailureReason.channelDeleted;

  final action = await showStreamSheet<_Action>(
    context: context,
    isDismissible: true,
    builder: (sheetContext, _) => SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: sheetContext.streamSpacing.lg),
        child: Column(
          mainAxisSize: .min,
          children: [
            if (!isFailed) ...[
              StreamContextMenuAction(
                onTap: () => Navigator.of(sheetContext).pop(_Action.edit),
                leading: Icon(icons.edit),
                label: const Text('Edit message'),
              ),
              StreamContextMenuAction(
                onTap: () => Navigator.of(sheetContext).pop(_Action.reschedule),
                leading: Icon(icons.clock),
                label: const Text('Reschedule'),
              ),
              StreamContextMenuAction(
                onTap: () => Navigator.of(sheetContext).pop(_Action.sendNow),
                leading: Icon(icons.send),
                label: const Text('Send now'),
              ),
            ] else if (!isChannelDeleted)
              StreamContextMenuAction(
                onTap: () => Navigator.of(sheetContext).pop(_Action.reschedule),
                leading: Icon(icons.clock),
                label: const Text('Reschedule'),
              ),
            StreamContextMenuAction.destructive(
              onTap: () => Navigator.of(sheetContext).pop(_Action.delete),
              leading: Icon(icons.delete),
              label: const Text('Delete'),
            ),
          ],
        ),
      ),
    ),
  );

  if (action == null || !context.mounted) return;

  final client = StreamChat.of(context).client;
  final messenger = StreamSnackbarMessenger.of(context);

  Future<void> run(Future<void> Function() call, String done) async {
    try {
      await call();
      messenger.show(StreamSnackbar(message: Text(done), variant: .success));
    } catch (error) {
      messenger.show(
        StreamSnackbar(
          message: Text(describeScheduleError(error, fallback: 'Something went wrong')),
          variant: .error,
        ),
      );
    }
  }

  switch (action) {
    case _Action.edit:
      final text = await _showEditSheet(context, scheduledMessage.message);
      if (text == null) return;

      Future<void> edit() async {
        final content = scheduledMessage.message;
        final mentionedUsers = await _resolveMentionedUsers(client, content);
        final quotedMessage = await _resolveQuotedMessage(client, scheduledMessage);
        final edited = content.copyWith(
          text: text,
          mentionedUsers: mentionedUsers,
          quotedMessage: quotedMessage,
        );
        await client.updateScheduledMessage(scheduledMessage.id, edited);
      }

      await run(edit, 'Scheduled message updated');
    case _Action.reschedule:
      final time = await showScheduleTimeSheet(
        context,
        title: 'Reschedule message',
        label: 'Scheduled for ${formatScheduledTime(scheduledMessage.scheduledAt)}',
        message: scheduledMessage.message,
        initial: isFailed ? null : scheduledMessage.scheduledAt.toLocal(),
        maxLeadTime: client.state.channels[scheduledMessage.cid]?.config?.scheduledMessagesMaxLeadTime,
      );
      if (time == null) return;

      Future<void> reschedule() async {
        if (isFailed) return _scheduleAgain(client, scheduledMessage, time);
        await client.rescheduleMessage(scheduledMessage.id, scheduledAt: time);
      }

      await run(reschedule, 'Message scheduled for ${formatScheduledTime(time, short: true)}');
    case _Action.sendNow:
      await run(() => client.sendScheduledMessageNow(scheduledMessage.id), 'Sending message');
    case _Action.delete:
      if (!context.mounted) return;
      final confirmed = await showStreamDialog<bool>(
        context: context,
        builder: (context) => StreamMessageActionConfirmationModal(
          isDestructiveAction: true,
          title: const Text('Delete scheduled message?'),
          content: Text(
            "This message to ${_channelName(context, scheduledMessage)} won't be sent. This can't be undone.",
          ),
          cancelActionTitle: const Text('Cancel'),
          confirmActionTitle: const Text('Delete'),
        ),
      );
      if (confirmed != true) return;
      await run(() => client.deleteScheduledMessage(scheduledMessage.id), 'Scheduled message deleted');
  }
}

// A failed scheduled message can't be changed, so its content is scheduled
// again as a new message and the failed one is removed.
Future<void> _scheduleAgain(StreamChatClient client, ScheduledMessage scheduledMessage, DateTime time) async {
  final content = scheduledMessage.message;
  final message = Message(
    text: content.text,
    attachments: content.attachments,
    mentionedUsers: await _resolveMentionedUsers(client, content),
    quotedMessageId: content.quotedMessageId,
    parentId: content.parentId,
    showInChannel: content.showInChannel,
    extraData: content.extraData,
  );

  final ChannelModel(:id, :type) = ChannelModel(cid: scheduledMessage.cid);
  await client.scheduleMessage(message, id, type, scheduledAt: time);
  await client.deleteScheduledMessage(scheduledMessage.id);
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
  late final _controller = TextEditingController(text: widget.text)..addListener(() => setState(() {}));

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
              title: const Text('Edit scheduled message'),
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
                hintText: 'Message',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
