import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

import '../../../stream_chat_flutter.dart';
import '../../utils/channel_name.dart';
import 'schedule_message_bounds.dart';
import 'schedule_message_picker_theme.dart';

/// Shows a sheet to pick the date and time [message] is sent at in [channel],
/// which must be initialized.
///
/// The sheet starts at [initialScheduledAt], or an hour from now. With
/// [initialScheduledAt] set, it is headed "Reschedule message" and its
/// too-soon error is the one for rescheduling. A time sooner or further ahead
/// than the channel allows shows an error, and can't be picked; the sheet
/// returns the picked time, or null when dismissed.
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

    final bounds = ScheduleMessageBounds.fromConfig(widget.channel.config);
    final errorText = _errorText(bounds);
    final canSchedule = bounds.contains(_scheduledAt);

    final channel = widget.channel;
    final channelName = loadedChannelName(channel, currentUser: channel.client.state.currentUser);
    final channelLabel = translations.messageToLabel(channelName: channelName ?? translations.noTitleText);
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
            // A close button, not a back one, even when the sheet is stacked
            // on another, as closing it picks no time.
            leading: StreamButton.icon(
              type: .outline,
              style: .secondary,
              tooltip: materialLocalizations.closeButtonTooltip,
              icon: Icon(icons.xmark),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            title: Text(
              switch (_isRescheduling) {
                true => translations.rescheduleMessageLabel,
                false => translations.scheduleMessageLabel,
              },
            ),
            trailing: StreamButton.icon(
              type: .solid,
              tooltip: translations.scheduleLabel,
              icon: Icon(icons.checkmark),
              onPressed: switch (canSchedule) {
                true => () => Navigator.of(context).pop(_scheduledAt),
                false => null,
              },
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
                    title: Text(channelLabel),
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

  void _setScheduledAt(DateTime scheduledAt) {
    setState(() => _scheduledAt = scheduledAt);
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
    _setScheduledAt(DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: .fromDateTime(_scheduledAt),
      builder: buildSchedulePickerTheme,
    );

    if (time == null || !mounted) return;

    final date = _scheduledAt;
    _setScheduledAt(DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }

  // The error to show for the picked time, when the channel doesn't allow it.
  String? _errorText(ScheduleMessageBounds bounds) {
    final translations = context.translations;
    if (bounds.isTooSoon(_scheduledAt)) {
      return switch (_isRescheduling) {
        true => translations.rescheduleTooSoonError,
        false => translations.scheduleTooSoonError(minLeadTime: bounds.minLeadTime),
      };
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
