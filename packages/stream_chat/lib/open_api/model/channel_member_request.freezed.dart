// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_member_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelMemberRequest {
  String? get channelRole;
  Map<String, Object?>? get custom;
  MemberUserRequest? get user;
  String? get userId;

  /// Create a copy of ChannelMemberRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelMemberRequestCopyWith<ChannelMemberRequest> get copyWith =>
      _$ChannelMemberRequestCopyWithImpl<ChannelMemberRequest>(
        this as ChannelMemberRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelMemberRequest &&
            (identical(other.channelRole, channelRole) ||
                other.channelRole == channelRole) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channelRole,
    const DeepCollectionEquality().hash(custom),
    user,
    userId,
  );

  @override
  String toString() {
    return 'ChannelMemberRequest(channelRole: $channelRole, custom: $custom, user: $user, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $ChannelMemberRequestCopyWith<$Res> {
  factory $ChannelMemberRequestCopyWith(
    ChannelMemberRequest value,
    $Res Function(ChannelMemberRequest) _then,
  ) = _$ChannelMemberRequestCopyWithImpl;
  @useResult
  $Res call({
    String? channelRole,
    Map<String, Object?>? custom,
    MemberUserRequest? user,
    String? userId,
  });
}

/// @nodoc
class _$ChannelMemberRequestCopyWithImpl<$Res>
    implements $ChannelMemberRequestCopyWith<$Res> {
  _$ChannelMemberRequestCopyWithImpl(this._self, this._then);

  final ChannelMemberRequest _self;
  final $Res Function(ChannelMemberRequest) _then;

  /// Create a copy of ChannelMemberRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelRole = freezed,
    Object? custom = freezed,
    Object? user = freezed,
    Object? userId = freezed,
  }) {
    return _then(
      ChannelMemberRequest(
        channelRole: freezed == channelRole
            ? _self.channelRole
            : channelRole // ignore: cast_nullable_to_non_nullable
                  as String?,
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as MemberUserRequest?,
        userId: freezed == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
