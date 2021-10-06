import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:stream_chat/src/core/util/serializer.dart';

part 'reaction.g.dart';

/// The class that defines a reaction
@JsonSerializable()
class Reaction {
  /// Constructor used for json serialization
  Reaction({
    this.messageId,
    DateTime? createdAt,
    required this.type,
    this.user,
    String? userId,
    this.score = 0,
    this.extraData = const {},
  })  : userId = userId ?? user?.id,
        createdAt = createdAt ?? DateTime.now();

  /// Create a new instance from a json
  factory Reaction.fromJson(Map<String, dynamic> json) =>
      _$ReactionFromJson(Serializer.moveToExtraDataFromRoot(
        json,
        topLevelFields,
      ));

  /// The messageId to which the reaction belongs
  final String? messageId;

  /// The type of the reaction
  final String type;

  /// The date of the reaction
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final DateTime createdAt;

  /// The user that sent the reaction
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final User? user;

  /// The score of the reaction (ie. number of reactions sent)
  final int score;

  /// The userId that sent the reaction
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final String? userId;

  /// Reaction custom extraData
  @JsonKey(includeIfNull: false)
  final Map<String, Object?> extraData;

  /// Map of custom user extraData
  static const topLevelFields = [
    'message_id',
    'created_at',
    'type',
    'user',
    'user_id',
    'score',
  ];

  /// Serialize to json
  Map<String, dynamic> toJson() => Serializer.moveFromExtraDataToRoot(
        _$ReactionToJson(this),
      );

  /// Creates a copy of [Reaction] with specified attributes overridden.
  Reaction copyWith({
    String? messageId,
    DateTime? createdAt,
    String? type,
    User? user,
    String? userId,
    int? score,
    Map<String, Object?>? extraData,
  }) =>
      Reaction(
        messageId: messageId ?? this.messageId,
        createdAt: createdAt ?? this.createdAt,
        type: type ?? this.type,
        user: user ?? this.user,
        userId: userId ?? this.userId,
        score: score ?? this.score,
        extraData: extraData ?? this.extraData,
      );

  /// Returns a new [Reaction] that is a combination of this reaction and the
  /// given [other] reaction.
  Reaction merge(Reaction other) => copyWith(
        messageId: other.messageId,
        createdAt: other.createdAt,
        type: other.type,
        user: other.user,
        userId: other.userId,
        score: other.score,
        extraData: other.extraData,
      );
}
