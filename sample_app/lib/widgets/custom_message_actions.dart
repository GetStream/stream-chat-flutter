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
///   → _TranslateMessageAction (translate message on request)
/// ```
Widget customMessageItemBuilder(
  BuildContext context,
  StreamMessageItemProps props,
) {
  final message = props.message;

  return DefaultStreamMessageItem(
    props: props.copyWith(
      actionsBuilder: (context, defaultActions) {
        return StreamContextMenuAction.partitioned(
          items: [
            ...defaultActions,
            ..._ReminderActions.build(context, message),
            ..._DeleteForMeAction.build(context, message),
            ..._MessageInfoAction.build(context, message),
            ..._TranslateMessageAction.build(context, message),
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

// ---------------------------------------------------------------------------
// Translate action
// ---------------------------------------------------------------------------

/// Requests an on-request translation for a message and merges the result
/// into the channel's local state.
///
/// Once merged, the message's `i18n` map carries the translation, and the
/// SDK's own message rendering (`StreamMessageText`, `DefaultStreamMessageHeader`)
/// picks it up automatically — this sample app only needs to fetch it.
///
/// Only shown for messages from other users — translating your own message
/// isn't a useful action — and always translates directly to the current
/// user's [User.language], with no language picker. Hidden entirely when
/// that isn't set, rather than guessing a target language.
abstract final class _TranslateMessageAction {
  static List<StreamContextMenuAction> build(
    BuildContext context,
    Message message,
  ) {
    if (!context.sampleAppConfig.enableMessageTranslation) return const [];
    if (message.deletedAt != null) return const [];
    if (message.text == null || message.text!.isEmpty) return const [];

    final currentUser = StreamChat.of(context).currentUser;
    final isSentByCurrentUser = message.user?.id == currentUser?.id;
    if (isSentByCurrentUser) return const [];

    // The SDK renders translations for the user's own language, so that is
    // what we ask the backend for. Set at login by `AuthController.connect`.
    final language = currentUser?.language;
    if (language == null || language.isEmpty) return const [];

    // Already covers the message's own language: the server includes a
    // self-referential entry keyed by its source language, so this is also
    // `true` when the original text is already in the display language —
    // either way, there's nothing left to translate.
    final alreadyTranslated = message.i18n?['${language}_text'] != null;

    final icons = context.streamIcons;
    return [
      StreamContextMenuAction(
        label: const Text('Translate Message'),
        leading: Icon(icons.translate),
        enabled: !alreadyTranslated,
        onTap: () => _translateMessage(context, message, language),
      ),
    ];
  }

  static Future<void> _translateMessage(
    BuildContext context,
    Message message,
    String language,
  ) async {
    final channel = StreamChannel.of(context).channel;
    try {
      final response = await channel.translateMessage(message.id, language);
      channel.state?.updateMessage(response.message);
    } catch (e) {
      if (!context.mounted) return;
      StreamSnackbarMessenger.of(context).show(
        StreamSnackbar(
          message: Text('Failed to translate message: $e'),
          variant: .error,
        ),
      );
    }
  }
}
