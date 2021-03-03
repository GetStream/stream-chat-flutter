import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/models/channel_config.dart';
import 'package:stream_chat/src/models/serialization.dart';
import 'package:stream_chat/src/models/user.dart';

part 'channel_model.g.dart';

/// The class that contains the information about a channel
@JsonSerializable()
class ChannelModel {
  /// Constructor used for json serialization
  ChannelModel({
    this.id,
    this.type,
    this.cid,
    this.config,
    this.createdBy,
    this.frozen,
    this.lastMessageAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.memberCount,
    this.extraData,
    this.team,
  });

  /// Create a new instance from a json
  factory ChannelModel.fromJson(Map<String, dynamic> json) =>
      _$ChannelModelFromJson(
          Serialization.moveToExtraDataFromRoot(json, topLevelFields));

  /// The id of this channel
  final String id;

  /// The type of this channel
  final String type;

  /// The cid of this channel
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final String cid;

  /// The channel configuration data
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final ChannelConfig config;

  /// The user that created this channel
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final User createdBy;

  /// True if this channel is frozen
  @JsonKey(includeIfNull: false)
  final bool frozen;

  /// The date of the last message
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime lastMessageAt;

  /// The date of channel creation
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime createdAt;

  /// The date of the last channel update
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime updatedAt;

  /// The date of channel deletion
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime deletedAt;

  /// The count of this channel members
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final int memberCount;

  /// Map of custom channel extraData
  @JsonKey(includeIfNull: false)
  final Map<String, dynamic> extraData;

  /// The team the channel belongs to
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final String team;

  /// Known top level fields.
  /// Useful for [Serialization] methods.
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
  ];

  /// Shortcut for channel name
  String get name =>
      extraData?.containsKey('name') == true ? extraData['name'] : cid;

  /// Serialize to json
  Map<String, dynamic> toJson() => Serialization.moveFromExtraDataToRoot(
        _$ChannelModelToJson(this),
        topLevelFields,
      );

  /// Creates a copy of [ChannelModel] with specified attributes overridden.
  ChannelModel copyWith({
    String id,
    String type,
    String cid,
    ChannelConfig config,
    User createdBy,
    bool frozen,
    DateTime lastMessageAt,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime deletedAt,
    int memberCount,
    Map<String, dynamic> extraData,
    String team,
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
      );

  /// Returns a new [ChannelModel] that is a combination of this channelModel
  /// and the given [other] channelModel.
  ChannelModel merge(ChannelModel other) {
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
    );
  }
}
