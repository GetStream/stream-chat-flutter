// ignore_for_file: avoid_redundant_argument_values

import 'package:stream_chat/stream_chat.dart';

/// Extension methods for checking channel capabilities on a Channel instance.
///
/// These methods provide a convenient way to check if the current user has
/// specific capabilities in a channel.
extension ChannelCapabilityCheck on Channel {
  /// True, if the current user can send a message to this channel.
  bool get canSendMessage {
    return ownCapabilities.contains(ChannelCapability.sendMessage);
  }

  /// True, if the current user can send a reply to this channel.
  bool get canSendReply {
    return ownCapabilities.contains(ChannelCapability.sendReply);
  }

  /// True, if the current user can send a message with restricted visibility.
  bool get canSendRestrictedVisibilityMessage {
    return ownCapabilities.contains(
      ChannelCapability.sendRestrictedVisibilityMessage,
    );
  }

  /// True, if the current user can send reactions.
  bool get canSendReaction {
    return ownCapabilities.contains(ChannelCapability.sendReaction);
  }

  /// True, if the current user can attach links to messages.
  bool get canSendLinks {
    return ownCapabilities.contains(ChannelCapability.sendLinks);
  }

  /// True, if the current user can attach files to messages.
  bool get canCreateAttachment {
    return ownCapabilities.contains(ChannelCapability.createAttachment);
  }

  /// True, if the current user can freeze or unfreeze channel.
  bool get canFreezeChannel {
    return ownCapabilities.contains(ChannelCapability.freezeChannel);
  }

  /// True, if the current user can enable or disable slow mode.
  bool get canSetChannelCooldown {
    return ownCapabilities.contains(ChannelCapability.setChannelCooldown);
  }

  /// True, if the current user can leave channel (remove own membership).
  bool get canLeaveChannel {
    return ownCapabilities.contains(ChannelCapability.leaveChannel);
  }

  /// True, if the current user can join channel (add own membership).
  bool get canJoinChannel {
    return ownCapabilities.contains(ChannelCapability.joinChannel);
  }

  /// True, if the current user can pin a message.
  bool get canPinMessage {
    return ownCapabilities.contains(ChannelCapability.pinMessage);
  }

  /// True, if the current user can delete any message from the channel.
  bool get canDeleteAnyMessage {
    return ownCapabilities.contains(ChannelCapability.deleteAnyMessage);
  }

  /// True, if the current user can delete own messages from the channel.
  bool get canDeleteOwnMessage {
    return ownCapabilities.contains(ChannelCapability.deleteOwnMessage);
  }

  /// True, if the current user can update any message in the channel.
  bool get canUpdateAnyMessage {
    return ownCapabilities.contains(ChannelCapability.updateAnyMessage);
  }

  /// True, if the current user can update own messages in the channel.
  bool get canUpdateOwnMessage {
    return ownCapabilities.contains(ChannelCapability.updateOwnMessage);
  }

  /// True, if the current user can use message search.
  bool get canSearchMessages {
    return ownCapabilities.contains(ChannelCapability.searchMessages);
  }

  /// True, if the current user can send typing events.
  @Deprecated('Use canUseTypingEvents instead')
  bool get canSendTypingEvents {
    if (canUseTypingEvents) return true;
    return ownCapabilities.contains(ChannelCapability.sendTypingEvents);
  }

  /// True, if the current user can upload message attachments.
  bool get canUploadFile {
    return ownCapabilities.contains(ChannelCapability.uploadFile);
  }

  /// True, if the current user can delete channel.
  bool get canDeleteChannel {
    return ownCapabilities.contains(ChannelCapability.deleteChannel);
  }

  /// True, if the current user can update channel data.
  bool get canUpdateChannel {
    return ownCapabilities.contains(ChannelCapability.updateChannel);
  }

  /// True, if the current user can update channel members.
  bool get canUpdateChannelMembers {
    return ownCapabilities.contains(ChannelCapability.updateChannelMembers);
  }

