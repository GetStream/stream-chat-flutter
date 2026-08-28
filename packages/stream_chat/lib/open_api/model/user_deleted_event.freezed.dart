// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_deleted_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserDeletedEvent {
  DateTime get createdAt;
  Map<String, Object?> get custom;
  String get deleteConversation;
  bool get deleteConversationChannels;
  String get deleteMessages;
  String get deleteUser;
  bool get hardDelete;
  bool get markMessagesDeleted;
  DateTime? get receivedAt;
  String get type;
  UserResponseCommonFields get user;

  /// Create a copy of UserDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserDeletedEventCopyWith<UserDeletedEvent> get copyWith =>
      _$UserDeletedEventCopyWithImpl<UserDeletedEvent>(
        this as UserDeletedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserDeletedEvent &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.deleteConversation, deleteConversation) ||
                other.deleteConversation == deleteConversation) &&
            (identical(
                  other.deleteConversationChannels,
                  deleteConversationChannels,
                ) ||
                other.deleteConversationChannels ==
                    deleteConversationChannels) &&
            (identical(other.deleteMessages, deleteMessages) ||
                other.deleteMessages == deleteMessages) &&
            (identical(other.deleteUser, deleteUser) ||
                other.deleteUser == deleteUser) &&
            (identical(other.hardDelete, hardDelete) ||
                other.hardDelete == hardDelete) &&
            (identical(other.markMessagesDeleted, markMessagesDeleted) ||
                other.markMessagesDeleted == markMessagesDeleted) &&
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
    deleteConversation,
    deleteConversationChannels,
    deleteMessages,
    deleteUser,
    hardDelete,
    markMessagesDeleted,
    receivedAt,
    type,
    user,
  );

  @override
  String toString() {
    return 'UserDeletedEvent(createdAt: $createdAt, custom: $custom, deleteConversation: $deleteConversation, deleteConversationChannels: $deleteConversationChannels, deleteMessages: $deleteMessages, deleteUser: $deleteUser, hardDelete: $hardDelete, markMessagesDeleted: $markMessagesDeleted, receivedAt: $receivedAt, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $UserDeletedEventCopyWith<$Res> {
  factory $UserDeletedEventCopyWith(
    UserDeletedEvent value,
    $Res Function(UserDeletedEvent) _then,
  ) = _$UserDeletedEventCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    Map<String, Object?> custom,
    String deleteConversation,
    bool deleteConversationChannels,
    String deleteMessages,
    String deleteUser,
    bool hardDelete,
    bool markMessagesDeleted,
    DateTime? receivedAt,
    String type,
    UserResponseCommonFields user,
  });
}

/// @nodoc
class _$UserDeletedEventCopyWithImpl<$Res>
    implements $UserDeletedEventCopyWith<$Res> {
  _$UserDeletedEventCopyWithImpl(this._self, this._then);

  final UserDeletedEvent _self;
  final $Res Function(UserDeletedEvent) _then;

  /// Create a copy of UserDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? custom = null,
    Object? deleteConversation = null,
    Object? deleteConversationChannels = null,
    Object? deleteMessages = null,
    Object? deleteUser = null,
    Object? hardDelete = null,
    Object? markMessagesDeleted = null,
    Object? receivedAt = freezed,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      UserDeletedEvent(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        deleteConversation: null == deleteConversation
            ? _self.deleteConversation
            : deleteConversation // ignore: cast_nullable_to_non_nullable
                  as String,
        deleteConversationChannels: null == deleteConversationChannels
            ? _self.deleteConversationChannels
            : deleteConversationChannels // ignore: cast_nullable_to_non_nullable
                  as bool,
        deleteMessages: null == deleteMessages
            ? _self.deleteMessages
            : deleteMessages // ignore: cast_nullable_to_non_nullable
                  as String,
        deleteUser: null == deleteUser
            ? _self.deleteUser
            : deleteUser // ignore: cast_nullable_to_non_nullable
                  as String,
        hardDelete: null == hardDelete
            ? _self.hardDelete
            : hardDelete // ignore: cast_nullable_to_non_nullable
                  as bool,
        markMessagesDeleted: null == markMessagesDeleted
            ? _self.markMessagesDeleted
            : markMessagesDeleted // ignore: cast_nullable_to_non_nullable
                  as bool,
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
                  as UserResponseCommonFields,
      ),
    );
  }
}
