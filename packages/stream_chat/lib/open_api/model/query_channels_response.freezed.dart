// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_channels_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryChannelsResponse {
  List<ChannelStateResponseFields> get channels;
  String get duration;
  ParsedPredefinedFilterResponse? get predefinedFilter;

  /// Create a copy of QueryChannelsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryChannelsResponseCopyWith<QueryChannelsResponse> get copyWith =>
      _$QueryChannelsResponseCopyWithImpl<QueryChannelsResponse>(
        this as QueryChannelsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryChannelsResponse &&
            const DeepCollectionEquality().equals(other.channels, channels) &&
            (identical(other.duration, duration) || other.duration == duration) &&
            (identical(other.predefinedFilter, predefinedFilter) || other.predefinedFilter == predefinedFilter));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(channels),
    duration,
    predefinedFilter,
  );

  @override
  String toString() {
    return 'QueryChannelsResponse(channels: $channels, duration: $duration, predefinedFilter: $predefinedFilter)';
  }
}

/// @nodoc
abstract mixin class $QueryChannelsResponseCopyWith<$Res> {
  factory $QueryChannelsResponseCopyWith(
    QueryChannelsResponse value,
    $Res Function(QueryChannelsResponse) _then,
  ) = _$QueryChannelsResponseCopyWithImpl;
  @useResult
  $Res call({
    List<ChannelStateResponseFields> channels,
    String duration,
    ParsedPredefinedFilterResponse? predefinedFilter,
  });
}

/// @nodoc
class _$QueryChannelsResponseCopyWithImpl<$Res> implements $QueryChannelsResponseCopyWith<$Res> {
  _$QueryChannelsResponseCopyWithImpl(this._self, this._then);

  final QueryChannelsResponse _self;
  final $Res Function(QueryChannelsResponse) _then;

  /// Create a copy of QueryChannelsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channels = null,
    Object? duration = null,
    Object? predefinedFilter = freezed,
  }) {
    return _then(
      QueryChannelsResponse(
        channels: null == channels
            ? _self.channels
            : channels // ignore: cast_nullable_to_non_nullable
                  as List<ChannelStateResponseFields>,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        predefinedFilter: freezed == predefinedFilter
            ? _self.predefinedFilter
            : predefinedFilter // ignore: cast_nullable_to_non_nullable
                  as ParsedPredefinedFilterResponse?,
      ),
    );
  }
}
