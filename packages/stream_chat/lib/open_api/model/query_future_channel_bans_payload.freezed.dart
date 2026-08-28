// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_future_channel_bans_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryFutureChannelBansPayload {
  bool? get excludeExpiredBans;
  bool? get includeTotal;
  int? get limit;
  int? get offset;
  String? get targetUserId;

  /// Create a copy of QueryFutureChannelBansPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryFutureChannelBansPayloadCopyWith<QueryFutureChannelBansPayload>
  get copyWith =>
      _$QueryFutureChannelBansPayloadCopyWithImpl<
        QueryFutureChannelBansPayload
      >(this as QueryFutureChannelBansPayload, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryFutureChannelBansPayload &&
            (identical(other.excludeExpiredBans, excludeExpiredBans) ||
                other.excludeExpiredBans == excludeExpiredBans) &&
            (identical(other.includeTotal, includeTotal) ||
                other.includeTotal == includeTotal) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.targetUserId, targetUserId) ||
                other.targetUserId == targetUserId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    excludeExpiredBans,
    includeTotal,
    limit,
    offset,
    targetUserId,
  );

  @override
  String toString() {
    return 'QueryFutureChannelBansPayload(excludeExpiredBans: $excludeExpiredBans, includeTotal: $includeTotal, limit: $limit, offset: $offset, targetUserId: $targetUserId)';
  }
}

/// @nodoc
abstract mixin class $QueryFutureChannelBansPayloadCopyWith<$Res> {
  factory $QueryFutureChannelBansPayloadCopyWith(
    QueryFutureChannelBansPayload value,
    $Res Function(QueryFutureChannelBansPayload) _then,
  ) = _$QueryFutureChannelBansPayloadCopyWithImpl;
  @useResult
  $Res call({
    bool? excludeExpiredBans,
    bool? includeTotal,
    int? limit,
    int? offset,
    String? targetUserId,
  });
}

/// @nodoc
class _$QueryFutureChannelBansPayloadCopyWithImpl<$Res>
    implements $QueryFutureChannelBansPayloadCopyWith<$Res> {
  _$QueryFutureChannelBansPayloadCopyWithImpl(this._self, this._then);

  final QueryFutureChannelBansPayload _self;
  final $Res Function(QueryFutureChannelBansPayload) _then;

  /// Create a copy of QueryFutureChannelBansPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? excludeExpiredBans = freezed,
    Object? includeTotal = freezed,
    Object? limit = freezed,
    Object? offset = freezed,
    Object? targetUserId = freezed,
  }) {
    return _then(
      QueryFutureChannelBansPayload(
        excludeExpiredBans: freezed == excludeExpiredBans
            ? _self.excludeExpiredBans
            : excludeExpiredBans // ignore: cast_nullable_to_non_nullable
                  as bool?,
        includeTotal: freezed == includeTotal
            ? _self.includeTotal
            : includeTotal // ignore: cast_nullable_to_non_nullable
                  as bool?,
        limit: freezed == limit
            ? _self.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
        offset: freezed == offset
            ? _self.offset
            : offset // ignore: cast_nullable_to_non_nullable
                  as int?,
        targetUserId: freezed == targetUserId
            ? _self.targetUserId
            : targetUserId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
