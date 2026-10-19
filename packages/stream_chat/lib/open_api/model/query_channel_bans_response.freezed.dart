// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_channel_bans_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryChannelBansResponse {
  List<ChannelBanResponse> get bans;
  String get duration;
  String? get next;
  String? get prev;
  int? get total;
  ChannelBansScopeTotals? get totalByScope;

  /// Create a copy of QueryChannelBansResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryChannelBansResponseCopyWith<QueryChannelBansResponse> get copyWith =>
      _$QueryChannelBansResponseCopyWithImpl<QueryChannelBansResponse>(
        this as QueryChannelBansResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryChannelBansResponse &&
            const DeepCollectionEquality().equals(other.bans, bans) &&
            (identical(other.duration, duration) || other.duration == duration) &&
            (identical(other.next, next) || other.next == next) &&
            (identical(other.prev, prev) || other.prev == prev) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.totalByScope, totalByScope) || other.totalByScope == totalByScope));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(bans),
    duration,
    next,
    prev,
    total,
    totalByScope,
  );

  @override
  String toString() {
    return 'QueryChannelBansResponse(bans: $bans, duration: $duration, next: $next, prev: $prev, total: $total, totalByScope: $totalByScope)';
  }
}

/// @nodoc
abstract mixin class $QueryChannelBansResponseCopyWith<$Res> {
  factory $QueryChannelBansResponseCopyWith(
    QueryChannelBansResponse value,
    $Res Function(QueryChannelBansResponse) _then,
  ) = _$QueryChannelBansResponseCopyWithImpl;
  @useResult
  $Res call({
    List<ChannelBanResponse> bans,
    String duration,
    String? next,
    String? prev,
    int? total,
    ChannelBansScopeTotals? totalByScope,
  });
}

/// @nodoc
class _$QueryChannelBansResponseCopyWithImpl<$Res> implements $QueryChannelBansResponseCopyWith<$Res> {
  _$QueryChannelBansResponseCopyWithImpl(this._self, this._then);

  final QueryChannelBansResponse _self;
  final $Res Function(QueryChannelBansResponse) _then;

  /// Create a copy of QueryChannelBansResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bans = null,
    Object? duration = null,
    Object? next = freezed,
    Object? prev = freezed,
    Object? total = freezed,
    Object? totalByScope = freezed,
  }) {
    return _then(
      QueryChannelBansResponse(
        bans: null == bans
            ? _self.bans
            : bans // ignore: cast_nullable_to_non_nullable
                  as List<ChannelBanResponse>,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        next: freezed == next
            ? _self.next
            : next // ignore: cast_nullable_to_non_nullable
                  as String?,
        prev: freezed == prev
            ? _self.prev
            : prev // ignore: cast_nullable_to_non_nullable
                  as String?,
        total: freezed == total
            ? _self.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int?,
        totalByScope: freezed == totalByScope
            ? _self.totalByScope
            : totalByScope // ignore: cast_nullable_to_non_nullable
                  as ChannelBansScopeTotals?,
      ),
    );
  }
}
