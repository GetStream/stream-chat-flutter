import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mark_group.g.dart';

/// The users who marked a message with one mark type.
@JsonSerializable()
class MarkGroup extends Equatable {
  /// Creates a new [MarkGroup].
  const MarkGroup({
    this.count = 0,
    this.latestBy = const [],
  });

  /// Creates a new [MarkGroup] from [json].
  factory MarkGroup.fromJson(Map<String, dynamic> json) => _$MarkGroupFromJson(json);

  /// The number of users who marked the message.
  final int count;

  /// The users who marked the message most recently, newest first.
  ///
  /// Holds at most the latest 100 users, so it can be shorter than [count].
  final List<MessageMarker> latestBy;

  /// Serializes this group to json.
  Map<String, dynamic> toJson() => _$MarkGroupToJson(this);

  /// Creates a copy of this group with the given fields replaced.
  MarkGroup copyWith({
    int? count,
    List<MessageMarker>? latestBy,
  }) {
    return MarkGroup(
      count: count ?? this.count,
      latestBy: latestBy ?? this.latestBy,
    );
  }

  @override
  List<Object?> get props => [count, latestBy];
}

/// A user who marked a message, and when.
@JsonSerializable()
class MessageMarker extends Equatable {
  /// Creates a new [MessageMarker].
  const MessageMarker({
    required this.userId,
    required this.createdAt,
  });

  /// Creates a new [MessageMarker] from [json].
  factory MessageMarker.fromJson(Map<String, dynamic> json) => _$MessageMarkerFromJson(json);

  /// The ID of the user who marked the message.
  final String userId;

  /// When the user marked the message.
  final DateTime createdAt;

  /// Serializes this marker to json.
  Map<String, dynamic> toJson() => _$MessageMarkerToJson(this);

  @override
  List<Object?> get props => [userId, createdAt];
}
