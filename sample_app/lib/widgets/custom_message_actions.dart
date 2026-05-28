import 'package:flutter/material.dart';
import 'package:sample_app/config/sample_app_config.dart';
import 'package:sample_app/widgets/message_info_sheet.dart';
import 'package:sample_app/widgets/reminder_dialog.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Custom [StreamComponentBuilder] for [StreamMessageItemProps] that
/// composes app-specific message action customizations via a delegation
/// chain.
///
/// Delegation chain:
/// ```
/// customMessageItemBuilder
///   → _ReminderActions    (remind me, save for later, edit/remove reminder)
///   → _DeleteForMeAction  (delete message for current user only)
///   → _MessageInfoAction  (show message delivery info sheet)
/// ```
Widget customMessageItemBuilder(
  BuildContext context,
  StreamMessageItemProps props,
) {
  return DefaultStreamMessageItem(
    props: props.copyWith(
      actionsBuilder: (context, defaultActions) {
        final message = props.message;
        return StreamContextMenuAction.partitioned(
          items: [
            ...defaultActions,
            ..._ReminderActions.build(context, message),
            ..._DeleteForMeAction.build(context, message),
            ..._MessageInfoAction.build(context, message),
          ],
        );
      },
    ),
  );
}

// ---------------------------------------------------------------------------
// Reminder actions
// ---------------------------------------------------------------------------

abstract final class _ReminderActions {
  static List<StreamContextMenuAction> build(
    BuildContext context,
    Message message,
  ) {
    if (!context.sampleAppConfig.enableReminderActions) return const [];

    final icons = context.streamIcons;
    final channel = StreamChannel.of(context).channel;
    final channelConfig = channel.config;
    if (channelConfig?.userMessageReminders != true) return const [];

    final reminder = message.reminder;
    if (reminder != null) {
      return [
        StreamContextMenuAction(
          label: const Text('Edit Reminder'),
          leading: Icon(icons.clock),
          onTap: () => _editReminder(context, message, reminder),
        ),
        StreamContextMenuAction(
          label: const Text('Remove from later'),
          leading: Icon(icons.checkmark),
          onTap: () => _removeReminder(context, message),
        ),
      ];
    }

    return [
      StreamContextMenuAction(
        label: const Text('Remind me'),
        leading: Icon(icons.bell),
        onTap: () => _createReminder(context, message),
      ),
      StreamContextMenuAction(
        label: const Text('Save for later'),
        leading: Icon(icons.file),
        onTap: () => _createBookmark(context, message),
      ),
    ];
  }

  static Future<void> _editReminder(
    BuildContext context,
    Message message,
    MessageReminder reminder,
  ) async {
    final option = await showDialog<ReminderOption>(
      context: context,
      builder: (_) => EditReminderDialog(
        isBookmarkReminder: reminder.remindAt == null,
      ),
    );

    if (option == null) return;
    final client = StreamChat.of(context).client;
    return client.updateReminder(message.id, remindAt: option.remindAt).ignore();
  }

  static Future<void> _removeReminder(
    BuildContext context,
    Message message,
  ) async {
    final client = StreamChat.of(context).client;
    return client.deleteReminder(message.id).ignore();
  }

  static Future<void> _createReminder(
    BuildContext context,
    Message message,
  ) async {
    final reminder = await showDialog<ScheduledReminder>(
      context: context,
      builder: (_) => const CreateReminderDialog(),
    );

    if (reminder == null) return;
    final client = StreamChat.of(context).client;
    return client.createReminder(message.id, remindAt: reminder.remindAt).ignore();
  }

  static Future<void> _createBookmark(
    BuildContext context,
    Message message,
  ) async {
    final client = StreamChat.of(context).client;
    return client.createReminder(message.id).ignore();
  }
}

// ---------------------------------------------------------------------------
// Delete-for-me action
// ---------------------------------------------------------------------------

abstract final class _DeleteForMeAction {
  static List<StreamContextMenuAction> build(
    BuildContext context,
    Message message,
  ) {
    if (!context.sampleAppConfig.enableDeleteForMe) return const [];

    final icons = context.streamIcons;
    final channel = StreamChannel.of(context).channel;
    final currentUser = StreamChat.of(context).currentUser;
    final isSentByCurrentUser = message.user?.id == currentUser?.id;
    if (!isSentByCurrentUser || !channel.canDeleteOwnMessage) return const [];

    return [
      StreamContextMenuAction.destructive(
        label: const Text('Delete Message for Me'),
        leading: Icon(icons.delete),
        onTap: () => _confirmAndDelete(context, message),
      ),
    ];
  }

  static Future<void> _confirmAndDelete(
    BuildContext context,
    Message message,
  ) async {
    final confirmed = await showStreamDialog<bool>(
      context: context,
      builder: (context) => const StreamMessageActionConfirmationModal(
        isDestructiveAction: true,
        title: Text('Delete for me'),
        content: Text('Are you sure you want to delete this message for you?'),
        cancelActionTitle: Text('Cancel'),
        confirmActionTitle: Text('Delete'),
      ),
    );

    if (confirmed != true) return;
    final channel = StreamChannel.of(context).channel;
    return channel.deleteMessageForMe(message).ignore();
  }
}

// ---------------------------------------------------------------------------
// Message info action
// ---------------------------------------------------------------------------

abstract final class _MessageInfoAction {
  static List<StreamContextMenuAction> build(
    BuildContext context,
    Message message,
  ) {
    if (!context.sampleAppConfig.enableMessageInfo) return const [];

    final icons = context.streamIcons;
    final channel = StreamChannel.of(context).channel;
    if (channel.config?.deliveryEvents != true) return const [];

    return [
      StreamContextMenuAction(
        label: const Text('Message Info'),
        leading: Icon(icons.info),
        onTap: () => MessageInfoSheet.show(context: context, message: message),
      ),
    ];
  }
}
