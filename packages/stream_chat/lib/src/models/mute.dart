import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/models/channel_model.dart';
import 'package:stream_chat/src/models/serialization.dart';
import 'package:stream_chat/src/models/user.dart';

part 'mute.g.dart';

/// The class that contains the information about a muted user
@JsonSerializable()
class Mute {
  /// Constructor used for json serialization
  Mute({this.user, this.channel, this.createdAt, this.updatedAt});

  /// Create a new instance from a json
  factory Mute.fromJson(Map<String, dynamic> json) => _$MuteFromJson(json);

  /// The user that performed the muting action
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final User? user;

  /// The target user
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final ChannelModel? channel;

  /// The date in which the use was muted
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime? createdAt;

  /// The date of the last update
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime? updatedAt;

  /// Serialize to json
  Map<String, dynamic> toJson() => _$MuteToJson(this);
}
