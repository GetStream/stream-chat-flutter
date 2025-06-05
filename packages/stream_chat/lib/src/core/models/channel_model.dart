import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/channel_config.dart';
import 'package:stream_chat/src/core/models/member.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:stream_chat/src/core/util/serializer.dart';

part 'channel_model.g.dart';

/// The class that contains the information about a channel
@JsonSerializable()
class ChannelModel {
  /// Constructor used for json serialization
  ChannelModel({
    String? id,
    String? type,
    String? cid,
    List<String>? ownCapabilities,
    ChannelConfig? config,
    this.createdBy,
    this.frozen = false,
    this.lastMessageAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.deletedAt,
    this.memberCount = 0,
    this.members,
    Map<String, Object?> extraData = const {},
    this.team,
    this.cooldown = 0,
    bool? disabled,
    bool? hidden,
    DateTime? truncatedAt,
  })  : assert(
          (cid != null && cid.contains(':')) || (id != null && type != null),
          'provide either a cid or an id and type',
        ),
        id = id ?? cid!.split(':')[1],
        type = type ?? cid!.split(':')[0],
        cid = cid ?? '$type:$id',
        config = config ?? ChannelConfig(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        ownCapabilities = ownCapabilities?.map(ChannelCapability.new).toList(),

        // For backwards compatibility, set 'disabled', 'hidden'
        // and 'truncated_at' in [extraData].
        extraData = {
          ...extraData,
          if (disabled != null) 'disabled': disabled,
          if (hidden != null) 'hidden': hidden,
          if (truncatedAt != null)
            'truncated_at': truncatedAt.toIso8601String(),
        };

  /// Create a new instance from a json
  factory ChannelModel.fromJson(Map<String, dynamic> json) =>
      _$ChannelModelFromJson(
        Serializer.moveToExtraDataFromRoot(json, topLevelFields),
      );

  /// The id of this channel
  final String id;

  /// The type of this channel
  final String type;

  /// The cid of this channel
  @JsonKey(includeToJson: false)
  final String cid;

  /// List of various capabilities that a user can have in a channel.
  @JsonKey(includeToJson: false)
  final List<ChannelCapability>? ownCapabilities;

  /// The channel configuration data
  @JsonKey(includeToJson: false)
  final ChannelConfig config;

  /// The user that created this channel
  @JsonKey(includeToJson: false)
  final User? createdBy;

  /// True if this channel is frozen
  @JsonKey(includeIfNull: false)
  final bool frozen;

  /// The date of the last message
  @JsonKey(includeToJson: false)
  final DateTime? lastMessageAt;

  /// The date of channel creation
  @JsonKey(includeToJson: false)
  final DateTime createdAt;

  /// The date at which the channel was last updated.
  @JsonKey(includeToJson: false, includeFromJson: false)
  DateTime? get lastUpdatedAt => lastMessageAt ?? createdAt;

  /// The date of the last channel update
  @JsonKey(includeToJson: false)
  final DateTime updatedAt;

  /// The date of channel deletion
  @JsonKey(includeToJson: false)
  final DateTime? deletedAt;

  /// The count of this channel members
  @JsonKey(includeToJson: false)
  final int memberCount;

  /// The list of this channel members
  @JsonKey(includeToJson: false)
  final List<Member>? members;

  /// The number of seconds in a cooldown
  @JsonKey(includeIfNull: false)
  final int cooldown;

  /// True if the channel is disabled
  @JsonKey(includeToJson: false, includeFromJson: false)
  bool? get disabled {
    final disabled = extraData['disabled'];
    if (disabled is bool) return disabled;

    return null;
  }

  /// True if the channel is hidden
  @JsonKey(includeToJson: false, includeFromJson: false)
  bool? get hidden {
    final hidden = extraData['hidden'];
    if (hidden is bool) return hidden;

    return null;
  }

  /// The date of the last time channel got truncated
  @JsonKey(includeToJson: false, includeFromJson: false)
  DateTime? get truncatedAt {
    final truncatedAt = extraData['truncated_at'];
    if (truncatedAt is String && truncatedAt.isNotEmpty) {
      return DateTime.parse(truncatedAt);
    }

    return null;
  }

  /// Map of custom channel extraData
  final Map<String, Object?> extraData;

  /// The team the channel belongs to
  @JsonKey(includeToJson: false)
  final String? team;

  /// Shortcut for channel name
  String? get name {
    final name = extraData['name'];
    if (name is String && name.isNotEmpty) return name;

    return null;
  }

  /// Known top level fields.
  /// Useful for [Serializer] methods.
  static const topLevelFields = [
    'id',
    'type',
    'cid',
    'own_capabilities',
    'config',
    'created_by',
    'frozen',
    'last_message_at',
    'created_at',
    'updated_at',
    'deleted_at',
    'member_count',
    'members',
    'team',
    'cooldown',
  ];

  /// Serialize to json
  Map<String, dynamic> toJson() => Serializer.moveFromExtraDataToRoot(
        _$ChannelModelToJson(this),
      );

  /// Creates a copy of [ChannelModel] with specified attributes overridden.
  ChannelModel copyWith({
    String? id,
    String? type,
    String? cid,
    List<String>? ownCapabilities,
    ChannelConfig? config,
    User? createdBy,
    bool? frozen,
    DateTime? lastMessageAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    int? memberCount,
    List<Member>? members,
    Map<String, Object?>? extraData,
    String? team,
    int? cooldown,
    bool? disabled,
    bool? hidden,
    DateTime? truncatedAt,
  }) =>
      ChannelModel(
        id: id ?? this.id,
        type: type ?? this.type,
        cid: cid ?? this.cid,
        ownCapabilities: ownCapabilities ?? this.ownCapabilities,
        config: config ?? this.config,
        createdBy: createdBy ?? this.createdBy,
        frozen: frozen ?? this.frozen,
        lastMessageAt: lastMessageAt ?? this.lastMessageAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        deletedAt: deletedAt ?? this.deletedAt,
        memberCount: memberCount ?? this.memberCount,
        members: members ?? this.members,
        extraData: extraData ?? this.extraData,
        team: team ?? this.team,
        cooldown: cooldown ?? this.cooldown,
        disabled: disabled ?? extraData?['disabled'] as bool? ?? this.disabled,
        hidden: hidden ?? extraData?['hidden'] as bool? ?? this.hidden,
        truncatedAt: truncatedAt ??
            (extraData?['truncated_at'] == null
                ? null
                // ignore: cast_nullable_to_non_nullable
                : DateTime.parse(extraData?['truncated_at'] as String)) ??
            this.truncatedAt,
      );

  /// Returns a new [ChannelModel] that is a combination of this channelModel
  /// and the given [other] channelModel.
  ChannelModel merge(ChannelModel? other) {
    if (other == null) return this;
    return copyWith(
      id: other.id,
      type: other.type,
      cid: other.cid,
      ownCapabilities: other.ownCapabilities,
      config: other.config,
      createdBy: other.createdBy,
      frozen: other.frozen,
      lastMessageAt: other.lastMessageAt,
      createdAt: other.createdAt,
      updatedAt: other.updatedAt,
      deletedAt: other.deletedAt,
      memberCount: other.memberCount,
      members: other.members,
      extraData: other.extraData,
      team: other.team,
      cooldown: other.cooldown,
      disabled: other.disabled,
      hidden: other.hidden,
      truncatedAt: other.truncatedAt,
    );
  }
}

/// {@template channelCapability}
/// Represents various capabilities that a user can have in a channel.
/// {@endtemplate}
extension type const ChannelCapability(String capability) implements String {
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
}
