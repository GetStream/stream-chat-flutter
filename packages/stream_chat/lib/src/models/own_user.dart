import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/models/device.dart';
import 'package:stream_chat/src/models/mute.dart';
import 'package:stream_chat/src/models/serialization.dart';
import 'package:stream_chat/src/models/user.dart';

part 'own_user.g.dart';

/// The class that defines the own user model
/// This object can be found in [Event]
@JsonSerializable()
class OwnUser extends User {
  /// Constructor used for json serialization
  OwnUser({
    this.devices,
    this.mutes,
    this.totalUnreadCount,
    this.unreadChannels,
    this.channelMutes,
    String id,
    String role,
    DateTime createdAt,
    DateTime updatedAt,
    DateTime lastActive,
    bool online,
    Map<String, dynamic> extraData,
    bool banned,
  }) : super(
          id: id,
          role: role,
          createdAt: createdAt,
          updatedAt: updatedAt,
          lastActive: lastActive,
          online: online,
          extraData: extraData,
          banned: banned,
        );

  /// Create a new instance from a json
  factory OwnUser.fromJson(Map<String, dynamic> json) => _$OwnUserFromJson(
      Serialization.moveToExtraDataFromRoot(json, topLevelFields));

  /// List of user devices
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final List<Device> devices;

  /// List of users muted by the user
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final List<Mute> mutes;

  /// List of users muted by the user
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final List<Mute> channelMutes;

  /// Total unread messages by the user
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final int totalUnreadCount;

  /// Total unread channels by the user
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final int unreadChannels;

  /// Known top level fields.
  /// Useful for [Serialization] methods.
  static final topLevelFields = [
    'devices',
    'mutes',
    'total_unread_count',
    'unread_channels',
    'channel_mutes',
    ...User.topLevelFields,
  ];

  /// Serialize to json
  @override
  Map<String, dynamic> toJson() => Serialization.moveFromExtraDataToRoot(
      _$OwnUserToJson(this), topLevelFields);
}
