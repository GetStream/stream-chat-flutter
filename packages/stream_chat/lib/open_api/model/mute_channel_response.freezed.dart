// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mute_channel_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MuteChannelResponse {
  ChannelMute? get channelMute;
  List<ChannelMute>? get channelMutes;
  String get duration;
  OwnUserResponse? get ownUser;

  /// Create a copy of MuteChannelResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MuteChannelResponseCopyWith<MuteChannelResponse> get copyWith =>
      _$MuteChannelResponseCopyWithImpl<MuteChannelResponse>(
        this as MuteChannelResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MuteChannelResponse &&
            (identical(other.channelMute, channelMute) ||
                other.channelMute == channelMute) &&
            const DeepCollectionEquality().equals(
              other.channelMutes,
              channelMutes,
            ) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.ownUser, ownUser) || other.ownUser == ownUser));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channelMute,
    const DeepCollectionEquality().hash(channelMutes),
    duration,
    ownUser,
  );

  @override
  String toString() {
    return 'MuteChannelResponse(channelMute: $channelMute, channelMutes: $channelMutes, duration: $duration, ownUser: $ownUser)';
  }
}

/// @nodoc
abstract mixin class $MuteChannelResponseCopyWith<$Res> {
  factory $MuteChannelResponseCopyWith(
    MuteChannelResponse value,
    $Res Function(MuteChannelResponse) _then,
  ) = _$MuteChannelResponseCopyWithImpl;
  @useResult
  $Res call({
    ChannelMute? channelMute,
    List<ChannelMute>? channelMutes,
    String duration,
    OwnUserResponse? ownUser,
  });
}

/// @nodoc
class _$MuteChannelResponseCopyWithImpl<$Res>
    implements $MuteChannelResponseCopyWith<$Res> {
  _$MuteChannelResponseCopyWithImpl(this._self, this._then);

  final MuteChannelResponse _self;
  final $Res Function(MuteChannelResponse) _then;

  /// Create a copy of MuteChannelResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelMute = freezed,
    Object? channelMutes = freezed,
    Object? duration = null,
    Object? ownUser = freezed,
  }) {
    return _then(
      MuteChannelResponse(
        channelMute: freezed == channelMute
            ? _self.channelMute
            : channelMute // ignore: cast_nullable_to_non_nullable
                  as ChannelMute?,
        channelMutes: freezed == channelMutes
            ? _self.channelMutes
            : channelMutes // ignore: cast_nullable_to_non_nullable
                  as List<ChannelMute>?,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        ownUser: freezed == ownUser
            ? _self.ownUser
            : ownUser // ignore: cast_nullable_to_non_nullable
                  as OwnUserResponse?,
      ),
    );
  }
}
