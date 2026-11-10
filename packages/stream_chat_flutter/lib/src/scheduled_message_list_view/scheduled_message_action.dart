import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// Signature for a builder that customizes the rows of the scheduled message
/// actions sheet.
///
/// [defaultActions] are the rows offered for the scheduled message. The
/// returned list replaces them, so rows can be added, removed, or reordered.
///
/// Any widget can be mixed in alongside the default rows; an added row handles
/// its own tap.
typedef ScheduledMessageActionsBuilder =
    List<Widget> Function(
      BuildContext context,
      List<Widget> defaultActions,
    );

/// An action on a scheduled message, chosen from the scheduled message
/// actions sheet.
sealed class ScheduledMessageAction {
  /// Creates a scheduled message action.
  const ScheduledMessageAction({required this.scheduledMessage});

  /// The scheduled message this action applies to.
  final ScheduledMessage scheduledMessage;
}

/// Action to change the text of a scheduled message.
final class EditScheduledMessage extends ScheduledMessageAction {
  /// Creates an edit scheduled message action.
  const EditScheduledMessage({required super.scheduledMessage});
}

/// Action to change when a scheduled message is sent.
final class RescheduleMessage extends ScheduledMessageAction {
  /// Creates a reschedule message action.
  const RescheduleMessage({required super.scheduledMessage});
}

/// Action to send a scheduled message right away.
final class SendScheduledMessageNow extends ScheduledMessageAction {
  /// Creates a send scheduled message now action.
  const SendScheduledMessageNow({required super.scheduledMessage});
}

/// Action to schedule the content of a failed scheduled message again, with
/// its text edited.
///
/// A failed scheduled message can't be changed, so the caller is expected to
/// schedule a new message and delete the failed one.
final class EditAndRescheduleMessage extends ScheduledMessageAction {
  /// Creates an edit and reschedule message action.
  const EditAndRescheduleMessage({required super.scheduledMessage});
}

/// Action to copy the text of a scheduled message.
final class CopyScheduledMessageText extends ScheduledMessageAction {
  /// Creates a copy scheduled message text action.
  const CopyScheduledMessageText({required super.scheduledMessage});
}

/// Action to delete a scheduled message.
final class DeleteScheduledMessage extends ScheduledMessageAction {
  /// Creates a delete scheduled message action.
  const DeleteScheduledMessage({required super.scheduledMessage});
}
