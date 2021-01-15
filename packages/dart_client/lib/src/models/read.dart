import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'read.g.dart';

/// The class that defines a read event
@JsonSerializable()
class Read {
  /// Date of the read event
  final DateTime lastRead;

  /// User who sent the event
  final User user;

  /// Number of unread messages
  final int unreadMessages;

  /// Constructor used for json serialization
  Read({
    this.lastRead,
    this.user,
    this.unreadMessages,
  });

  /// Create a new instance from a json
  factory Read.fromJson(Map<String, dynamic> json) => _$ReadFromJson(json);

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ReadToJson(this);
}
