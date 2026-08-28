// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'enriched_reaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EnrichedReaction {
  String get activityId;
  Map<String, int>? get childrenCounts;
  Map<String, Object?>? get data;
  String? get id;
  String get kind;
  Map<String, List<EnrichedReaction>>? get latestChildren;
  Map<String, List<EnrichedReaction>>? get ownChildren;
  String? get parent;
  List<String>? get targetFeeds;
  Data? get user;
  String get userId;

  /// Create a copy of EnrichedReaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EnrichedReactionCopyWith<EnrichedReaction> get copyWith =>
      _$EnrichedReactionCopyWithImpl<EnrichedReaction>(
        this as EnrichedReaction,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EnrichedReaction &&
            (identical(other.activityId, activityId) ||
                other.activityId == activityId) &&
            const DeepCollectionEquality().equals(
              other.childrenCounts,
              childrenCounts,
            ) &&
            const DeepCollectionEquality().equals(other.data, data) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            const DeepCollectionEquality().equals(
              other.latestChildren,
              latestChildren,
            ) &&
            const DeepCollectionEquality().equals(
              other.ownChildren,
              ownChildren,
            ) &&
            (identical(other.parent, parent) || other.parent == parent) &&
            const DeepCollectionEquality().equals(
              other.targetFeeds,
              targetFeeds,
            ) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    activityId,
    const DeepCollectionEquality().hash(childrenCounts),
    const DeepCollectionEquality().hash(data),
    id,
    kind,
    const DeepCollectionEquality().hash(latestChildren),
    const DeepCollectionEquality().hash(ownChildren),
    parent,
    const DeepCollectionEquality().hash(targetFeeds),
    user,
    userId,
  );

  @override
  String toString() {
    return 'EnrichedReaction(activityId: $activityId, childrenCounts: $childrenCounts, data: $data, id: $id, kind: $kind, latestChildren: $latestChildren, ownChildren: $ownChildren, parent: $parent, targetFeeds: $targetFeeds, user: $user, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $EnrichedReactionCopyWith<$Res> {
  factory $EnrichedReactionCopyWith(
    EnrichedReaction value,
    $Res Function(EnrichedReaction) _then,
  ) = _$EnrichedReactionCopyWithImpl;
  @useResult
  $Res call({
    String activityId,
    Map<String, int>? childrenCounts,
    Map<String, Object?>? data,
    String? id,
    String kind,
    Map<String, List<EnrichedReaction>>? latestChildren,
    Map<String, List<EnrichedReaction>>? ownChildren,
    String? parent,
    List<String>? targetFeeds,
    Data? user,
    String userId,
  });
}

/// @nodoc
class _$EnrichedReactionCopyWithImpl<$Res>
    implements $EnrichedReactionCopyWith<$Res> {
  _$EnrichedReactionCopyWithImpl(this._self, this._then);

  final EnrichedReaction _self;
  final $Res Function(EnrichedReaction) _then;

  /// Create a copy of EnrichedReaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityId = null,
    Object? childrenCounts = freezed,
    Object? data = freezed,
    Object? id = freezed,
    Object? kind = null,
    Object? latestChildren = freezed,
    Object? ownChildren = freezed,
    Object? parent = freezed,
    Object? targetFeeds = freezed,
    Object? user = freezed,
    Object? userId = null,
  }) {
    return _then(
      EnrichedReaction(
        activityId: null == activityId
            ? _self.activityId
            : activityId // ignore: cast_nullable_to_non_nullable
                  as String,
        childrenCounts: freezed == childrenCounts
            ? _self.childrenCounts
            : childrenCounts // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>?,
        data: freezed == data
            ? _self.data
            : data // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
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
                  as Map<String, List<EnrichedReaction>>?,
        ownChildren: freezed == ownChildren
            ? _self.ownChildren
            : ownChildren // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<EnrichedReaction>>?,
        parent: freezed == parent
            ? _self.parent
            : parent // ignore: cast_nullable_to_non_nullable
                  as String?,
        targetFeeds: freezed == targetFeeds
            ? _self.targetFeeds
            : targetFeeds // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as Data?,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
