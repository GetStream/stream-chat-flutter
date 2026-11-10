import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../config/sample_app_config.dart';
import '../../widgets/location/location_aware_message_composer.dart';
import '../scheduled_messages_strings.dart';
import '../scheduled_messages_utils.dart';
import 'schedule_message_sheet.dart';
import 'scheduled_messages_screen.dart';

/// Builds the composer, with a long press on send to schedule the message.
///
/// Scheduling is offered only when the sample app config enables it and the
/// surrounding channel allows it.
///
/// The pending scheduled messages are counted above the composer: the
/// thread's replies in a thread, the channel's messages otherwise.
Widget scheduleAwareMessageComposer(BuildContext context, MessageComposerProps props) {
  final channel = StreamChannel.maybeOf(context)?.channel;

  if (channel == null || channel.state == null) {
    return locationAwareMessageComposer(context, props);
  }
  if (!context.sampleAppConfig.enableScheduledMessages) {
    return locationAwareMessageComposer(context, props);
  }
  if (!channel.canScheduleMessage) {
    return locationAwareMessageComposer(context, props);
  }

  final surfaceStyle = StreamMessageComposer.resolveSurfaceStyle(context, surfaceStyle: props.surfaceStyle);
  final parentId = props.messageComposerController?.message.parentId;

  return Column(
    mainAxisSize: .min,
    crossAxisAlignment: .stretch,
    children: [
      _ScheduledMessagesPill(
        key: ValueKey(parentId),
        channel: channel,
        parentId: parentId,
        isFloating: surfaceStyle.isFloating,
      ),
      locationAwareMessageComposer(
        context,
        props.copyWith(
          onSendLongPress: (context, details) => _scheduleMessage(context, channel, details.controller),
        ),
      ),
    ],
  );
}

Future<void> _scheduleMessage(
  BuildContext context,
  Channel channel,
  StreamMessageComposerController controller,
) async {
  final messenger = StreamSnackbarMessenger.of(context);
  final message = controller.message;

  if (message.attachments.isNotEmpty) {
    messenger.show(
      StreamSnackbar(message: const Text(ScheduledMessagesStrings.attachmentsNotSchedulable), variant: .error),
    );
    return;
  }

  // A text starting with / is a command in a channel that has commands, and
  // commands can't be scheduled. A picked command is sent at the text's start.
  final hasCommands = channel.config?.commands.isNotEmpty ?? false;
  final hasPickedCommand = message.command?.isNotEmpty ?? false;
  final isCommand = hasPickedCommand || (message.text?.startsWith('/') ?? false);
  if (hasCommands && isCommand) {
    messenger.show(
      StreamSnackbar(message: const Text(ScheduledMessagesStrings.commandsNotSchedulable), variant: .error),
    );
    return;
  }

  final recipient = channelDisplayName(channel) ?? ScheduledMessagesStrings.fallbackRecipient;
  final time = await showScheduleMessageSheet(
    context,
    message: message,
    recipient: recipient,
    maxLeadTime: channel.config?.scheduledMessagesMaxLeadTime,
  );
  if (time == null || !context.mounted) return;

  controller.reset();

  try {
    final response = await channel.scheduleMessage(message, scheduledAt: time);

    final scheduledMessage = response.scheduledMessage;
    if (scheduledMessage == null) {
      messenger.show(StreamSnackbar(message: const Text(ScheduledMessagesStrings.sent)));
      return;
    }

    if (!context.mounted) return;
    messenger.show(
      StreamSnackbar(
        message: const Text(ScheduledMessagesStrings.scheduled),
        variant: .success,
        action: StreamSnackbarAction(
          label: const Text(ScheduledMessagesStrings.view),
          onPressed: () => _openScheduledMessages(
            context,
            channel,
            parentId: message.parentId,
          ),
        ),
      ),
    );
  } catch (error) {
    // A retriable failure stays in the scheduled messages, to retry from there.
    if (error is StreamChatNetworkError && error.isRetriable) {
      if (!context.mounted) return;
      messenger.show(
        StreamSnackbar(
          message: const Text(ScheduledMessagesStrings.scheduleFailed),
          variant: .error,
          // Longer, so there is time to open the message and retry it.
          duration: const Duration(seconds: 10),
          action: StreamSnackbarAction(
            label: const Text(ScheduledMessagesStrings.view),
            onPressed: () => _openScheduledMessages(
              context,
              channel,
              parentId: message.parentId,
            ),
          ),
        ),
      );
      return;
    }

    // Brings the message back unless something new was typed meanwhile.
    if (context.mounted && controller.text.isEmpty) controller.message = message;

    messenger.show(
      StreamSnackbar(
        message: Text(describeScheduleError(error, fallback: ScheduledMessagesStrings.scheduleFailed)),
        variant: .error,
      ),
    );
  }
}

void _openScheduledMessages(
  BuildContext context,
  Channel channel, {
  String? parentId,
}) {
  if (!context.mounted) return;

  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => ScheduledMessagesScreen(cid: channel.cid, parentId: parentId),
    ),
  );
}

class _ScheduledMessagesPill extends StatefulWidget {
  const _ScheduledMessagesPill({
    super.key,
    required this.channel,
    this.parentId,
    required this.isFloating,
  });

  final Channel channel;
  final String? parentId;
  final bool isFloating;

  @override
  State<_ScheduledMessagesPill> createState() => _ScheduledMessagesPillState();
}

class _ScheduledMessagesPillState extends State<_ScheduledMessagesPill> {
  late final _state = widget.channel.state!;

  late final _scheduledMessagesStream = switch (widget.parentId) {
    final parentId? => _state.scheduledThreadRepliesStream(parentId),
    null => _state.scheduledMessagesStream,
  };

  List<ScheduledMessage> get _scheduledMessages => switch (widget.parentId) {
    final parentId? => _state.scheduledThreadReplies(parentId),
    null => _state.scheduledMessages,
  };

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final spacing = context.streamSpacing;
    final radius = context.streamRadius;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    return StreamBuilder<List<ScheduledMessage>>(
      stream: _scheduledMessagesStream,
      initialData: _scheduledMessages,
      builder: (context, snapshot) {
        final count = snapshot.requireData.length;
        if (count == 0) return const SizedBox.shrink();

        return Padding(
          padding: EdgeInsets.fromLTRB(spacing.sm, spacing.xs, spacing.sm, 0),
          child: Material(
            color: colorScheme.backgroundElevation1,
            elevation: widget.isFloating ? context.streamElevation.level2 : 0,
            shape: RoundedSuperellipseBorder(
              borderRadius: .all(radius.max),
              side: BorderSide(color: colorScheme.borderDefault),
            ),
            clipBehavior: .antiAlias,
            child: InkWell(
              onTap: () => _openScheduledMessages(
                context,
                widget.channel,
                parentId: widget.parentId,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.sm),
                child: Row(
                  spacing: spacing.xs,
                  children: [
                    Icon(icons.clock, size: 20, color: colorScheme.accentPrimary),
                    Expanded(
                      child: Text(
                        ScheduledMessagesStrings.scheduledCount(count),
                        style: textTheme.captionEmphasis,
                      ),
                    ),
                    Text(
                      ScheduledMessagesStrings.viewAll,
                      style: textTheme.captionDefault.copyWith(color: colorScheme.accentPrimary),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
