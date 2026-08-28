// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'enriched_activity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EnrichedActivity {
  Data? get actor;
  String? get foreignId;
  String? get id;
  Map<String, List<EnrichedReaction>>? get latestReactions;
  Data? get object;
  Data? get origin;
  Map<String, List<EnrichedReaction>>? get ownReactions;
  Map<String, int>? get reactionCounts;
  double? get score;
  Data? get target;
  List<String>? get to;
  String? get verb;

  /// Create a copy of EnrichedActivity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EnrichedActivityCopyWith<EnrichedActivity> get copyWith =>
      _$EnrichedActivityCopyWithImpl<EnrichedActivity>(
        this as EnrichedActivity,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EnrichedActivity &&
            (identical(other.actor, actor) || other.actor == actor) &&
            (identical(other.foreignId, foreignId) ||
                other.foreignId == foreignId) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(
              other.latestReactions,
              latestReactions,
            ) &&
            (identical(other.object, object) || other.object == object) &&
            (identical(other.origin, origin) || other.origin == origin) &&
            const DeepCollectionEquality().equals(
              other.ownReactions,
              ownReactions,
            ) &&
            const DeepCollectionEquality().equals(
              other.reactionCounts,
              reactionCounts,
            ) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.target, target) || other.target == target) &&
            const DeepCollectionEquality().equals(other.to, to) &&
            (identical(other.verb, verb) || other.verb == verb));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    actor,
    foreignId,
    id,
    const DeepCollectionEquality().hash(latestReactions),
    object,
    origin,
    const DeepCollectionEquality().hash(ownReactions),
    const DeepCollectionEquality().hash(reactionCounts),
    score,
    target,
    const DeepCollectionEquality().hash(to),
    verb,
  );

  @override
  String toString() {
    return 'EnrichedActivity(actor: $actor, foreignId: $foreignId, id: $id, latestReactions: $latestReactions, object: $object, origin: $origin, ownReactions: $ownReactions, reactionCounts: $reactionCounts, score: $score, target: $target, to: $to, verb: $verb)';
  }
}

/// @nodoc
abstract mixin class $EnrichedActivityCopyWith<$Res> {
  factory $EnrichedActivityCopyWith(
    EnrichedActivity value,
    $Res Function(EnrichedActivity) _then,
  ) = _$EnrichedActivityCopyWithImpl;
  @useResult
  $Res call({
    Data? actor,
    String? foreignId,
    String? id,
    Map<String, List<EnrichedReaction>>? latestReactions,
    Data? object,
    Data? origin,
    Map<String, List<EnrichedReaction>>? ownReactions,
    Map<String, int>? reactionCounts,
    double? score,
    Data? target,
    List<String>? to,
    String? verb,
  });
}

/// @nodoc
class _$EnrichedActivityCopyWithImpl<$Res>
    implements $EnrichedActivityCopyWith<$Res> {
  _$EnrichedActivityCopyWithImpl(this._self, this._then);

  final EnrichedActivity _self;
  final $Res Function(EnrichedActivity) _then;

  /// Create a copy of EnrichedActivity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? actor = freezed,
    Object? foreignId = freezed,
    Object? id = freezed,
    Object? latestReactions = freezed,
    Object? object = freezed,
    Object? origin = freezed,
    Object? ownReactions = freezed,
    Object? reactionCounts = freezed,
    Object? score = freezed,
    Object? target = freezed,
    Object? to = freezed,
    Object? verb = freezed,
  }) {
    return _then(
      EnrichedActivity(
        actor: freezed == actor
            ? _self.actor
            : actor // ignore: cast_nullable_to_non_nullable
                  as Data?,
        foreignId: freezed == foreignId
            ? _self.foreignId
            : foreignId // ignore: cast_nullable_to_non_nullable
                  as String?,
        id: freezed == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        latestReactions: freezed == latestReactions
            ? _self.latestReactions
            : latestReactions // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<EnrichedReaction>>?,
        object: freezed == object
            ? _self.object
            : object // ignore: cast_nullable_to_non_nullable
                  as Data?,
        origin: freezed == origin
            ? _self.origin
            : origin // ignore: cast_nullable_to_non_nullable
                  as Data?,
        ownReactions: freezed == ownReactions
            ? _self.ownReactions
            : ownReactions // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<EnrichedReaction>>?,
        reactionCounts: freezed == reactionCounts
            ? _self.reactionCounts
            : reactionCounts // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>?,
        score: freezed == score
            ? _self.score
            : score // ignore: cast_nullable_to_non_nullable
                  as double?,
        target: freezed == target
            ? _self.target
            : target // ignore: cast_nullable_to_non_nullable
                  as Data?,
        to: freezed == to
            ? _self.to
            : to // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        verb: freezed == verb
            ? _self.verb
            : verb // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
