import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

import '../../../stream_chat_flutter.dart';
import '../../utils/channel_name.dart';
import 'schedule_message_picker_theme.dart';
import 'schedule_message_time.dart';

/// Shows a sheet to pick the date and time [message] is sent at in the channel
/// [cid].
///
/// The sheet starts at [initialScheduledAt], or an hour from now, and is
/// headed by [title], or "Schedule message" by default. A time sooner or
/// further ahead than the channel allows shows an error, and can't be picked.
/// Returns the picked time, or null when the sheet is dismissed.
Future<DateTime?> showStreamScheduleTimeSheet({
  required BuildContext context,
  required String cid,
  required Message message,
  DateTime? initialScheduledAt,
  Widget? title,
}) {
  return showStreamSheet<DateTime>(
    context: context,
    isDismissible: true,
    builder: (_, _) => _ScheduleTimeSheet(
      cid: cid,
      message: message,
      initialScheduledAt: initialScheduledAt,
      title: title,
    ),
  );
}

// A sheet to pick the date and time a message is sent at. It previews the
// message, and shows a date and a time to change through the Material pickers.
class _ScheduleTimeSheet extends StatefulWidget {
  const _ScheduleTimeSheet({
    required this.cid,
    required this.message,
    this.initialScheduledAt,
    this.title,
  });

  final String cid;
  final Message message;
  final DateTime? initialScheduledAt;
  final Widget? title;

  @override
  State<_ScheduleTimeSheet> createState() => _ScheduleTimeSheetState();
}

class _ScheduleTimeSheetState extends State<_ScheduleTimeSheet> {
  late var _scheduledAt = _initialScheduledAt();

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final spacing = context.streamSpacing;
    final textTheme = context.streamTextTheme;
    final colorScheme = context.streamColorScheme;
    final translations = context.translations;
    final materialLocalizations = MaterialLocalizations.of(context);

    final client = StreamChat.of(context).client;
    final config = loadedChannelConfig(client, widget.cid);
    final window = scheduleWindow(config);
    final errorText = _errorText(window, config);
    final canSchedule = errorText == null;

    final channel = client.state.channels[widget.cid];
    final channelName = loadedChannelName(channel, currentUser: client.state.currentUser);
    final channelLabel = translations.messageToLabel(
      channelName: channelName ?? translations.noTitleText,
    );
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
                    padding: EdgeInsets.symmetric(horizontal: spacing.xxs),
                    child: Column(
                      mainAxisSize: .min,
                      children: [
                        _ScheduleTimeRow(
                          icon: Icon(icons.calendar),
                          label: Text(translations.dateLabel),
                          value: Text(date, style: valueStyle),
                          onTap: () => _pickDate(window),
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
                        onPressed: () => Navigator.of(context).maybePop(),
                        child: Text(translations.cancelLabel),
                      ),
                      StreamButton(
                        onPressed: switch (canSchedule) {
                          true => () => Navigator.of(context).pop(_scheduledAt),
                          false => null,
                        },
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

  Future<void> _pickDate(({DateTime earliest, DateTime latest}) window) async {
    final (:earliest, :latest) = window;
    final firstDate = DateTime(earliest.year, earliest.month, earliest.day);
    final initialDate = switch (_scheduledAt) {
      final date when date.isBefore(firstDate) => firstDate,
      final date when date.isAfter(latest) => latest,
      final date => date,
    };

    final date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: latest,
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

  // The error to show for the picked time, when the channel doesn't allow it.
  String? _errorText(
    ({DateTime earliest, DateTime latest}) window,
    ChannelConfig? config,
  ) {
    final translations = context.translations;
    if (_scheduledAt.isBefore(window.earliest)) {
      // A sheet that starts at a time moves a message that is already
      // scheduled.
      if (widget.initialScheduledAt != null) {
        return translations.rescheduleTooSoonError;
      }

      final minLeadTime = config?.scheduledMessagesMinLeadTime ?? defaultScheduleMinLeadTime;
      return translations.scheduleTooSoonError(minLeadTime: minLeadTime);
    }
    if (_scheduledAt.isAfter(window.latest)) return translations.scheduleTooFarError;
    return null;
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
