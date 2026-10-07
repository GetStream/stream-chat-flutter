// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_channel_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeleteChannelResponse {
  String get duration;
  ChannelModel? get channel;

  /// Create a copy of DeleteChannelResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeleteChannelResponseCopyWith<DeleteChannelResponse> get copyWith =>
      _$DeleteChannelResponseCopyWithImpl<DeleteChannelResponse>(
        this as DeleteChannelResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeleteChannelResponse &&
            (identical(other.duration, duration) || other.duration == duration) &&
            (identical(other.channel, channel) || other.channel == channel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration, channel);

  @override
  String toString() {
    return 'DeleteChannelResponse(duration: $duration, channel: $channel)';
  }
}

/// @nodoc
abstract mixin class $DeleteChannelResponseCopyWith<$Res> {
  factory $DeleteChannelResponseCopyWith(
    DeleteChannelResponse value,
    $Res Function(DeleteChannelResponse) _then,
  ) = _$DeleteChannelResponseCopyWithImpl;
  @useResult
  $Res call({String duration, ChannelModel? channel});
}

/// @nodoc
class _$DeleteChannelResponseCopyWithImpl<$Res> implements $DeleteChannelResponseCopyWith<$Res> {
  _$DeleteChannelResponseCopyWithImpl(this._self, this._then);

  final DeleteChannelResponse _self;
  final $Res Function(DeleteChannelResponse) _then;

  /// Create a copy of DeleteChannelResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? channel = freezed}) {
    return _then(
      DeleteChannelResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        channel: freezed == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelModel?,
      ),
    );
  }
}
