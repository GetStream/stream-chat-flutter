import 'package:flutter/material.dart';

import '../../stream_chat_flutter.dart';

/// Shows the actions on [scheduledMessage] in a sheet.
///
/// The rows are the [StreamScheduledMessageActionsBuilder.buildActions] of
/// [scheduledMessage]. A message being scheduled or sent, or already sent or
/// canceled, has no actions, so no sheet is shown.
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
    final spacing = context.streamSpacing;

    final defaultActions = StreamScheduledMessageActionsBuilder.buildActions(
      context: context,
      scheduledMessage: scheduledMessage,
    );

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
