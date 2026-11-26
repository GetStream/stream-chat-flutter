// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LocationSharedEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  int? get channelMemberCount;
  int? get channelMessageCount;
  ChannelModel? get channel;
  Message get message;
  User? get user;
  int? get totalUnreadCount;
  int? get unreadChannels;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of LocationSharedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LocationSharedEventCopyWith<LocationSharedEvent> get copyWith =>
      _$LocationSharedEventCopyWithImpl<LocationSharedEvent>(
        this as LocationSharedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LocationSharedEvent &&
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
    totalUnreadCount,
    unreadChannels,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'LocationSharedEvent(cid: $cid, channelId: $channelId, channelType: $channelType, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channel: $channel, message: $message, user: $user, totalUnreadCount: $totalUnreadCount, unreadChannels: $unreadChannels, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $LocationSharedEventCopyWith<$Res> {
  factory $LocationSharedEventCopyWith(
    LocationSharedEvent value,
    $Res Function(LocationSharedEvent) _then,
  ) = _$LocationSharedEventCopyWithImpl;
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
    int? totalUnreadCount,
    int? unreadChannels,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$LocationSharedEventCopyWithImpl<$Res> implements $LocationSharedEventCopyWith<$Res> {
  _$LocationSharedEventCopyWithImpl(this._self, this._then);

  final LocationSharedEvent _self;
  final $Res Function(LocationSharedEvent) _then;

  /// Create a copy of LocationSharedEvent
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
    Object? totalUnreadCount = freezed,
    Object? unreadChannels = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      LocationSharedEvent(
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
mixin _$LocationUpdatedEvent {
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

  /// Create a copy of LocationUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LocationUpdatedEventCopyWith<LocationUpdatedEvent> get copyWith =>
      _$LocationUpdatedEventCopyWithImpl<LocationUpdatedEvent>(
        this as LocationUpdatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LocationUpdatedEvent &&
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
    return 'LocationUpdatedEvent(cid: $cid, channelId: $channelId, channelType: $channelType, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, message: $message, user: $user, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $LocationUpdatedEventCopyWith<$Res> {
  factory $LocationUpdatedEventCopyWith(
    LocationUpdatedEvent value,
    $Res Function(LocationUpdatedEvent) _then,
  ) = _$LocationUpdatedEventCopyWithImpl;
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
class _$LocationUpdatedEventCopyWithImpl<$Res> implements $LocationUpdatedEventCopyWith<$Res> {
  _$LocationUpdatedEventCopyWithImpl(this._self, this._then);

  final LocationUpdatedEvent _self;
  final $Res Function(LocationUpdatedEvent) _then;

  /// Create a copy of LocationUpdatedEvent
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
      LocationUpdatedEvent(
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
mixin _$LocationExpiredEvent {
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

  /// Create a copy of LocationExpiredEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LocationExpiredEventCopyWith<LocationExpiredEvent> get copyWith =>
      _$LocationExpiredEventCopyWithImpl<LocationExpiredEvent>(
        this as LocationExpiredEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LocationExpiredEvent &&
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
    return 'LocationExpiredEvent(cid: $cid, channelId: $channelId, channelType: $channelType, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, message: $message, user: $user, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $LocationExpiredEventCopyWith<$Res> {
  factory $LocationExpiredEventCopyWith(
    LocationExpiredEvent value,
    $Res Function(LocationExpiredEvent) _then,
  ) = _$LocationExpiredEventCopyWithImpl;
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
class _$LocationExpiredEventCopyWithImpl<$Res> implements $LocationExpiredEventCopyWith<$Res> {
  _$LocationExpiredEventCopyWithImpl(this._self, this._then);

  final LocationExpiredEvent _self;
  final $Res Function(LocationExpiredEvent) _then;

  /// Create a copy of LocationExpiredEvent
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
      LocationExpiredEvent(
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
