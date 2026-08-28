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
  String get activityId;
  Map<String, Object?>? get childrenCounts;
  DateTime get createdAt;
  Map<String, Object?>? get data;
  DateTime? get deletedAt;
  String? get id;
  String get kind;
  Map<String, List<Reaction>>? get latestChildren;
  Map<String, Object?>? get moderation;
  Map<String, List<Reaction>>? get ownChildren;
  String? get parent;
  double? get score;
  List<String>? get targetFeeds;
  Map<String, Object?>? get targetFeedsExtraData;
  DateTime get updatedAt;
  User? get user;
  String get userId;

  /// Create a copy of Reaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReactionCopyWith<Reaction> get copyWith =>
      _$ReactionCopyWithImpl<Reaction>(this as Reaction, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Reaction &&
            (identical(other.activityId, activityId) ||
                other.activityId == activityId) &&
            const DeepCollectionEquality().equals(
              other.childrenCounts,
              childrenCounts,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            const DeepCollectionEquality().equals(
              other.latestChildren,
              latestChildren,
            ) &&
            const DeepCollectionEquality().equals(
              other.moderation,
              moderation,
            ) &&
            const DeepCollectionEquality().equals(
              other.ownChildren,
              ownChildren,
            ) &&
            (identical(other.parent, parent) || other.parent == parent) &&
            (identical(other.score, score) || other.score == score) &&
            const DeepCollectionEquality().equals(
              other.targetFeeds,
              targetFeeds,
            ) &&
            const DeepCollectionEquality().equals(
              other.targetFeedsExtraData,
              targetFeedsExtraData,
            ) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    activityId,
    const DeepCollectionEquality().hash(childrenCounts),
    createdAt,
    const DeepCollectionEquality().hash(data),
    deletedAt,
    id,
    kind,
    const DeepCollectionEquality().hash(latestChildren),
    const DeepCollectionEquality().hash(moderation),
    const DeepCollectionEquality().hash(ownChildren),
    parent,
    score,
    const DeepCollectionEquality().hash(targetFeeds),
    const DeepCollectionEquality().hash(targetFeedsExtraData),
    updatedAt,
    user,
    userId,
  );

  @override
  String toString() {
    return 'Reaction(activityId: $activityId, childrenCounts: $childrenCounts, createdAt: $createdAt, data: $data, deletedAt: $deletedAt, id: $id, kind: $kind, latestChildren: $latestChildren, moderation: $moderation, ownChildren: $ownChildren, parent: $parent, score: $score, targetFeeds: $targetFeeds, targetFeedsExtraData: $targetFeedsExtraData, updatedAt: $updatedAt, user: $user, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $ReactionCopyWith<$Res> {
  factory $ReactionCopyWith(Reaction value, $Res Function(Reaction) _then) =
      _$ReactionCopyWithImpl;
  @useResult
  $Res call({
    String activityId,
    Map<String, Object?>? childrenCounts,
    DateTime createdAt,
    Map<String, Object?>? data,
    DateTime? deletedAt,
    String? id,
    String kind,
    Map<String, List<Reaction>>? latestChildren,
    Map<String, Object?>? moderation,
    Map<String, List<Reaction>>? ownChildren,
    String? parent,
    double? score,
    List<String>? targetFeeds,
    Map<String, Object?>? targetFeedsExtraData,
    DateTime updatedAt,
    User? user,
    String userId,
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
    Object? activityId = null,
    Object? childrenCounts = freezed,
    Object? createdAt = null,
    Object? data = freezed,
    Object? deletedAt = freezed,
    Object? id = freezed,
    Object? kind = null,
    Object? latestChildren = freezed,
    Object? moderation = freezed,
    Object? ownChildren = freezed,
    Object? parent = freezed,
    Object? score = freezed,
    Object? targetFeeds = freezed,
    Object? targetFeedsExtraData = freezed,
    Object? updatedAt = null,
    Object? user = freezed,
    Object? userId = null,
  }) {
    return _then(
      Reaction(
        activityId: null == activityId
            ? _self.activityId
            : activityId // ignore: cast_nullable_to_non_nullable
                  as String,
        childrenCounts: freezed == childrenCounts
            ? _self.childrenCounts
            : childrenCounts // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        data: freezed == data
            ? _self.data
            : data // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        deletedAt: freezed == deletedAt
            ? _self.deletedAt
            : deletedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        id: freezed == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        kind: null == kind
            ? _self.kind
            : kind // ignore: cast_nullable_to_non_nullable
                  as String,
        latestChildren: freezed == latestChildren
            ? _self.latestChildren
            : latestChildren // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<Reaction>>?,
        moderation: freezed == moderation
            ? _self.moderation
            : moderation // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        ownChildren: freezed == ownChildren
            ? _self.ownChildren
            : ownChildren // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<Reaction>>?,
        parent: freezed == parent
            ? _self.parent
            : parent // ignore: cast_nullable_to_non_nullable
                  as String?,
        score: freezed == score
            ? _self.score
            : score // ignore: cast_nullable_to_non_nullable
                  as double?,
        targetFeeds: freezed == targetFeeds
            ? _self.targetFeeds
            : targetFeeds // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        targetFeedsExtraData: freezed == targetFeedsExtraData
            ? _self.targetFeedsExtraData
            : targetFeedsExtraData // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User?,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
