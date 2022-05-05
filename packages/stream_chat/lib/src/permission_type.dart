/// Describes capabilities of a user vis-a-vis a channel
class PermissionType {
  /// Capability required to send a message in the channel
  /// Channel is not frozen (or user has UseFrozenChannel permission)
  /// and user has CreateMessage permission.
  static const String sendMessage = 'send-message';

  /// Capability required to receive connect events in the channel
  static const String connectEvents = 'connect-events';

  /// Capability required to send a message
  /// Reactions are enabled for the channel, channel is not frozen
  /// (or user has UseFrozenChannel permission) and user has
  /// CreateReaction permission
  static const String sendReaction = 'send-reaction';

  /// Capability required to send links in a channel
  /// send-message + user has AddLinks permission
  static const String sendLinks = 'send-links';

  /// Capability required to send thread reply
  /// send-message + channel has replies enabled
  static const String sendReply = 'send-reply';

  /// Capability to freeze a channel
  /// User has UpdateChannelFrozen permission.
  /// The name implies freezing,
  /// but unfreezing is also allowed when this capability is present
  static const String freezeChannel = 'freeze-channel';

  /// User has UpdateChannelCooldown permission.
  /// Allows to enable/disable slow mode in the channel
  static const String setChannelCooldown = 'set-channel-cooldown';

  /// User has RemoveOwnChannelMembership or UpdateChannelMembers permission
  static const String leaveChannel = 'leave-channel';

  /// User can mute channel
  static const String muteChannel = 'mute-channel';

  /// Ability to receive read events
  static const String readEvents = 'read-events';

  /// Capability required to pin a message in a channel
  /// Corresponds to PinMessage permission
  static const String pinMessage = 'pin-message';

  /// Capability required to quote a message in a channel
  static const String quoteMessage = 'quote-message';

  /// Capability required to flag a message in a channel
  static const String flagMessage = 'flag-message';

  /// User has ability to delete any message in the channel
  /// User has DeleteMessage permission
  /// which applies to any message in the channel
  static const String deleteAnyMessage = 'delete-any-message';

  /// User has ability to delete their own message in the channel
  /// User has DeleteMessage permission which applies only to owned messages
  static const String deleteOwnMessage = 'delete-own-message';

  /// User has ability to update/edit any message in the channel
  /// User has UpdateMessage permission which
  /// applies to any message in the channel
  static const String updateAnyMessage = 'update-any-message';

  /// User has ability to update/edit their own message in the channel
  /// User has UpdateMessage permission which applies only to owned messages
  static const String updateOwnMessage = 'update-own-message';

  /// User can search for message in a channel
  /// Search feature is enabled (it will also have
  /// permission check in the future)
  static const String searchMessages = 'search-messages';

  /// Capability required to send typing events in a channel
  /// (Typing events are enabled)
  static const String sendTypingEvents = 'send-typing-events';

  /// Capability required to upload a file in a channel
  /// Uploads are enabled and user has UploadAttachment
  static const String uploadFile = 'upload-file';

  /// Capability required to delete channel
  /// User has DeleteChannel permission
  static const String deleteChannel = 'delete-channel';

  /// Capability required update/edit channel info
  /// User has UpdateChannel permission
  static const String updateChannel = 'update-channel';

  /// Capability required to update/edit channel members
  /// Channel is not distinct and user has UpdateChannelMembers permission
  static const String updateChannelMembers = 'update-channel-members';
}
