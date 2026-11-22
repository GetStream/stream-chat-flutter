// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rewind_channel_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RewindChannelResponse {
  ChannelResponse? get channel;
  String get duration;
  ChannelRewindResponse get rewind;

  /// Create a copy of RewindChannelResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RewindChannelResponseCopyWith<RewindChannelResponse> get copyWith =>
      _$RewindChannelResponseCopyWithImpl<RewindChannelResponse>(
        this as RewindChannelResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RewindChannelResponse &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.duration, duration) || other.duration == duration) &&
            (identical(other.rewind, rewind) || other.rewind == rewind));
  }

  @override
  int get hashCode => Object.hash(runtimeType, channel, duration, rewind);

  @override
  String toString() {
    return 'RewindChannelResponse(channel: $channel, duration: $duration, rewind: $rewind)';
  }
}

/// @nodoc
abstract mixin class $RewindChannelResponseCopyWith<$Res> {
  factory $RewindChannelResponseCopyWith(
    RewindChannelResponse value,
    $Res Function(RewindChannelResponse) _then,
  ) = _$RewindChannelResponseCopyWithImpl;
  @useResult
  $Res call({
    ChannelResponse? channel,
    String duration,
    ChannelRewindResponse rewind,
  });
}

/// @nodoc
class _$RewindChannelResponseCopyWithImpl<$Res> implements $RewindChannelResponseCopyWith<$Res> {
  _$RewindChannelResponseCopyWithImpl(this._self, this._then);

  final RewindChannelResponse _self;
  final $Res Function(RewindChannelResponse) _then;

  /// Create a copy of RewindChannelResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = freezed,
    Object? duration = null,
    Object? rewind = null,
  }) {
    return _then(
      RewindChannelResponse(
        channel: freezed == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse?,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        rewind: null == rewind
            ? _self.rewind
            : rewind // ignore: cast_nullable_to_non_nullable
                  as ChannelRewindResponse,
      ),
    );
  }
}
