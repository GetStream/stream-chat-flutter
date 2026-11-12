import 'package:flutter/material.dart';

import '../../../stream_chat_flutter.dart';
import '../../localization/translations.dart';
import 'schedule_message_bounds.dart';

/// Shows the times [message] can be scheduled for in [channel], which must be
/// initialized, in a sheet.
///
/// The sheet offers tomorrow morning and afternoon, the next Monday morning,
/// and a custom time, which opens [showStreamScheduleTimeSheet]. A preset the
/// channel doesn't allow isn't offered, and none can be picked once the
/// channel holds its limit. Returns the chosen time, or null when the sheet is
/// dismissed.
Future<DateTime?> showStreamScheduleMessageSheet({
  required BuildContext context,
  required Channel channel,
  required Message message,
}) {
  return showStreamSheet<DateTime>(
    context: context,
    isDismissible: true,
    builder: (_, _) => _ScheduleMessageSheet(
      channel: channel,
      message: message,
    ),
  );
}

// A sheet of the times a message can be scheduled for. A preset closes it with
// that time; "Custom time" opens the time sheet on top, and closes this one
// with the time picked there.
class _ScheduleMessageSheet extends StatelessWidget {
  const _ScheduleMessageSheet({
    required this.channel,
    required this.message,
  });

  final Channel channel;
  final Message message;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final spacing = context.streamSpacing;
    final translations = context.translations;

    final config = channel.config;
    final bounds = ScheduleMessageBounds.fromConfig(config);
    final presets = schedulePresets().where(bounds.contains);

    // Messages that failed don't count toward the channel's limit.
    final scheduledMessages = channel.client.state.scheduledMessages;
    final pending = scheduledMessages.where((it) => it.cid == channel.cid && it.status.isPending);
    final reachedLimit = switch (config?.scheduledMessagesMaxPerChannel) {
      final limit? when pending.length >= limit => limit,
      _ => null,
    };
    final isLimitReached = reachedLimit != null;
    final title = switch (reachedLimit) {
      final limit? => translations.scheduleChannelLimitReachedLabel(limit: limit),
      null => translations.scheduleMessageLabel,
    };

    return SafeArea(
      child: IconTheme.merge(
        data: const IconThemeData(size: 20),
        child: Column(
          mainAxisSize: .min,
          children: [
            StreamSheetHeader(
              automaticallyImplyLeading: false,
              title: Text(title),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.xxs),
              child: Column(
                mainAxisSize: .min,
                children: [
                  for (final preset in presets)
                    _ScheduleOptionRow(
                      label: Text(_presetLabel(translations, preset)),
                      enabled: !isLimitReached,
                      onTap: () => Navigator.of(context).pop(preset),
                    ),
                  _ScheduleOptionRow(
                    label: Text(translations.customTimeLabel),
                    trailing: Icon(icons.chevronRight),
                    enabled: !isLimitReached,
                    onTap: () => _pickCustomTime(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _presetLabel(Translations translations, DateTime preset) {
    return switch (preset.isTomorrow) {
      true => translations.scheduleTomorrowText(scheduledAt: preset),
      false => translations.scheduleWeekdayText(scheduledAt: preset),
    };
  }

  Future<void> _pickCustomTime(BuildContext context) async {
    final navigator = Navigator.of(context);

    final scheduledAt = await showStreamScheduleTimeSheet(
      context: context,
      channel: channel,
      message: message,
    );

    if (scheduledAt == null) return;
    return navigator.pop(scheduledAt);
  }
}

// A time option of the sheet, led by a clock.
class _ScheduleOptionRow extends StatelessWidget {
  const _ScheduleOptionRow({
    required this.label,
    required this.enabled,
    required this.onTap,
    this.trailing,
  });

  final Widget label;
  final Widget? trailing;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;

    return StreamListTileTheme(
      data: StreamListTileThemeData(
        minTileHeight: 48,
        contentPadding: .symmetric(horizontal: spacing.sm, vertical: spacing.xs),
      ),
      child: StreamListTile(
        leading: Icon(context.streamIcons.clock),
        title: label,
        trailing: trailing,
        enabled: enabled,
        onTap: onTap,
      ),
    );
  }
}
