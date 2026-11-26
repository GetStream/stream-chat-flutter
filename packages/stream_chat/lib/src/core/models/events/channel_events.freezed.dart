// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelUpdatedEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  int? get channelMemberCount;
  int? get channelMessageCount;
  ChannelModel get channel;
  User? get user;
  Message? get message;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of ChannelUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelUpdatedEventCopyWith<ChannelUpdatedEvent> get copyWith =>
      _$ChannelUpdatedEventCopyWithImpl<ChannelUpdatedEvent>(
        this as ChannelUpdatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelUpdatedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.message, message) || other.message == message) &&
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
    channel,
    user,
    message,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'ChannelUpdatedEvent(cid: $cid, channelId: $channelId, channelType: $channelType, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channel: $channel, user: $user, message: $message, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $ChannelUpdatedEventCopyWith<$Res> {
  factory $ChannelUpdatedEventCopyWith(
    ChannelUpdatedEvent value,
    $Res Function(ChannelUpdatedEvent) _then,
  ) = _$ChannelUpdatedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? channelId,
    String? channelType,
    int? channelMemberCount,
    int? channelMessageCount,
    ChannelModel channel,
    User? user,
    Message? message,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$ChannelUpdatedEventCopyWithImpl<$Res> implements $ChannelUpdatedEventCopyWith<$Res> {
  _$ChannelUpdatedEventCopyWithImpl(this._self, this._then);

  final ChannelUpdatedEvent _self;
  final $Res Function(ChannelUpdatedEvent) _then;

  /// Create a copy of ChannelUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channel = null,
    Object? user = freezed,
    Object? message = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      ChannelUpdatedEvent(
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
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelModel,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User?,
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as Message?,
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
mixin _$ChannelDeletedEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  int? get channelMemberCount;
  int? get channelMessageCount;
  ChannelModel get channel;
  User? get user;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of ChannelDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelDeletedEventCopyWith<ChannelDeletedEvent> get copyWith =>
      _$ChannelDeletedEventCopyWithImpl<ChannelDeletedEvent>(
        this as ChannelDeletedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelDeletedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channel, channel) || other.channel == channel) &&
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
    channel,
    user,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'ChannelDeletedEvent(cid: $cid, channelId: $channelId, channelType: $channelType, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channel: $channel, user: $user, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $ChannelDeletedEventCopyWith<$Res> {
  factory $ChannelDeletedEventCopyWith(
    ChannelDeletedEvent value,
    $Res Function(ChannelDeletedEvent) _then,
  ) = _$ChannelDeletedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? channelId,
    String? channelType,
    int? channelMemberCount,
    int? channelMessageCount,
    ChannelModel channel,
    User? user,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$ChannelDeletedEventCopyWithImpl<$Res> implements $ChannelDeletedEventCopyWith<$Res> {
  _$ChannelDeletedEventCopyWithImpl(this._self, this._then);

  final ChannelDeletedEvent _self;
  final $Res Function(ChannelDeletedEvent) _then;

  /// Create a copy of ChannelDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channel = null,
    Object? user = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      ChannelDeletedEvent(
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
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelModel,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User?,
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
mixin _$ChannelTruncatedEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  int? get channelMemberCount;
  int? get channelMessageCount;
  ChannelModel get channel;
  User? get user;
  Message? get message;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of ChannelTruncatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelTruncatedEventCopyWith<ChannelTruncatedEvent> get copyWith =>
      _$ChannelTruncatedEventCopyWithImpl<ChannelTruncatedEvent>(
        this as ChannelTruncatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelTruncatedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.message, message) || other.message == message) &&
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
    channel,
    user,
    message,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'ChannelTruncatedEvent(cid: $cid, channelId: $channelId, channelType: $channelType, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channel: $channel, user: $user, message: $message, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $ChannelTruncatedEventCopyWith<$Res> {
  factory $ChannelTruncatedEventCopyWith(
    ChannelTruncatedEvent value,
    $Res Function(ChannelTruncatedEvent) _then,
  ) = _$ChannelTruncatedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? channelId,
    String? channelType,
    int? channelMemberCount,
    int? channelMessageCount,
    ChannelModel channel,
    User? user,
    Message? message,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$ChannelTruncatedEventCopyWithImpl<$Res> implements $ChannelTruncatedEventCopyWith<$Res> {
  _$ChannelTruncatedEventCopyWithImpl(this._self, this._then);

  final ChannelTruncatedEvent _self;
  final $Res Function(ChannelTruncatedEvent) _then;

  /// Create a copy of ChannelTruncatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channel = null,
    Object? user = freezed,
    Object? message = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      ChannelTruncatedEvent(
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
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelModel,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User?,
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as Message?,
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
mixin _$ChannelHiddenEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  int? get channelMemberCount;
  int? get channelMessageCount;
  ChannelModel get channel;
  User? get user;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of ChannelHiddenEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelHiddenEventCopyWith<ChannelHiddenEvent> get copyWith => _$ChannelHiddenEventCopyWithImpl<ChannelHiddenEvent>(
    this as ChannelHiddenEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelHiddenEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channel, channel) || other.channel == channel) &&
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
    channel,
    user,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'ChannelHiddenEvent(cid: $cid, channelId: $channelId, channelType: $channelType, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channel: $channel, user: $user, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $ChannelHiddenEventCopyWith<$Res> {
  factory $ChannelHiddenEventCopyWith(
    ChannelHiddenEvent value,
    $Res Function(ChannelHiddenEvent) _then,
  ) = _$ChannelHiddenEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? channelId,
    String? channelType,
    int? channelMemberCount,
    int? channelMessageCount,
    ChannelModel channel,
    User? user,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$ChannelHiddenEventCopyWithImpl<$Res> implements $ChannelHiddenEventCopyWith<$Res> {
  _$ChannelHiddenEventCopyWithImpl(this._self, this._then);

  final ChannelHiddenEvent _self;
  final $Res Function(ChannelHiddenEvent) _then;

  /// Create a copy of ChannelHiddenEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channel = null,
    Object? user = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      ChannelHiddenEvent(
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
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelModel,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User?,
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
mixin _$ChannelVisibleEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  int? get channelMemberCount;
  int? get channelMessageCount;
  ChannelModel get channel;
  User? get user;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of ChannelVisibleEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelVisibleEventCopyWith<ChannelVisibleEvent> get copyWith =>
      _$ChannelVisibleEventCopyWithImpl<ChannelVisibleEvent>(
        this as ChannelVisibleEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelVisibleEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channel, channel) || other.channel == channel) &&
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
    channel,
    user,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'ChannelVisibleEvent(cid: $cid, channelId: $channelId, channelType: $channelType, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channel: $channel, user: $user, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $ChannelVisibleEventCopyWith<$Res> {
  factory $ChannelVisibleEventCopyWith(
    ChannelVisibleEvent value,
    $Res Function(ChannelVisibleEvent) _then,
  ) = _$ChannelVisibleEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? channelId,
    String? channelType,
    int? channelMemberCount,
    int? channelMessageCount,
    ChannelModel channel,
    User? user,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$ChannelVisibleEventCopyWithImpl<$Res> implements $ChannelVisibleEventCopyWith<$Res> {
  _$ChannelVisibleEventCopyWithImpl(this._self, this._then);

  final ChannelVisibleEvent _self;
  final $Res Function(ChannelVisibleEvent) _then;

  /// Create a copy of ChannelVisibleEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channel = null,
    Object? user = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      ChannelVisibleEvent(
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
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelModel,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User?,
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
