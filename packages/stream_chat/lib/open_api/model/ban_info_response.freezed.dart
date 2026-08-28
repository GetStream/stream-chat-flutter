// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ban_info_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BanInfoResponse {
  ChannelMetadata? get channel;
  String? get channelCid;
  DateTime get createdAt;
  UserResponse? get createdBy;
  DateTime? get expires;
  String? get reason;
  bool? get shadow;
  UserResponse? get user;

  /// Create a copy of BanInfoResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BanInfoResponseCopyWith<BanInfoResponse> get copyWith =>
      _$BanInfoResponseCopyWithImpl<BanInfoResponse>(
        this as BanInfoResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BanInfoResponse &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.channelCid, channelCid) ||
                other.channelCid == channelCid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.expires, expires) || other.expires == expires) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.shadow, shadow) || other.shadow == shadow) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    channelCid,
    createdAt,
    createdBy,
    expires,
    reason,
    shadow,
    user,
  );

  @override
  String toString() {
    return 'BanInfoResponse(channel: $channel, channelCid: $channelCid, createdAt: $createdAt, createdBy: $createdBy, expires: $expires, reason: $reason, shadow: $shadow, user: $user)';
  }
}

/// @nodoc
abstract mixin class $BanInfoResponseCopyWith<$Res> {
  factory $BanInfoResponseCopyWith(
    BanInfoResponse value,
    $Res Function(BanInfoResponse) _then,
  ) = _$BanInfoResponseCopyWithImpl;
  @useResult
  $Res call({
    ChannelMetadata? channel,
    String? channelCid,
    DateTime createdAt,
    UserResponse? createdBy,
    DateTime? expires,
    String? reason,
    bool? shadow,
    UserResponse? user,
  });
}

/// @nodoc
class _$BanInfoResponseCopyWithImpl<$Res>
    implements $BanInfoResponseCopyWith<$Res> {
  _$BanInfoResponseCopyWithImpl(this._self, this._then);

  final BanInfoResponse _self;
  final $Res Function(BanInfoResponse) _then;

  /// Create a copy of BanInfoResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = freezed,
    Object? channelCid = freezed,
    Object? createdAt = null,
    Object? createdBy = freezed,
    Object? expires = freezed,
    Object? reason = freezed,
    Object? shadow = freezed,
    Object? user = freezed,
  }) {
    return _then(
      BanInfoResponse(
        channel: freezed == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelMetadata?,
        channelCid: freezed == channelCid
            ? _self.channelCid
            : channelCid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdBy: freezed == createdBy
            ? _self.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as UserResponse?,
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
