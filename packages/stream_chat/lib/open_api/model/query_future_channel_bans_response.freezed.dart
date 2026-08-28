// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_future_channel_bans_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryFutureChannelBansResponse {
  List<FutureChannelBanResponse> get bans;
  String get duration;
  int? get total;

  /// Create a copy of QueryFutureChannelBansResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryFutureChannelBansResponseCopyWith<QueryFutureChannelBansResponse> get copyWith =>
      _$QueryFutureChannelBansResponseCopyWithImpl<QueryFutureChannelBansResponse>(
        this as QueryFutureChannelBansResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryFutureChannelBansResponse &&
            const DeepCollectionEquality().equals(other.bans, bans) &&
            (identical(other.duration, duration) || other.duration == duration) &&
            (identical(other.total, total) || other.total == total));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(bans),
    duration,
    total,
  );

  @override
  String toString() {
    return 'QueryFutureChannelBansResponse(bans: $bans, duration: $duration, total: $total)';
  }
}

/// @nodoc
abstract mixin class $QueryFutureChannelBansResponseCopyWith<$Res> {
  factory $QueryFutureChannelBansResponseCopyWith(
    QueryFutureChannelBansResponse value,
    $Res Function(QueryFutureChannelBansResponse) _then,
  ) = _$QueryFutureChannelBansResponseCopyWithImpl;
  @useResult
  $Res call({List<FutureChannelBanResponse> bans, String duration, int? total});
}

/// @nodoc
class _$QueryFutureChannelBansResponseCopyWithImpl<$Res> implements $QueryFutureChannelBansResponseCopyWith<$Res> {
  _$QueryFutureChannelBansResponseCopyWithImpl(this._self, this._then);

  final QueryFutureChannelBansResponse _self;
  final $Res Function(QueryFutureChannelBansResponse) _then;

  /// Create a copy of QueryFutureChannelBansResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bans = null,
    Object? duration = null,
    Object? total = freezed,
  }) {
    return _then(
      QueryFutureChannelBansResponse(
        bans: null == bans
            ? _self.bans
            : bans // ignore: cast_nullable_to_non_nullable
                  as List<FutureChannelBanResponse>,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        total: freezed == total
            ? _self.total
            : total // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}
