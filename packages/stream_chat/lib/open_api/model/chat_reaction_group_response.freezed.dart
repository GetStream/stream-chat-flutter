// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_reaction_group_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatReactionGroupResponse {
  int get count;
  DateTime get firstReactionAt;
  DateTime get lastReactionAt;
  List<ChatReactionGroupUserResponse> get latestReactionsBy;
  int get sumScores;

  /// Create a copy of ChatReactionGroupResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChatReactionGroupResponseCopyWith<ChatReactionGroupResponse> get copyWith =>
      _$ChatReactionGroupResponseCopyWithImpl<ChatReactionGroupResponse>(
        this as ChatReactionGroupResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatReactionGroupResponse &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.firstReactionAt, firstReactionAt) ||
                other.firstReactionAt == firstReactionAt) &&
            (identical(other.lastReactionAt, lastReactionAt) ||
                other.lastReactionAt == lastReactionAt) &&
            const DeepCollectionEquality().equals(
              other.latestReactionsBy,
              latestReactionsBy,
            ) &&
            (identical(other.sumScores, sumScores) ||
                other.sumScores == sumScores));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    count,
    firstReactionAt,
    lastReactionAt,
    const DeepCollectionEquality().hash(latestReactionsBy),
    sumScores,
  );

  @override
  String toString() {
    return 'ChatReactionGroupResponse(count: $count, firstReactionAt: $firstReactionAt, lastReactionAt: $lastReactionAt, latestReactionsBy: $latestReactionsBy, sumScores: $sumScores)';
  }
}

/// @nodoc
abstract mixin class $ChatReactionGroupResponseCopyWith<$Res> {
  factory $ChatReactionGroupResponseCopyWith(
    ChatReactionGroupResponse value,
    $Res Function(ChatReactionGroupResponse) _then,
  ) = _$ChatReactionGroupResponseCopyWithImpl;
  @useResult
  $Res call({
    int count,
    DateTime firstReactionAt,
    DateTime lastReactionAt,
    List<ChatReactionGroupUserResponse> latestReactionsBy,
    int sumScores,
  });
}

/// @nodoc
class _$ChatReactionGroupResponseCopyWithImpl<$Res>
    implements $ChatReactionGroupResponseCopyWith<$Res> {
  _$ChatReactionGroupResponseCopyWithImpl(this._self, this._then);

  final ChatReactionGroupResponse _self;
  final $Res Function(ChatReactionGroupResponse) _then;

  /// Create a copy of ChatReactionGroupResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? count = null,
    Object? firstReactionAt = null,
    Object? lastReactionAt = null,
    Object? latestReactionsBy = null,
    Object? sumScores = null,
  }) {
    return _then(
      ChatReactionGroupResponse(
        count: null == count
            ? _self.count
            : count // ignore: cast_nullable_to_non_nullable
                  as int,
        firstReactionAt: null == firstReactionAt
            ? _self.firstReactionAt
            : firstReactionAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastReactionAt: null == lastReactionAt
            ? _self.lastReactionAt
            : lastReactionAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        latestReactionsBy: null == latestReactionsBy
            ? _self.latestReactionsBy
            : latestReactionsBy // ignore: cast_nullable_to_non_nullable
                  as List<ChatReactionGroupUserResponse>,
        sumScores: null == sumScores
            ? _self.sumScores
            : sumScores // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
