// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserUpdatedEvent {
  User get user;
  PrivacySettings? get privacySettings;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of UserUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserUpdatedEventCopyWith<UserUpdatedEvent> get copyWith => _$UserUpdatedEventCopyWithImpl<UserUpdatedEvent>(
    this as UserUpdatedEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserUpdatedEvent &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.privacySettings, privacySettings) || other.privacySettings == privacySettings) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    user,
    privacySettings,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'UserUpdatedEvent(user: $user, privacySettings: $privacySettings, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
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
    User user,
    PrivacySettings? privacySettings,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$UserUpdatedEventCopyWithImpl<$Res> implements $UserUpdatedEventCopyWith<$Res> {
  _$UserUpdatedEventCopyWithImpl(this._self, this._then);

  final UserUpdatedEvent _self;
  final $Res Function(UserUpdatedEvent) _then;

  /// Create a copy of UserUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? privacySettings = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      UserUpdatedEvent(
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User,
        privacySettings: freezed == privacySettings
            ? _self.privacySettings
            : privacySettings // ignore: cast_nullable_to_non_nullable
                  as PrivacySettings?,
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
mixin _$UserPresenceChangedEvent {
  User get user;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of UserPresenceChangedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserPresenceChangedEventCopyWith<UserPresenceChangedEvent> get copyWith =>
      _$UserPresenceChangedEventCopyWithImpl<UserPresenceChangedEvent>(
        this as UserPresenceChangedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserPresenceChangedEvent &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    user,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'UserPresenceChangedEvent(user: $user, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $UserPresenceChangedEventCopyWith<$Res> {
  factory $UserPresenceChangedEventCopyWith(
    UserPresenceChangedEvent value,
    $Res Function(UserPresenceChangedEvent) _then,
  ) = _$UserPresenceChangedEventCopyWithImpl;
  @useResult
  $Res call({
    User user,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$UserPresenceChangedEventCopyWithImpl<$Res> implements $UserPresenceChangedEventCopyWith<$Res> {
  _$UserPresenceChangedEventCopyWithImpl(this._self, this._then);

  final UserPresenceChangedEvent _self;
  final $Res Function(UserPresenceChangedEvent) _then;

  /// Create a copy of UserPresenceChangedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      UserPresenceChangedEvent(
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
mixin _$UserWatchingStartEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  User get user;
  int get watcherCount;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of UserWatchingStartEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserWatchingStartEventCopyWith<UserWatchingStartEvent> get copyWith =>
      _$UserWatchingStartEventCopyWithImpl<UserWatchingStartEvent>(
        this as UserWatchingStartEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserWatchingStartEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.watcherCount, watcherCount) || other.watcherCount == watcherCount) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    channelId,
    channelType,
    user,
    watcherCount,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'UserWatchingStartEvent(cid: $cid, channelId: $channelId, channelType: $channelType, user: $user, watcherCount: $watcherCount, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $UserWatchingStartEventCopyWith<$Res> {
  factory $UserWatchingStartEventCopyWith(
    UserWatchingStartEvent value,
    $Res Function(UserWatchingStartEvent) _then,
  ) = _$UserWatchingStartEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? channelId,
    String? channelType,
    User user,
    int watcherCount,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$UserWatchingStartEventCopyWithImpl<$Res> implements $UserWatchingStartEventCopyWith<$Res> {
  _$UserWatchingStartEventCopyWithImpl(this._self, this._then);

  final UserWatchingStartEvent _self;
  final $Res Function(UserWatchingStartEvent) _then;

  /// Create a copy of UserWatchingStartEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? user = null,
    Object? watcherCount = null,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      UserWatchingStartEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User,
        watcherCount: null == watcherCount
            ? _self.watcherCount
            : watcherCount // ignore: cast_nullable_to_non_nullable
                  as int,
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
mixin _$UserWatchingStopEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  User get user;
  int get watcherCount;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of UserWatchingStopEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserWatchingStopEventCopyWith<UserWatchingStopEvent> get copyWith =>
      _$UserWatchingStopEventCopyWithImpl<UserWatchingStopEvent>(
        this as UserWatchingStopEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserWatchingStopEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.watcherCount, watcherCount) || other.watcherCount == watcherCount) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    channelId,
    channelType,
    user,
    watcherCount,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'UserWatchingStopEvent(cid: $cid, channelId: $channelId, channelType: $channelType, user: $user, watcherCount: $watcherCount, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $UserWatchingStopEventCopyWith<$Res> {
  factory $UserWatchingStopEventCopyWith(
    UserWatchingStopEvent value,
    $Res Function(UserWatchingStopEvent) _then,
  ) = _$UserWatchingStopEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? channelId,
    String? channelType,
    User user,
    int watcherCount,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$UserWatchingStopEventCopyWithImpl<$Res> implements $UserWatchingStopEventCopyWith<$Res> {
  _$UserWatchingStopEventCopyWithImpl(this._self, this._then);

  final UserWatchingStopEvent _self;
  final $Res Function(UserWatchingStopEvent) _then;

  /// Create a copy of UserWatchingStopEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? user = null,
    Object? watcherCount = null,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      UserWatchingStopEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User,
        watcherCount: null == watcherCount
            ? _self.watcherCount
            : watcherCount // ignore: cast_nullable_to_non_nullable
                  as int,
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
mixin _$UserBannedEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  int? get channelMemberCount;
  int? get channelMessageCount;
  User get user;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of UserBannedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserBannedEventCopyWith<UserBannedEvent> get copyWith => _$UserBannedEventCopyWithImpl<UserBannedEvent>(
    this as UserBannedEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserBannedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    channelId,
    channelType,
    channelMemberCount,
    channelMessageCount,
    user,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'UserBannedEvent(cid: $cid, channelId: $channelId, channelType: $channelType, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, user: $user, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $UserBannedEventCopyWith<$Res> {
  factory $UserBannedEventCopyWith(
    UserBannedEvent value,
    $Res Function(UserBannedEvent) _then,
  ) = _$UserBannedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? channelId,
    String? channelType,
    int? channelMemberCount,
    int? channelMessageCount,
    User user,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$UserBannedEventCopyWithImpl<$Res> implements $UserBannedEventCopyWith<$Res> {
  _$UserBannedEventCopyWithImpl(this._self, this._then);

  final UserBannedEvent _self;
  final $Res Function(UserBannedEvent) _then;

  /// Create a copy of UserBannedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? user = null,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      UserBannedEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
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
mixin _$UserUnbannedEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  int? get channelMemberCount;
  int? get channelMessageCount;
  User get user;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of UserUnbannedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserUnbannedEventCopyWith<UserUnbannedEvent> get copyWith => _$UserUnbannedEventCopyWithImpl<UserUnbannedEvent>(
    this as UserUnbannedEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserUnbannedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    channelId,
    channelType,
    channelMemberCount,
    channelMessageCount,
    user,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'UserUnbannedEvent(cid: $cid, channelId: $channelId, channelType: $channelType, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, user: $user, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $UserUnbannedEventCopyWith<$Res> {
  factory $UserUnbannedEventCopyWith(
    UserUnbannedEvent value,
    $Res Function(UserUnbannedEvent) _then,
  ) = _$UserUnbannedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? channelId,
    String? channelType,
    int? channelMemberCount,
    int? channelMessageCount,
    User user,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$UserUnbannedEventCopyWithImpl<$Res> implements $UserUnbannedEventCopyWith<$Res> {
  _$UserUnbannedEventCopyWithImpl(this._self, this._then);

  final UserUnbannedEvent _self;
  final $Res Function(UserUnbannedEvent) _then;

  /// Create a copy of UserUnbannedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? user = null,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      UserUnbannedEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
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
mixin _$UserMessagesDeletedEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  int? get channelMemberCount;
  int? get channelMessageCount;
  User get user;
  bool? get hardDelete;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of UserMessagesDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserMessagesDeletedEventCopyWith<UserMessagesDeletedEvent> get copyWith =>
      _$UserMessagesDeletedEventCopyWithImpl<UserMessagesDeletedEvent>(
        this as UserMessagesDeletedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserMessagesDeletedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.hardDelete, hardDelete) || other.hardDelete == hardDelete) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    channelId,
    channelType,
    channelMemberCount,
    channelMessageCount,
    user,
    hardDelete,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'UserMessagesDeletedEvent(cid: $cid, channelId: $channelId, channelType: $channelType, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, user: $user, hardDelete: $hardDelete, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $UserMessagesDeletedEventCopyWith<$Res> {
  factory $UserMessagesDeletedEventCopyWith(
    UserMessagesDeletedEvent value,
    $Res Function(UserMessagesDeletedEvent) _then,
  ) = _$UserMessagesDeletedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? channelId,
    String? channelType,
    int? channelMemberCount,
    int? channelMessageCount,
    User user,
    bool? hardDelete,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$UserMessagesDeletedEventCopyWithImpl<$Res> implements $UserMessagesDeletedEventCopyWith<$Res> {
  _$UserMessagesDeletedEventCopyWithImpl(this._self, this._then);

  final UserMessagesDeletedEvent _self;
  final $Res Function(UserMessagesDeletedEvent) _then;

  /// Create a copy of UserMessagesDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? user = null,
    Object? hardDelete = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      UserMessagesDeletedEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User,
        hardDelete: freezed == hardDelete
            ? _self.hardDelete
            : hardDelete // ignore: cast_nullable_to_non_nullable
                  as bool?,
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
