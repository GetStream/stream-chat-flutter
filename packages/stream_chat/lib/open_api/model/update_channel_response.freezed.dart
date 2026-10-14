// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_channel_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateChannelResponse {
  ChannelResponse? get channel;
  String get duration;
  List<ChannelMemberResponse> get members;
  MessageResponse? get message;

  /// Create a copy of UpdateChannelResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateChannelResponseCopyWith<UpdateChannelResponse> get copyWith =>
      _$UpdateChannelResponseCopyWithImpl<UpdateChannelResponse>(
        this as UpdateChannelResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateChannelResponse &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.duration, duration) || other.duration == duration) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    duration,
    const DeepCollectionEquality().hash(members),
    message,
  );

  @override
  String toString() {
    return 'UpdateChannelResponse(channel: $channel, duration: $duration, members: $members, message: $message)';
  }
}

/// @nodoc
abstract mixin class $UpdateChannelResponseCopyWith<$Res> {
  factory $UpdateChannelResponseCopyWith(
    UpdateChannelResponse value,
    $Res Function(UpdateChannelResponse) _then,
  ) = _$UpdateChannelResponseCopyWithImpl;
  @useResult
  $Res call({
    ChannelResponse? channel,
    String duration,
    List<ChannelMemberResponse> members,
    MessageResponse? message,
  });
}

/// @nodoc
class _$UpdateChannelResponseCopyWithImpl<$Res> implements $UpdateChannelResponseCopyWith<$Res> {
  _$UpdateChannelResponseCopyWithImpl(this._self, this._then);

  final UpdateChannelResponse _self;
  final $Res Function(UpdateChannelResponse) _then;

  /// Create a copy of UpdateChannelResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = freezed,
    Object? duration = null,
    Object? members = null,
    Object? message = freezed,
  }) {
    return _then(
      UpdateChannelResponse(
        channel: freezed == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse?,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        members: null == members
            ? _self.members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<ChannelMemberResponse>,
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse?,
      ),
    );
  }
}
