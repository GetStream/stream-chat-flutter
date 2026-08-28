// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder_deleted_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReminderDeletedEvent {
  String get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  String get messageId;
  String? get parentId;
  DateTime? get receivedAt;
  ReminderResponseData get reminder;
  String get type;
  String get userId;

  /// Create a copy of ReminderDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReminderDeletedEventCopyWith<ReminderDeletedEvent> get copyWith =>
      _$ReminderDeletedEventCopyWithImpl<ReminderDeletedEvent>(
        this as ReminderDeletedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReminderDeletedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.reminder, reminder) ||
                other.reminder == reminder) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    messageId,
    parentId,
    receivedAt,
    reminder,
    type,
    userId,
  );

  @override
  String toString() {
    return 'ReminderDeletedEvent(cid: $cid, createdAt: $createdAt, custom: $custom, messageId: $messageId, parentId: $parentId, receivedAt: $receivedAt, reminder: $reminder, type: $type, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $ReminderDeletedEventCopyWith<$Res> {
  factory $ReminderDeletedEventCopyWith(
    ReminderDeletedEvent value,
    $Res Function(ReminderDeletedEvent) _then,
  ) = _$ReminderDeletedEventCopyWithImpl;
  @useResult
  $Res call({
    String cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    String messageId,
    String? parentId,
    DateTime? receivedAt,
    ReminderResponseData reminder,
    String type,
    String userId,
  });
}

/// @nodoc
class _$ReminderDeletedEventCopyWithImpl<$Res>
    implements $ReminderDeletedEventCopyWith<$Res> {
  _$ReminderDeletedEventCopyWithImpl(this._self, this._then);

  final ReminderDeletedEvent _self;
  final $Res Function(ReminderDeletedEvent) _then;

  /// Create a copy of ReminderDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = null,
    Object? createdAt = null,
    Object? custom = null,
    Object? messageId = null,
    Object? parentId = freezed,
    Object? receivedAt = freezed,
    Object? reminder = null,
    Object? type = null,
    Object? userId = null,
  }) {
    return _then(
      ReminderDeletedEvent(
        cid: null == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        messageId: null == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String,
        parentId: freezed == parentId
            ? _self.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        reminder: null == reminder
            ? _self.reminder
            : reminder // ignore: cast_nullable_to_non_nullable
                  as ReminderResponseData,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
