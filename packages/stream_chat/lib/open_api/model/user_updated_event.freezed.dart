// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_updated_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserUpdatedEvent {
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String get type;
  UserResponsePrivacyFields get user;

  /// Create a copy of UserUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserUpdatedEventCopyWith<UserUpdatedEvent> get copyWith =>
      _$UserUpdatedEventCopyWithImpl<UserUpdatedEvent>(
        this as UserUpdatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserUpdatedEvent &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    type,
    user,
  );

  @override
  String toString() {
    return 'UserUpdatedEvent(createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $UserUpdatedEventCopyWith<$Res> {
  factory $UserUpdatedEventCopyWith(
    UserUpdatedEvent value,
    $Res Function(UserUpdatedEvent) _then,
  ) = _$UserUpdatedEventCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String type,
    UserResponsePrivacyFields user,
  });
}

/// @nodoc
class _$UserUpdatedEventCopyWithImpl<$Res>
    implements $UserUpdatedEventCopyWith<$Res> {
  _$UserUpdatedEventCopyWithImpl(this._self, this._then);

  final UserUpdatedEvent _self;
  final $Res Function(UserUpdatedEvent) _then;

  /// Create a copy of UserUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      UserUpdatedEvent(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponsePrivacyFields,
      ),
    );
  }
}
