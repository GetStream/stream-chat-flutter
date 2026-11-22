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
  String get duration;
  List<ChannelState> get channels;
  PredefinedFilter? get predefinedFilter;

  /// Create a copy of QueryChannelsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryChannelsResponseCopyWith<QueryChannelsResponse> get copyWith =>
      _$QueryChannelsResponseCopyWithImpl<QueryChannelsResponse>(this as QueryChannelsResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryChannelsResponse &&
            (identical(other.duration, duration) || other.duration == duration) &&
            const DeepCollectionEquality().equals(other.channels, channels) &&
            (identical(other.predefinedFilter, predefinedFilter) || other.predefinedFilter == predefinedFilter));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, duration, const DeepCollectionEquality().hash(channels), predefinedFilter);

  @override
  String toString() {
    return 'QueryChannelsResponse(duration: $duration, channels: $channels, predefinedFilter: $predefinedFilter)';
  }
}

/// @nodoc
abstract mixin class $QueryChannelsResponseCopyWith<$Res> {
  factory $QueryChannelsResponseCopyWith(QueryChannelsResponse value, $Res Function(QueryChannelsResponse) _then) =
      _$QueryChannelsResponseCopyWithImpl;
  @useResult
  $Res call({String duration, List<ChannelState> channels, PredefinedFilter? predefinedFilter});
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
  $Res call({Object? duration = null, Object? channels = null, Object? predefinedFilter = freezed}) {
    return _then(
      QueryChannelsResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        channels: null == channels
            ? _self.channels
            : channels // ignore: cast_nullable_to_non_nullable
                  as List<ChannelState>,
        predefinedFilter: freezed == predefinedFilter
            ? _self.predefinedFilter
            : predefinedFilter // ignore: cast_nullable_to_non_nullable
                  as PredefinedFilter?,
      ),
    );
  }
}
