// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'truncate_channel_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TruncateChannelResponse {
  ChannelResponse? get channel;
  String get duration;
  MessageResponse? get message;

  /// Create a copy of TruncateChannelResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TruncateChannelResponseCopyWith<TruncateChannelResponse> get copyWith =>
      _$TruncateChannelResponseCopyWithImpl<TruncateChannelResponse>(
        this as TruncateChannelResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TruncateChannelResponse &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.duration, duration) || other.duration == duration) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, channel, duration, message);

  @override
  String toString() {
    return 'TruncateChannelResponse(channel: $channel, duration: $duration, message: $message)';
  }
}

/// @nodoc
abstract mixin class $TruncateChannelResponseCopyWith<$Res> {
  factory $TruncateChannelResponseCopyWith(
    TruncateChannelResponse value,
    $Res Function(TruncateChannelResponse) _then,
  ) = _$TruncateChannelResponseCopyWithImpl;
  @useResult
  $Res call({
    ChannelResponse? channel,
    String duration,
    MessageResponse? message,
  });
}

/// @nodoc
class _$TruncateChannelResponseCopyWithImpl<$Res> implements $TruncateChannelResponseCopyWith<$Res> {
  _$TruncateChannelResponseCopyWithImpl(this._self, this._then);

  final TruncateChannelResponse _self;
  final $Res Function(TruncateChannelResponse) _then;

  /// Create a copy of TruncateChannelResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = freezed,
    Object? duration = null,
    Object? message = freezed,
  }) {
    return _then(
      TruncateChannelResponse(
        channel: freezed == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse?,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse?,
      ),
    );
  }
}
