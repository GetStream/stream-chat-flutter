// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_ban_scope_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelBanScopeResponse {
  UserResponse? get bannedBy;
  DateTime get createdAt;
  DateTime? get expires;
  String? get reason;
  bool get shadow;

  /// Create a copy of ChannelBanScopeResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelBanScopeResponseCopyWith<ChannelBanScopeResponse> get copyWith =>
      _$ChannelBanScopeResponseCopyWithImpl<ChannelBanScopeResponse>(
        this as ChannelBanScopeResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelBanScopeResponse &&
            (identical(other.bannedBy, bannedBy) || other.bannedBy == bannedBy) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.expires, expires) || other.expires == expires) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.shadow, shadow) || other.shadow == shadow));
  }

  @override
  int get hashCode => Object.hash(runtimeType, bannedBy, createdAt, expires, reason, shadow);

  @override
  String toString() {
    return 'ChannelBanScopeResponse(bannedBy: $bannedBy, createdAt: $createdAt, expires: $expires, reason: $reason, shadow: $shadow)';
  }
}

/// @nodoc
abstract mixin class $ChannelBanScopeResponseCopyWith<$Res> {
  factory $ChannelBanScopeResponseCopyWith(
    ChannelBanScopeResponse value,
    $Res Function(ChannelBanScopeResponse) _then,
  ) = _$ChannelBanScopeResponseCopyWithImpl;
  @useResult
  $Res call({
    UserResponse? bannedBy,
    DateTime createdAt,
    DateTime? expires,
    String? reason,
    bool shadow,
  });
}

/// @nodoc
class _$ChannelBanScopeResponseCopyWithImpl<$Res> implements $ChannelBanScopeResponseCopyWith<$Res> {
  _$ChannelBanScopeResponseCopyWithImpl(this._self, this._then);

  final ChannelBanScopeResponse _self;
  final $Res Function(ChannelBanScopeResponse) _then;

  /// Create a copy of ChannelBanScopeResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bannedBy = freezed,
    Object? createdAt = null,
    Object? expires = freezed,
    Object? reason = freezed,
    Object? shadow = null,
  }) {
    return _then(
      ChannelBanScopeResponse(
        bannedBy: freezed == bannedBy
            ? _self.bannedBy
            : bannedBy // ignore: cast_nullable_to_non_nullable
                  as UserResponse?,
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
        shadow: null == shadow
            ? _self.shadow
            : shadow // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
