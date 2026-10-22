import 'package:freezed_annotation/freezed_annotation.dart';

import '../util/extension.dart';
import 'channel_config.dart';
import 'member.dart';
import 'user.dart';

part 'channel_model.freezed.dart';

/// The class that contains the information about a channel
@freezed
class ChannelModel with _$ChannelModel {
  /// Creates a channel model.
  ChannelModel({
    String? id,
    String? type,
    String? cid,
    this.ownCapabilities,
    ChannelConfig? config,
    this.createdBy,
    this.frozen = false,
    this.lastMessageAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.deletedAt,
    this.memberCount = 0,
    this.members,
    Map<String, Object?> custom = const {},
    this.team,
    this.cooldown = 0,
    this.disabled,
    this.hidden,
    this.muted,
    this.blocked,
    this.truncatedAt,
    this.messageCount,
    this.filterTags,
    this.truncatedBy,
    this.autoTranslationEnabled,
    this.autoTranslationLanguage,
  }) : assert(
         (cid != null && cid.contains(':')) || (id != null && type != null),
         'provide either a cid or an id and type',
       ),
       id = id ?? cid!.split(':')[1],
       type = type ?? cid!.split(':')[0],
       cid = cid ?? '$type:$id',
       config = config ?? ChannelConfig(),
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now(),
       custom = {...custom};

  /// The id of this channel
  @override
  final String id;

  /// The type of this channel
  @override
  final String type;

  /// The cid of this channel
  @override
  final String cid;

  /// List of various capabilities that a user can have in a channel.
  @override
  final List<ChannelCapability>? ownCapabilities;

  /// The channel configuration data
  @override
  final ChannelConfig config;

  /// The user that created this channel
  @override
  final User? createdBy;

  /// True if this channel is frozen
  @override
  final bool frozen;

  /// The date of the last message
  @override
  final DateTime? lastMessageAt;

  /// The date of channel creation
  @override
  final DateTime createdAt;

  /// The date at which the channel was last updated.
  ///
  /// Resolves to whichever of [lastMessageAt] and [createdAt] is more recent.
  /// Truncating a channel leaves [lastMessageAt] set to a value older than
  /// [createdAt] rather than clearing it, so taking the later of the two keeps
  /// the channel in place under a `last_updated` sort.
  DateTime get lastUpdatedAt {
    if (lastMessageAt case final lastMessageAt? when lastMessageAt.isAfter(createdAt)) {
      return lastMessageAt;
    }
    return createdAt;
  }

  /// The date of the last channel update
  @override
  final DateTime updatedAt;

  /// The date of channel deletion
  @override
  final DateTime? deletedAt;

  /// The count of this channel members
  @override
  final int memberCount;

  /// The list of this channel members
  @override
  final List<Member>? members;

  /// The number of seconds in a cooldown
  @override
  final int cooldown;

  /// Whether this channel is disabled.
  ///
  /// Loading a disabled channel fails, and channel queries leave it out for
  /// users who lack the permission to see it.
  @override
  final bool? disabled;

  /// Whether this channel is hidden for the current user.
  @override
  final bool? hidden;

  /// Whether this channel is muted for the current user.
  @override
  final bool? muted;

  /// Whether this channel is blocked by the current user.
  @override
  final bool? blocked;

  /// The date this channel was last truncated.
  @override
  final DateTime? truncatedAt;

  /// The user that last truncated this channel.
  @override
  final User? truncatedBy;

  /// Whether messages in this channel are translated automatically.
  @override
  final bool? autoTranslationEnabled;

  /// The language this channel's messages are translated into automatically.
  ///
  /// It can name several languages, separated by commas.
  @override
  final String? autoTranslationLanguage;

  /// This channel's custom data.
  @override
  final Map<String, Object?> custom;

  /// The team the channel belongs to
  @override
  final String? team;

  /// Shortcut for channel name
  String? get name {
    final name = custom['name'].safeCast<String>();
    if (name != null && name.isNotEmpty) return name;

    return null;
  }

  /// The total number of messages in the channel.
  ///
  /// Note: This field is only populated if the `count_messages` option is
  /// enabled for your app.
  @override
  final int? messageCount;

  /// List of filter tags applied to the channel.
  ///
  /// This is generally used for querying filtered channels based on tags.
  @override
  final List<String>? filterTags;

  /// A copy of this channel updated with the fields [other] carries.
  ///
  /// A nullable field [other] leaves out keeps its value here, except the
  /// auto-translation settings: when [other] leaves them out, auto translation
  /// is off.
  ///
  /// Every other field, [custom] included, takes the value of [other].
  ChannelModel merge(ChannelModel? other) {
    if (other == null) return this;
    return ChannelModel(
      id: other.id,
      type: other.type,
      cid: other.cid,
      ownCapabilities: other.ownCapabilities ?? ownCapabilities,
      config: other.config,
      createdBy: other.createdBy ?? createdBy,
      frozen: other.frozen,
      lastMessageAt: other.lastMessageAt ?? lastMessageAt,
      createdAt: other.createdAt,
      updatedAt: other.updatedAt,
      deletedAt: other.deletedAt ?? deletedAt,
      memberCount: other.memberCount,
      members: other.members ?? members,
      custom: other.custom,
      team: other.team ?? team,
      cooldown: other.cooldown,
      disabled: other.disabled ?? disabled,
      hidden: other.hidden ?? hidden,
      muted: other.muted ?? muted,
      blocked: other.blocked ?? blocked,
      truncatedAt: other.truncatedAt ?? truncatedAt,
      messageCount: other.messageCount ?? messageCount,
      filterTags: other.filterTags ?? filterTags,
      truncatedBy: other.truncatedBy ?? truncatedBy,
      autoTranslationEnabled: other.autoTranslationEnabled ?? false,
      autoTranslationLanguage: other.autoTranslationLanguage,
    );
  }
}

