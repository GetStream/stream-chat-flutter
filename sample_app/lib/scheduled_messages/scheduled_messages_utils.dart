import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'scheduled_messages_strings.dart';

/// The SDK's strings that tell why a scheduled message request failed.
///
/// Read with [scheduleErrorTexts] before an await, as the error comes after
/// it.
typedef ScheduleErrorTexts = ({
  String generic,
  String commandRefused,
  String quotedMessageDeleted,
  String refused,
});

/// The [ScheduleErrorTexts] of [context].
ScheduleErrorTexts scheduleErrorTexts(BuildContext context) {
  final translations = context.translations;
  return (
    generic: translations.genericErrorText,
    commandRefused: translations.scheduleCommandRefusedError,
    quotedMessageDeleted: translations.scheduleQuotedMessageDeletedError,
    refused: translations.scheduleMessageRefusedError,
  );
}

/// Describes why scheduling or changing a scheduled message failed.
///
/// Returns the generic one of [texts] when [error] has nothing more specific
/// to say.
String describeScheduleError(Object error, ScheduleErrorTexts texts) {
  if (error is ScheduledMessageRefusedError) {
    return switch (error.reason) {
      .slashCommand => texts.commandRefused,
      .quotedMessageDeleted => texts.quotedMessageDeleted,
      _ => texts.refused,
    };
  }

  if (error is! StreamChatNetworkError) return texts.generic;

  return switch (error.scheduledMessageErrorReason) {
    .scheduledMessagesDisabled => ScheduledMessagesStrings.scheduledMessagesDisabled,
    .scheduledAtTooSoon => ScheduledMessagesStrings.pickFutureTime,
    .scheduledAtTooFar => ScheduledMessagesStrings.pickEarlierTime,
    .scheduledLimitChannel => ScheduledMessagesStrings.channelLimitReached,
    .scheduledLimitUser => ScheduledMessagesStrings.userLimitReached,
    .scheduledMessageNotEditable => ScheduledMessagesStrings.notEditable,
    .scheduledMessageSending => ScheduledMessagesStrings.alreadySending,
    .scheduledMessageConflict => ScheduledMessagesStrings.conflict,
    .scheduledMessageAlreadySent => ScheduledMessagesStrings.alreadySentError,
    .scheduledMessageCanceled => ScheduledMessagesStrings.canceled,
    _ when error.isScheduledMessageNotFound => ScheduledMessagesStrings.sentOrDeleted,
    _ => texts.generic,
  };
}

/// Shows why scheduling or changing a scheduled message failed, on
/// [messenger].
///
/// One already sent or deleted is shown as a notice rather than an error, as
/// there is nothing left to change.
void showScheduleError(StreamSnackbarMessenger messenger, Object error, ScheduleErrorTexts texts) {
  final description = describeScheduleError(error, texts);
  final variant = _isScheduledMessageGone(error) ? StreamSnackbarVariant.neutral : StreamSnackbarVariant.error;
  messenger.show(StreamSnackbar(message: Text(description), variant: variant));
}

// Whether [error] says the scheduled message was already sent or deleted.
bool _isScheduledMessageGone(Object error) {
  if (error is! StreamChatNetworkError) return false;
  if (error.scheduledMessageErrorReason == .scheduledMessageAlreadySent) return true;
  return error.isScheduledMessageNotFound;
}

/// The name of the channel [scheduledMessage] is sent to, or null when it has
/// none.
///
/// A loaded channel without a name of its own is named after its other
/// members.
String? scheduledMessageChannelName(BuildContext context, ScheduledMessage scheduledMessage) {
  final client = StreamChat.of(context).client;
  return switch (client.state.channels[scheduledMessage.cid]) {
    final loaded? => _channelDisplayName(loaded),
    null => scheduledMessage.channel?.name,
  };
}

// The name of [channel]. A channel without a name of its own is named after
// its other members.
String? _channelDisplayName(Channel channel) {
  // A loaded channel keeps its members on its state, not on its model.
  final state = channel.state;
  final model = state?.channelState.channel?.copyWith(members: state.members);

  return model?.formatName(currentUser: channel.client.state.currentUser);
}
