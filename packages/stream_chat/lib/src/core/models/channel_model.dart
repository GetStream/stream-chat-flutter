import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/channel_config.dart';
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
    this.ownCapabilities,
    ChannelConfig? config,
    this.createdBy,
    this.frozen = false,
    this.lastMessageAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.deletedAt,
    this.memberCount = 0,
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

  /// List of user permissions on this channel
  @JsonKey(includeToJson: false)
  final List<String>? ownCapabilities;

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

  /// The date of the last channel update
  @JsonKey(includeToJson: false)
  final DateTime updatedAt;

  /// The date of channel deletion
  @JsonKey(includeToJson: false)
  final DateTime? deletedAt;

  /// The count of this channel members
  @JsonKey(includeToJson: false)
  final int memberCount;

  /// The number of seconds in a cooldown
  @JsonKey(includeIfNull: false)
  final int cooldown;

  /// True if the channel is disabled
  @JsonKey(includeToJson: false, includeFromJson: false)
  bool? get disabled => extraData['disabled'] as bool?;

  /// True if the channel is hidden
  @JsonKey(includeToJson: false, includeFromJson: false)
  bool? get hidden => extraData['hidden'] as bool?;

  /// The date of the last time channel got truncated
  @JsonKey(includeToJson: false, includeFromJson: false)
  DateTime? get truncatedAt {
    final truncatedAt = extraData['truncated_at'] as String?;
    if (truncatedAt == null) return null;
    return DateTime.parse(truncatedAt);
  }

  /// Map of custom channel extraData
  @JsonKey(includeIfNull: false)
  final Map<String, Object?> extraData;

  /// The team the channel belongs to
  @JsonKey(includeToJson: false)
  final String? team;

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
    'team',
    'cooldown',
  ];

  /// Shortcut for channel name
  String get name =>
      extraData.containsKey('name') ? extraData['name']! as String : cid;

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
      extraData: other.extraData,
      team: other.team,
      cooldown: other.cooldown,
      disabled: other.disabled,
      hidden: other.hidden,
      truncatedAt: other.truncatedAt,
    );
  }
}
