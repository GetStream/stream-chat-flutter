import 'package:flutter/material.dart';

import '../../stream_chat_flutter.dart';

/// Builds the actions offered on a [ScheduledMessage].
///
/// See also:
///
///  * [showStreamScheduledMessageActionsSheet], which shows these actions in a
///    sheet.
class StreamScheduledMessageActionsBuilder {
  StreamScheduledMessageActionsBuilder._();

  /// Returns the actions [scheduledMessage] allows.
  ///
  /// A scheduled message can be edited, rescheduled, sent now or deleted. A
  /// failed one can be edited and scheduled again, or deleted; when its
  /// channel was deleted, its text can only be copied before it is deleted.
  /// Any other message has no actions.
  static List<StreamScheduledMessageActionTile> buildActions({
    required BuildContext context,
    required ScheduledMessage scheduledMessage,
  }) {
    final isScheduled = scheduledMessage.status == .scheduled;
    final isFailed = scheduledMessage.status == .failed;

    // Only a scheduled or a failed message has actions.
    if (!isScheduled && !isFailed) return [];

    final icons = context.streamIcons;
    final translations = context.translations;

    // A message whose channel was deleted can't be scheduled again.
    final isChannelDeleted = scheduledMessage.failureReason == .channelDeleted;
    final hasText = scheduledMessage.message.text?.isNotEmpty ?? false;

    return [
      if (isScheduled) ...[
        StreamScheduledMessageActionTile(
          value: EditScheduledMessage(scheduledMessage: scheduledMessage),
          label: Text(translations.editMessageLabel),
          leading: Icon(icons.edit),
        ),
        StreamScheduledMessageActionTile(
          value: RescheduleMessage(scheduledMessage: scheduledMessage),
          label: Text(translations.rescheduleLabel),
          leading: Icon(icons.clock),
        ),
        StreamScheduledMessageActionTile(
          value: SendScheduledMessageNow(scheduledMessage: scheduledMessage),
          label: Text(translations.sendNowLabel),
          leading: Icon(icons.send),
        ),
      ],
      if (isFailed && !isChannelDeleted)
        StreamScheduledMessageActionTile(
          value: EditAndRescheduleMessage(scheduledMessage: scheduledMessage),
          label: Text(translations.editAndRescheduleLabel),
          leading: Icon(icons.edit),
        ),
      if (isFailed && isChannelDeleted && hasText)
        StreamScheduledMessageActionTile(
          value: CopyScheduledMessageText(scheduledMessage: scheduledMessage),
          label: Text(translations.copyMessageLabel),
          leading: Icon(icons.copy),
        ),
      StreamScheduledMessageActionTile.destructive(
        value: DeleteScheduledMessage(scheduledMessage: scheduledMessage),
        label: Text(translations.deleteLabel),
        leading: Icon(icons.delete),
      ),
    ];
  }
}

/// A row of the scheduled message actions sheet that closes the sheet with
/// its [value] when tapped.
///
/// See also:
///
///  * [StreamScheduledMessageActionsBuilder], which builds these rows.
class StreamScheduledMessageActionTile extends StatelessWidget {
  /// Creates a scheduled message action row.
  const StreamScheduledMessageActionTile({
    super.key,
    required this.value,
    required this.label,
    this.leading,
  }) : isDestructive = false;

  /// Creates a scheduled message action row painted with the error color.
  const StreamScheduledMessageActionTile.destructive({
    super.key,
    required this.value,
    required this.label,
    this.leading,
  }) : isDestructive = true;

  /// The action the sheet resolves to when this row is tapped.
  final ScheduledMessageAction value;

  /// The label of the action.
  final Widget label;

  /// The icon before the [label].
  final Widget? leading;

  /// Whether the action destroys something, such as deleting the message.
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;
    final colorScheme = context.streamColorScheme;

    return StreamListTileTheme(
      data: StreamListTileThemeData(
        iconColor: isDestructive ? .all(colorScheme.accentError) : null,
        titleColor: isDestructive ? .all(colorScheme.accentError) : null,
        minTileHeight: 48,
        contentPadding: .symmetric(horizontal: spacing.sm),
      ),
      child: StreamListTile(
        leading: leading,
        title: label,
        onTap: () => Navigator.of(context).pop(value),
      ),
    );
  }
}
