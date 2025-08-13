import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:stream_chat/src/core/util/serializer.dart';

part 'reaction.g.dart';

/// The class that defines a reaction
@JsonSerializable()
class Reaction extends Equatable {
  /// Constructor used for json serialization
  Reaction({
    this.messageId,
    required this.type,
    this.user,
    String? userId,
    this.score = 1,
    this.emojiCode,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.extraData = const {},
  })  : userId = userId ?? user?.id,
        createdAt = createdAt ?? DateTime.timestamp(),
        updatedAt = updatedAt ?? DateTime.timestamp();

  /// Create a new instance from a json
  factory Reaction.fromJson(Map<String, dynamic> json) =>
      _$ReactionFromJson(Serializer.moveToExtraDataFromRoot(
        json,
        topLevelFields,
      ));

  /// The messageId to which the reaction belongs
  @JsonKey(includeToJson: false)
  final String? messageId;

  /// The type of the reaction
  final String type;

  /// The score of the reaction (ie. number of reactions sent)
  final int score;

  /// The emoji code of the reaction (used for notifications)
  @JsonKey(includeIfNull: false)
  final String? emojiCode;

  /// The user that sent the reaction
  @JsonKey(includeToJson: false)
  final User? user;

  /// The userId that sent the reaction
  @JsonKey(includeToJson: false)
  final String? userId;

  /// The date of the reaction
  @JsonKey(includeToJson: false)
  final DateTime createdAt;

  /// The date of the reaction update
  @JsonKey(includeToJson: false)
  final DateTime updatedAt;

  /// Reaction custom extraData
  final Map<String, Object?> extraData;

  /// Map of custom user extraData
  static const topLevelFields = [
    'message_id',
    'type',
    'user',
    'user_id',
    'score',
    'emoji_code',
    'created_at',
    'updated_at',
  ];

  /// Serialize to json
  Map<String, dynamic> toJson() => Serializer.moveFromExtraDataToRoot(
        _$ReactionToJson(this),
      );

  /// Creates a copy of [Reaction] with specified attributes overridden.
  Reaction copyWith({
    String? messageId,
    String? type,
    User? user,
    String? userId,
    int? score,
    String? emojiCode,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, Object?>? extraData,
  }) =>
      Reaction(
        messageId: messageId ?? this.messageId,
        type: type ?? this.type,
        user: user ?? this.user,
        userId: userId ?? this.userId,
        score: score ?? this.score,
        emojiCode: emojiCode ?? this.emojiCode,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        extraData: extraData ?? this.extraData,
      );

  /// Returns a new [Reaction] that is a combination of this reaction and the
  /// given [other] reaction.
  Reaction merge(Reaction other) => copyWith(
        messageId: other.messageId,
        type: other.type,
        user: other.user,
        userId: other.userId,
        score: other.score,
        emojiCode: other.emojiCode,
        createdAt: other.createdAt,
        updatedAt: other.updatedAt,
        extraData: other.extraData,
      );

  @override
  List<Object?> get props => [
        messageId,
        type,
        user,
        userId,
        score,
        emojiCode,
        createdAt,
        updatedAt,
        extraData,
      ];
}
