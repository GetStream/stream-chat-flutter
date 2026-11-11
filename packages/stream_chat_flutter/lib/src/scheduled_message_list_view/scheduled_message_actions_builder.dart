import 'package:flutter/material.dart';

import '../../stream_chat_flutter.dart';

/// Builds the actions offered on a [ScheduledMessage].
///
/// See also:
///
///  * [showStreamScheduledMessageActions], which shows these actions in a
///    sheet.
class StreamScheduledMessageActionsBuilder {
  StreamScheduledMessageActionsBuilder._();

  /// Returns the action rows [scheduledMessage] allows.
  ///
  /// A scheduled message can be edited, rescheduled, sent now or deleted. A
  /// failed one can be edited and scheduled again, or deleted; when its
  /// channel was deleted, its text can only be copied before it is deleted.
  /// Tapping a row closes the route of [context] with its
  /// [ScheduledMessageAction].
  static List<Widget> buildActions({
    required BuildContext context,
    required ScheduledMessage scheduledMessage,
  }) {
    final icons = context.streamIcons;
    final translations = context.translations;

    final isScheduled = scheduledMessage.status == .scheduled;
    final isFailed = scheduledMessage.status == .failed;
    final isChannelDeleted = scheduledMessage.failureReason == .channelDeleted;
    final hasText = scheduledMessage.message.text?.isNotEmpty ?? false;

    final canEditAndReschedule = isFailed && !isChannelDeleted;
    final canCopyText = hasText && !isScheduled && !canEditAndReschedule;

    void emit(ScheduledMessageAction action) => Navigator.of(context).pop(action);

    return <Widget>[
      if (isScheduled) ...[
        _ScheduledMessageActionRow(
          icon: Icon(icons.edit),
          label: Text(translations.editMessageLabel),
          onTap: () => emit(EditScheduledMessage(scheduledMessage: scheduledMessage)),
        ),
        _ScheduledMessageActionRow(
          icon: Icon(icons.clock),
          label: Text(translations.rescheduleLabel),
          onTap: () => emit(RescheduleMessage(scheduledMessage: scheduledMessage)),
        ),
        _ScheduledMessageActionRow(
          icon: Icon(icons.send),
          label: Text(translations.sendNowLabel),
          onTap: () => emit(SendScheduledMessageNow(scheduledMessage: scheduledMessage)),
        ),
      ],
      if (canEditAndReschedule)
        _ScheduledMessageActionRow(
          icon: Icon(icons.edit),
          label: Text(translations.editAndRescheduleLabel),
          onTap: () => emit(EditAndRescheduleMessage(scheduledMessage: scheduledMessage)),
        ),
      if (canCopyText)
        _ScheduledMessageActionRow(
          icon: Icon(icons.copy),
          label: Text(translations.copyMessageLabel),
          onTap: () => emit(CopyScheduledMessageText(scheduledMessage: scheduledMessage)),
        ),
      _ScheduledMessageActionRow(
        icon: Icon(icons.delete),
        label: Text(translations.deleteLabel),
        destructive: true,
        onTap: () => emit(DeleteScheduledMessage(scheduledMessage: scheduledMessage)),
      ),
    ];
  }
}

// A tappable action row of the scheduled message actions sheet, painted with
// the error color when destructive.
class _ScheduledMessageActionRow extends StatelessWidget {
  const _ScheduledMessageActionRow({
    required this.icon,
    required this.label,
    this.onTap,
    this.destructive = false,
  });

  final Widget icon;
  final Widget label;
  final VoidCallback? onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;

    return StreamListTileTheme(
      data: StreamListTileThemeData(
        iconColor: destructive ? .all(colorScheme.accentError) : null,
        titleColor: destructive ? .all(colorScheme.accentError) : null,
        minTileHeight: 48,
        contentPadding: .symmetric(horizontal: spacing.sm),
      ),
      child: StreamListTile(leading: icon, title: label, onTap: onTap),
    );
  }
}
