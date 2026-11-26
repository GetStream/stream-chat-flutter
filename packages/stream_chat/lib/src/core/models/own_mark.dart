import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'message_mark.dart';

part 'own_mark.g.dart';

/// A mark the current user put on another user's message.
@JsonSerializable()
final class OwnMark extends Equatable {
  /// Creates a new [OwnMark].
  const OwnMark({
    required this.type,
    required this.createdAt,
  });

  /// Creates a new [OwnMark] from [json].
  factory OwnMark.fromJson(Map<String, dynamic> json) => _$OwnMarkFromJson(json);

  /// The type of the mark.
  final MessageMarkType type;

  /// When the current user marked the message.
  final DateTime createdAt;

  /// Serializes this mark to json.
  Map<String, dynamic> toJson() => _$OwnMarkToJson(this);

  @override
  List<Object?> get props => [type, createdAt];
}