/// {@template channelCapability}
/// Represents various capabilities that a user can have in a channel.
/// {@endtemplate}
extension type const ChannelCapability(String _) implements String {
  /// Ability to send a message.
  static const sendMessage = ChannelCapability('send-message');

  /// Ability to reply to a message.
  static const sendReply = ChannelCapability('send-reply');

  /// Ability to send a message with restricted visibility.
  static const sendRestrictedVisibilityMessage = ChannelCapability(
    'send-restricted-visibility-message',
  );

  /// Ability to send reactions.
  static const sendReaction = ChannelCapability('send-reaction');

  /// Ability to attach links to messages.
  static const sendLinks = ChannelCapability('send-links');

  /// Ability to attach files to messages.
  static const createAttachment = ChannelCapability('create-attachment');

  /// Ability to freeze or unfreeze channel.
  static const freezeChannel = ChannelCapability('freeze-channel');

  /// Ability to enable or disable slow mode.
  static const setChannelCooldown = ChannelCapability('set-channel-cooldown');

  /// Ability to leave channel (remove own membership).
  static const leaveChannel = ChannelCapability('leave-channel');

  /// Ability to join channel (add own membership).
  static const joinChannel = ChannelCapability('join-channel');

  /// Ability to pin a message.
  static const pinMessage = ChannelCapability('pin-message');

  /// Ability to delete any message from the channel.
  static const deleteAnyMessage = ChannelCapability('delete-any-message');

  /// Ability to delete own messages from the channel.
  static const deleteOwnMessage = ChannelCapability('delete-own-message');

  /// Ability to update any message in the channel.
  static const updateAnyMessage = ChannelCapability('update-any-message');

  /// Ability to update own messages in the channel.
  static const updateOwnMessage = ChannelCapability('update-own-message');

  /// Ability to use message search.
  static const searchMessages = ChannelCapability('search-messages');

  /// Ability to send typing events.
  @Deprecated('Use typingEvents instead')
  static const sendTypingEvents = ChannelCapability('send-typing-events');

  /// Ability to upload message attachments.
  static const uploadFile = ChannelCapability('upload-file');

  /// Ability to delete channel.
  static const deleteChannel = ChannelCapability('delete-channel');

  /// Ability to update channel data.
  static const updateChannel = ChannelCapability('update-channel');

  /// Ability to update channel members.
  static const updateChannelMembers = ChannelCapability(
    'update-channel-members',
  );

  /// Ability to update thread data.
  static const updateThread = ChannelCapability('update-thread');

  /// Ability to quote a message.
  static const quoteMessage = ChannelCapability('quote-message');

  /// Ability to ban channel members.
  static const banChannelMembers = ChannelCapability('ban-channel-members');

  /// Ability to flag a message.
  static const flagMessage = ChannelCapability('flag-message');

  /// Ability to mute a channel.
  static const muteChannel = ChannelCapability('mute-channel');

  /// Ability to send custom events.
  static const sendCustomEvents = ChannelCapability('send-custom-events');

  /// Ability to receive read events.
  static const readEvents = ChannelCapability('read-events');

  /// Ability to receive delivery events.
  static const deliveryEvents = ChannelCapability('delivery-events');

  /// Ability to receive connect events.
  static const connectEvents = ChannelCapability('connect-events');

  /// Ability to send and receive typing events.
  static const typingEvents = ChannelCapability('typing-events');

  /// Indicates that channel slow mode is active.
  static const slowMode = ChannelCapability('slow-mode');

  /// Indicates that the user is allowed to post messages as usual even if the
  /// channel is in slow mode.
  static const skipSlowMode = ChannelCapability('skip-slow-mode');

  /// Ability to update a poll.
  static const sendPoll = ChannelCapability('send-poll');

  /// Ability to update a poll.
  static const castPollVote = ChannelCapability('cast-poll-vote');

  /// Ability to query poll votes.
  static const queryPollVotes = ChannelCapability('query-poll-votes');

  /// Ability to share location.
  static const shareLocation = ChannelCapability('share-location');

  /// Ability to send an "@channel" mention that notifies all channel members.
  static const notifyChannel = ChannelCapability('notify-channel');

  /// Ability to send an "@here" mention that notifies all online channel
  /// members.
  static const notifyHere = ChannelCapability('notify-here');

  /// Ability to mention one or more roles in a message.
  static const notifyRole = ChannelCapability('notify-role');

  /// Ability to mention one or more user groups in a message.
  static const notifyGroup = ChannelCapability('notify-group');
}
