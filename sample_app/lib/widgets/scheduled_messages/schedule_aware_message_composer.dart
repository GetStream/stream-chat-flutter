import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../config/sample_app_config.dart';
import '../../pages/scheduled_messages_page.dart';
import '../location/location_aware_message_composer.dart';
import 'schedule_message_sheet.dart';

/// Builds the composer, letting a long press on send schedule the message
/// when scheduling is available on the surrounding channel.
///
/// The channel's pending scheduled messages are counted above the composer.
Widget scheduleAwareMessageComposer(BuildContext context, MessageComposerProps props) {
  final channel = StreamChannel.maybeOf(context)?.channel;

  final schedulingEnabled =
      channel != null &&
      channel.state != null &&
      context.sampleAppConfig.enableScheduledMessages &&
      channel.canScheduleMessage;

  if (!schedulingEnabled) return locationAwareMessageComposer(context, props);

  final surfaceStyle = StreamMessageComposer.resolveSurfaceStyle(context, surfaceStyle: props.surfaceStyle);

  return Column(
    mainAxisSize: .min,
    crossAxisAlignment: .stretch,
    children: [
      _ScheduledMessagesPill(channel: channel, isFloating: surfaceStyle.isFloating),
      locationAwareMessageComposer(
        context,
        props.copyWith(
          onSendLongPress: (controller) => _scheduleMessage(context, channel, controller),
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
      StreamSnackbar(message: const Text("Messages with attachments can't be scheduled yet"), variant: .error),
    );
    return;
  }

  final recipient = channelDisplayName(channel) ?? 'channel';
  final time = await showScheduleMessageSheet(context, message: message, recipient: recipient);
  if (time == null || !context.mounted) return;

  controller.reset();

  try {
    final response = await channel.scheduleMessage(message, time);

    final scheduledMessage = response.scheduledMessage;
    if (scheduledMessage == null) {
      messenger.show(StreamSnackbar(message: const Text('Message sent')));
      return;
    }

    if (!context.mounted) return;
    messenger.show(
      StreamSnackbar(
        message: Text('Message scheduled for ${formatScheduledTime(scheduledMessage.scheduledAt, short: true)}'),
        variant: .success,
        action: StreamSnackbarAction(
          label: const Text('View'),
          onPressed: () => _openScheduledMessages(context, channel),
        ),
      ),
    );
  } catch (error) {
    messenger.show(
      StreamSnackbar(
        message: Text(describeScheduleError(error, fallback: "Couldn't schedule the message")),
        variant: .error,
      ),
    );
  }
}

void _openScheduledMessages(BuildContext context, Channel channel) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => ScheduledMessagesScreen(cid: channel.cid)),
  );
}

class _ScheduledMessagesPill extends StatefulWidget {
  const _ScheduledMessagesPill({required this.channel, required this.isFloating});

  final Channel channel;
  final bool isFloating;

  @override
  State<_ScheduledMessagesPill> createState() => _ScheduledMessagesPillState();
}

class _ScheduledMessagesPillState extends State<_ScheduledMessagesPill> {
  late final _state = widget.channel.state!;

  @override
  void initState() {
    super.initState();
    // The channel keeps its scheduled messages current once loaded, so they
    // are loaded the first time only.
    if (_state.channelState.scheduledMessages != null) return;
    widget.channel.queryScheduledMessages().ignore();
  }

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final spacing = context.streamSpacing;
    final radius = context.streamRadius;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    return StreamBuilder(
      stream: _state.scheduledMessagesStream,
      initialData: _state.scheduledMessages,
      builder: (context, snapshot) {
        final count = snapshot.data?.length ?? 0;
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
              onTap: () => _openScheduledMessages(context, widget.channel),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.sm),
                child: Row(
                  spacing: spacing.xs,
                  children: [
                    Icon(icons.clock, size: 20, color: colorScheme.accentPrimary),
                    Expanded(
                      child: Text(
                        count == 1 ? '1 scheduled message' : '$count scheduled messages',
                        style: textTheme.captionEmphasis,
                      ),
                    ),
                    Text('View all', style: textTheme.captionDefault.copyWith(color: colorScheme.accentPrimary)),
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
