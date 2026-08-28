// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ban_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BanResponse {
  UserResponse? get bannedBy;
  ChannelResponse? get channel;
  DateTime get createdAt;
  DateTime? get expires;
  String? get reason;
  bool? get shadow;
  UserResponse? get user;

  /// Create a copy of BanResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BanResponseCopyWith<BanResponse> get copyWith =>
      _$BanResponseCopyWithImpl<BanResponse>(this as BanResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BanResponse &&
            (identical(other.bannedBy, bannedBy) ||
                other.bannedBy == bannedBy) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expires, expires) || other.expires == expires) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.shadow, shadow) || other.shadow == shadow) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    bannedBy,
    channel,
    createdAt,
    expires,
    reason,
    shadow,
    user,
  );

  @override
  String toString() {
    return 'BanResponse(bannedBy: $bannedBy, channel: $channel, createdAt: $createdAt, expires: $expires, reason: $reason, shadow: $shadow, user: $user)';
  }
}

/// @nodoc
abstract mixin class $BanResponseCopyWith<$Res> {
  factory $BanResponseCopyWith(
    BanResponse value,
    $Res Function(BanResponse) _then,
  ) = _$BanResponseCopyWithImpl;
  @useResult
  $Res call({
    UserResponse? bannedBy,
    ChannelResponse? channel,
    DateTime createdAt,
    DateTime? expires,
    String? reason,
    bool? shadow,
    UserResponse? user,
  });
}

/// @nodoc
class _$BanResponseCopyWithImpl<$Res> implements $BanResponseCopyWith<$Res> {
  _$BanResponseCopyWithImpl(this._self, this._then);

  final BanResponse _self;
  final $Res Function(BanResponse) _then;

  /// Create a copy of BanResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bannedBy = freezed,
    Object? channel = freezed,
    Object? createdAt = null,
    Object? expires = freezed,
    Object? reason = freezed,
    Object? shadow = freezed,
    Object? user = freezed,
  }) {
    return _then(
      BanResponse(
        bannedBy: freezed == bannedBy
            ? _self.bannedBy
            : bannedBy // ignore: cast_nullable_to_non_nullable
                  as UserResponse?,
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
        reason: freezed == reason
            ? _self.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
        shadow: freezed == shadow
            ? _self.shadow
            : shadow // ignore: cast_nullable_to_non_nullable
                  as bool?,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponse?,
      ),
    );
  }
}
