import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// How far ahead a message can be scheduled when the channel doesn't say.
const _defaultMaxLeadTime = Duration(days: 120);

/// Shows the quick choices for when to send [message] to [recipient].
///
/// The choices are two times tomorrow, Monday morning, or a custom time. A
/// custom time can be at most [maxLeadTime] ahead, 120 days by default.
///
/// Resolves to the chosen time, or null if the user closes the sheet.
Future<DateTime?> showScheduleMessageSheet(
  BuildContext context, {
  required Message message,
  required String recipient,
  Duration? maxLeadTime,
}) {
  return showStreamSheet<DateTime>(
    context: context,
    isDismissible: true,
    builder: (_, _) => _ScheduleOptionsSheet(
      message: message,
      recipient: recipient,
      maxLeadTime: maxLeadTime ?? _defaultMaxLeadTime,
    ),
  );
}

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
      initial: initial ?? clock.now().add(const Duration(hours: 1)),
      maxLeadTime: maxLeadTime ?? _defaultMaxLeadTime,
    ),
  );
}

/// Formats [time] the way the scheduled messages screens show it.
///
/// For example, "Fri, Oct 23 at 09:00". A [short] one leaves out the date
/// within the coming week, such as "Fri at 09:00".
String formatScheduledTime(DateTime time, {bool short = false}) {
  final local = time.toLocal();
  final withinWeek = local.difference(clock.now()) < const Duration(days: 6);
  final day = switch (short) {
    true when withinWeek => 'EEE',
    true => 'MMM d',
    false => 'EEE, MMM d',
  };

  final jiffy = Jiffy.parseFromDateTime(local);
  return '${jiffy.format(pattern: day)} at ${jiffy.format(pattern: 'HH:mm')}';
}

/// Describes why scheduling or changing a scheduled message failed.
///
/// Returns [fallback] when [error] has nothing more specific to say.
String describeScheduleError(Object error, {required String fallback}) {
  if (error is! StreamChatNetworkError) return fallback;

  return switch (error.scheduledMessageErrorReason) {
    .scheduledMessagesDisabled => 'Scheduled messages are turned off for this app',
    .scheduledAtTooSoon => 'Pick a time in the future',
    .scheduledAtTooFar => 'Pick an earlier time',
    .scheduledLimitChannel => 'This channel has too many scheduled messages',
    .scheduledLimitUser => 'You have too many scheduled messages',
    .scheduledMessageNotEditable => 'This message failed to send and can only be deleted',
    .scheduledMessageSending => 'This message is already being sent',
    .scheduledMessageConflict => 'This message just changed. Try again',
    .scheduledMessageAlreadySent => 'This message was already sent',
    .scheduledMessageCanceled => 'This message was deleted',
    _ => fallback,
  };
}

/// The name of [channel].
///
/// A channel without a name of its own is named after its other members.
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
  const _ScheduleOptionsSheet({
    required this.message,
    required this.recipient,
    required this.maxLeadTime,
  });

  final Message message;
  final String recipient;
  final Duration maxLeadTime;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final spacing = context.streamSpacing;

    final now = clock.now();
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
                  maxLeadTime: maxLeadTime,
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
  bool get _isPast => !_time.isAfter(clock.now());
  bool get _isTooFar => _time.isAfter(clock.now().add(widget.maxLeadTime));

  String? get _problem => switch ((_isPast, _isTooFar)) {
    (true, _) => 'Pick a time in the future',
    (_, true) => 'Pick a time within the next ${widget.maxLeadTime.inDays} days',
    _ => null,
  };

  Future<void> _pickDate() async {
    final now = clock.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _time,
      firstDate: now,
      lastDate: now.add(widget.maxLeadTime),
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
