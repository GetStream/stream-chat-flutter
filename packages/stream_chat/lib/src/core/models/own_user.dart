import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/channel_mute.dart';
import 'package:stream_chat/src/core/util/serializer.dart';
import 'package:stream_chat/stream_chat.dart';

part 'own_user.g.dart';

/// The class that defines the own user model.
///
/// This object can be found in [Event].
@JsonSerializable(createToJson: false)
class OwnUser extends User {
  /// Constructor used for json serialization.
  OwnUser({
    this.devices = const [],
    this.mutes = const [],
    this.totalUnreadCount = 0,
    this.unreadChannels = 0,
    this.channelMutes = const [],
    required super.id,
    super.role,
    super.name,
    super.image,
    super.createdAt,
    super.updatedAt,
    super.lastActive,
    super.online,
    super.extraData,
    super.banned,
    super.banExpires,
    super.teams,
    super.language,
  });

  /// Create a new instance from json.
  factory OwnUser.fromJson(Map<String, dynamic> json) => _$OwnUserFromJson(
        Serializer.moveToExtraDataFromRoot(json, topLevelFields),
      );

  /// Create a new instance from [User] object.
  factory OwnUser.fromUser(User user) => OwnUser(
        id: user.id,
        role: user.role,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
        lastActive: user.lastActive,
        online: user.online,
        banned: user.banned,
        extraData: user.extraData,
        teams: user.teams,
        language: user.language,
      );

  /// Creates a copy of [OwnUser] with specified attributes overridden.
  @override
  OwnUser copyWith({
    String? id,
    String? role,
    String? name,
    String? image,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastActive,
    bool? online,
    Map<String, Object?>? extraData,
    bool? banned,
    DateTime? banExpires,
    List<String>? teams,
    List<ChannelMute>? channelMutes,
    List<Device>? devices,
    List<Mute>? mutes,
    int? totalUnreadCount,
    int? unreadChannels,
    String? language,
  }) =>
      OwnUser(
        id: id ?? this.id,
        role: role ?? this.role,
        // if null, it will be retrieved from extraData['name']
        name: name,
        // if null, it will be retrieved from extraData['image']
        image: image,
        banned: banned ?? this.banned,
        banExpires: banExpires ?? this.banExpires,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        lastActive: lastActive ?? this.lastActive,
        online: online ?? this.online,
        extraData: extraData ?? this.extraData,
        teams: teams ?? this.teams,
        channelMutes: channelMutes ?? this.channelMutes,
        devices: devices ?? this.devices,
        mutes: mutes ?? this.mutes,
        totalUnreadCount: totalUnreadCount ?? this.totalUnreadCount,
        unreadChannels: unreadChannels ?? this.unreadChannels,
        language: language ?? this.language,
      );

  /// Returns a new [OwnUser] that is a combination of this ownUser
  /// and the given [other] ownUser.
  OwnUser merge(OwnUser? other) {
    if (other == null) return this;
    return copyWith(
      id: other.id,
      role: other.role,
      banned: other.banned,
      channelMutes: other.channelMutes,
      createdAt: other.createdAt,
      devices: other.devices,
      extraData: other.extraData,
      lastActive: other.lastActive,
      mutes: other.mutes,
      online: other.online,
      teams: other.teams,
      totalUnreadCount: other.totalUnreadCount,
      unreadChannels: other.unreadChannels,
      updatedAt: other.updatedAt,
      language: other.language,
    );
  }

  /// List of user devices.
  @JsonKey(includeIfNull: false)
  final List<Device> devices;

  /// List of users muted by the user.
  @JsonKey(includeIfNull: false)
  final List<Mute> mutes;

  /// List of channels muted by the user.
  @JsonKey(includeIfNull: false)
  final List<ChannelMute> channelMutes;

  /// Total unread messages by the user.
  @JsonKey(includeIfNull: false)
  final int totalUnreadCount;

  /// Total unread channels by the user.
  @JsonKey(includeIfNull: false)
  final int unreadChannels;

  /// Known top level fields.
  ///
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
