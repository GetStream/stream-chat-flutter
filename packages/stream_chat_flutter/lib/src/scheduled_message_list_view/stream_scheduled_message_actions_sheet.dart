import 'package:flutter/material.dart';

import '../../stream_chat_flutter.dart';

/// Shows the actions on [scheduledMessage] in a sheet.
///
/// A scheduled message can be edited, rescheduled, sent now or deleted. A
/// failed one can be edited and scheduled again, or deleted; when its channel
/// was deleted, its text can only be copied before it is deleted. A message
/// being scheduled or sent, or already sent or canceled, has no actions, so
/// no sheet is shown.
///
/// [actionsBuilder] adds, removes or reorders the rows.
///
/// Returns the chosen action, or null when the sheet is dismissed or a row
/// added by [actionsBuilder] is tapped. Taking the action is up to the
/// caller.
Future<ScheduledMessageAction?> showStreamScheduledMessageActions(
  BuildContext context, {
  required ScheduledMessage scheduledMessage,
  ScheduledMessageActionsBuilder? actionsBuilder,
}) async {
  final hasActions = switch (scheduledMessage.status) {
    .preparingToSchedule || .sending || .sent || .canceled => false,
    _ => true,
  };
  if (!hasActions) return null;

  return showStreamSheet<ScheduledMessageAction>(
    context: context,
    isDismissible: true,
    builder: (_, _) => _ScheduledMessageActionsSheet(
      scheduledMessage: scheduledMessage,
      actionsBuilder: actionsBuilder,
    ),
  );
}

class _ScheduledMessageActionsSheet extends StatelessWidget {
  const _ScheduledMessageActionsSheet({
    required this.scheduledMessage,
    this.actionsBuilder,
  });

  final ScheduledMessage scheduledMessage;
  final ScheduledMessageActionsBuilder? actionsBuilder;

  @override
  Widget build(BuildContext context) {
    final icons = context.streamIcons;
    final spacing = context.streamSpacing;
    final translations = context.translations;

    final isScheduled = scheduledMessage.status == .scheduled;
    final isFailed = scheduledMessage.status == .failed;
    final isChannelDeleted = scheduledMessage.failureReason == .channelDeleted;
    final hasText = scheduledMessage.message.text?.isNotEmpty ?? false;

    final canEditAndReschedule = isFailed && !isChannelDeleted;
    final canCopyText = hasText && !isScheduled && !canEditAndReschedule;

    void emit(ScheduledMessageAction action) {
      Navigator.of(context).pop(action);
    }

    final defaultActions = <Widget>[
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

    final rows = actionsBuilder?.call(context, defaultActions) ?? defaultActions;

    return SafeArea(
      child: IconTheme.merge(
        data: const IconThemeData(size: 20),
        child: Padding(
          padding: .only(left: spacing.xxs, top: spacing.xl, right: spacing.xxs),
          child: Column(mainAxisSize: .min, children: rows),
        ),
      ),
    );
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
        shape: RoundedRectangleBorder(borderRadius: .all(context.streamRadius.md)),
      ),
      child: StreamListTile(leading: icon, title: label, onTap: onTap),
    );
  }
}
