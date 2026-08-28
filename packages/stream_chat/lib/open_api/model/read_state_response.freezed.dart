// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'read_state_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReadStateResponse {
  DateTime? get lastDeliveredAt;
  String? get lastDeliveredMessageId;
  DateTime get lastRead;
  String? get lastReadMessageId;
  int get unreadMessages;
  UserResponse get user;

  /// Create a copy of ReadStateResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReadStateResponseCopyWith<ReadStateResponse> get copyWith =>
      _$ReadStateResponseCopyWithImpl<ReadStateResponse>(
        this as ReadStateResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReadStateResponse &&
            (identical(other.lastDeliveredAt, lastDeliveredAt) ||
                other.lastDeliveredAt == lastDeliveredAt) &&
            (identical(other.lastDeliveredMessageId, lastDeliveredMessageId) ||
                other.lastDeliveredMessageId == lastDeliveredMessageId) &&
            (identical(other.lastRead, lastRead) ||
                other.lastRead == lastRead) &&
            (identical(other.lastReadMessageId, lastReadMessageId) ||
                other.lastReadMessageId == lastReadMessageId) &&
            (identical(other.unreadMessages, unreadMessages) ||
                other.unreadMessages == unreadMessages) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    lastDeliveredAt,
    lastDeliveredMessageId,
    lastRead,
    lastReadMessageId,
    unreadMessages,
    user,
  );

  @override
  String toString() {
    return 'ReadStateResponse(lastDeliveredAt: $lastDeliveredAt, lastDeliveredMessageId: $lastDeliveredMessageId, lastRead: $lastRead, lastReadMessageId: $lastReadMessageId, unreadMessages: $unreadMessages, user: $user)';
  }
}

/// @nodoc
abstract mixin class $ReadStateResponseCopyWith<$Res> {
  factory $ReadStateResponseCopyWith(
    ReadStateResponse value,
    $Res Function(ReadStateResponse) _then,
  ) = _$ReadStateResponseCopyWithImpl;
  @useResult
  $Res call({
    DateTime? lastDeliveredAt,
    String? lastDeliveredMessageId,
    DateTime lastRead,
    String? lastReadMessageId,
    int unreadMessages,
    UserResponse user,
  });
}

/// @nodoc
class _$ReadStateResponseCopyWithImpl<$Res>
    implements $ReadStateResponseCopyWith<$Res> {
  _$ReadStateResponseCopyWithImpl(this._self, this._then);

  final ReadStateResponse _self;
  final $Res Function(ReadStateResponse) _then;

  /// Create a copy of ReadStateResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lastDeliveredAt = freezed,
    Object? lastDeliveredMessageId = freezed,
    Object? lastRead = null,
    Object? lastReadMessageId = freezed,
    Object? unreadMessages = null,
    Object? user = null,
  }) {
    return _then(
      ReadStateResponse(
        lastDeliveredAt: freezed == lastDeliveredAt
            ? _self.lastDeliveredAt
            : lastDeliveredAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastDeliveredMessageId: freezed == lastDeliveredMessageId
            ? _self.lastDeliveredMessageId
            : lastDeliveredMessageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastRead: null == lastRead
            ? _self.lastRead
            : lastRead // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastReadMessageId: freezed == lastReadMessageId
            ? _self.lastReadMessageId
            : lastReadMessageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        unreadMessages: null == unreadMessages
            ? _self.unreadMessages
            : unreadMessages // ignore: cast_nullable_to_non_nullable
                  as int,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponse,
      ),
    );
  }
}
