/// This class defines some basic event types
class EventType {
  /// Indicates any type of events
  static const String any = '*';

  ///
  static const String healthCheck = 'health.check';

  /// Event sent when a user starts typing a message
  static const String typingStart = 'typing.start';

  /// Event sent when a user stops typing a message
  static const String typingStop = 'typing.stop';

  /// Event sent when receiving a new message
  static const String messageNew = 'message.new';

  /// Event sent when receiving a new message
  static const String notificationMessageNew = 'notification.message_new';

  /// Event sent when the unread count changes
  static const String notificationMarkRead = 'notification.mark_read';

  /// Event sent when the unread count changes
  static const String notificationMarkUnread = 'notification.mark_unread';

  /// Event sent when deleting a new message
  static const String messageDeleted = 'message.deleted';

  /// Event sent when receiving a new reaction
  static const String reactionNew = 'reaction.new';

  /// Event sent when deleting a reaction
  static const String reactionDeleted = 'reaction.deleted';

  /// Event sent when updating a reaction
  static const String reactionUpdated = 'reaction.updated';

  /// Event sent when updating a message
  static const String messageUpdated = 'message.updated';

  /// Event sent when a user starts watching a channel
  static const String userWatchingStart = 'user.watching.start';

  /// Event sent when a user stops watching a channel
  static const String userWatchingStop = 'user.watching.stop';

  /// Event sent when reading a message
  static const String messageRead = 'message.read';

  /// Event sent when a channel is deleted
  static const String channelDeleted = 'channel.deleted';

  /// Event sent when a channel is deleted
  static const String notificationChannelDeleted = 'notification.channel_deleted';

  /// Event sent when a channel is truncated
  static const String channelTruncated = 'channel.truncated';

  /// Event sent when a channel is truncated
  static const String notificationChannelTruncated = 'notification.channel_truncated';

  /// Event sent when the user is added to a channel
  static const String notificationAddedToChannel = 'notification.added_to_channel';

  /// Event sent when the user is removed from a channel
  static const String notificationRemovedFromChannel = 'notification.removed_from_channel';

  /// Event sent when a channel is updated
  static const String channelUpdated = 'channel.updated';

  /// Event sent when a user is updated
  static const String userUpdated = 'user.updated';

  /// Event sent when a member is added to a channel
  static const String memberAdded = 'member.added';

  /// Event sent when a member is removed from a channel
  static const String memberRemoved = 'member.removed';

  /// Event sent when a member is updated in a channel
  static const String memberUpdated = 'member.updated';

  /// Event sent when a member is removed to a channel
  static const String userBanned = 'user.banned';

  /// Event sent when a member is removed to a channel
  static const String userUnbanned = 'user.unbanned';

  /// Event sent when a channel is hidden
  static const String channelHidden = 'channel.hidden';

  /// Event sent when a channel is visible
  static const String channelVisible = 'channel.visible';

  /// Event sent when the connection status changes
  static const String connectionChanged = 'connection.changed';

  /// Event sent when the connection is recovered
  static const String connectionRecovered = 'connection.recovered';

  /// Event sent when the user is accepts an invite
  static const String notificationInviteAccepted = 'notification.invite_accepted';

  /// Event sent when the user is invited
  static const String notificationInvited = 'notification.invited';

  /// Event sent when the user's mutes list is updated
  static const String notificationMutesUpdated = 'notification.mutes_updated';

  /// Event sent when the AI indicator is updated
  static const String aiIndicatorUpdate = 'ai_indicator.update';

  /// Event sent when the AI indicator is stopped
  static const String aiIndicatorStop = 'ai_indicator.stop';

  /// Event sent when the AI indicator is cleared
  static const String aiIndicatorClear = 'ai_indicator.clear';

  /// Event sent when a new poll is created.
  static const String pollCreated = 'poll.created';

  /// Event sent when a poll is updated.
  static const String pollUpdated = 'poll.updated';

  /// Event sent when a answer is casted on a poll.
  static const String pollAnswerCasted = 'poll.answer_casted';

  /// Event sent when a vote is casted on a poll.
  static const String pollVoteCasted = 'poll.vote_casted';

  /// Event sent when a vote is changed on a poll.
  static const String pollVoteChanged = 'poll.vote_changed';

  /// Event sent when a vote is removed from a poll.
  static const String pollVoteRemoved = 'poll.vote_removed';

  /// Event sent when a answer is removed from a poll.
  static const String pollAnswerRemoved = 'poll.answer_removed';

  /// Event sent when a poll is closed.
  static const String pollClosed = 'poll.closed';

  /// Event sent when a poll is deleted.
  static const String pollDeleted = 'poll.deleted';

  /// Event sent when a thread is updated.
  static const String threadUpdated = 'thread.updated';

  /// Event sent when a new message is added to a thread.
  static const String notificationThreadMessageNew = 'notification.thread_message_new';

  /// Event sent when a draft message is either created or updated.
  static const String draftUpdated = 'draft.updated';

  /// Event sent when a draft message is deleted.
  static const String draftDeleted = 'draft.deleted';

  /// Event sent when a message reminder is created.
  static const String reminderCreated = 'reminder.created';

  /// Event sent when a message reminder is updated.
  static const String reminderUpdated = 'reminder.updated';

  /// Event sent when a message reminder is deleted.
  static const String reminderDeleted = 'reminder.deleted';

  /// Event sent when a message reminder is due.
  static const String notificationReminderDue = 'notification.reminder_due';

  /// Event sent when a new shared location is created.
  static const String locationShared = 'location.shared';

  /// Event sent when a live shared location is updated.
  static const String locationUpdated = 'location.updated';

  /// Event sent when a live shared location is expired.
  static const String locationExpired = 'location.expired';

  /// Local event sent when push notification preference is updated.
  static const String pushPreferenceUpdated = 'push_preference.updated';

  /// Local event sent when channel push notification preference is updated.
  static const String channelPushPreferenceUpdated = 'channel.push_preference.updated';

  /// Event sent when a message is marked as delivered.
  static const String messageDelivered = 'message.delivered';

  /// Event sent when all messages of a user are deleted.
  static const String userMessagesDeleted = 'user.messages.deleted';
}
