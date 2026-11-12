import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'scheduled_messages_strings.dart';

/// Describes why scheduling or changing a scheduled message failed.
///
/// Returns [fallback] when [error] has nothing more specific to say.
String describeScheduleError(Object error, {required String fallback}) {
  if (error is! StreamChatNetworkError) return fallback;

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
    _ when error.statusCode == 404 => ScheduledMessagesStrings.sentOrDeleted,
    _ => fallback,
  };
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
