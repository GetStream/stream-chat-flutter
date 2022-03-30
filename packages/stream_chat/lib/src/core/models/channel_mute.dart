import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:stream_chat/src/core/models/user.dart';

part 'channel_mute.g.dart';

/// The class that contains the information about a muted user
@JsonSerializable(createToJson: false)
class ChannelMute {
  /// Constructor used for json serialization
  ChannelMute({
    required this.user,
    required this.channel,
    required this.createdAt,
    required this.updatedAt,
    this.expires,
  });

  /// Create a new instance from a json
  factory ChannelMute.fromJson(Map<String, dynamic> json) =>
      _$ChannelMuteFromJson(json);

  /// The user that performed the muting action
  final User user;

  /// The target user
  final ChannelModel channel;

  /// The date in which the use was muted
  final DateTime createdAt;

  /// The date of the last update
  final DateTime updatedAt;

  /// The date in which the mute expires
  final DateTime? expires;
}
