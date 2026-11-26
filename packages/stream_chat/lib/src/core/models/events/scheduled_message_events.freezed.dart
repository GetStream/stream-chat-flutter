// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scheduled_message_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduledMessageCreatedEvent {
  String? get cid;
  ScheduledMessage? get scheduledMessage;
  User get user;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of ScheduledMessageCreatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScheduledMessageCreatedEventCopyWith<ScheduledMessageCreatedEvent> get copyWith =>
      _$ScheduledMessageCreatedEventCopyWithImpl<ScheduledMessageCreatedEvent>(
        this as ScheduledMessageCreatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ScheduledMessageCreatedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.scheduledMessage, scheduledMessage) || other.scheduledMessage == scheduledMessage) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    scheduledMessage,
    user,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'ScheduledMessageCreatedEvent(cid: $cid, scheduledMessage: $scheduledMessage, user: $user, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $ScheduledMessageCreatedEventCopyWith<$Res> {
  factory $ScheduledMessageCreatedEventCopyWith(
    ScheduledMessageCreatedEvent value,
    $Res Function(ScheduledMessageCreatedEvent) _then,
  ) = _$ScheduledMessageCreatedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    ScheduledMessage? scheduledMessage,
    User user,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$ScheduledMessageCreatedEventCopyWithImpl<$Res> implements $ScheduledMessageCreatedEventCopyWith<$Res> {
  _$ScheduledMessageCreatedEventCopyWithImpl(this._self, this._then);

  final ScheduledMessageCreatedEvent _self;
  final $Res Function(ScheduledMessageCreatedEvent) _then;

  /// Create a copy of ScheduledMessageCreatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? scheduledMessage = freezed,
    Object? user = null,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      ScheduledMessageCreatedEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        scheduledMessage: freezed == scheduledMessage
            ? _self.scheduledMessage
            : scheduledMessage // ignore: cast_nullable_to_non_nullable
                  as ScheduledMessage?,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User,
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
mixin _$ScheduledMessageUpdatedEvent {
  String? get cid;
  ScheduledMessage? get scheduledMessage;
  User get user;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of ScheduledMessageUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScheduledMessageUpdatedEventCopyWith<ScheduledMessageUpdatedEvent> get copyWith =>
      _$ScheduledMessageUpdatedEventCopyWithImpl<ScheduledMessageUpdatedEvent>(
        this as ScheduledMessageUpdatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ScheduledMessageUpdatedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.scheduledMessage, scheduledMessage) || other.scheduledMessage == scheduledMessage) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    scheduledMessage,
    user,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'ScheduledMessageUpdatedEvent(cid: $cid, scheduledMessage: $scheduledMessage, user: $user, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $ScheduledMessageUpdatedEventCopyWith<$Res> {
  factory $ScheduledMessageUpdatedEventCopyWith(
    ScheduledMessageUpdatedEvent value,
    $Res Function(ScheduledMessageUpdatedEvent) _then,
  ) = _$ScheduledMessageUpdatedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    ScheduledMessage? scheduledMessage,
    User user,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$ScheduledMessageUpdatedEventCopyWithImpl<$Res> implements $ScheduledMessageUpdatedEventCopyWith<$Res> {
  _$ScheduledMessageUpdatedEventCopyWithImpl(this._self, this._then);

  final ScheduledMessageUpdatedEvent _self;
  final $Res Function(ScheduledMessageUpdatedEvent) _then;

  /// Create a copy of ScheduledMessageUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? scheduledMessage = freezed,
    Object? user = null,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      ScheduledMessageUpdatedEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        scheduledMessage: freezed == scheduledMessage
            ? _self.scheduledMessage
            : scheduledMessage // ignore: cast_nullable_to_non_nullable
                  as ScheduledMessage?,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User,
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
mixin _$ScheduledMessageDeletedEvent {
  String? get cid;
  ScheduledMessage? get scheduledMessage;
  User get user;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of ScheduledMessageDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScheduledMessageDeletedEventCopyWith<ScheduledMessageDeletedEvent> get copyWith =>
      _$ScheduledMessageDeletedEventCopyWithImpl<ScheduledMessageDeletedEvent>(
        this as ScheduledMessageDeletedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ScheduledMessageDeletedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.scheduledMessage, scheduledMessage) || other.scheduledMessage == scheduledMessage) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    scheduledMessage,
    user,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'ScheduledMessageDeletedEvent(cid: $cid, scheduledMessage: $scheduledMessage, user: $user, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $ScheduledMessageDeletedEventCopyWith<$Res> {
  factory $ScheduledMessageDeletedEventCopyWith(
    ScheduledMessageDeletedEvent value,
    $Res Function(ScheduledMessageDeletedEvent) _then,
  ) = _$ScheduledMessageDeletedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    ScheduledMessage? scheduledMessage,
    User user,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$ScheduledMessageDeletedEventCopyWithImpl<$Res> implements $ScheduledMessageDeletedEventCopyWith<$Res> {
  _$ScheduledMessageDeletedEventCopyWithImpl(this._self, this._then);

  final ScheduledMessageDeletedEvent _self;
  final $Res Function(ScheduledMessageDeletedEvent) _then;

  /// Create a copy of ScheduledMessageDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? scheduledMessage = freezed,
    Object? user = null,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      ScheduledMessageDeletedEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        scheduledMessage: freezed == scheduledMessage
            ? _self.scheduledMessage
            : scheduledMessage // ignore: cast_nullable_to_non_nullable
                  as ScheduledMessage?,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User,
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
mixin _$ScheduledMessageFailedEvent {
  String? get cid;
  ScheduledMessage? get scheduledMessage;
  User get user;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of ScheduledMessageFailedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScheduledMessageFailedEventCopyWith<ScheduledMessageFailedEvent> get copyWith =>
      _$ScheduledMessageFailedEventCopyWithImpl<ScheduledMessageFailedEvent>(
        this as ScheduledMessageFailedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ScheduledMessageFailedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.scheduledMessage, scheduledMessage) || other.scheduledMessage == scheduledMessage) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    scheduledMessage,
    user,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'ScheduledMessageFailedEvent(cid: $cid, scheduledMessage: $scheduledMessage, user: $user, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $ScheduledMessageFailedEventCopyWith<$Res> {
  factory $ScheduledMessageFailedEventCopyWith(
    ScheduledMessageFailedEvent value,
    $Res Function(ScheduledMessageFailedEvent) _then,
  ) = _$ScheduledMessageFailedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    ScheduledMessage? scheduledMessage,
    User user,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$ScheduledMessageFailedEventCopyWithImpl<$Res> implements $ScheduledMessageFailedEventCopyWith<$Res> {
  _$ScheduledMessageFailedEventCopyWithImpl(this._self, this._then);

  final ScheduledMessageFailedEvent _self;
  final $Res Function(ScheduledMessageFailedEvent) _then;

  /// Create a copy of ScheduledMessageFailedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? scheduledMessage = freezed,
    Object? user = null,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      ScheduledMessageFailedEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        scheduledMessage: freezed == scheduledMessage
            ? _self.scheduledMessage
            : scheduledMessage // ignore: cast_nullable_to_non_nullable
                  as ScheduledMessage?,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User,
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
mixin _$ScheduledMessageSentEvent {
  String? get cid;
  ScheduledMessage? get scheduledMessage;
  User get user;
  String? get messageId;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of ScheduledMessageSentEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScheduledMessageSentEventCopyWith<ScheduledMessageSentEvent> get copyWith =>
      _$ScheduledMessageSentEventCopyWithImpl<ScheduledMessageSentEvent>(
        this as ScheduledMessageSentEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ScheduledMessageSentEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.scheduledMessage, scheduledMessage) || other.scheduledMessage == scheduledMessage) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    scheduledMessage,
    user,
    messageId,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'ScheduledMessageSentEvent(cid: $cid, scheduledMessage: $scheduledMessage, user: $user, messageId: $messageId, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $ScheduledMessageSentEventCopyWith<$Res> {
  factory $ScheduledMessageSentEventCopyWith(
    ScheduledMessageSentEvent value,
    $Res Function(ScheduledMessageSentEvent) _then,
  ) = _$ScheduledMessageSentEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    ScheduledMessage? scheduledMessage,
    User user,
    String? messageId,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$ScheduledMessageSentEventCopyWithImpl<$Res> implements $ScheduledMessageSentEventCopyWith<$Res> {
  _$ScheduledMessageSentEventCopyWithImpl(this._self, this._then);

  final ScheduledMessageSentEvent _self;
  final $Res Function(ScheduledMessageSentEvent) _then;

  /// Create a copy of ScheduledMessageSentEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? scheduledMessage = freezed,
    Object? user = null,
    Object? messageId = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      ScheduledMessageSentEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        scheduledMessage: freezed == scheduledMessage
            ? _self.scheduledMessage
            : scheduledMessage // ignore: cast_nullable_to_non_nullable
                  as ScheduledMessage?,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User,
        messageId: freezed == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String?,
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
