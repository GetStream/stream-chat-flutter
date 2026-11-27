// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_ban_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelBanResponse {
  ChannelBanScopeResponse? get channelBan;
  DateTime get createdAt;
  ChannelBanScopeResponse? get futureChannelBan;
  List<String> get scopes;
  UserResponse? get user;

  /// Create a copy of ChannelBanResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelBanResponseCopyWith<ChannelBanResponse> get copyWith => _$ChannelBanResponseCopyWithImpl<ChannelBanResponse>(
    this as ChannelBanResponse,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelBanResponse &&
            (identical(other.channelBan, channelBan) || other.channelBan == channelBan) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.futureChannelBan, futureChannelBan) || other.futureChannelBan == futureChannelBan) &&
            const DeepCollectionEquality().equals(other.scopes, scopes) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channelBan,
    createdAt,
    futureChannelBan,
    const DeepCollectionEquality().hash(scopes),
    user,
  );

  @override
  String toString() {
    return 'ChannelBanResponse(channelBan: $channelBan, createdAt: $createdAt, futureChannelBan: $futureChannelBan, scopes: $scopes, user: $user)';
  }
}

/// @nodoc
abstract mixin class $ChannelBanResponseCopyWith<$Res> {
  factory $ChannelBanResponseCopyWith(
    ChannelBanResponse value,
    $Res Function(ChannelBanResponse) _then,
  ) = _$ChannelBanResponseCopyWithImpl;
  @useResult
  $Res call({
    ChannelBanScopeResponse? channelBan,
    DateTime createdAt,
    ChannelBanScopeResponse? futureChannelBan,
    List<String> scopes,
    UserResponse? user,
  });
}

/// @nodoc
class _$ChannelBanResponseCopyWithImpl<$Res> implements $ChannelBanResponseCopyWith<$Res> {
  _$ChannelBanResponseCopyWithImpl(this._self, this._then);

  final ChannelBanResponse _self;
  final $Res Function(ChannelBanResponse) _then;

  /// Create a copy of ChannelBanResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelBan = freezed,
    Object? createdAt = null,
    Object? futureChannelBan = freezed,
    Object? scopes = null,
    Object? user = freezed,
  }) {
    return _then(
      ChannelBanResponse(
        channelBan: freezed == channelBan
            ? _self.channelBan
            : channelBan // ignore: cast_nullable_to_non_nullable
                  as ChannelBanScopeResponse?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        futureChannelBan: freezed == futureChannelBan
            ? _self.futureChannelBan
            : futureChannelBan // ignore: cast_nullable_to_non_nullable
                  as ChannelBanScopeResponse?,
        scopes: null == scopes
            ? _self.scopes
            : scopes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponse?,
      ),
    );
  }
}
