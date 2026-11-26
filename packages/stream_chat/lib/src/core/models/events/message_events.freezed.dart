// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageNewEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  int? get channelMemberCount;
  int? get channelMessageCount;
  ChannelModel? get channel;
  Message get message;
  User? get user;
  int get watcherCount;
  int? get totalUnreadCount;
  int? get unreadChannels;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of MessageNewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessageNewEventCopyWith<MessageNewEvent> get copyWith => _$MessageNewEventCopyWithImpl<MessageNewEvent>(
    this as MessageNewEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MessageNewEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.watcherCount, watcherCount) || other.watcherCount == watcherCount) &&
            (identical(other.totalUnreadCount, totalUnreadCount) || other.totalUnreadCount == totalUnreadCount) &&
            (identical(other.unreadChannels, unreadChannels) || other.unreadChannels == unreadChannels) &&
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
    message,
    user,
    watcherCount,
    totalUnreadCount,
    unreadChannels,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'MessageNewEvent(cid: $cid, channelId: $channelId, channelType: $channelType, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channel: $channel, message: $message, user: $user, watcherCount: $watcherCount, totalUnreadCount: $totalUnreadCount, unreadChannels: $unreadChannels, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $MessageNewEventCopyWith<$Res> {
  factory $MessageNewEventCopyWith(
    MessageNewEvent value,
    $Res Function(MessageNewEvent) _then,
  ) = _$MessageNewEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? channelId,
    String? channelType,
    int? channelMemberCount,
    int? channelMessageCount,
    ChannelModel? channel,
    Message message,
    User? user,
    int watcherCount,
    int? totalUnreadCount,
    int? unreadChannels,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$MessageNewEventCopyWithImpl<$Res> implements $MessageNewEventCopyWith<$Res> {
  _$MessageNewEventCopyWithImpl(this._self, this._then);

  final MessageNewEvent _self;
  final $Res Function(MessageNewEvent) _then;

  /// Create a copy of MessageNewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channel = freezed,
    Object? message = null,
    Object? user = freezed,
    Object? watcherCount = null,
    Object? totalUnreadCount = freezed,
    Object? unreadChannels = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      MessageNewEvent(
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
        channel: freezed == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelModel?,
        message: null == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as Message,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User?,
        watcherCount: null == watcherCount
            ? _self.watcherCount
            : watcherCount // ignore: cast_nullable_to_non_nullable
                  as int,
        totalUnreadCount: freezed == totalUnreadCount
            ? _self.totalUnreadCount
            : totalUnreadCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        unreadChannels: freezed == unreadChannels
            ? _self.unreadChannels
            : unreadChannels // ignore: cast_nullable_to_non_nullable
                  as int?,
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
mixin _$MessageUpdatedEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  int? get channelMemberCount;
  int? get channelMessageCount;
  Message get message;
  User? get user;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of MessageUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessageUpdatedEventCopyWith<MessageUpdatedEvent> get copyWith =>
      _$MessageUpdatedEventCopyWithImpl<MessageUpdatedEvent>(
        this as MessageUpdatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MessageUpdatedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.message, message) || other.message == message) &&
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
    message,
    user,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'MessageUpdatedEvent(cid: $cid, channelId: $channelId, channelType: $channelType, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, message: $message, user: $user, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $MessageUpdatedEventCopyWith<$Res> {
  factory $MessageUpdatedEventCopyWith(
    MessageUpdatedEvent value,
    $Res Function(MessageUpdatedEvent) _then,
  ) = _$MessageUpdatedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? channelId,
    String? channelType,
    int? channelMemberCount,
    int? channelMessageCount,
    Message message,
    User? user,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$MessageUpdatedEventCopyWithImpl<$Res> implements $MessageUpdatedEventCopyWith<$Res> {
  _$MessageUpdatedEventCopyWithImpl(this._self, this._then);

  final MessageUpdatedEvent _self;
  final $Res Function(MessageUpdatedEvent) _then;

  /// Create a copy of MessageUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? message = null,
    Object? user = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      MessageUpdatedEvent(
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
        message: null == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as Message,
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
mixin _$MessageDeletedEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  int? get channelMemberCount;
  int? get channelMessageCount;
  Message get message;
  User? get user;
  bool get hardDelete;
  bool? get deletedForMe;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of MessageDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessageDeletedEventCopyWith<MessageDeletedEvent> get copyWith =>
      _$MessageDeletedEventCopyWithImpl<MessageDeletedEvent>(
        this as MessageDeletedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MessageDeletedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.hardDelete, hardDelete) || other.hardDelete == hardDelete) &&
            (identical(other.deletedForMe, deletedForMe) || other.deletedForMe == deletedForMe) &&
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
    message,
    user,
    hardDelete,
    deletedForMe,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'MessageDeletedEvent(cid: $cid, channelId: $channelId, channelType: $channelType, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, message: $message, user: $user, hardDelete: $hardDelete, deletedForMe: $deletedForMe, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $MessageDeletedEventCopyWith<$Res> {
  factory $MessageDeletedEventCopyWith(
    MessageDeletedEvent value,
    $Res Function(MessageDeletedEvent) _then,
  ) = _$MessageDeletedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? channelId,
    String? channelType,
    int? channelMemberCount,
    int? channelMessageCount,
    Message message,
    User? user,
    bool hardDelete,
    bool? deletedForMe,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$MessageDeletedEventCopyWithImpl<$Res> implements $MessageDeletedEventCopyWith<$Res> {
  _$MessageDeletedEventCopyWithImpl(this._self, this._then);

  final MessageDeletedEvent _self;
  final $Res Function(MessageDeletedEvent) _then;

  /// Create a copy of MessageDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? message = null,
    Object? user = freezed,
    Object? hardDelete = null,
    Object? deletedForMe = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      MessageDeletedEvent(
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
        message: null == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as Message,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User?,
        hardDelete: null == hardDelete
            ? _self.hardDelete
            : hardDelete // ignore: cast_nullable_to_non_nullable
                  as bool,
        deletedForMe: freezed == deletedForMe
            ? _self.deletedForMe
            : deletedForMe // ignore: cast_nullable_to_non_nullable
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

/// @nodoc
mixin _$MessageReadEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  int? get channelMemberCount;
  int? get channelMessageCount;
  ChannelModel? get channel;
  User? get user;
  String? get lastReadMessageId;
  Thread? get thread;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of MessageReadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessageReadEventCopyWith<MessageReadEvent> get copyWith => _$MessageReadEventCopyWithImpl<MessageReadEvent>(
    this as MessageReadEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MessageReadEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.lastReadMessageId, lastReadMessageId) || other.lastReadMessageId == lastReadMessageId) &&
            (identical(other.thread, thread) || other.thread == thread) &&
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
    lastReadMessageId,
    thread,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'MessageReadEvent(cid: $cid, channelId: $channelId, channelType: $channelType, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channel: $channel, user: $user, lastReadMessageId: $lastReadMessageId, thread: $thread, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $MessageReadEventCopyWith<$Res> {
  factory $MessageReadEventCopyWith(
    MessageReadEvent value,
    $Res Function(MessageReadEvent) _then,
  ) = _$MessageReadEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? channelId,
    String? channelType,
    int? channelMemberCount,
    int? channelMessageCount,
    ChannelModel? channel,
    User? user,
    String? lastReadMessageId,
    Thread? thread,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$MessageReadEventCopyWithImpl<$Res> implements $MessageReadEventCopyWith<$Res> {
  _$MessageReadEventCopyWithImpl(this._self, this._then);

  final MessageReadEvent _self;
  final $Res Function(MessageReadEvent) _then;

  /// Create a copy of MessageReadEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channel = freezed,
    Object? user = freezed,
    Object? lastReadMessageId = freezed,
    Object? thread = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      MessageReadEvent(
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
        channel: freezed == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelModel?,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User?,
        lastReadMessageId: freezed == lastReadMessageId
            ? _self.lastReadMessageId
            : lastReadMessageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        thread: freezed == thread
            ? _self.thread
            : thread // ignore: cast_nullable_to_non_nullable
                  as Thread?,
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
mixin _$MessageDeliveredEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  int? get channelMemberCount;
  int? get channelMessageCount;
  ChannelModel? get channel;
  User? get user;
  DateTime? get lastDeliveredAt;
  String? get lastDeliveredMessageId;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of MessageDeliveredEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessageDeliveredEventCopyWith<MessageDeliveredEvent> get copyWith =>
      _$MessageDeliveredEventCopyWithImpl<MessageDeliveredEvent>(
        this as MessageDeliveredEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MessageDeliveredEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.lastDeliveredAt, lastDeliveredAt) || other.lastDeliveredAt == lastDeliveredAt) &&
            (identical(other.lastDeliveredMessageId, lastDeliveredMessageId) ||
                other.lastDeliveredMessageId == lastDeliveredMessageId) &&
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
    lastDeliveredAt,
    lastDeliveredMessageId,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'MessageDeliveredEvent(cid: $cid, channelId: $channelId, channelType: $channelType, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channel: $channel, user: $user, lastDeliveredAt: $lastDeliveredAt, lastDeliveredMessageId: $lastDeliveredMessageId, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $MessageDeliveredEventCopyWith<$Res> {
  factory $MessageDeliveredEventCopyWith(
    MessageDeliveredEvent value,
    $Res Function(MessageDeliveredEvent) _then,
  ) = _$MessageDeliveredEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? channelId,
    String? channelType,
    int? channelMemberCount,
    int? channelMessageCount,
    ChannelModel? channel,
    User? user,
    DateTime? lastDeliveredAt,
    String? lastDeliveredMessageId,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$MessageDeliveredEventCopyWithImpl<$Res> implements $MessageDeliveredEventCopyWith<$Res> {
  _$MessageDeliveredEventCopyWithImpl(this._self, this._then);

  final MessageDeliveredEvent _self;
  final $Res Function(MessageDeliveredEvent) _then;

  /// Create a copy of MessageDeliveredEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channel = freezed,
    Object? user = freezed,
    Object? lastDeliveredAt = freezed,
    Object? lastDeliveredMessageId = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      MessageDeliveredEvent(
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
        channel: freezed == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelModel?,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User?,
        lastDeliveredAt: freezed == lastDeliveredAt
            ? _self.lastDeliveredAt
            : lastDeliveredAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastDeliveredMessageId: freezed == lastDeliveredMessageId
            ? _self.lastDeliveredMessageId
            : lastDeliveredMessageId // ignore: cast_nullable_to_non_nullable
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
