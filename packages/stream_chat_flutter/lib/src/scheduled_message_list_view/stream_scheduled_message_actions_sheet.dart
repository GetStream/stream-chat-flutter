import 'package:flutter/material.dart';

import '../../stream_chat_flutter.dart';

/// Shows the actions on [scheduledMessage] in a sheet.
///
/// The actions are the [StreamScheduledMessageActionsBuilder.buildActions] of
/// [scheduledMessage]. A message without actions, such as one being sent,
/// shows no sheet.
///
/// [actionsBuilder] adds, removes or reorders the actions.
///
/// Returns the chosen action, or null when the sheet is dismissed. Taking the
/// action is up to the caller.
Future<ScheduledMessageAction?> showStreamScheduledMessageActionsSheet({
  required BuildContext context,
  required ScheduledMessage scheduledMessage,
  ScheduledMessageActionsBuilder? actionsBuilder,
}) async {
  final defaultActions = StreamScheduledMessageActionsBuilder.buildActions(
    context: context,
    scheduledMessage: scheduledMessage,
  );

  final actions = actionsBuilder?.call(context, defaultActions) ?? defaultActions;
  if (actions.isEmpty) return null;

  return showStreamSheet<ScheduledMessageAction>(
    context: context,
    isDismissible: true,
    builder: (_, _) => _ScheduledMessageActionsSheet(children: actions),
  );
}

class _ScheduledMessageActionsSheet extends StatelessWidget {
  const _ScheduledMessageActionsSheet({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final spacing = context.streamSpacing;

    return SafeArea(
      child: IconTheme.merge(
        data: const IconThemeData(size: 20),
        child: Padding(
          padding: .only(left: spacing.xxs, top: spacing.xl, right: spacing.xxs),
          child: Column(mainAxisSize: .min, children: children),
        ),
      ),
    );
  }
}
