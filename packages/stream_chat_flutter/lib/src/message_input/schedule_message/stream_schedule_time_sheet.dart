import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

import '../../../stream_chat_flutter.dart';
import 'schedule_message_bounds.dart';
import 'schedule_message_picker_theme.dart';

/// Signature for a callback that schedules a message for [scheduledAt].
typedef StreamScheduleMessageCallback = Future<void> Function(DateTime scheduledAt);

/// Shows a sheet to pick the date and time [message] is sent at in [channel].
///
/// The sheet starts at [initialScheduledAt], or an hour from now, and is
/// headed by [title], or [Translations.scheduleMessageLabel] by default. A time sooner or
/// further ahead than the channel allows shows an error, and can't be picked.
///
/// When [onSchedule] is given, it schedules the picked time before the sheet
/// closes; a failure keeps the sheet open and shows the error.
///
/// Returns the picked time, or null when the sheet is dismissed.
Future<DateTime?> showStreamScheduleTimeSheet(
  BuildContext context, {
  required Channel channel,
  required Message message,
  DateTime? initialScheduledAt,
  Widget? title,
  StreamScheduleMessageCallback? onSchedule,
}) {
  return showStreamSheet<DateTime>(
    context: context,
    isDismissible: true,
    // A drag closes the sheet even while it schedules, so it's turned off
    // when the sheet schedules the picked time itself.
    enableDrag: onSchedule == null,
    builder: (_, _) => StreamScheduleTimeSheet(
      channel: channel,
      message: message,
      initialScheduledAt: initialScheduledAt,
      title: title,
      onSchedule: onSchedule,
    ),
  );
}

/// A sheet to pick the date and time a message is sent at.
///
/// It previews the message, and shows a date and a time to change through the
/// Material pickers. Scheduling closes the sheet with the picked time.
///
/// See also:
///
///  * [showStreamScheduleTimeSheet], which shows this sheet.
///  * [StreamScheduleMessageSheet], which offers preset times and opens this
///    sheet for a custom one.
class StreamScheduleTimeSheet extends StatefulWidget {
  /// Creates a sheet to pick when [message] is sent in [channel].
  const StreamScheduleTimeSheet({
    super.key,
    required this.channel,
    required this.message,
    this.initialScheduledAt,
    this.title,
    this.onSchedule,
  });

  /// The channel the message is sent to.
  final Channel channel;

  /// The message to schedule.
  final Message message;

  /// The time the sheet starts at.
  ///
  /// Defaults to an hour from now.
  final DateTime? initialScheduledAt;

  /// The title of the sheet.
  ///
  /// Defaults to [Translations.scheduleMessageLabel].
  final Widget? title;

  /// Called to schedule the picked time before the sheet closes.
  ///
  /// A failure keeps the sheet open and shows the error.
  final StreamScheduleMessageCallback? onSchedule;

  @override
  State<StreamScheduleTimeSheet> createState() => _StreamScheduleTimeSheetState();
}

class _StreamScheduleTimeSheetState extends State<StreamScheduleTimeSheet> {
  late var _scheduledAt = _initialScheduledAt();
  var _isScheduling = false;
  Object? _failure;

  DateTime _initialScheduledAt() {
    if (widget.initialScheduledAt case final initial?) return initial.toLocal();

    final now = clock.now().add(const Duration(hours: 1));
    return DateTime(now.year, now.month, now.day, now.hour, now.minute);
  }

  void _setScheduledAt(DateTime scheduledAt) {
    setState(() {
      _scheduledAt = scheduledAt;
      _failure = null;
    });
  }

  Future<void> _pickDate(ScheduleMessageBounds bounds) async {
    final earliest = bounds.earliest;
    final firstDate = DateTime(earliest.year, earliest.month, earliest.day);
    final initialDate = switch (_scheduledAt) {
      final date when date.isBefore(firstDate) => firstDate,
      final date when date.isAfter(bounds.latest) => bounds.latest,
      final date => date,
    };

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: bounds.latest,
      builder: buildSchedulePickerTheme,
    );
    if (date == null || !mounted) return;

