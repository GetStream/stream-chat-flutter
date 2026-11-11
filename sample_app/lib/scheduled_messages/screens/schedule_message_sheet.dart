import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../scheduled_messages_strings.dart';

// How far ahead a message can be scheduled when the channel doesn't say.
const _defaultMaxLeadTime = Duration(days: 120);

/// Shows a sheet to pick the date and time [message] is sent at.
///
/// The [title] heads the sheet and the [label] sits above the message, so the
/// same sheet serves both scheduling and rescheduling.
///
/// It starts at [initial], or an hour from now, and allows a time at most
/// [maxLeadTime] ahead, 120 days by default.
///
/// Resolves to the chosen time, or null if the user closes the sheet.
Future<DateTime?> showScheduleTimeSheet(
  BuildContext context, {
  required String title,
  required String label,
  required Message message,
  DateTime? initial,
  Duration? maxLeadTime,
}) {
  return showStreamSheet<DateTime>(
    context: context,
    isDismissible: true,
    builder: (_, _) => _ScheduleTimeSheet(
      title: title,
      label: label,
      message: message,
      initial: initial ?? DateTime.now().add(const Duration(hours: 1)),
      maxLeadTime: maxLeadTime ?? _defaultMaxLeadTime,
    ),
  );
}

// Labels an offset from UTC the usual way, such as "GMT+2" or "GMT+5:30".
String _gmtLabel(Duration offset) {
  final sign = offset.isNegative ? '-' : '+';
  final hours = offset.inHours.abs();
  final minutes = offset.inMinutes.remainder(60).abs();

  if (minutes == 0) return 'GMT$sign$hours';
  return 'GMT$sign$hours:${minutes.toString().padLeft(2, '0')}';
}

class _ScheduleTimeSheet extends StatefulWidget {
  const _ScheduleTimeSheet({
    required this.title,
    required this.label,
    required this.message,
    required this.initial,
    required this.maxLeadTime,
  });

  final String title;
  final String label;
  final Message message;
  final DateTime initial;
  final Duration maxLeadTime;

  @override
  State<_ScheduleTimeSheet> createState() => _ScheduleTimeSheetState();
}

class _ScheduleTimeSheetState extends State<_ScheduleTimeSheet> {
  late DateTime _time = widget.initial;

  // A time sooner than the channel's minimum lead time is moved later when
  // scheduled, so only a time that has passed is refused.
  bool get _isPast => !_time.isAfter(DateTime.now());
  bool get _isTooFar => _time.isAfter(DateTime.now().add(widget.maxLeadTime));

  String? get _problem => switch ((_isPast, _isTooFar)) {
    (true, _) => ScheduledMessagesStrings.pickFutureTime,
    (_, true) => ScheduledMessagesStrings.pickWithinDays(widget.maxLeadTime.inDays),
    _ => null,
  };

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final lastDate = now.add(widget.maxLeadTime);
    // A failed message's time may have passed, which the picker can't start at.
    final initialDate = _time.isBefore(now) ? now : (_time.isAfter(lastDate) ? lastDate : _time);
    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: lastDate,
      builder: _withPickerTheme,
    );
    if (date == null) return;

    setState(() => _time = DateTime(date.year, date.month, date.day, _time.hour, _time.minute));
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_time),
      builder: _withPickerTheme,
    );
    if (time == null) return;

    setState(() => _time = DateTime(_time.year, _time.month, _time.day, time.hour, time.minute));
  }

  // Colors the Material pickers with the Stream color scheme.
  Widget _withPickerTheme(BuildContext context, Widget? child) {
    final theme = Theme.of(context);
    final colorScheme = context.streamColorScheme;

    return Theme(
      data: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
          primary: colorScheme.accentPrimary,
          onPrimary: colorScheme.textOnAccent,
          primaryContainer: colorScheme.backgroundSelected,
          onPrimaryContainer: colorScheme.accentPrimary,
          tertiaryContainer: colorScheme.backgroundSelected,
          onTertiaryContainer: colorScheme.accentPrimary,
          surface: colorScheme.backgroundElevation1,
          surfaceContainerHigh: colorScheme.backgroundElevation1,
          onSurface: colorScheme.textPrimary,
          onSurfaceVariant: colorScheme.textSecondary,
          outline: colorScheme.borderDefault,
          outlineVariant: colorScheme.borderSubtle,
        ),
        datePickerTheme: DatePickerThemeData(
          backgroundColor: colorScheme.backgroundElevation1,
          surfaceTintColor: Colors.transparent,
        ),
        timePickerTheme: TimePickerThemeData(
          backgroundColor: colorScheme.backgroundElevation1,
          dialBackgroundColor: colorScheme.backgroundSurface,
          hourMinuteColor: colorScheme.backgroundSurface,
        ),
      ),
      child: child!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final spacing = context.streamSpacing;
    final radius = context.streamRadius;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;

    final time = Jiffy.parseFromDateTime(_time);
    final zone = _gmtLabel(_time.timeZoneOffset);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: spacing.md),
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
          children: [
            StreamSheetHeader(
              title: Text(widget.title),
              trailing: StreamButton.icon(
                icon: Icon(icons.checkmark),
                type: .solid,
                onPressed: _problem != null ? null : () => Navigator.of(context).pop(_time),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.xs),
              child: Column(
                crossAxisAlignment: .start,
                spacing: spacing.xxs,
                children: [
                  Text(
                    widget.label,
                    style: textTheme.captionEmphasis.copyWith(color: colorScheme.textSecondary),
                  ),
                  DefaultTextStyle.merge(
                    maxLines: 3,
                    overflow: .ellipsis,
                    style: textTheme.bodyDefault,
                    child: StreamMessagePreviewText(message: widget.message),
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing.xs),
            StreamListTile(
              leading: const Icon(Icons.calendar_today_outlined),
              title: const Text(ScheduledMessagesStrings.date),
              trailing: Text(time.format(pattern: 'EEE, MMM d')),
              onTap: _pickDate,
            ),
            StreamListTile(
              leading: Icon(icons.clock),
              title: const Text(ScheduledMessagesStrings.time),
              trailing: Text(time.format(pattern: 'HH:mm')),
              onTap: _pickTime,
            ),
            SizedBox(height: spacing.xs),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.md),
              child: DecoratedBox(
                decoration: ShapeDecoration(
                  color: colorScheme.backgroundSurfaceCard,
                  shape: RoundedSuperellipseBorder(borderRadius: .all(radius.lg)),
                ),
                child: Padding(
                  padding: EdgeInsets.all(spacing.sm),
                  child: Row(
                    spacing: spacing.xs,
                    children: [
                      Icon(
                        _problem != null ? icons.exclamationCircle : icons.info,
                        size: 20,
                        color: _problem != null ? colorScheme.accentError : colorScheme.textSecondary,
                      ),
                      Expanded(
                        child: Text(
                          _problem ?? ScheduledMessagesStrings.sentInTimeZone(zone),
                          style: textTheme.captionDefault.copyWith(
                            color: _problem != null ? colorScheme.accentError : colorScheme.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
