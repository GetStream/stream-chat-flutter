import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// The longest a message can be scheduled ahead.
const _maxLeadTime = Duration(days: 120);

/// The shortest a message can be scheduled ahead.
const _minLeadTime = Duration(minutes: 1);

/// Shows the quick choices for when to send [message] to [recipient]: two
/// times tomorrow, Monday morning, or a custom time.
///
/// Resolves to the chosen time, or null if the user closes the sheet.
Future<DateTime?> showScheduleMessageSheet(
  BuildContext context, {
  required Message message,
  required String recipient,
}) {
  return showStreamSheet<DateTime>(
    context: context,
    isDismissible: true,
    builder: (_, _) => _ScheduleOptionsSheet(message: message, recipient: recipient),
  );
}

/// Shows a sheet to pick the date and time [message] is sent at.
///
/// The [title] heads the sheet and the [label] sits above the message, so the
/// same sheet serves both scheduling and rescheduling. It starts at [initial],
/// or an hour from now.
///
/// Resolves to the chosen time, or null if the user closes the sheet.
Future<DateTime?> showScheduleTimeSheet(
  BuildContext context, {
  required String title,
  required String label,
  required Message message,
  DateTime? initial,
}) {
  return showStreamSheet<DateTime>(
    context: context,
    isDismissible: true,
    builder: (_, _) => _ScheduleTimeSheet(
      title: title,
      label: label,
      message: message,
      initial: initial ?? DateTime.now().add(const Duration(hours: 1)),
    ),
  );
}

/// Formats [time] the way the scheduled messages screens show it, such as
/// "Fri, Oct 23 at 09:00".
///
/// A [short] one leaves out the date within the coming week, such as
/// "Fri at 09:00".
String formatScheduledTime(DateTime time, {bool short = false}) {
  final local = time.toLocal();
  final withinWeek = local.difference(DateTime.now()) < const Duration(days: 6);
  final day = switch (short) {
    true when withinWeek => 'EEE',
    true => 'MMM d',
    false => 'EEE, MMM d',
  };

  final jiffy = Jiffy.parseFromDateTime(local);
  return '${jiffy.format(pattern: day)} at ${jiffy.format(pattern: 'HH:mm')}';
}

/// Describes why scheduling or changing a scheduled message failed with
/// [error], or returns [fallback] when there is nothing more specific to say.
String describeScheduleError(Object error, {required String fallback}) {
  if (error is! StreamChatNetworkError) return fallback;

  return switch (error.code) {
    114 => 'Scheduled messages are turned off for this app',
    115 => 'Pick a time at least a minute from now',
    116 => 'Pick a time within the next ${_maxLeadTime.inDays} days',
    117 => 'This channel has too many scheduled messages',
    118 => 'You have too many scheduled messages',
    120 || 121 => 'This message is already being sent',
    122 => 'This message just changed. Try again',
    123 => 'This message was already sent',
    124 => 'This message was deleted',
    _ => fallback,
  };
}

/// The name of [channel], or of its other members when it has none.
String? channelDisplayName(Channel channel) {
  // A loaded channel keeps its members on its state, not on its model.
  final state = channel.state;
  final model = state?.channelState.channel?.copyWith(members: state.members);

  return model?.formatName(currentUser: channel.client.state.currentUser);
}

// Labels an offset from UTC the usual way, such as "GMT+2" or "GMT+5:30".
String _gmtLabel(Duration offset) {
  final sign = offset.isNegative ? '-' : '+';
  final hours = offset.inHours.abs();
  final minutes = offset.inMinutes.remainder(60).abs();

  if (minutes == 0) return 'GMT$sign$hours';
  return 'GMT$sign$hours:${minutes.toString().padLeft(2, '0')}';
}

class _ScheduleOptionsSheet extends StatelessWidget {
  const _ScheduleOptionsSheet({required this.message, required this.recipient});

  final Message message;
  final String recipient;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final spacing = context.streamSpacing;

    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final daysToMonday = (DateTime.monday - now.weekday) % 7;
    final monday = DateTime(now.year, now.month, now.day + (daysToMonday == 0 ? 7 : daysToMonday));

    final options = [
      ('Tomorrow at 09:00', tomorrow.add(const Duration(hours: 9))),
      ('Tomorrow at 13:00', tomorrow.add(const Duration(hours: 13))),
      ('Monday at 09:00', monday.add(const Duration(hours: 9))),
    ];

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: spacing.sm),
        child: Column(
          mainAxisSize: .min,
          children: [
            StreamSheetHeader(title: const Text('Schedule message')),
            for (final (label, time) in options)
              StreamListTile(
                leading: Icon(icons.clock),
                title: Text(label),
                onTap: () => Navigator.of(context).pop(time),
              ),
            StreamListTile(
              leading: Icon(icons.clock),
              title: const Text('Custom time'),
              trailing: Icon(icons.chevronRight),
              onTap: () async {
                final navigator = Navigator.of(context);
                final time = await showScheduleTimeSheet(
                  context,
                  title: 'Schedule message',
                  label: 'Message to $recipient',
                  message: message,
                );
                if (time != null) navigator.pop(time);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleTimeSheet extends StatefulWidget {
  const _ScheduleTimeSheet({
    required this.title,
    required this.label,
    required this.message,
    required this.initial,
  });

  final String title;
  final String label;
  final Message message;
  final DateTime initial;

  @override
  State<_ScheduleTimeSheet> createState() => _ScheduleTimeSheetState();
}

class _ScheduleTimeSheetState extends State<_ScheduleTimeSheet> {
  late DateTime _time = widget.initial;

  bool get _isTooSoon => _time.isBefore(DateTime.now().add(_minLeadTime));
  bool get _isTooFar => _time.isAfter(DateTime.now().add(_maxLeadTime));

  String? get _problem => switch ((_isTooSoon, _isTooFar)) {
    (true, _) => 'Pick a time at least a minute from now',
    (_, true) => 'Pick a time within the next ${_maxLeadTime.inDays} days',
    _ => null,
  };

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _time,
      firstDate: now,
      lastDate: now.add(_maxLeadTime),
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
              title: const Text('Date'),
              trailing: Text(time.format(pattern: 'EEE, MMM d')),
              onTap: _pickDate,
            ),
            StreamListTile(
              leading: Icon(icons.clock),
              title: const Text('Time'),
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
                          _problem ?? 'Sent in your time zone ($zone)',
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
