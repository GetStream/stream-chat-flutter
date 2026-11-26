// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReminderCreatedEvent {
  String get cid;
  String get messageId;
  String? get parentId;
  MessageReminder get reminder;
  String get userId;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of ReminderCreatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReminderCreatedEventCopyWith<ReminderCreatedEvent> get copyWith =>
      _$ReminderCreatedEventCopyWithImpl<ReminderCreatedEvent>(
        this as ReminderCreatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReminderCreatedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.parentId, parentId) || other.parentId == parentId) &&
            (identical(other.reminder, reminder) || other.reminder == reminder) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    messageId,
    parentId,
    reminder,
    userId,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'ReminderCreatedEvent(cid: $cid, messageId: $messageId, parentId: $parentId, reminder: $reminder, userId: $userId, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $ReminderCreatedEventCopyWith<$Res> {
  factory $ReminderCreatedEventCopyWith(
    ReminderCreatedEvent value,
    $Res Function(ReminderCreatedEvent) _then,
  ) = _$ReminderCreatedEventCopyWithImpl;
  @useResult
  $Res call({
    String cid,
    String messageId,
    String? parentId,
    MessageReminder reminder,
    String userId,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$ReminderCreatedEventCopyWithImpl<$Res> implements $ReminderCreatedEventCopyWith<$Res> {
  _$ReminderCreatedEventCopyWithImpl(this._self, this._then);

  final ReminderCreatedEvent _self;
  final $Res Function(ReminderCreatedEvent) _then;

  /// Create a copy of ReminderCreatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = null,
    Object? messageId = null,
    Object? parentId = freezed,
    Object? reminder = null,
    Object? userId = null,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      ReminderCreatedEvent(
        cid: null == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String,
        messageId: null == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String,
        parentId: freezed == parentId
            ? _self.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        reminder: null == reminder
            ? _self.reminder
            : reminder // ignore: cast_nullable_to_non_nullable
                  as MessageReminder,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _self.createdAt!
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        isLocal: null == isLocal
            ? _self.isLocal
            : isLocal // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
mixin _$ReminderUpdatedEvent {
  String get cid;
  String get messageId;
  String? get parentId;
  MessageReminder get reminder;
  String get userId;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of ReminderUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReminderUpdatedEventCopyWith<ReminderUpdatedEvent> get copyWith =>
      _$ReminderUpdatedEventCopyWithImpl<ReminderUpdatedEvent>(
        this as ReminderUpdatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReminderUpdatedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.parentId, parentId) || other.parentId == parentId) &&
            (identical(other.reminder, reminder) || other.reminder == reminder) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    messageId,
    parentId,
    reminder,
    userId,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'ReminderUpdatedEvent(cid: $cid, messageId: $messageId, parentId: $parentId, reminder: $reminder, userId: $userId, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $ReminderUpdatedEventCopyWith<$Res> {
  factory $ReminderUpdatedEventCopyWith(
    ReminderUpdatedEvent value,
    $Res Function(ReminderUpdatedEvent) _then,
  ) = _$ReminderUpdatedEventCopyWithImpl;
  @useResult
  $Res call({
    String cid,
    String messageId,
    String? parentId,
    MessageReminder reminder,
    String userId,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$ReminderUpdatedEventCopyWithImpl<$Res> implements $ReminderUpdatedEventCopyWith<$Res> {
  _$ReminderUpdatedEventCopyWithImpl(this._self, this._then);

  final ReminderUpdatedEvent _self;
  final $Res Function(ReminderUpdatedEvent) _then;

  /// Create a copy of ReminderUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = null,
    Object? messageId = null,
    Object? parentId = freezed,
    Object? reminder = null,
    Object? userId = null,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      ReminderUpdatedEvent(
        cid: null == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String,
        messageId: null == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String,
        parentId: freezed == parentId
            ? _self.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        reminder: null == reminder
            ? _self.reminder
            : reminder // ignore: cast_nullable_to_non_nullable
                  as MessageReminder,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _self.createdAt!
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        isLocal: null == isLocal
            ? _self.isLocal
            : isLocal // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
mixin _$ReminderDeletedEvent {
  String get cid;
  String get messageId;
  String? get parentId;
  MessageReminder get reminder;
  String get userId;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

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
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.parentId, parentId) || other.parentId == parentId) &&
            (identical(other.reminder, reminder) || other.reminder == reminder) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    messageId,
    parentId,
    reminder,
    userId,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'ReminderDeletedEvent(cid: $cid, messageId: $messageId, parentId: $parentId, reminder: $reminder, userId: $userId, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
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
    String messageId,
    String? parentId,
    MessageReminder reminder,
    String userId,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$ReminderDeletedEventCopyWithImpl<$Res> implements $ReminderDeletedEventCopyWith<$Res> {
  _$ReminderDeletedEventCopyWithImpl(this._self, this._then);

  final ReminderDeletedEvent _self;
  final $Res Function(ReminderDeletedEvent) _then;

  /// Create a copy of ReminderDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = null,
    Object? messageId = null,
    Object? parentId = freezed,
    Object? reminder = null,
    Object? userId = null,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      ReminderDeletedEvent(
        cid: null == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String,
        messageId: null == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String,
        parentId: freezed == parentId
            ? _self.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        reminder: null == reminder
            ? _self.reminder
            : reminder // ignore: cast_nullable_to_non_nullable
                  as MessageReminder,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _self.createdAt!
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        isLocal: null == isLocal
            ? _self.isLocal
            : isLocal // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
