// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_state_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelStateResponse {
  String get duration;
  ChannelState get channelState;

  /// Create a copy of ChannelStateResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelStateResponseCopyWith<ChannelStateResponse> get copyWith =>
      _$ChannelStateResponseCopyWithImpl<ChannelStateResponse>(this as ChannelStateResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelStateResponse &&
            (identical(other.duration, duration) || other.duration == duration) &&
            (identical(other.channelState, channelState) || other.channelState == channelState));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration, channelState);

  @override
  String toString() {
    return 'ChannelStateResponse(duration: $duration, channelState: $channelState)';
  }
}

/// @nodoc
abstract mixin class $ChannelStateResponseCopyWith<$Res> {
  factory $ChannelStateResponseCopyWith(ChannelStateResponse value, $Res Function(ChannelStateResponse) _then) =
      _$ChannelStateResponseCopyWithImpl;
  @useResult
  $Res call({String duration, ChannelState channelState});
}

/// @nodoc
class _$ChannelStateResponseCopyWithImpl<$Res> implements $ChannelStateResponseCopyWith<$Res> {
  _$ChannelStateResponseCopyWithImpl(this._self, this._then);

  final ChannelStateResponse _self;
  final $Res Function(ChannelStateResponse) _then;

  /// Create a copy of ChannelStateResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? channelState = null}) {
    return _then(
      ChannelStateResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        channelState: null == channelState
            ? _self.channelState
            : channelState // ignore: cast_nullable_to_non_nullable
                  as ChannelState,
      ),
    );
  }
}
