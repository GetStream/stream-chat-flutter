import 'package:json_annotation/json_annotation.dart';

import 'serialization.dart';
import 'user.dart';

part 'reaction.g.dart';

/// The class that defines a reaction
@JsonSerializable()
class Reaction {
  /// The messageId to which the reaction belongs
  final String messageId;

  /// The type of the reaction
  final String type;

  /// The date of the reaction
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final DateTime createdAt;

  /// The user that sent the reaction
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final User user;

  /// The score of the reaction (ie. number of reactions sent)
  final int score;

  /// The userId that sent the reaction
  @JsonKey(includeIfNull: false, toJson: Serialization.readOnly)
  final String userId;

  /// The score of the reaction (ie. number of reactions sent)
  @JsonKey(includeIfNull: false)
  final Map<String, dynamic> extraData;

  /// Map of custom user extraData
  static const topLevelFields = [
    'message_id',
    'created_at',
    'type',
    'user',
    'user_id',
    'score',
  ];

  /// Constructor used for json serialization
  Reaction({
    this.messageId,
    this.createdAt,
    this.type,
    this.user,
    this.userId,
    this.score,
    this.extraData,
  });

  /// Create a new instance from a json
  factory Reaction.fromJson(Map<String, dynamic> json) {
    return _$ReactionFromJson(
        Serialization.moveToExtraDataFromRoot(json, topLevelFields));
  }

  /// Serialize to json
  Map<String, dynamic> toJson() {
    return Serialization.moveFromExtraDataToRoot(
        _$ReactionToJson(this), topLevelFields);
  }
}
