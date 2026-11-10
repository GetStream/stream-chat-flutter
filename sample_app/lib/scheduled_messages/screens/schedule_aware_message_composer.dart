import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../config/sample_app_config.dart';
import '../../widgets/location/location_aware_message_composer.dart';
import '../scheduled_messages_strings.dart';
import 'scheduled_messages_screen.dart';

/// Builds the composer, with the pending scheduled messages counted above it:
/// the thread's replies in a thread, the channel's messages otherwise.
///
/// The count shows only when the sample app config enables scheduled messages
/// and the surrounding channel allows them.
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
      locationAwareMessageComposer(context, props),
    ],
  );
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