    final time = _scheduledAt;
    _setScheduledAt(DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduledAt),
      builder: buildSchedulePickerTheme,
    );
    if (time == null || !mounted) return;

    final date = _scheduledAt;
    _setScheduledAt(DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  Future<void> _schedule() async {
    final navigator = Navigator.of(context);
    final scheduledAt = _scheduledAt;

    final onSchedule = widget.onSchedule;
    if (onSchedule == null) return navigator.pop(scheduledAt);

    setState(() {
      _isScheduling = true;
      _failure = null;
    });

    try {
      await onSchedule(scheduledAt);
      if (!mounted) return;
      navigator.pop(scheduledAt);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isScheduling = false;
        _failure = error;
      });
    }
  }

  // The error to show for the picked time, or for a failure to schedule it.
  String? _errorText(ScheduleMessageBounds bounds) {
    final translations = context.translations;
    if (bounds.isTooSoon(_scheduledAt)) return translations.scheduleTooSoonText;
    if (bounds.isTooFar(_scheduledAt)) return translations.scheduleTooFarText;

    final failure = _failure;
    if (failure == null) return null;

    final config = widget.channel.config;
    final userLimit = config?.scheduledMessagesMaxPerUser;
    final channelLimit = config?.scheduledMessagesMaxPerChannel;
    final reason = switch (failure) {
      StreamChatNetworkError() => failure.scheduledMessageErrorReason,
      _ => null,
    };

    return switch (reason) {
      .scheduledAtTooSoon => translations.scheduleTooSoonText,
      .scheduledAtTooFar => translations.scheduleTooFarText,
      .scheduledLimitUser when userLimit != null => translations.scheduledMessageUserLimitText(limit: userLimit),
      .scheduledLimitChannel when channelLimit != null => translations.scheduleLimitReachedText(limit: channelLimit),
      _ => translations.scheduleMessageFailedText,
    };
  }

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final spacing = context.streamSpacing;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;
    final translations = context.translations;
    final materialLocalizations = MaterialLocalizations.of(context);

    final bounds = ScheduleMessageBounds.of(widget.channel);
    final errorText = _errorText(bounds);
    final isOutOfBounds = !bounds.contains(_scheduledAt);
    final canSchedule = !isOutOfBounds && !_isScheduling;

    final channelName = scheduleChannelName(widget.channel);
    final valueStyle = textTheme.captionDefault.copyWith(color: colorScheme.textTertiary);
    final date = materialLocalizations.formatMediumDate(_scheduledAt);
    final time = materialLocalizations.formatTimeOfDay(TimeOfDay.fromDateTime(_scheduledAt));
    final timeZone = timeZoneLabel(_scheduledAt.timeZoneOffset);

    final contentPadding = EdgeInsets.symmetric(horizontal: spacing.md);

    return PopScope(
      canPop: !_isScheduling,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .stretch,
          children: [
            StreamSheetHeader(
              automaticallyImplyLeading: false,
              title: widget.title ?? Text(translations.scheduleMessageLabel),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: spacing.md),
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .stretch,
                spacing: spacing.md,
                children: [
                  Padding(
                    padding: contentPadding,
                    child: StreamMessageComposerEditMessageAttachment(
                      title: Text(
                        translations.messageToText(name: channelName ?? translations.noTitleText),
                      ),
                      subtitle: _ScheduledMessagePreviewText(message: widget.message),
                    ),
                  ),
                  if (errorText != null)
                    Padding(
                      padding: contentPadding,
                      child: StreamInlineNotification(type: .error, title: Text(errorText)),
                    ),
                  IconTheme.merge(
                    data: const IconThemeData(size: 20),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: spacing.xxs),
                      child: Column(
                        mainAxisSize: .min,
                        children: [
                          _ScheduleTimeRow(
                            icon: Icon(icons.calendar),
                            label: Text(translations.dateLabel),
                            value: Text(date, style: valueStyle),
                            onTap: () => _pickDate(bounds),
                          ),
                          _ScheduleTimeRow(
                            icon: Icon(icons.clock),
                            label: Text(translations.timeLabel),
                            value: Text(time, style: valueStyle),
                            onTap: _pickTime,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: contentPadding,
                    child: StreamInlineNotification(
                      title: Text(translations.sentInYourTimeZoneText(timeZone: timeZone)),
                    ),
                  ),
                  Padding(
                    padding: contentPadding,
                    child: Row(
                      mainAxisAlignment: .end,
                      spacing: spacing.xs,
                      children: [
                        StreamButton(
                          type: .ghost,
                          style: .primary,
                          onPressed: switch (_isScheduling) {
                            true => null,
                            false => () => Navigator.of(context).maybePop(),
                          },
                          child: Text(translations.cancelLabel),
                        ),
                        StreamButton(
                          onPressed: canSchedule ? _schedule : null,
                          child: Text(translations.scheduleLabel),
                        ),
                      ],
                    ),
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

// A date or time row of the sheet, which opens a picker when tapped.
class _ScheduleTimeRow extends StatelessWidget {
  const _ScheduleTimeRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final Widget icon;
  final Widget label;
  final Widget value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;

    return StreamListTileTheme(
      data: StreamListTileThemeData(
        minTileHeight: 48,
        contentPadding: .symmetric(horizontal: spacing.sm, vertical: spacing.xs),
      ),
      child: StreamListTile(leading: icon, title: label, trailing: value, onTap: onTap),
    );
  }
}

// The preview of the message being scheduled, with the smaller icons the
// composer header uses.
class _ScheduledMessagePreviewText extends StatelessWidget {
  const _ScheduledMessagePreviewText({required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    const previewTextTheme = StreamMessagePreviewTextThemeData(iconSize: 12);
    final ambientTextTheme = StreamMessagePreviewTextTheme.of(context);

    return StreamMessagePreviewTextTheme(
      data: previewTextTheme.merge(ambientTextTheme),
      child: StreamMessagePreviewText(message: message),
    );
  }
}
