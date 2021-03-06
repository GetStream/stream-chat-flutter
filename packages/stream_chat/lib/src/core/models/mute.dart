import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:stream_chat/src/core/util/serializer.dart';

part 'mute.g.dart';

/// The class that contains the information about a muted user
@JsonSerializable(createToJson: false)
class Mute {
  /// Constructor used for json serialization
  Mute({
    required this.user,
    required this.channel,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a new instance from a json
  factory Mute.fromJson(Map<String, dynamic> json) => _$MuteFromJson(json);

  /// The user that performed the muting action
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final User user;

  /// The target user
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final ChannelModel channel;

  /// The date in which the use was muted
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final DateTime createdAt;

  /// The date of the last update
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final DateTime updatedAt;
}
