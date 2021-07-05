import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/device.dart';
import 'package:stream_chat/src/core/models/mute.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:stream_chat/src/core/util/serializer.dart';

part 'own_user.g.dart';

/// The class that defines the own user model
/// This object can be found in [Event]
@JsonSerializable(createToJson: false)
class OwnUser extends User {
  /// Constructor used for json serialization
  OwnUser({
    this.devices = const [],
    this.mutes = const [],
    this.totalUnreadCount = 0,
    this.unreadChannels,
    this.channelMutes = const [],
    required String id,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastActive,
    bool online = false,
    Map<String, Object?> extraData = const {},
    bool banned = false,
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
      Serializer.moveToExtraDataFromRoot(json, topLevelFields));

  /// Create a new instance from [User] object
  factory OwnUser.fromUser(User user) => OwnUser(
        id: user.id,
        role: user.role,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
        lastActive: user.lastActive,
        online: user.online,
        banned: user.banned,
        extraData: user.extraData,
      );

  /// List of user devices
  @JsonKey(includeIfNull: false, defaultValue: <Device>[])
  final List<Device> devices;

  /// List of users muted by the user
  @JsonKey(includeIfNull: false, defaultValue: <Mute>[])
  final List<Mute> mutes;

  /// List of users muted by the user
  @JsonKey(includeIfNull: false, defaultValue: <Mute>[])
  final List<Mute> channelMutes;

  /// Total unread messages by the user
  @JsonKey(includeIfNull: false, defaultValue: 0)
  final int totalUnreadCount;

  /// Total unread channels by the user
  @JsonKey(includeIfNull: false)
  final int? unreadChannels;

  /// Known top level fields.
  /// Useful for [Serializer] methods.
  static final topLevelFields = [
    'devices',
    'mutes',
    'total_unread_count',
    'unread_channels',
    'channel_mutes',
    ...User.topLevelFields,
  ];
}
