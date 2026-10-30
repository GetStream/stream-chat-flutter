import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../widgets/scheduled_messages/schedule_message_sheet.dart';

/// A pushed screen listing the current user's scheduled messages in the
/// channel [cid], or in every channel when it is null.
class ScheduledMessagesScreen extends StatelessWidget {
  const ScheduledMessagesScreen({super.key, this.cid});

  /// The channel whose scheduled messages are listed, or null for all.
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

/// The current user's scheduled messages in the channel [cid], or in every
/// channel when it is null: failed ones first, then the rest by day.
class ScheduledMessagesPage extends StatefulWidget {
  const ScheduledMessagesPage({super.key, this.cid});

  /// The channel whose scheduled messages are listed, or null for all.
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
        (items, _, _) => switch (items.isEmpty) {
          true => Center(
            child: StreamScrollViewEmptyWidget(
              emptyIcon: Icon(icons.clock),
              emptyTitle: const Text('No scheduled messages'),
            ),
          ),
          false => RefreshIndicator.adaptive(
            onRefresh: () => _controller.refresh(resetValue: false),
            child: _ScheduledMessageList(scheduledMessages: items),
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
  const _ScheduledMessageList({required this.scheduledMessages});

  final List<ScheduledMessage> scheduledMessages;

  @override
  Widget build(BuildContext context) {
    final failed = scheduledMessages.where((it) => it.status == ScheduledMessageStatus.failed);
    final pending = scheduledMessages.where((it) => it.status != ScheduledMessageStatus.failed);

    final rows = <Object>[
      if (failed.isNotEmpty) ...['Failed to send', ...failed],
      for (final MapEntry(key: day, value: messages) in pending.groupListsBy(_dayOf).entries) ...[
        Jiffy.parseFromDateTime(day).format(pattern: 'EEE, MMM d'),
        ...messages,
      ],
    ];

    return ListView.builder(
      itemCount: rows.length,
      itemBuilder: (context, index) => switch (rows[index]) {
        final String title => _SectionHeader(title: title),
        final ScheduledMessage scheduledMessage => _ScheduledMessageTile(scheduledMessage: scheduledMessage),
        _ => const SizedBox.shrink(),
      },
    );
  }

  static DateTime _dayOf(ScheduledMessage scheduledMessage) {
    final local = scheduledMessage.scheduledAt.toLocal();
    return DateTime(local.year, local.month, local.day);
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;

    return Container(
      color: colorScheme.backgroundSurfaceCard,
      padding: EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.xs),
      child: Text(
        title,
        style: context.streamTextTheme.captionEmphasis.copyWith(color: colorScheme.textSecondary),
      ),
    );
  }
}

class _ScheduledMessageTile extends StatelessWidget {
  const _ScheduledMessageTile({required this.scheduledMessage});

  final ScheduledMessage scheduledMessage;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    final isFailed = scheduledMessage.status == ScheduledMessageStatus.failed;
    final time = Jiffy.parseFromDateTime(scheduledMessage.scheduledAt.toLocal()).format(pattern: 'HH:mm');

    return StreamListTile(
      leading: switch (isFailed) {
        true => Icon(icons.exclamationTriangleFill, color: colorScheme.accentError),
        false => Icon(icons.clock),
      },
      title: Text(_channelName(context, scheduledMessage), maxLines: 1, overflow: .ellipsis),
      subtitle: switch (_failureText(scheduledMessage.failureReason)) {
        final reason? when isFailed => Text(reason, maxLines: 1, overflow: .ellipsis),
        _ => DefaultTextStyle.merge(
          maxLines: 1,
          overflow: .ellipsis,
          child: StreamMessagePreviewText(message: scheduledMessage.message),
        ),
      },
      trailing: Text(
        switch (scheduledMessage.status) {
          ScheduledMessageStatus.sending => 'Sending',
          _ => time,
        },
        style: textTheme.captionDefault.copyWith(
          color: isFailed ? colorScheme.accentError : colorScheme.textSecondary,
        ),
      ),
      onTap: switch (scheduledMessage.status) {
        ScheduledMessageStatus.sending => null,
        _ => () => _showActions(context, scheduledMessage),
      },
    );
  }

  static String? _failureText(ScheduledMessageFailureReason? reason) => switch (reason) {
    null => null,
    ScheduledMessageFailureReason.channelDeleted => 'This channel was deleted',
    ScheduledMessageFailureReason.channelFrozen => 'This channel is frozen',
    ScheduledMessageFailureReason.banned => 'You were banned from this channel',
    ScheduledMessageFailureReason.noPermission => "You can't send messages here anymore",
    ScheduledMessageFailureReason.moderationBlocked => 'Blocked by moderation',
    _ => "Couldn't send",
  };
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

      final edited = scheduledMessage.message.copyWith(text: text);
      await run(
        () => client.updateScheduledMessage(scheduledMessage.id, message: edited),
        'Scheduled message updated',
      );
    case _Action.reschedule:
      final time = await showScheduleTimeSheet(
        context,
        title: 'Reschedule message',
        label: 'Scheduled for ${formatScheduledTime(scheduledMessage.scheduledAt)}',
        message: scheduledMessage.message,
        initial: isFailed ? null : scheduledMessage.scheduledAt.toLocal(),
      );
      if (time == null) return;

      Future<void> reschedule() async {
        if (isFailed) return _scheduleAgain(client, scheduledMessage, time);
        await client.updateScheduledMessage(scheduledMessage.id, scheduledAt: time);
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
  final [type, id] = scheduledMessage.cid.split(':');
  final content = scheduledMessage.message;
  final message = Message(
    text: content.text,
    attachments: content.attachments,
    mentionedUsers: content.mentionedUsers,
    quotedMessageId: content.quotedMessageId,
    parentId: content.parentId,
    showInChannel: content.showInChannel,
    extraData: content.extraData,
  );

  await client.sendMessage(message, id, type, scheduledAt: time);
  await client.deleteScheduledMessage(scheduledMessage.id);
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
