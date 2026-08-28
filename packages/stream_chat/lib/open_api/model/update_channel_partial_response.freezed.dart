// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_channel_partial_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateChannelPartialResponse {
  ChannelResponse? get channel;
  String get duration;
  List<ChannelMemberResponse> get members;

  /// Create a copy of UpdateChannelPartialResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateChannelPartialResponseCopyWith<UpdateChannelPartialResponse>
  get copyWith =>
      _$UpdateChannelPartialResponseCopyWithImpl<UpdateChannelPartialResponse>(
        this as UpdateChannelPartialResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateChannelPartialResponse &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            const DeepCollectionEquality().equals(other.members, members));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    duration,
    const DeepCollectionEquality().hash(members),
  );

  @override
  String toString() {
    return 'UpdateChannelPartialResponse(channel: $channel, duration: $duration, members: $members)';
  }
}

/// @nodoc
abstract mixin class $UpdateChannelPartialResponseCopyWith<$Res> {
  factory $UpdateChannelPartialResponseCopyWith(
    UpdateChannelPartialResponse value,
    $Res Function(UpdateChannelPartialResponse) _then,
  ) = _$UpdateChannelPartialResponseCopyWithImpl;
  @useResult
  $Res call({
    ChannelResponse? channel,
    String duration,
    List<ChannelMemberResponse> members,
  });
}

/// @nodoc
class _$UpdateChannelPartialResponseCopyWithImpl<$Res>
    implements $UpdateChannelPartialResponseCopyWith<$Res> {
  _$UpdateChannelPartialResponseCopyWithImpl(this._self, this._then);

  final UpdateChannelPartialResponse _self;
  final $Res Function(UpdateChannelPartialResponse) _then;

  /// Create a copy of UpdateChannelPartialResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = freezed,
    Object? duration = null,
    Object? members = null,
  }) {
    return _then(
      UpdateChannelPartialResponse(
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
      ),
    );
  }
}
