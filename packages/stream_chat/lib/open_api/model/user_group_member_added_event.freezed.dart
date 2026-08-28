// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_group_member_added_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserGroupMemberAddedEvent {
  DateTime get createdAt;
  Map<String, Object?> get custom;
  List<String> get members;
  DateTime? get receivedAt;
  String get type;
  UserResponseCommonFields? get user;
  UserGroup? get userGroup;

  /// Create a copy of UserGroupMemberAddedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserGroupMemberAddedEventCopyWith<UserGroupMemberAddedEvent> get copyWith =>
      _$UserGroupMemberAddedEventCopyWithImpl<UserGroupMemberAddedEvent>(
        this as UserGroupMemberAddedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserGroupMemberAddedEvent &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.userGroup, userGroup) ||
                other.userGroup == userGroup));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    const DeepCollectionEquality().hash(members),
    receivedAt,
    type,
    user,
    userGroup,
  );

  @override
  String toString() {
    return 'UserGroupMemberAddedEvent(createdAt: $createdAt, custom: $custom, members: $members, receivedAt: $receivedAt, type: $type, user: $user, userGroup: $userGroup)';
  }
}

/// @nodoc
abstract mixin class $UserGroupMemberAddedEventCopyWith<$Res> {
  factory $UserGroupMemberAddedEventCopyWith(
    UserGroupMemberAddedEvent value,
    $Res Function(UserGroupMemberAddedEvent) _then,
  ) = _$UserGroupMemberAddedEventCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    Map<String, Object?> custom,
    List<String> members,
    DateTime? receivedAt,
    String type,
    UserResponseCommonFields? user,
    UserGroup? userGroup,
  });
}

/// @nodoc
class _$UserGroupMemberAddedEventCopyWithImpl<$Res>
    implements $UserGroupMemberAddedEventCopyWith<$Res> {
  _$UserGroupMemberAddedEventCopyWithImpl(this._self, this._then);

  final UserGroupMemberAddedEvent _self;
  final $Res Function(UserGroupMemberAddedEvent) _then;

  /// Create a copy of UserGroupMemberAddedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? custom = null,
    Object? members = null,
    Object? receivedAt = freezed,
    Object? type = null,
    Object? user = freezed,
    Object? userGroup = freezed,
  }) {
    return _then(
      UserGroupMemberAddedEvent(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        members: null == members
            ? _self.members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
        userGroup: freezed == userGroup
            ? _self.userGroup
            : userGroup // ignore: cast_nullable_to_non_nullable
                  as UserGroup?,
      ),
    );
  }
}
