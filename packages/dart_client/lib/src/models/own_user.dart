import 'package:json_annotation/json_annotation.dart';

import 'device.dart';
import 'mute.dart';
import 'serialization.dart';
import 'user.dart';

part 'own_user.g.dart';

/// The class that defines the own user model
/// This object can be found in [Event]
@JsonSerializable()
class OwnUser extends User {
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
  factory OwnUser.fromJson(Map<String, dynamic> json) {
    return _$OwnUserFromJson(
        Serialization.moveToExtraDataFromRoot(json, topLevelFields));
  }

  /// Serialize to json
  @override
  Map<String, dynamic> toJson() {
    return Serialization.moveFromExtraDataToRoot(
        _$OwnUserToJson(this), topLevelFields);
  }
}
