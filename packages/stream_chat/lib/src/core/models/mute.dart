import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/user.dart';

part 'mute.g.dart';

/// The class that contains the information about a muted user
@JsonSerializable(createToJson: false)
class Mute {
  /// Constructor used for json serialization
  Mute({
    required this.user,
    required this.target,
    required this.createdAt,
    required this.updatedAt,
    this.expires,
  });

  /// Create a new instance from a json
  factory Mute.fromJson(Map<String, dynamic> json) => _$MuteFromJson(json);

  /// The user that performed the muting action
  final User user;

  /// The target user
  final User target;

  /// The date in which the use was muted
  final DateTime createdAt;

  /// The date of the last update
  final DateTime updatedAt;

  /// The date in which the mute expires
  final DateTime? expires;
}
