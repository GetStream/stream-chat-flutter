import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/channel_config.dart';
import 'package:stream_chat/src/core/util/serializer.dart';
import 'package:stream_chat/src/core/models/user.dart';

part 'channel_model.g.dart';

/// The class that contains the information about a channel
@JsonSerializable()
class ChannelModel {
  /// Constructor used for json serialization
  ChannelModel({
    String? id,
    String? type,
    String? cid,
    ChannelConfig? config,
    this.createdBy,
    this.frozen = false,
    this.lastMessageAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.deletedAt,
    this.memberCount = 0,
    this.extraData = const {},
    this.team,
    this.cooldown = 0,
  })  : assert(
          (cid != null && cid.contains(':')) || (id != null && type != null),
          'provide either a cid or an id and type',
        ),
        id = id ?? cid!.split(':')[1],
        type = type ?? cid!.split(':')[0],
        cid = cid ?? '$type:$id',
        config = config ?? ChannelConfig(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Create a new instance from a json
  factory ChannelModel.fromJson(Map<String, dynamic> json) =>
      _$ChannelModelFromJson(
          Serializer.moveToExtraDataFromRoot(json, topLevelFields));

  /// The id of this channel
  final String id;

  /// The type of this channel
  final String type;

  /// The cid of this channel
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final String cid;

  /// The channel configuration data
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final ChannelConfig config;

  /// The user that created this channel
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final User? createdBy;

  /// True if this channel is frozen
  @JsonKey(includeIfNull: false, defaultValue: false)
  final bool frozen;

  /// The date of the last message
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final DateTime? lastMessageAt;

  /// The date of channel creation
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final DateTime createdAt;

  /// The date of the last channel update
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final DateTime updatedAt;

  /// The date of channel deletion
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final DateTime? deletedAt;

  /// The count of this channel members
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly, defaultValue: 0)
  final int memberCount;

  /// The number of seconds in a cooldown
  @JsonKey(includeIfNull: false, defaultValue: 0)
  final int cooldown;

  /// Map of custom channel extraData
  @JsonKey(
    includeIfNull: false,
    defaultValue: {},
  )
  final Map<String, Object?> extraData;

  /// The team the channel belongs to
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final String? team;

  /// Known top level fields.
  /// Useful for [Serializer] methods.
  static const topLevelFields = [
    'id',
    'type',
    'cid',
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
  }) =>
      ChannelModel(
        id: id ?? this.id,
        type: type ?? this.type,
        cid: cid ?? this.cid,
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
      );

  /// Returns a new [ChannelModel] that is a combination of this channelModel
  /// and the given [other] channelModel.
  ChannelModel merge(ChannelModel? other) {
    if (other == null) return this;
    return copyWith(
      id: other.id,
      type: other.type,
      cid: other.cid,
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
    );
  }
}
