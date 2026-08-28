// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_mute.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelMute {
  ChannelResponse? get channel;
  DateTime get createdAt;
  DateTime? get expires;
  DateTime get updatedAt;
  UserResponse? get user;

  /// Create a copy of ChannelMute
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelMuteCopyWith<ChannelMute> get copyWith =>
      _$ChannelMuteCopyWithImpl<ChannelMute>(this as ChannelMute, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelMute &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expires, expires) || other.expires == expires) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, channel, createdAt, expires, updatedAt, user);

  @override
  String toString() {
    return 'ChannelMute(channel: $channel, createdAt: $createdAt, expires: $expires, updatedAt: $updatedAt, user: $user)';
  }
}

/// @nodoc
abstract mixin class $ChannelMuteCopyWith<$Res> {
  factory $ChannelMuteCopyWith(
    ChannelMute value,
    $Res Function(ChannelMute) _then,
  ) = _$ChannelMuteCopyWithImpl;
  @useResult
  $Res call({
    ChannelResponse? channel,
    DateTime createdAt,
    DateTime? expires,
    DateTime updatedAt,
    UserResponse? user,
  });
}

/// @nodoc
class _$ChannelMuteCopyWithImpl<$Res> implements $ChannelMuteCopyWith<$Res> {
  _$ChannelMuteCopyWithImpl(this._self, this._then);

  final ChannelMute _self;
  final $Res Function(ChannelMute) _then;

  /// Create a copy of ChannelMute
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = freezed,
    Object? createdAt = null,
    Object? expires = freezed,
    Object? updatedAt = null,
    Object? user = freezed,
  }) {
    return _then(
      ChannelMute(
        channel: freezed == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        expires: freezed == expires
            ? _self.expires
            : expires // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponse?,
      ),
    );
  }
}