  /// True, if the current user can update thread data.
  bool get canUpdateThread {
    return ownCapabilities.contains(ChannelCapability.updateThread);
  }

  /// True, if the current user can quote a message.
  bool get canQuoteMessage {
    return ownCapabilities.contains(ChannelCapability.quoteMessage);
  }

  /// True, if the current user can ban channel members.
  bool get canBanChannelMembers {
    return ownCapabilities.contains(ChannelCapability.banChannelMembers);
  }

  /// True, if the current user can flag a message.
  bool get canFlagMessage {
    return ownCapabilities.contains(ChannelCapability.flagMessage);
  }

  /// True, if the current user can mute a channel.
  bool get canMuteChannel {
    return ownCapabilities.contains(ChannelCapability.muteChannel);
  }

  /// True, if the current user can send custom events.
  bool get canSendCustomEvents {
    return ownCapabilities.contains(ChannelCapability.sendCustomEvents);
  }

  /// True, if the current user has read events capability.
  @Deprecated('Use canUseReadReceipts instead')
  bool get canReceiveReadEvents => canUseReadReceipts;

  /// True, if the current user has read events capability.
  bool get canUseReadReceipts {
    return ownCapabilities.contains(ChannelCapability.readEvents);
  }

  /// True, if unread counts for this channel should be tracked locally,
  /// on-device, rather than relying on the server.
  ///
  /// This is the case when [StreamChatClient.isLocalUnreadCountEnabled] is
  /// enabled and the channel doesn't support read receipts (for example,
  /// livestream channel types that disable read events). Channels that
  /// support read receipts always rely on server-driven unread counts.
  bool get usesLocalUnreadCount {
    return client.isLocalUnreadCountEnabled && !canUseReadReceipts;
  }

  /// True, if the current user has connect events capability.
  bool get canReceiveConnectEvents {
    return ownCapabilities.contains(ChannelCapability.connectEvents);
  }

  /// True, if the current user can send and receive typing events.
  bool get canUseTypingEvents {
    return ownCapabilities.contains(ChannelCapability.typingEvents);
  }

  /// True, if channel slow mode is active.
  bool get isInSlowMode {
    return ownCapabilities.contains(ChannelCapability.slowMode);
  }

  /// True, if the current user is allowed to post messages as usual even if the
  /// channel is in slow mode.
  bool get canSkipSlowMode {
    return ownCapabilities.contains(ChannelCapability.skipSlowMode);
  }

  /// True, if the current user can create a poll.
  bool get canSendPoll {
    return ownCapabilities.contains(ChannelCapability.sendPoll);
  }

  /// True, if the current user can vote in a poll.
  bool get canCastPollVote {
    return ownCapabilities.contains(ChannelCapability.castPollVote);
  }

  /// True, if the current user can query poll votes.
  bool get canQueryPollVotes {
    return ownCapabilities.contains(ChannelCapability.queryPollVotes);
  }

  /// True, if the current user has delivery events capability.
  bool get canUseDeliveryReceipts {
    return ownCapabilities.contains(ChannelCapability.deliveryEvents);
  }

  /// True, if the current user can share location in the channel.
  bool get canShareLocation {
    return ownCapabilities.contains(ChannelCapability.shareLocation);
  }

  /// True, if the current user can send an "@channel" mention that notifies
  /// all channel members.
  bool get canNotifyChannel {
    return ownCapabilities.contains(ChannelCapability.notifyChannel);
  }

  /// True, if the current user can send an "@here" mention that notifies all
  /// online channel members.
  bool get canNotifyHere {
    return ownCapabilities.contains(ChannelCapability.notifyHere);
  }

  /// True, if the current user can mention one or more roles in a message.
  bool get canNotifyRole {
    return ownCapabilities.contains(ChannelCapability.notifyRole);
  }

  /// True, if the current user can mention one or more user groups in a
  /// message.
  bool get canNotifyGroup {
    return ownCapabilities.contains(ChannelCapability.notifyGroup);
  }
}
