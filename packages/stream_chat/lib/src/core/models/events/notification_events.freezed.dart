// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationAddedToChannelEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  int? get channelMemberCount;
  int? get channelMessageCount;
  ChannelModel get channel;
  Member get member;
  int? get totalUnreadCount;
  int? get unreadChannels;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of NotificationAddedToChannelEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationAddedToChannelEventCopyWith<NotificationAddedToChannelEvent> get copyWith =>
      _$NotificationAddedToChannelEventCopyWithImpl<NotificationAddedToChannelEvent>(
        this as NotificationAddedToChannelEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationAddedToChannelEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.member, member) || other.member == member) &&
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
    member,
    totalUnreadCount,
    unreadChannels,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'NotificationAddedToChannelEvent(cid: $cid, channelId: $channelId, channelType: $channelType, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channel: $channel, member: $member, totalUnreadCount: $totalUnreadCount, unreadChannels: $unreadChannels, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $NotificationAddedToChannelEventCopyWith<$Res> {
  factory $NotificationAddedToChannelEventCopyWith(
    NotificationAddedToChannelEvent value,
    $Res Function(NotificationAddedToChannelEvent) _then,
  ) = _$NotificationAddedToChannelEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? channelId,
    String? channelType,
    int? channelMemberCount,
    int? channelMessageCount,
    ChannelModel channel,
    Member member,
    int? totalUnreadCount,
    int? unreadChannels,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$NotificationAddedToChannelEventCopyWithImpl<$Res> implements $NotificationAddedToChannelEventCopyWith<$Res> {
  _$NotificationAddedToChannelEventCopyWithImpl(this._self, this._then);

  final NotificationAddedToChannelEvent _self;
  final $Res Function(NotificationAddedToChannelEvent) _then;

  /// Create a copy of NotificationAddedToChannelEvent
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
    Object? member = null,
    Object? totalUnreadCount = freezed,
    Object? unreadChannels = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      NotificationAddedToChannelEvent(
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
        member: null == member
            ? _self.member
            : member // ignore: cast_nullable_to_non_nullable
                  as Member,
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
mixin _$NotificationRemovedFromChannelEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  int? get channelMemberCount;
  int? get channelMessageCount;
  ChannelModel get channel;
  Member get member;
  User? get user;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of NotificationRemovedFromChannelEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationRemovedFromChannelEventCopyWith<NotificationRemovedFromChannelEvent> get copyWith =>
      _$NotificationRemovedFromChannelEventCopyWithImpl<NotificationRemovedFromChannelEvent>(
        this as NotificationRemovedFromChannelEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationRemovedFromChannelEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.member, member) || other.member == member) &&
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
    member,
    user,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'NotificationRemovedFromChannelEvent(cid: $cid, channelId: $channelId, channelType: $channelType, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channel: $channel, member: $member, user: $user, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $NotificationRemovedFromChannelEventCopyWith<$Res> {
  factory $NotificationRemovedFromChannelEventCopyWith(
    NotificationRemovedFromChannelEvent value,
    $Res Function(NotificationRemovedFromChannelEvent) _then,
  ) = _$NotificationRemovedFromChannelEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? channelId,
    String? channelType,
    int? channelMemberCount,
    int? channelMessageCount,
    ChannelModel channel,
    Member member,
    User? user,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$NotificationRemovedFromChannelEventCopyWithImpl<$Res>
    implements $NotificationRemovedFromChannelEventCopyWith<$Res> {
  _$NotificationRemovedFromChannelEventCopyWithImpl(this._self, this._then);

  final NotificationRemovedFromChannelEvent _self;
  final $Res Function(NotificationRemovedFromChannelEvent) _then;

  /// Create a copy of NotificationRemovedFromChannelEvent
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
    Object? member = null,
    Object? user = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      NotificationRemovedFromChannelEvent(
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
        member: null == member
            ? _self.member
            : member // ignore: cast_nullable_to_non_nullable
                  as Member,
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
mixin _$NotificationInvitedEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  int? get channelMemberCount;
  int? get channelMessageCount;
  ChannelModel get channel;
  Member get member;
  User? get user;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of NotificationInvitedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationInvitedEventCopyWith<NotificationInvitedEvent> get copyWith =>
      _$NotificationInvitedEventCopyWithImpl<NotificationInvitedEvent>(
        this as NotificationInvitedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationInvitedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.member, member) || other.member == member) &&
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
    member,
    user,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'NotificationInvitedEvent(cid: $cid, channelId: $channelId, channelType: $channelType, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channel: $channel, member: $member, user: $user, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $NotificationInvitedEventCopyWith<$Res> {
  factory $NotificationInvitedEventCopyWith(
    NotificationInvitedEvent value,
    $Res Function(NotificationInvitedEvent) _then,
  ) = _$NotificationInvitedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? channelId,
    String? channelType,
    int? channelMemberCount,
    int? channelMessageCount,
    ChannelModel channel,
    Member member,
    User? user,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$NotificationInvitedEventCopyWithImpl<$Res> implements $NotificationInvitedEventCopyWith<$Res> {
  _$NotificationInvitedEventCopyWithImpl(this._self, this._then);

  final NotificationInvitedEvent _self;
  final $Res Function(NotificationInvitedEvent) _then;

  /// Create a copy of NotificationInvitedEvent
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
    Object? member = null,
    Object? user = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      NotificationInvitedEvent(
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
        member: null == member
            ? _self.member
            : member // ignore: cast_nullable_to_non_nullable
                  as Member,
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
mixin _$NotificationInviteAcceptedEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  int? get channelMemberCount;
  int? get channelMessageCount;
  ChannelModel get channel;
  Member get member;
  User? get user;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of NotificationInviteAcceptedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationInviteAcceptedEventCopyWith<NotificationInviteAcceptedEvent> get copyWith =>
      _$NotificationInviteAcceptedEventCopyWithImpl<NotificationInviteAcceptedEvent>(
        this as NotificationInviteAcceptedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationInviteAcceptedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.member, member) || other.member == member) &&
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
    member,
    user,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'NotificationInviteAcceptedEvent(cid: $cid, channelId: $channelId, channelType: $channelType, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channel: $channel, member: $member, user: $user, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $NotificationInviteAcceptedEventCopyWith<$Res> {
  factory $NotificationInviteAcceptedEventCopyWith(
    NotificationInviteAcceptedEvent value,
    $Res Function(NotificationInviteAcceptedEvent) _then,
  ) = _$NotificationInviteAcceptedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? channelId,
    String? channelType,
    int? channelMemberCount,
    int? channelMessageCount,
    ChannelModel channel,
    Member member,
    User? user,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$NotificationInviteAcceptedEventCopyWithImpl<$Res> implements $NotificationInviteAcceptedEventCopyWith<$Res> {
  _$NotificationInviteAcceptedEventCopyWithImpl(this._self, this._then);

  final NotificationInviteAcceptedEvent _self;
  final $Res Function(NotificationInviteAcceptedEvent) _then;

  /// Create a copy of NotificationInviteAcceptedEvent
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
    Object? member = null,
    Object? user = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      NotificationInviteAcceptedEvent(
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
        member: null == member
            ? _self.member
            : member // ignore: cast_nullable_to_non_nullable
                  as Member,
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
mixin _$NotificationChannelDeletedEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  int? get channelMemberCount;
  int? get channelMessageCount;
  ChannelModel get channel;
  int? get totalUnreadCount;
  int? get unreadChannels;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of NotificationChannelDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationChannelDeletedEventCopyWith<NotificationChannelDeletedEvent> get copyWith =>
      _$NotificationChannelDeletedEventCopyWithImpl<NotificationChannelDeletedEvent>(
        this as NotificationChannelDeletedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationChannelDeletedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channel, channel) || other.channel == channel) &&
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
    totalUnreadCount,
    unreadChannels,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'NotificationChannelDeletedEvent(cid: $cid, channelId: $channelId, channelType: $channelType, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channel: $channel, totalUnreadCount: $totalUnreadCount, unreadChannels: $unreadChannels, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $NotificationChannelDeletedEventCopyWith<$Res> {
  factory $NotificationChannelDeletedEventCopyWith(
    NotificationChannelDeletedEvent value,
    $Res Function(NotificationChannelDeletedEvent) _then,
  ) = _$NotificationChannelDeletedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? channelId,
    String? channelType,
    int? channelMemberCount,
    int? channelMessageCount,
    ChannelModel channel,
    int? totalUnreadCount,
    int? unreadChannels,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$NotificationChannelDeletedEventCopyWithImpl<$Res> implements $NotificationChannelDeletedEventCopyWith<$Res> {
  _$NotificationChannelDeletedEventCopyWithImpl(this._self, this._then);

  final NotificationChannelDeletedEvent _self;
  final $Res Function(NotificationChannelDeletedEvent) _then;

  /// Create a copy of NotificationChannelDeletedEvent
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
    Object? totalUnreadCount = freezed,
    Object? unreadChannels = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      NotificationChannelDeletedEvent(
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
mixin _$NotificationChannelTruncatedEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  int? get channelMemberCount;
  int? get channelMessageCount;
  ChannelModel get channel;
  Message? get message;
  int? get totalUnreadCount;
  int? get unreadChannels;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of NotificationChannelTruncatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationChannelTruncatedEventCopyWith<NotificationChannelTruncatedEvent> get copyWith =>
      _$NotificationChannelTruncatedEventCopyWithImpl<NotificationChannelTruncatedEvent>(
        this as NotificationChannelTruncatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationChannelTruncatedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.message, message) || other.message == message) &&
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
    totalUnreadCount,
    unreadChannels,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'NotificationChannelTruncatedEvent(cid: $cid, channelId: $channelId, channelType: $channelType, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channel: $channel, message: $message, totalUnreadCount: $totalUnreadCount, unreadChannels: $unreadChannels, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $NotificationChannelTruncatedEventCopyWith<$Res> {
  factory $NotificationChannelTruncatedEventCopyWith(
    NotificationChannelTruncatedEvent value,
    $Res Function(NotificationChannelTruncatedEvent) _then,
  ) = _$NotificationChannelTruncatedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? channelId,
    String? channelType,
    int? channelMemberCount,
    int? channelMessageCount,
    ChannelModel channel,
    Message? message,
    int? totalUnreadCount,
    int? unreadChannels,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$NotificationChannelTruncatedEventCopyWithImpl<$Res>
    implements $NotificationChannelTruncatedEventCopyWith<$Res> {
  _$NotificationChannelTruncatedEventCopyWithImpl(this._self, this._then);

  final NotificationChannelTruncatedEvent _self;
  final $Res Function(NotificationChannelTruncatedEvent) _then;

  /// Create a copy of NotificationChannelTruncatedEvent
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
    Object? message = freezed,
    Object? totalUnreadCount = freezed,
    Object? unreadChannels = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      NotificationChannelTruncatedEvent(
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
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as Message?,
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
mixin _$NotificationMutesUpdatedEvent {
  OwnUser get me;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of NotificationMutesUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationMutesUpdatedEventCopyWith<NotificationMutesUpdatedEvent> get copyWith =>
      _$NotificationMutesUpdatedEventCopyWithImpl<NotificationMutesUpdatedEvent>(
        this as NotificationMutesUpdatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationMutesUpdatedEvent &&
            (identical(other.me, me) || other.me == me) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    me,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'NotificationMutesUpdatedEvent(me: $me, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $NotificationMutesUpdatedEventCopyWith<$Res> {
  factory $NotificationMutesUpdatedEventCopyWith(
    NotificationMutesUpdatedEvent value,
    $Res Function(NotificationMutesUpdatedEvent) _then,
  ) = _$NotificationMutesUpdatedEventCopyWithImpl;
  @useResult
  $Res call({
    OwnUser me,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$NotificationMutesUpdatedEventCopyWithImpl<$Res> implements $NotificationMutesUpdatedEventCopyWith<$Res> {
  _$NotificationMutesUpdatedEventCopyWithImpl(this._self, this._then);

  final NotificationMutesUpdatedEvent _self;
  final $Res Function(NotificationMutesUpdatedEvent) _then;

  /// Create a copy of NotificationMutesUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? me = null,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      NotificationMutesUpdatedEvent(
        me: null == me
            ? _self.me
            : me // ignore: cast_nullable_to_non_nullable
                  as OwnUser,
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
mixin _$NotificationChannelMutesUpdatedEvent {
  OwnUser get me;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of NotificationChannelMutesUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationChannelMutesUpdatedEventCopyWith<NotificationChannelMutesUpdatedEvent> get copyWith =>
      _$NotificationChannelMutesUpdatedEventCopyWithImpl<NotificationChannelMutesUpdatedEvent>(
        this as NotificationChannelMutesUpdatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationChannelMutesUpdatedEvent &&
            (identical(other.me, me) || other.me == me) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    me,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'NotificationChannelMutesUpdatedEvent(me: $me, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $NotificationChannelMutesUpdatedEventCopyWith<$Res> {
  factory $NotificationChannelMutesUpdatedEventCopyWith(
    NotificationChannelMutesUpdatedEvent value,
    $Res Function(NotificationChannelMutesUpdatedEvent) _then,
  ) = _$NotificationChannelMutesUpdatedEventCopyWithImpl;
  @useResult
  $Res call({
    OwnUser me,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$NotificationChannelMutesUpdatedEventCopyWithImpl<$Res>
    implements $NotificationChannelMutesUpdatedEventCopyWith<$Res> {
  _$NotificationChannelMutesUpdatedEventCopyWithImpl(this._self, this._then);

  final NotificationChannelMutesUpdatedEvent _self;
  final $Res Function(NotificationChannelMutesUpdatedEvent) _then;

  /// Create a copy of NotificationChannelMutesUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? me = null,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      NotificationChannelMutesUpdatedEvent(
        me: null == me
            ? _self.me
            : me // ignore: cast_nullable_to_non_nullable
                  as OwnUser,
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
mixin _$NotificationMarkReadEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  int? get channelMemberCount;
  int? get channelMessageCount;
  ChannelModel? get channel;
  User? get user;
  String? get lastReadMessageId;
  Thread? get thread;
  int get totalUnreadCount;
  int get unreadChannels;
  int? get unreadThreadMessages;
  int? get unreadThreads;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of NotificationMarkReadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationMarkReadEventCopyWith<NotificationMarkReadEvent> get copyWith =>
      _$NotificationMarkReadEventCopyWithImpl<NotificationMarkReadEvent>(
        this as NotificationMarkReadEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationMarkReadEvent &&
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
            (identical(other.totalUnreadCount, totalUnreadCount) || other.totalUnreadCount == totalUnreadCount) &&
            (identical(other.unreadChannels, unreadChannels) || other.unreadChannels == unreadChannels) &&
            (identical(other.unreadThreadMessages, unreadThreadMessages) ||
                other.unreadThreadMessages == unreadThreadMessages) &&
            (identical(other.unreadThreads, unreadThreads) || other.unreadThreads == unreadThreads) &&
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
    totalUnreadCount,
    unreadChannels,
    unreadThreadMessages,
    unreadThreads,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'NotificationMarkReadEvent(cid: $cid, channelId: $channelId, channelType: $channelType, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channel: $channel, user: $user, lastReadMessageId: $lastReadMessageId, thread: $thread, totalUnreadCount: $totalUnreadCount, unreadChannels: $unreadChannels, unreadThreadMessages: $unreadThreadMessages, unreadThreads: $unreadThreads, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $NotificationMarkReadEventCopyWith<$Res> {
  factory $NotificationMarkReadEventCopyWith(
    NotificationMarkReadEvent value,
    $Res Function(NotificationMarkReadEvent) _then,
  ) = _$NotificationMarkReadEventCopyWithImpl;
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
    int totalUnreadCount,
    int unreadChannels,
    int? unreadThreadMessages,
    int? unreadThreads,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$NotificationMarkReadEventCopyWithImpl<$Res> implements $NotificationMarkReadEventCopyWith<$Res> {
  _$NotificationMarkReadEventCopyWithImpl(this._self, this._then);

  final NotificationMarkReadEvent _self;
  final $Res Function(NotificationMarkReadEvent) _then;

  /// Create a copy of NotificationMarkReadEvent
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
    Object? totalUnreadCount = null,
    Object? unreadChannels = null,
    Object? unreadThreadMessages = freezed,
    Object? unreadThreads = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      NotificationMarkReadEvent(
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
        totalUnreadCount: null == totalUnreadCount
            ? _self.totalUnreadCount
            : totalUnreadCount // ignore: cast_nullable_to_non_nullable
                  as int,
        unreadChannels: null == unreadChannels
            ? _self.unreadChannels
            : unreadChannels // ignore: cast_nullable_to_non_nullable
                  as int,
        unreadThreadMessages: freezed == unreadThreadMessages
            ? _self.unreadThreadMessages
            : unreadThreadMessages // ignore: cast_nullable_to_non_nullable
                  as int?,
        unreadThreads: freezed == unreadThreads
            ? _self.unreadThreads
            : unreadThreads // ignore: cast_nullable_to_non_nullable
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
mixin _$NotificationMarkUnreadEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  int? get channelMemberCount;
  int? get channelMessageCount;
  ChannelModel? get channel;
  User? get user;
  String? get threadId;
  DateTime? get lastReadAt;
  String? get lastReadMessageId;
  int? get totalUnreadCount;
  int? get unreadChannels;
  int? get unreadMessages;
  int? get unreadThreadMessages;
  int? get unreadThreads;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of NotificationMarkUnreadEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationMarkUnreadEventCopyWith<NotificationMarkUnreadEvent> get copyWith =>
      _$NotificationMarkUnreadEventCopyWithImpl<NotificationMarkUnreadEvent>(
        this as NotificationMarkUnreadEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationMarkUnreadEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.threadId, threadId) || other.threadId == threadId) &&
            (identical(other.lastReadAt, lastReadAt) || other.lastReadAt == lastReadAt) &&
            (identical(other.lastReadMessageId, lastReadMessageId) || other.lastReadMessageId == lastReadMessageId) &&
            (identical(other.totalUnreadCount, totalUnreadCount) || other.totalUnreadCount == totalUnreadCount) &&
            (identical(other.unreadChannels, unreadChannels) || other.unreadChannels == unreadChannels) &&
            (identical(other.unreadMessages, unreadMessages) || other.unreadMessages == unreadMessages) &&
            (identical(other.unreadThreadMessages, unreadThreadMessages) ||
                other.unreadThreadMessages == unreadThreadMessages) &&
            (identical(other.unreadThreads, unreadThreads) || other.unreadThreads == unreadThreads) &&
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
    threadId,
    lastReadAt,
    lastReadMessageId,
    totalUnreadCount,
    unreadChannels,
    unreadMessages,
    unreadThreadMessages,
    unreadThreads,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'NotificationMarkUnreadEvent(cid: $cid, channelId: $channelId, channelType: $channelType, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channel: $channel, user: $user, threadId: $threadId, lastReadAt: $lastReadAt, lastReadMessageId: $lastReadMessageId, totalUnreadCount: $totalUnreadCount, unreadChannels: $unreadChannels, unreadMessages: $unreadMessages, unreadThreadMessages: $unreadThreadMessages, unreadThreads: $unreadThreads, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $NotificationMarkUnreadEventCopyWith<$Res> {
  factory $NotificationMarkUnreadEventCopyWith(
    NotificationMarkUnreadEvent value,
    $Res Function(NotificationMarkUnreadEvent) _then,
  ) = _$NotificationMarkUnreadEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? channelId,
    String? channelType,
    int? channelMemberCount,
    int? channelMessageCount,
    ChannelModel? channel,
    User? user,
    String? threadId,
    DateTime? lastReadAt,
    String? lastReadMessageId,
    int? totalUnreadCount,
    int? unreadChannels,
    int? unreadMessages,
    int? unreadThreadMessages,
    int? unreadThreads,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$NotificationMarkUnreadEventCopyWithImpl<$Res> implements $NotificationMarkUnreadEventCopyWith<$Res> {
  _$NotificationMarkUnreadEventCopyWithImpl(this._self, this._then);

  final NotificationMarkUnreadEvent _self;
  final $Res Function(NotificationMarkUnreadEvent) _then;

  /// Create a copy of NotificationMarkUnreadEvent
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
    Object? threadId = freezed,
    Object? lastReadAt = freezed,
    Object? lastReadMessageId = freezed,
    Object? totalUnreadCount = freezed,
    Object? unreadChannels = freezed,
    Object? unreadMessages = freezed,
    Object? unreadThreadMessages = freezed,
    Object? unreadThreads = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      NotificationMarkUnreadEvent(
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
        threadId: freezed == threadId
            ? _self.threadId
            : threadId // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastReadAt: freezed == lastReadAt
            ? _self.lastReadAt
            : lastReadAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastReadMessageId: freezed == lastReadMessageId
            ? _self.lastReadMessageId
            : lastReadMessageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalUnreadCount: freezed == totalUnreadCount
            ? _self.totalUnreadCount
            : totalUnreadCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        unreadChannels: freezed == unreadChannels
            ? _self.unreadChannels
            : unreadChannels // ignore: cast_nullable_to_non_nullable
                  as int?,
        unreadMessages: freezed == unreadMessages
            ? _self.unreadMessages
            : unreadMessages // ignore: cast_nullable_to_non_nullable
                  as int?,
        unreadThreadMessages: freezed == unreadThreadMessages
            ? _self.unreadThreadMessages
            : unreadThreadMessages // ignore: cast_nullable_to_non_nullable
                  as int?,
        unreadThreads: freezed == unreadThreads
            ? _self.unreadThreads
            : unreadThreads // ignore: cast_nullable_to_non_nullable
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
mixin _$NotificationMessageNewEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  int? get channelMemberCount;
  int? get channelMessageCount;
  ChannelModel get channel;
  Message get message;
  int get watcherCount;
  int? get totalUnreadCount;
  int? get unreadChannels;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of NotificationMessageNewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationMessageNewEventCopyWith<NotificationMessageNewEvent> get copyWith =>
      _$NotificationMessageNewEventCopyWithImpl<NotificationMessageNewEvent>(
        this as NotificationMessageNewEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationMessageNewEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.message, message) || other.message == message) &&
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
    watcherCount,
    totalUnreadCount,
    unreadChannels,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'NotificationMessageNewEvent(cid: $cid, channelId: $channelId, channelType: $channelType, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channel: $channel, message: $message, watcherCount: $watcherCount, totalUnreadCount: $totalUnreadCount, unreadChannels: $unreadChannels, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $NotificationMessageNewEventCopyWith<$Res> {
  factory $NotificationMessageNewEventCopyWith(
    NotificationMessageNewEvent value,
    $Res Function(NotificationMessageNewEvent) _then,
  ) = _$NotificationMessageNewEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? channelId,
    String? channelType,
    int? channelMemberCount,
    int? channelMessageCount,
    ChannelModel channel,
    Message message,
    int watcherCount,
    int? totalUnreadCount,
    int? unreadChannels,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$NotificationMessageNewEventCopyWithImpl<$Res> implements $NotificationMessageNewEventCopyWith<$Res> {
  _$NotificationMessageNewEventCopyWithImpl(this._self, this._then);

  final NotificationMessageNewEvent _self;
  final $Res Function(NotificationMessageNewEvent) _then;

  /// Create a copy of NotificationMessageNewEvent
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
    Object? message = null,
    Object? watcherCount = null,
    Object? totalUnreadCount = freezed,
    Object? unreadChannels = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      NotificationMessageNewEvent(
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
        message: null == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as Message,
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
mixin _$NotificationThreadMessageNewEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  int? get channelMemberCount;
  int? get channelMessageCount;
  ChannelModel get channel;
  Message get message;
  int get watcherCount;
  int? get unreadThreadMessages;
  int? get unreadThreads;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of NotificationThreadMessageNewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationThreadMessageNewEventCopyWith<NotificationThreadMessageNewEvent> get copyWith =>
      _$NotificationThreadMessageNewEventCopyWithImpl<NotificationThreadMessageNewEvent>(
        this as NotificationThreadMessageNewEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationThreadMessageNewEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.watcherCount, watcherCount) || other.watcherCount == watcherCount) &&
            (identical(other.unreadThreadMessages, unreadThreadMessages) ||
                other.unreadThreadMessages == unreadThreadMessages) &&
            (identical(other.unreadThreads, unreadThreads) || other.unreadThreads == unreadThreads) &&
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
    watcherCount,
    unreadThreadMessages,
    unreadThreads,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'NotificationThreadMessageNewEvent(cid: $cid, channelId: $channelId, channelType: $channelType, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channel: $channel, message: $message, watcherCount: $watcherCount, unreadThreadMessages: $unreadThreadMessages, unreadThreads: $unreadThreads, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $NotificationThreadMessageNewEventCopyWith<$Res> {
  factory $NotificationThreadMessageNewEventCopyWith(
    NotificationThreadMessageNewEvent value,
    $Res Function(NotificationThreadMessageNewEvent) _then,
  ) = _$NotificationThreadMessageNewEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    String? channelId,
    String? channelType,
    int? channelMemberCount,
    int? channelMessageCount,
    ChannelModel channel,
    Message message,
    int watcherCount,
    int? unreadThreadMessages,
    int? unreadThreads,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$NotificationThreadMessageNewEventCopyWithImpl<$Res>
    implements $NotificationThreadMessageNewEventCopyWith<$Res> {
  _$NotificationThreadMessageNewEventCopyWithImpl(this._self, this._then);

  final NotificationThreadMessageNewEvent _self;
  final $Res Function(NotificationThreadMessageNewEvent) _then;

  /// Create a copy of NotificationThreadMessageNewEvent
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
    Object? message = null,
    Object? watcherCount = null,
    Object? unreadThreadMessages = freezed,
    Object? unreadThreads = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      NotificationThreadMessageNewEvent(
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
        message: null == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as Message,
        watcherCount: null == watcherCount
            ? _self.watcherCount
            : watcherCount // ignore: cast_nullable_to_non_nullable
                  as int,
        unreadThreadMessages: freezed == unreadThreadMessages
            ? _self.unreadThreadMessages
            : unreadThreadMessages // ignore: cast_nullable_to_non_nullable
                  as int?,
        unreadThreads: freezed == unreadThreads
            ? _self.unreadThreads
            : unreadThreads // ignore: cast_nullable_to_non_nullable
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
mixin _$NotificationReminderDueEvent {
  String get cid;
  String get messageId;
  String? get parentId;
  MessageReminder get reminder;
  String get userId;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of NotificationReminderDueEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationReminderDueEventCopyWith<NotificationReminderDueEvent> get copyWith =>
      _$NotificationReminderDueEventCopyWithImpl<NotificationReminderDueEvent>(
        this as NotificationReminderDueEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationReminderDueEvent &&
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
    return 'NotificationReminderDueEvent(cid: $cid, messageId: $messageId, parentId: $parentId, reminder: $reminder, userId: $userId, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $NotificationReminderDueEventCopyWith<$Res> {
  factory $NotificationReminderDueEventCopyWith(
    NotificationReminderDueEvent value,
    $Res Function(NotificationReminderDueEvent) _then,
  ) = _$NotificationReminderDueEventCopyWithImpl;
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
class _$NotificationReminderDueEventCopyWithImpl<$Res> implements $NotificationReminderDueEventCopyWith<$Res> {
  _$NotificationReminderDueEventCopyWithImpl(this._self, this._then);

  final NotificationReminderDueEvent _self;
  final $Res Function(NotificationReminderDueEvent) _then;

  /// Create a copy of NotificationReminderDueEvent
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
      NotificationReminderDueEvent(
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
