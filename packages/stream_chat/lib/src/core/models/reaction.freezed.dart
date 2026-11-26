// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Reaction {
  String? get messageId;
  String get type;
  int get score;
  String? get emojiCode;
  User? get user;
  String? get userId;
  DateTime get createdAt;
  DateTime get updatedAt;
  Map<String, Object?> get custom;

  /// Create a copy of Reaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReactionCopyWith<Reaction> get copyWith => _$ReactionCopyWithImpl<Reaction>(this as Reaction, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Reaction &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.emojiCode, emojiCode) || other.emojiCode == emojiCode) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other.custom, custom));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    messageId,
    type,
    score,
    emojiCode,
    user,
    userId,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(custom),
  );

  @override
  String toString() {
    return 'Reaction(messageId: $messageId, type: $type, score: $score, emojiCode: $emojiCode, user: $user, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt, custom: $custom)';
  }
}

/// @nodoc
abstract mixin class $ReactionCopyWith<$Res> {
  factory $ReactionCopyWith(Reaction value, $Res Function(Reaction) _then) = _$ReactionCopyWithImpl;
  @useResult
  $Res call({
    String? messageId,
    String type,
    User? user,
    String? userId,
    int score,
    String? emojiCode,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, Object?> custom,
  });
}

/// @nodoc
class _$ReactionCopyWithImpl<$Res> implements $ReactionCopyWith<$Res> {
  _$ReactionCopyWithImpl(this._self, this._then);

  final Reaction _self;
  final $Res Function(Reaction) _then;

  /// Create a copy of Reaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? messageId = freezed,
    Object? type = null,
    Object? user = freezed,
    Object? userId = freezed,
    Object? score = null,
    Object? emojiCode = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? custom = null,
  }) {
    return _then(
      Reaction(
        messageId: freezed == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User?,
        userId: freezed == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
        score: null == score
            ? _self.score
            : score // ignore: cast_nullable_to_non_nullable
                  as int,
        emojiCode: freezed == emojiCode
            ? _self.emojiCode
            : emojiCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _self.createdAt!
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _self.updatedAt!
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
      ),
    );
  }
}
