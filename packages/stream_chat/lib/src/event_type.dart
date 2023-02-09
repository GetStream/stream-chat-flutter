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
  static const String notificationChannelDeleted =
      'notification.channel_deleted';

  /// Event sent when a channel is truncated
  static const String channelTruncated = 'channel.truncated';

  /// Event sent when a channel is truncated
  static const String notificationChannelTruncated =
      'notification.channel_truncated';

  /// Event sent when the user is added to a channel
  static const String notificationAddedToChannel =
      'notification.added_to_channel';

  /// Event sent when the user is removed to a channel
  static const String notificationRemovedFromChannel =
      'notification.removed_from_channel';

  /// Event sent when a channel is updated
  static const String channelUpdated = 'channel.updated';

  /// Event sent when a user is updated
  static const String userUpdated = 'user.updated';

  /// Event sent when a member is added to a channel
  static const String memberAdded = 'member.added';

  /// Event sent when a member is removed to a channel
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
  static const String notificationInviteAccepted =
      'notification.invite_accepted';

  /// Event sent when the user is invited
  static const String notificationInvited = 'notification.invited';

  /// Event sent when the user's mutes list is updated
  static const String notificationMutesUpdated = 'notification.mutes_updated';
}
