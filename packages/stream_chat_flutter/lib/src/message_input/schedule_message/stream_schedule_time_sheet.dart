import 'dart:math' as math;

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

import '../../../stream_chat_flutter.dart';
import '../../utils/channel_name.dart';
import 'schedule_message_bounds.dart';
import 'schedule_message_picker_theme.dart';
import 'scheduled_message_counts.dart';

/// Shows a sheet to pick the date and time [message] is sent at in [channel],
/// which must be initialized.
///
/// The sheet starts at [initialScheduledAt], or an hour from now. A time
/// sooner or further ahead than the channel allows shows an error, and can't
/// be picked. With [initialScheduledAt] set, the sheet reschedules a message:
/// it is headed for rescheduling, and the channel's and user's limits aren't
/// checked.
///
/// Returns the picked time, or null when dismissed.
Future<DateTime?> showStreamScheduleTimeSheet({
  required BuildContext context,
  required Channel channel,
  required Message message,
  DateTime? initialScheduledAt,
}) {
  return showStreamSheet<DateTime>(
    context: context,
    isDismissible: true,
    builder: (_, _) => _ScheduleTimeSheet(
      channel: channel,
      message: message,
      initialScheduledAt: initialScheduledAt,
    ),
  );
}

// A sheet to pick the date and time a message is sent at. It previews the
// message, and shows a date and a time to change through the Material pickers.
class _ScheduleTimeSheet extends StatefulWidget {
  const _ScheduleTimeSheet({
    required this.channel,
    required this.message,
    this.initialScheduledAt,
  });

  final Channel channel;
  final Message message;
  final DateTime? initialScheduledAt;

  @override
  State<_ScheduleTimeSheet> createState() => _ScheduleTimeSheetState();
}

class _ScheduleTimeSheetState extends State<_ScheduleTimeSheet> {
  late var _scheduledAt = _initialScheduledAt();

  // A sheet that starts at a time moves a message that is already scheduled.
  bool get _isRescheduling => widget.initialScheduledAt != null;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final spacing = context.streamSpacing;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;
    final translations = context.translations;

    final materialLocalizations = MaterialLocalizations.of(context);

    final channel = widget.channel;
    final bounds = ScheduleMessageBounds.fromConfig(channel.config);
    final scheduledMessages = channel.client.state.scheduledMessages;
    final counts = ScheduledMessageCounts.of(scheduledMessages, cid: channel.cid!);
    final errorText = _errorText(bounds, counts);
    final canSchedule = errorText == null;

    final previewTitle = switch (widget.initialScheduledAt) {
      final scheduledAt? => translations.scheduledMessageScheduledForText(scheduledAt: scheduledAt),
      null => translations.messageToLabel(
        channelName:
            loadedChannelName(channel, currentUser: channel.client.state.currentUser) ?? translations.noTitleText,
      ),
    };
    final valueStyle = textTheme.captionDefault.copyWith(color: colorScheme.textTertiary);

    final date = materialLocalizations.formatMediumDate(_scheduledAt);
    final time = materialLocalizations.formatTimeOfDay(
      TimeOfDay.fromDateTime(_scheduledAt),
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );

    final timeZone = timeZoneLabel(_scheduledAt.timeZoneOffset);

    final contentPadding = EdgeInsets.symmetric(horizontal: spacing.md);

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .stretch,
        children: [
          StreamSheetHeader(
            title: Text(
              _isRescheduling ? translations.rescheduleMessageLabel : translations.scheduleMessageLabel,
            ),
            trailing: StreamButton.icon(
              type: .solid,
              tooltip: translations.scheduleLabel,
              icon: Icon(icons.checkmark),
              onPressed: canSchedule ? _confirm : null,
            ),
          ),
          Padding(
            padding: .symmetric(vertical: spacing.md),
            child: Column(
              mainAxisSize: .min,
              crossAxisAlignment: .stretch,
              spacing: spacing.md,
              children: [
                Padding(
                  padding: contentPadding,
                  child: StreamMessageComposerEditMessageAttachment(
                    title: Text(previewTitle),
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
                    padding: .symmetric(horizontal: spacing.xxs),
                    child: Column(
                      mainAxisSize: .min,
                      children: [
                        _SchedulePickerRow(
                          icon: Icon(icons.calendar),
                          label: Text(translations.dateLabel),
                          value: Text(date, style: valueStyle),
                          onTap: _pickDate,
                        ),
                        _SchedulePickerRow(
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  DateTime _initialScheduledAt() {
    if (widget.initialScheduledAt case final initial?) return initial.toLocal();

    final now = clock.now().add(const Duration(hours: 1));
    return DateTime(now.year, now.month, now.day, now.hour, now.minute);
  }

  Future<void> _pickDate() async {
    // Measured when the picker opens, as the sheet may have been open a while.
    final bounds = ScheduleMessageBounds.fromConfig(widget.channel.config);
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
    setState(() => _scheduledAt = DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: .fromDateTime(_scheduledAt),
      initialEntryMode: .input,
      builder: buildSchedulePickerTheme,
    );

    if (time == null || !mounted) return;

    final date = _scheduledAt;
    setState(() => _scheduledAt = DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  // Picks the time, unless the sheet stayed open until it was no longer
  // allowed; a rebuild then shows why.
  void _confirm() {
    final channel = widget.channel;
    final bounds = ScheduleMessageBounds.fromConfig(channel.config);
    final scheduledMessages = channel.client.state.scheduledMessages;
    final counts = ScheduledMessageCounts.of(scheduledMessages, cid: channel.cid!);
    if (_errorText(bounds, counts) != null) {
      // The bounds or counts changed while the sheet was open.
      setState(() {});
      return;
    }

    Navigator.of(context).pop(_scheduledAt);
  }

  // Why the picked time can't be scheduled, or null when it can.
  String? _errorText(ScheduleMessageBounds bounds, ScheduledMessageCounts counts) {
    final translations = context.translations;

    // Rescheduling moves a message the user already counts toward the limits.
    if (!_isRescheduling) {
      final config = widget.channel.config;
      final channelLimit = config?.scheduledMessagesMaxPerChannel;
      if (channelLimit != null && counts.channelPending >= channelLimit) {
        return translations.scheduleLimitReachedLabel(limit: channelLimit);
      }

      final userLimit = config?.scheduledMessagesMaxPerUser;
      if (userLimit != null && counts.userPending >= userLimit) {
        return translations.scheduleUserLimitReachedError(limit: userLimit);
      }
    }

    if (bounds.isTooSoon(_scheduledAt)) {
      if (_isRescheduling) return translations.rescheduleTooSoonError;

      // Shown in whole minutes, so a shorter minimum still reads as one.
      final minutes = math.max(1, (bounds.minLeadTime.inSeconds / 60).ceil());
      return translations.scheduleTooSoonError(minLeadTime: Duration(minutes: minutes));
    }
    if (bounds.isTooFar(_scheduledAt)) return translations.scheduleTooFarError;
    return null;
  }
}

// A row of the time sheet that opens a date or time picker when tapped.
class _SchedulePickerRow extends StatelessWidget {
  const _SchedulePickerRow({
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
        contentPadding: .symmetric(horizontal: spacing.sm),
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
