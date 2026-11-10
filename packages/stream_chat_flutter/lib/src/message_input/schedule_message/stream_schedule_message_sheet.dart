import 'package:flutter/material.dart';

import '../../../stream_chat_flutter.dart';
import 'schedule_message_bounds.dart';

/// Shows the times [message] can be scheduled for in [channel] in a sheet.
///
/// The sheet offers tomorrow morning and afternoon, the next Monday morning,
/// and a custom time, which opens [showStreamScheduleTimeSheet] on top. A
/// preset outside the times the channel allows isn't offered. When the
/// channel holds as many scheduled messages as it allows, no time can be
/// picked.
///
/// When [onSchedule] is given, it schedules the chosen time before this
/// returns. A failure for a custom time keeps that sheet open and shows the
/// error; a failure for a preset completes the returned future with it.
///
/// Returns the chosen time, or null when the sheet is dismissed.
Future<DateTime?> showStreamScheduleMessageSheet(
  BuildContext context, {
  required Channel channel,
  required Message message,
  StreamScheduleMessageCallback? onSchedule,
}) async {
  DateTime? scheduledCustomAt;
  Future<void> scheduleCustomTime(DateTime scheduledAt) async {
    await onSchedule!(scheduledAt);
    scheduledCustomAt = scheduledAt;
  }

  final scheduledAt = await showStreamSheet<DateTime>(
    context: context,
    isDismissible: true,
    builder: (_, _) => StreamScheduleMessageSheet(
      channel: channel,
      message: message,
      onSchedule: onSchedule == null ? null : scheduleCustomTime,
    ),
  );
  // A custom time is scheduled by its sheet, even when that sheet's result
  // doesn't make it back here.
  if (scheduledCustomAt case final customAt?) return customAt;
  if (scheduledAt == null) return null;

  await onSchedule?.call(scheduledAt);
  return scheduledAt;
}

/// A sheet of the times a message can be scheduled for.
///
/// Tapping a preset time closes the sheet with it. "Custom time" opens a
/// [StreamScheduleTimeSheet] on top, and closes this sheet with the time
/// picked there.
///
/// See also:
///
///  * [showStreamScheduleMessageSheet], which shows this sheet.
class StreamScheduleMessageSheet extends StatelessWidget {
  /// Creates a sheet of the times [message] can be scheduled for in
  /// [channel].
  const StreamScheduleMessageSheet({
    super.key,
    required this.channel,
    required this.message,
    this.onSchedule,
  });

  /// The channel the message is sent to.
  final Channel channel;

  /// The message to schedule.
  final Message message;

  /// Called to schedule a time picked in the [StreamScheduleTimeSheet]
  /// before that sheet closes.
  ///
  /// A failure keeps the [StreamScheduleTimeSheet] open and shows the error.
  /// Preset times are not passed to it.
  final StreamScheduleMessageCallback? onSchedule;

  Future<void> _pickCustomTime(BuildContext context) async {
    final navigator = Navigator.of(context);
    final scheduledAt = await showStreamScheduleTimeSheet(
      context,
      channel: channel,
      message: message,
      onSchedule: onSchedule,
    );
    if (scheduledAt == null) return;

    navigator.pop(scheduledAt);
  }

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final spacing = context.streamSpacing;
    final translations = context.translations;

    final bounds = ScheduleMessageBounds.of(channel);
    final presets = schedulePresets().where(bounds.contains);

    final limit = channel.config?.scheduledMessagesMaxPerChannel;
    final isLimitReached = isScheduleLimitReached(channel);
    final title = switch (limit) {
      final limit? when isLimitReached => translations.scheduleLimitReachedText(limit: limit),
      _ => translations.scheduleMessageLabel,
    };

    return SafeArea(
      top: false,
      child: IconTheme.merge(
        data: const IconThemeData(size: 20),
        child: Column(
          mainAxisSize: .min,
          children: [
            StreamSheetHeader(automaticallyImplyLeading: false, title: Text(title)),
            Padding(
              padding: EdgeInsets.fromLTRB(spacing.xxs, 0, spacing.xxs, spacing.xs),
              child: Column(
                mainAxisSize: .min,
                children: [
                  for (final preset in presets)
                    _ScheduleOptionRow(
                      label: Text(
                        switch (isTomorrow(preset)) {
                          true => translations.scheduleTomorrowText(scheduledAt: preset),
                          false => translations.scheduleWeekdayText(scheduledAt: preset),
                        },
                      ),
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
