import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/user.dart';

part 'read.g.dart';

/// The class that defines a read event
@JsonSerializable()
class Read extends Equatable {
  /// Constructor used for json serialization
  const Read({
    required this.lastRead,
    required this.user,
    this.unreadMessages = 0,
  });

  /// Create a new instance from a json
  factory Read.fromJson(Map<String, dynamic> json) => _$ReadFromJson(json);

  /// Date of the read event
  final DateTime lastRead;

  /// User who sent the event
  final User user;

  /// Number of unread messages
  final int unreadMessages;

  /// Serialize to json
  Map<String, dynamic> toJson() => _$ReadToJson(this);

  /// Creates a copy of [Read] with specified attributes overridden.
  Read copyWith({
    DateTime? lastRead,
    User? user,
    int? unreadMessages,
  }) =>
      Read(
        lastRead: lastRead ?? this.lastRead,
        user: user ?? this.user,
        unreadMessages: unreadMessages ?? this.unreadMessages,
      );

  @override
  List<Object?> get props => [
        lastRead,
        user,
        unreadMessages,
      ];
}
