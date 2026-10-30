// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AIIndicatorClearEvent {
  String? get channelId;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String get type;
  UserResponseCommonFields? get user;

  /// Create a copy of AIIndicatorClearEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AIIndicatorClearEventCopyWith<AIIndicatorClearEvent> get copyWith =>
      _$AIIndicatorClearEventCopyWithImpl<AIIndicatorClearEvent>(
        this as AIIndicatorClearEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AIIndicatorClearEvent &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channelId,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    type,
    user,
  );

  @override
  String toString() {
    return 'AIIndicatorClearEvent(channelId: $channelId, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $AIIndicatorClearEventCopyWith<$Res> {
  factory $AIIndicatorClearEventCopyWith(
    AIIndicatorClearEvent value,
    $Res Function(AIIndicatorClearEvent) _then,
  ) = _$AIIndicatorClearEventCopyWithImpl;
  @useResult
  $Res call({
    String? channelId,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String type,
    UserResponseCommonFields? user,
  });
}

/// @nodoc
class _$AIIndicatorClearEventCopyWithImpl<$Res> implements $AIIndicatorClearEventCopyWith<$Res> {
  _$AIIndicatorClearEventCopyWithImpl(this._self, this._then);

  final AIIndicatorClearEvent _self;
  final $Res Function(AIIndicatorClearEvent) _then;

  /// Create a copy of AIIndicatorClearEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      AIIndicatorClearEvent(
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$AIIndicatorStopEvent {
  String? get channelId;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String get type;
  UserResponseCommonFields? get user;

  /// Create a copy of AIIndicatorStopEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AIIndicatorStopEventCopyWith<AIIndicatorStopEvent> get copyWith =>
      _$AIIndicatorStopEventCopyWithImpl<AIIndicatorStopEvent>(
        this as AIIndicatorStopEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AIIndicatorStopEvent &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channelId,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    type,
    user,
  );

  @override
  String toString() {
    return 'AIIndicatorStopEvent(channelId: $channelId, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $AIIndicatorStopEventCopyWith<$Res> {
  factory $AIIndicatorStopEventCopyWith(
    AIIndicatorStopEvent value,
    $Res Function(AIIndicatorStopEvent) _then,
  ) = _$AIIndicatorStopEventCopyWithImpl;
  @useResult
  $Res call({
    String? channelId,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String type,
    UserResponseCommonFields? user,
  });
}

/// @nodoc
class _$AIIndicatorStopEventCopyWithImpl<$Res> implements $AIIndicatorStopEventCopyWith<$Res> {
  _$AIIndicatorStopEventCopyWithImpl(this._self, this._then);

  final AIIndicatorStopEvent _self;
  final $Res Function(AIIndicatorStopEvent) _then;

  /// Create a copy of AIIndicatorStopEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      AIIndicatorStopEvent(
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$AIIndicatorUpdateEvent {
  String? get aiMessage;
  String get aiState;
  String? get channelId;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  String get messageId;
  DateTime? get receivedAt;
  String get type;
  UserResponseCommonFields? get user;

  /// Create a copy of AIIndicatorUpdateEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AIIndicatorUpdateEventCopyWith<AIIndicatorUpdateEvent> get copyWith =>
      _$AIIndicatorUpdateEventCopyWithImpl<AIIndicatorUpdateEvent>(
        this as AIIndicatorUpdateEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AIIndicatorUpdateEvent &&
            (identical(other.aiMessage, aiMessage) || other.aiMessage == aiMessage) &&
            (identical(other.aiState, aiState) || other.aiState == aiState) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    aiMessage,
    aiState,
    channelId,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    messageId,
    receivedAt,
    type,
    user,
  );

  @override
  String toString() {
    return 'AIIndicatorUpdateEvent(aiMessage: $aiMessage, aiState: $aiState, channelId: $channelId, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, messageId: $messageId, receivedAt: $receivedAt, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $AIIndicatorUpdateEventCopyWith<$Res> {
  factory $AIIndicatorUpdateEventCopyWith(
    AIIndicatorUpdateEvent value,
    $Res Function(AIIndicatorUpdateEvent) _then,
  ) = _$AIIndicatorUpdateEventCopyWithImpl;
  @useResult
  $Res call({
    String? aiMessage,
    String aiState,
    String? channelId,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    String messageId,
    DateTime? receivedAt,
    String type,
    UserResponseCommonFields? user,
  });
}

/// @nodoc
class _$AIIndicatorUpdateEventCopyWithImpl<$Res> implements $AIIndicatorUpdateEventCopyWith<$Res> {
  _$AIIndicatorUpdateEventCopyWithImpl(this._self, this._then);

  final AIIndicatorUpdateEvent _self;
  final $Res Function(AIIndicatorUpdateEvent) _then;

  /// Create a copy of AIIndicatorUpdateEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? aiMessage = freezed,
    Object? aiState = null,
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? messageId = null,
    Object? receivedAt = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      AIIndicatorUpdateEvent(
        aiMessage: freezed == aiMessage
            ? _self.aiMessage
            : aiMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        aiState: null == aiState
            ? _self.aiState
            : aiState // ignore: cast_nullable_to_non_nullable
                  as String,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
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
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$AppUpdatedEvent {
  AppEventResponse get app;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String get type;

  /// Create a copy of AppUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AppUpdatedEventCopyWith<AppUpdatedEvent> get copyWith => _$AppUpdatedEventCopyWithImpl<AppUpdatedEvent>(
    this as AppUpdatedEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AppUpdatedEvent &&
            (identical(other.app, app) || other.app == app) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    app,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    type,
  );

  @override
  String toString() {
    return 'AppUpdatedEvent(app: $app, createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $AppUpdatedEventCopyWith<$Res> {
  factory $AppUpdatedEventCopyWith(
    AppUpdatedEvent value,
    $Res Function(AppUpdatedEvent) _then,
  ) = _$AppUpdatedEventCopyWithImpl;
  @useResult
  $Res call({
    AppEventResponse app,
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String type,
  });
}

/// @nodoc
class _$AppUpdatedEventCopyWithImpl<$Res> implements $AppUpdatedEventCopyWith<$Res> {
  _$AppUpdatedEventCopyWithImpl(this._self, this._then);

  final AppUpdatedEvent _self;
  final $Res Function(AppUpdatedEvent) _then;

  /// Create a copy of AppUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? app = null,
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? type = null,
  }) {
    return _then(
      AppUpdatedEvent(
        app: null == app
            ? _self.app
            : app // ignore: cast_nullable_to_non_nullable
                  as AppEventResponse,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$ChannelCreatedEvent {
  ChannelResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String? get team;
  String get type;
  UserResponseCommonFields? get user;

  /// Create a copy of ChannelCreatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelCreatedEventCopyWith<ChannelCreatedEvent> get copyWith =>
      _$ChannelCreatedEventCopyWithImpl<ChannelCreatedEvent>(
        this as ChannelCreatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelCreatedEvent &&
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    team,
    type,
    user,
  );

  @override
  String toString() {
    return 'ChannelCreatedEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, team: $team, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $ChannelCreatedEventCopyWith<$Res> {
  factory $ChannelCreatedEventCopyWith(
    ChannelCreatedEvent value,
    $Res Function(ChannelCreatedEvent) _then,
  ) = _$ChannelCreatedEventCopyWithImpl;
  @useResult
  $Res call({
    ChannelResponse channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String? team,
    String type,
    UserResponseCommonFields? user,
  });
}

/// @nodoc
class _$ChannelCreatedEventCopyWithImpl<$Res> implements $ChannelCreatedEventCopyWith<$Res> {
  _$ChannelCreatedEventCopyWithImpl(this._self, this._then);

  final ChannelCreatedEvent _self;
  final $Res Function(ChannelCreatedEvent) _then;

  /// Create a copy of ChannelCreatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = null,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      ChannelCreatedEvent(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$ChannelDeletedEvent {
  ChannelResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String? get team;
  String get type;
  UserResponseCommonFields? get user;

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
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    team,
    type,
    user,
  );

  @override
  String toString() {
    return 'ChannelDeletedEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, team: $team, type: $type, user: $user)';
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
    ChannelResponse channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String? team,
    String type,
    UserResponseCommonFields? user,
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
    Object? channel = null,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      ChannelDeletedEvent(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$ChannelForkedEvent {
  ChannelResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  ChannelForkSummary get fork;
  DateTime? get receivedAt;
  String? get team;
  String get type;
  UserResponseCommonFields? get user;

  /// Create a copy of ChannelForkedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelForkedEventCopyWith<ChannelForkedEvent> get copyWith => _$ChannelForkedEventCopyWithImpl<ChannelForkedEvent>(
    this as ChannelForkedEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelForkedEvent &&
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.fork, fork) || other.fork == fork) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    fork,
    receivedAt,
    team,
    type,
    user,
  );

  @override
  String toString() {
    return 'ChannelForkedEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, fork: $fork, receivedAt: $receivedAt, team: $team, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $ChannelForkedEventCopyWith<$Res> {
  factory $ChannelForkedEventCopyWith(
    ChannelForkedEvent value,
    $Res Function(ChannelForkedEvent) _then,
  ) = _$ChannelForkedEventCopyWithImpl;
  @useResult
  $Res call({
    ChannelResponse channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    ChannelForkSummary fork,
    DateTime? receivedAt,
    String? team,
    String type,
    UserResponseCommonFields? user,
  });
}

/// @nodoc
class _$ChannelForkedEventCopyWithImpl<$Res> implements $ChannelForkedEventCopyWith<$Res> {
  _$ChannelForkedEventCopyWithImpl(this._self, this._then);

  final ChannelForkedEvent _self;
  final $Res Function(ChannelForkedEvent) _then;

  /// Create a copy of ChannelForkedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = null,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? fork = null,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      ChannelForkedEvent(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        fork: null == fork
            ? _self.fork
            : fork // ignore: cast_nullable_to_non_nullable
                  as ChannelForkSummary,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$ChannelFrozenEvent {
  String? get channelId;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String get type;

  /// Create a copy of ChannelFrozenEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelFrozenEventCopyWith<ChannelFrozenEvent> get copyWith => _$ChannelFrozenEventCopyWithImpl<ChannelFrozenEvent>(
    this as ChannelFrozenEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelFrozenEvent &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channelId,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    type,
  );

  @override
  String toString() {
    return 'ChannelFrozenEvent(channelId: $channelId, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $ChannelFrozenEventCopyWith<$Res> {
  factory $ChannelFrozenEventCopyWith(
    ChannelFrozenEvent value,
    $Res Function(ChannelFrozenEvent) _then,
  ) = _$ChannelFrozenEventCopyWithImpl;
  @useResult
  $Res call({
    String? channelId,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String type,
  });
}

/// @nodoc
class _$ChannelFrozenEventCopyWithImpl<$Res> implements $ChannelFrozenEventCopyWith<$Res> {
  _$ChannelFrozenEventCopyWithImpl(this._self, this._then);

  final ChannelFrozenEvent _self;
  final $Res Function(ChannelFrozenEvent) _then;

  /// Create a copy of ChannelFrozenEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? type = null,
  }) {
    return _then(
      ChannelFrozenEvent(
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$ChannelHiddenEvent {
  ChannelResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  bool get clearHistory;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String? get team;
  String get type;
  UserResponseCommonFields? get user;

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
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.clearHistory, clearHistory) || other.clearHistory == clearHistory) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    clearHistory,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    team,
    type,
    user,
  );

  @override
  String toString() {
    return 'ChannelHiddenEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, clearHistory: $clearHistory, createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, team: $team, type: $type, user: $user)';
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
    ChannelResponse channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    bool clearHistory,
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String? team,
    String type,
    UserResponseCommonFields? user,
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
    Object? channel = null,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? clearHistory = null,
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      ChannelHiddenEvent(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        clearHistory: null == clearHistory
            ? _self.clearHistory
            : clearHistory // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$ChannelKickedEvent {
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String? get team;
  String get type;

  /// Create a copy of ChannelKickedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelKickedEventCopyWith<ChannelKickedEvent> get copyWith => _$ChannelKickedEventCopyWithImpl<ChannelKickedEvent>(
    this as ChannelKickedEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelKickedEvent &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    team,
    type,
  );

  @override
  String toString() {
    return 'ChannelKickedEvent(channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, team: $team, type: $type)';
  }
}

/// @nodoc
abstract mixin class $ChannelKickedEventCopyWith<$Res> {
  factory $ChannelKickedEventCopyWith(
    ChannelKickedEvent value,
    $Res Function(ChannelKickedEvent) _then,
  ) = _$ChannelKickedEventCopyWithImpl;
  @useResult
  $Res call({
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String? team,
    String type,
  });
}

/// @nodoc
class _$ChannelKickedEventCopyWithImpl<$Res> implements $ChannelKickedEventCopyWith<$Res> {
  _$ChannelKickedEventCopyWithImpl(this._self, this._then);

  final ChannelKickedEvent _self;
  final $Res Function(ChannelKickedEvent) _then;

  /// Create a copy of ChannelKickedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? type = null,
  }) {
    return _then(
      ChannelKickedEvent(
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$ChannelRewoundEvent {
  ChannelResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  ChannelRewindResponse get rewind;
  String? get team;
  String get type;
  UserResponseCommonFields? get user;

  /// Create a copy of ChannelRewoundEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelRewoundEventCopyWith<ChannelRewoundEvent> get copyWith =>
      _$ChannelRewoundEventCopyWithImpl<ChannelRewoundEvent>(
        this as ChannelRewoundEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelRewoundEvent &&
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.rewind, rewind) || other.rewind == rewind) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    rewind,
    team,
    type,
    user,
  );

  @override
  String toString() {
    return 'ChannelRewoundEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, rewind: $rewind, team: $team, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $ChannelRewoundEventCopyWith<$Res> {
  factory $ChannelRewoundEventCopyWith(
    ChannelRewoundEvent value,
    $Res Function(ChannelRewoundEvent) _then,
  ) = _$ChannelRewoundEventCopyWithImpl;
  @useResult
  $Res call({
    ChannelResponse channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    ChannelRewindResponse rewind,
    String? team,
    String type,
    UserResponseCommonFields? user,
  });
}

/// @nodoc
class _$ChannelRewoundEventCopyWithImpl<$Res> implements $ChannelRewoundEventCopyWith<$Res> {
  _$ChannelRewoundEventCopyWithImpl(this._self, this._then);

  final ChannelRewoundEvent _self;
  final $Res Function(ChannelRewoundEvent) _then;

  /// Create a copy of ChannelRewoundEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = null,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? rewind = null,
    Object? team = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      ChannelRewoundEvent(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        rewind: null == rewind
            ? _self.rewind
            : rewind // ignore: cast_nullable_to_non_nullable
                  as ChannelRewindResponse,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$ChannelTruncatedEvent {
  ChannelResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  MessageResponse? get message;
  String? get messageId;
  DateTime? get receivedAt;
  String? get team;
  String get type;
  UserResponseCommonFields? get user;

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
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    message,
    messageId,
    receivedAt,
    team,
    type,
    user,
  );

  @override
  String toString() {
    return 'ChannelTruncatedEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, message: $message, messageId: $messageId, receivedAt: $receivedAt, team: $team, type: $type, user: $user)';
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
    ChannelResponse channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    MessageResponse? message,
    String? messageId,
    DateTime? receivedAt,
    String? team,
    String type,
    UserResponseCommonFields? user,
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
    Object? channel = null,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? message = freezed,
    Object? messageId = freezed,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      ChannelTruncatedEvent(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse?,
        messageId: freezed == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$ChannelUnFrozenEvent {
  String? get channelId;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String get type;

  /// Create a copy of ChannelUnFrozenEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelUnFrozenEventCopyWith<ChannelUnFrozenEvent> get copyWith =>
      _$ChannelUnFrozenEventCopyWithImpl<ChannelUnFrozenEvent>(
        this as ChannelUnFrozenEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelUnFrozenEvent &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channelId,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    type,
  );

  @override
  String toString() {
    return 'ChannelUnFrozenEvent(channelId: $channelId, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $ChannelUnFrozenEventCopyWith<$Res> {
  factory $ChannelUnFrozenEventCopyWith(
    ChannelUnFrozenEvent value,
    $Res Function(ChannelUnFrozenEvent) _then,
  ) = _$ChannelUnFrozenEventCopyWithImpl;
  @useResult
  $Res call({
    String? channelId,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String type,
  });
}

/// @nodoc
class _$ChannelUnFrozenEventCopyWithImpl<$Res> implements $ChannelUnFrozenEventCopyWith<$Res> {
  _$ChannelUnFrozenEventCopyWithImpl(this._self, this._then);

  final ChannelUnFrozenEvent _self;
  final $Res Function(ChannelUnFrozenEvent) _then;

  /// Create a copy of ChannelUnFrozenEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? type = null,
  }) {
    return _then(
      ChannelUnFrozenEvent(
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$ChannelUpdatedEvent {
  ChannelResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  MessageResponse? get message;
  String? get messageId;
  DateTime? get receivedAt;
  String? get team;
  String get type;
  UserResponseCommonFields? get user;

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
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    message,
    messageId,
    receivedAt,
    team,
    type,
    user,
  );

  @override
  String toString() {
    return 'ChannelUpdatedEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, message: $message, messageId: $messageId, receivedAt: $receivedAt, team: $team, type: $type, user: $user)';
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
    ChannelResponse channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    MessageResponse? message,
    String? messageId,
    DateTime? receivedAt,
    String? team,
    String type,
    UserResponseCommonFields? user,
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
    Object? channel = null,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? message = freezed,
    Object? messageId = freezed,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      ChannelUpdatedEvent(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse?,
        messageId: freezed == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$ChannelVisibleEvent {
  ChannelResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String? get team;
  String get type;
  UserResponseCommonFields? get user;

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
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    team,
    type,
    user,
  );

  @override
  String toString() {
    return 'ChannelVisibleEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, team: $team, type: $type, user: $user)';
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
    ChannelResponse channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String? team,
    String type,
    UserResponseCommonFields? user,
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
    Object? channel = null,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      ChannelVisibleEvent(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$CustomEvent {
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String get type;

  /// Create a copy of CustomEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CustomEventCopyWith<CustomEvent> get copyWith =>
      _$CustomEventCopyWithImpl<CustomEvent>(this as CustomEvent, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CustomEvent &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    type,
  );

  @override
  String toString() {
    return 'CustomEvent(createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $CustomEventCopyWith<$Res> {
  factory $CustomEventCopyWith(
    CustomEvent value,
    $Res Function(CustomEvent) _then,
  ) = _$CustomEventCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String type,
  });
}

/// @nodoc
class _$CustomEventCopyWithImpl<$Res> implements $CustomEventCopyWith<$Res> {
  _$CustomEventCopyWithImpl(this._self, this._then);

  final CustomEvent _self;
  final $Res Function(CustomEvent) _then;

  /// Create a copy of CustomEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? type = null,
  }) {
    return _then(
      CustomEvent(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$DraftDeletedEvent {
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DraftResponse? get draft;
  String? get parentId;
  DateTime? get receivedAt;
  String get type;

  /// Create a copy of DraftDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DraftDeletedEventCopyWith<DraftDeletedEvent> get copyWith => _$DraftDeletedEventCopyWithImpl<DraftDeletedEvent>(
    this as DraftDeletedEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DraftDeletedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.draft, draft) || other.draft == draft) &&
            (identical(other.parentId, parentId) || other.parentId == parentId) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    draft,
    parentId,
    receivedAt,
    type,
  );

  @override
  String toString() {
    return 'DraftDeletedEvent(cid: $cid, createdAt: $createdAt, custom: $custom, draft: $draft, parentId: $parentId, receivedAt: $receivedAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $DraftDeletedEventCopyWith<$Res> {
  factory $DraftDeletedEventCopyWith(
    DraftDeletedEvent value,
    $Res Function(DraftDeletedEvent) _then,
  ) = _$DraftDeletedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    DraftResponse? draft,
    String? parentId,
    DateTime? receivedAt,
    String type,
  });
}

/// @nodoc
class _$DraftDeletedEventCopyWithImpl<$Res> implements $DraftDeletedEventCopyWith<$Res> {
  _$DraftDeletedEventCopyWithImpl(this._self, this._then);

  final DraftDeletedEvent _self;
  final $Res Function(DraftDeletedEvent) _then;

  /// Create a copy of DraftDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? draft = freezed,
    Object? parentId = freezed,
    Object? receivedAt = freezed,
    Object? type = null,
  }) {
    return _then(
      DraftDeletedEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        draft: freezed == draft
            ? _self.draft
            : draft // ignore: cast_nullable_to_non_nullable
                  as DraftResponse?,
        parentId: freezed == parentId
            ? _self.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$DraftUpdatedEvent {
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DraftResponse? get draft;
  String? get parentId;
  DateTime? get receivedAt;
  String get type;

  /// Create a copy of DraftUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DraftUpdatedEventCopyWith<DraftUpdatedEvent> get copyWith => _$DraftUpdatedEventCopyWithImpl<DraftUpdatedEvent>(
    this as DraftUpdatedEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DraftUpdatedEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.draft, draft) || other.draft == draft) &&
            (identical(other.parentId, parentId) || other.parentId == parentId) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    draft,
    parentId,
    receivedAt,
    type,
  );

  @override
  String toString() {
    return 'DraftUpdatedEvent(cid: $cid, createdAt: $createdAt, custom: $custom, draft: $draft, parentId: $parentId, receivedAt: $receivedAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $DraftUpdatedEventCopyWith<$Res> {
  factory $DraftUpdatedEventCopyWith(
    DraftUpdatedEvent value,
    $Res Function(DraftUpdatedEvent) _then,
  ) = _$DraftUpdatedEventCopyWithImpl;
  @useResult
  $Res call({
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    DraftResponse? draft,
    String? parentId,
    DateTime? receivedAt,
    String type,
  });
}

/// @nodoc
class _$DraftUpdatedEventCopyWithImpl<$Res> implements $DraftUpdatedEventCopyWith<$Res> {
  _$DraftUpdatedEventCopyWithImpl(this._self, this._then);

  final DraftUpdatedEvent _self;
  final $Res Function(DraftUpdatedEvent) _then;

  /// Create a copy of DraftUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? draft = freezed,
    Object? parentId = freezed,
    Object? receivedAt = freezed,
    Object? type = null,
  }) {
    return _then(
      DraftUpdatedEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        draft: freezed == draft
            ? _self.draft
            : draft // ignore: cast_nullable_to_non_nullable
                  as DraftResponse?,
        parentId: freezed == parentId
            ? _self.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$MaxStreakChangedEvent {
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String get type;

  /// Create a copy of MaxStreakChangedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MaxStreakChangedEventCopyWith<MaxStreakChangedEvent> get copyWith =>
      _$MaxStreakChangedEventCopyWithImpl<MaxStreakChangedEvent>(
        this as MaxStreakChangedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MaxStreakChangedEvent &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    type,
  );

  @override
  String toString() {
    return 'MaxStreakChangedEvent(createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $MaxStreakChangedEventCopyWith<$Res> {
  factory $MaxStreakChangedEventCopyWith(
    MaxStreakChangedEvent value,
    $Res Function(MaxStreakChangedEvent) _then,
  ) = _$MaxStreakChangedEventCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String type,
  });
}

/// @nodoc
class _$MaxStreakChangedEventCopyWithImpl<$Res> implements $MaxStreakChangedEventCopyWith<$Res> {
  _$MaxStreakChangedEventCopyWithImpl(this._self, this._then);

  final MaxStreakChangedEvent _self;
  final $Res Function(MaxStreakChangedEvent) _then;

  /// Create a copy of MaxStreakChangedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? type = null,
  }) {
    return _then(
      MaxStreakChangedEvent(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$MemberAddedEvent {
  ChannelResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  ChannelMemberResponse get member;
  DateTime? get receivedAt;
  String? get team;
  String get type;
  UserResponseCommonFields? get user;

  /// Create a copy of MemberAddedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MemberAddedEventCopyWith<MemberAddedEvent> get copyWith => _$MemberAddedEventCopyWithImpl<MemberAddedEvent>(
    this as MemberAddedEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MemberAddedEvent &&
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.member, member) || other.member == member) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    member,
    receivedAt,
    team,
    type,
    user,
  );

  @override
  String toString() {
    return 'MemberAddedEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, member: $member, receivedAt: $receivedAt, team: $team, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $MemberAddedEventCopyWith<$Res> {
  factory $MemberAddedEventCopyWith(
    MemberAddedEvent value,
    $Res Function(MemberAddedEvent) _then,
  ) = _$MemberAddedEventCopyWithImpl;
  @useResult
  $Res call({
    ChannelResponse channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    ChannelMemberResponse member,
    DateTime? receivedAt,
    String? team,
    String type,
    UserResponseCommonFields? user,
  });
}

/// @nodoc
class _$MemberAddedEventCopyWithImpl<$Res> implements $MemberAddedEventCopyWith<$Res> {
  _$MemberAddedEventCopyWithImpl(this._self, this._then);

  final MemberAddedEvent _self;
  final $Res Function(MemberAddedEvent) _then;

  /// Create a copy of MemberAddedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = null,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? member = null,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      MemberAddedEvent(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        member: null == member
            ? _self.member
            : member // ignore: cast_nullable_to_non_nullable
                  as ChannelMemberResponse,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$MemberRemovedEvent {
  ChannelResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  ChannelMemberResponse get member;
  DateTime? get receivedAt;
  String? get team;
  String get type;
  UserResponseCommonFields? get user;

  /// Create a copy of MemberRemovedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MemberRemovedEventCopyWith<MemberRemovedEvent> get copyWith => _$MemberRemovedEventCopyWithImpl<MemberRemovedEvent>(
    this as MemberRemovedEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MemberRemovedEvent &&
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.member, member) || other.member == member) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    member,
    receivedAt,
    team,
    type,
    user,
  );

  @override
  String toString() {
    return 'MemberRemovedEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, member: $member, receivedAt: $receivedAt, team: $team, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $MemberRemovedEventCopyWith<$Res> {
  factory $MemberRemovedEventCopyWith(
    MemberRemovedEvent value,
    $Res Function(MemberRemovedEvent) _then,
  ) = _$MemberRemovedEventCopyWithImpl;
  @useResult
  $Res call({
    ChannelResponse channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    ChannelMemberResponse member,
    DateTime? receivedAt,
    String? team,
    String type,
    UserResponseCommonFields? user,
  });
}

/// @nodoc
class _$MemberRemovedEventCopyWithImpl<$Res> implements $MemberRemovedEventCopyWith<$Res> {
  _$MemberRemovedEventCopyWithImpl(this._self, this._then);

  final MemberRemovedEvent _self;
  final $Res Function(MemberRemovedEvent) _then;

  /// Create a copy of MemberRemovedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = null,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? member = null,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      MemberRemovedEvent(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        member: null == member
            ? _self.member
            : member // ignore: cast_nullable_to_non_nullable
                  as ChannelMemberResponse,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$MemberUpdatedEvent {
  ChannelResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  ChannelMemberResponse get member;
  DateTime? get receivedAt;
  String? get team;
  String get type;
  UserResponseCommonFields? get user;

  /// Create a copy of MemberUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MemberUpdatedEventCopyWith<MemberUpdatedEvent> get copyWith => _$MemberUpdatedEventCopyWithImpl<MemberUpdatedEvent>(
    this as MemberUpdatedEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MemberUpdatedEvent &&
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.member, member) || other.member == member) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    member,
    receivedAt,
    team,
    type,
    user,
  );

  @override
  String toString() {
    return 'MemberUpdatedEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, member: $member, receivedAt: $receivedAt, team: $team, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $MemberUpdatedEventCopyWith<$Res> {
  factory $MemberUpdatedEventCopyWith(
    MemberUpdatedEvent value,
    $Res Function(MemberUpdatedEvent) _then,
  ) = _$MemberUpdatedEventCopyWithImpl;
  @useResult
  $Res call({
    ChannelResponse channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    ChannelMemberResponse member,
    DateTime? receivedAt,
    String? team,
    String type,
    UserResponseCommonFields? user,
  });
}

/// @nodoc
class _$MemberUpdatedEventCopyWithImpl<$Res> implements $MemberUpdatedEventCopyWith<$Res> {
  _$MemberUpdatedEventCopyWithImpl(this._self, this._then);

  final MemberUpdatedEvent _self;
  final $Res Function(MemberUpdatedEvent) _then;

  /// Create a copy of MemberUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = null,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? member = null,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      MemberUpdatedEvent(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        member: null == member
            ? _self.member
            : member // ignore: cast_nullable_to_non_nullable
                  as ChannelMemberResponse,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$MessageDeletedEvent {
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool? get deletedForMe;
  bool get hardDelete;
  MessageResponse get message;
  String get messageId;
  DateTime? get receivedAt;
  String? get team;
  String get type;
  UserResponseCommonFields? get user;

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
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.deletedForMe, deletedForMe) || other.deletedForMe == deletedForMe) &&
            (identical(other.hardDelete, hardDelete) || other.hardDelete == hardDelete) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    deletedForMe,
    hardDelete,
    message,
    messageId,
    receivedAt,
    team,
    type,
    user,
  );

  @override
  String toString() {
    return 'MessageDeletedEvent(channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, deletedForMe: $deletedForMe, hardDelete: $hardDelete, message: $message, messageId: $messageId, receivedAt: $receivedAt, team: $team, type: $type, user: $user)';
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
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    bool? deletedForMe,
    bool hardDelete,
    MessageResponse message,
    String messageId,
    DateTime? receivedAt,
    String? team,
    String type,
    UserResponseCommonFields? user,
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
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? deletedForMe = freezed,
    Object? hardDelete = null,
    Object? message = null,
    Object? messageId = null,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      MessageDeletedEvent(
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        deletedForMe: freezed == deletedForMe
            ? _self.deletedForMe
            : deletedForMe // ignore: cast_nullable_to_non_nullable
                  as bool?,
        hardDelete: null == hardDelete
            ? _self.hardDelete
            : hardDelete // ignore: cast_nullable_to_non_nullable
                  as bool,
        message: null == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse,
        messageId: null == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$MessageDeliveredEvent {
  ChannelResponse? get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get lastDeliveredAt;
  String? get lastDeliveredMessageId;
  DateTime? get receivedAt;
  String? get team;
  String get type;
  UserResponseCommonFields? get user;

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
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.lastDeliveredAt, lastDeliveredAt) || other.lastDeliveredAt == lastDeliveredAt) &&
            (identical(other.lastDeliveredMessageId, lastDeliveredMessageId) ||
                other.lastDeliveredMessageId == lastDeliveredMessageId) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    lastDeliveredAt,
    lastDeliveredMessageId,
    receivedAt,
    team,
    type,
    user,
  );

  @override
  String toString() {
    return 'MessageDeliveredEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, lastDeliveredAt: $lastDeliveredAt, lastDeliveredMessageId: $lastDeliveredMessageId, receivedAt: $receivedAt, team: $team, type: $type, user: $user)';
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
    ChannelResponse? channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? lastDeliveredAt,
    String? lastDeliveredMessageId,
    DateTime? receivedAt,
    String? team,
    String type,
    UserResponseCommonFields? user,
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
    Object? channel = freezed,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? lastDeliveredAt = freezed,
    Object? lastDeliveredMessageId = freezed,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      MessageDeliveredEvent(
        channel: freezed == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse?,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        lastDeliveredAt: freezed == lastDeliveredAt
            ? _self.lastDeliveredAt
            : lastDeliveredAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastDeliveredMessageId: freezed == lastDeliveredMessageId
            ? _self.lastDeliveredMessageId
            : lastDeliveredMessageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$MessageNewEvent {
  ChannelResponse? get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  Map<String, int>? get groupedUnreadChannels;
  MessageResponse get message;
  String get messageId;
  String? get parentAuthor;
  DateTime? get receivedAt;
  String? get team;
  List<UserResponseCommonFields>? get threadParticipants;
  int? get totalUnreadCount;
  String get type;
  int? get unreadChannels;
  int? get unreadCount;
  UserResponseCommonFields? get user;
  int get watcherCount;

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
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            const DeepCollectionEquality().equals(
              other.groupedUnreadChannels,
              groupedUnreadChannels,
            ) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.parentAuthor, parentAuthor) || other.parentAuthor == parentAuthor) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            const DeepCollectionEquality().equals(
              other.threadParticipants,
              threadParticipants,
            ) &&
            (identical(other.totalUnreadCount, totalUnreadCount) || other.totalUnreadCount == totalUnreadCount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.unreadChannels, unreadChannels) || other.unreadChannels == unreadChannels) &&
            (identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.watcherCount, watcherCount) || other.watcherCount == watcherCount));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    const DeepCollectionEquality().hash(groupedUnreadChannels),
    message,
    messageId,
    parentAuthor,
    receivedAt,
    team,
    const DeepCollectionEquality().hash(threadParticipants),
    totalUnreadCount,
    type,
    unreadChannels,
    unreadCount,
    user,
    watcherCount,
  ]);

  @override
  String toString() {
    return 'MessageNewEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, groupedUnreadChannels: $groupedUnreadChannels, message: $message, messageId: $messageId, parentAuthor: $parentAuthor, receivedAt: $receivedAt, team: $team, threadParticipants: $threadParticipants, totalUnreadCount: $totalUnreadCount, type: $type, unreadChannels: $unreadChannels, unreadCount: $unreadCount, user: $user, watcherCount: $watcherCount)';
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
    ChannelResponse? channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    Map<String, int>? groupedUnreadChannels,
    MessageResponse message,
    String messageId,
    String? parentAuthor,
    DateTime? receivedAt,
    String? team,
    List<UserResponseCommonFields>? threadParticipants,
    int? totalUnreadCount,
    String type,
    int? unreadChannels,
    int? unreadCount,
    UserResponseCommonFields? user,
    int watcherCount,
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
    Object? channel = freezed,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? groupedUnreadChannels = freezed,
    Object? message = null,
    Object? messageId = null,
    Object? parentAuthor = freezed,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? threadParticipants = freezed,
    Object? totalUnreadCount = freezed,
    Object? type = null,
    Object? unreadChannels = freezed,
    Object? unreadCount = freezed,
    Object? user = freezed,
    Object? watcherCount = null,
  }) {
    return _then(
      MessageNewEvent(
        channel: freezed == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse?,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        groupedUnreadChannels: freezed == groupedUnreadChannels
            ? _self.groupedUnreadChannels
            : groupedUnreadChannels // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>?,
        message: null == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse,
        messageId: null == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String,
        parentAuthor: freezed == parentAuthor
            ? _self.parentAuthor
            : parentAuthor // ignore: cast_nullable_to_non_nullable
                  as String?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        threadParticipants: freezed == threadParticipants
            ? _self.threadParticipants
            : threadParticipants // ignore: cast_nullable_to_non_nullable
                  as List<UserResponseCommonFields>?,
        totalUnreadCount: freezed == totalUnreadCount
            ? _self.totalUnreadCount
            : totalUnreadCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        unreadChannels: freezed == unreadChannels
            ? _self.unreadChannels
            : unreadChannels // ignore: cast_nullable_to_non_nullable
                  as int?,
        unreadCount: freezed == unreadCount
            ? _self.unreadCount
            : unreadCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
        watcherCount: null == watcherCount
            ? _self.watcherCount
            : watcherCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
mixin _$MessageReadEvent {
  ChannelResponse? get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  String? get lastReadMessageId;
  DateTime? get receivedAt;
  String? get team;
  ThreadResponse? get thread;
  String get type;
  UserResponseCommonFields? get user;

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
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.lastReadMessageId, lastReadMessageId) || other.lastReadMessageId == lastReadMessageId) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.thread, thread) || other.thread == thread) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    lastReadMessageId,
    receivedAt,
    team,
    thread,
    type,
    user,
  );

  @override
  String toString() {
    return 'MessageReadEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, lastReadMessageId: $lastReadMessageId, receivedAt: $receivedAt, team: $team, thread: $thread, type: $type, user: $user)';
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
    ChannelResponse? channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    String? lastReadMessageId,
    DateTime? receivedAt,
    String? team,
    ThreadResponse? thread,
    String type,
    UserResponseCommonFields? user,
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
    Object? channel = freezed,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? lastReadMessageId = freezed,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? thread = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      MessageReadEvent(
        channel: freezed == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse?,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        lastReadMessageId: freezed == lastReadMessageId
            ? _self.lastReadMessageId
            : lastReadMessageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        thread: freezed == thread
            ? _self.thread
            : thread // ignore: cast_nullable_to_non_nullable
                  as ThreadResponse?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$MessageUndeletedEvent {
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  MessageResponse get message;
  String get messageId;
  DateTime? get receivedAt;
  String? get team;
  String get type;

  /// Create a copy of MessageUndeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessageUndeletedEventCopyWith<MessageUndeletedEvent> get copyWith =>
      _$MessageUndeletedEventCopyWithImpl<MessageUndeletedEvent>(
        this as MessageUndeletedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MessageUndeletedEvent &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    message,
    messageId,
    receivedAt,
    team,
    type,
  );

  @override
  String toString() {
    return 'MessageUndeletedEvent(channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, message: $message, messageId: $messageId, receivedAt: $receivedAt, team: $team, type: $type)';
  }
}

/// @nodoc
abstract mixin class $MessageUndeletedEventCopyWith<$Res> {
  factory $MessageUndeletedEventCopyWith(
    MessageUndeletedEvent value,
    $Res Function(MessageUndeletedEvent) _then,
  ) = _$MessageUndeletedEventCopyWithImpl;
  @useResult
  $Res call({
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    MessageResponse message,
    String messageId,
    DateTime? receivedAt,
    String? team,
    String type,
  });
}

/// @nodoc
class _$MessageUndeletedEventCopyWithImpl<$Res> implements $MessageUndeletedEventCopyWith<$Res> {
  _$MessageUndeletedEventCopyWithImpl(this._self, this._then);

  final MessageUndeletedEvent _self;
  final $Res Function(MessageUndeletedEvent) _then;

  /// Create a copy of MessageUndeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? message = null,
    Object? messageId = null,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? type = null,
  }) {
    return _then(
      MessageUndeletedEvent(
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        message: null == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse,
        messageId: null == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$MessageUpdatedEvent {
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  MessageResponse get message;
  String get messageId;
  MessageUpdate? get messageUpdate;
  DateTime? get receivedAt;
  String? get team;
  String get type;
  UserResponseCommonFields? get user;

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
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.messageUpdate, messageUpdate) || other.messageUpdate == messageUpdate) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    message,
    messageId,
    messageUpdate,
    receivedAt,
    team,
    type,
    user,
  );

  @override
  String toString() {
    return 'MessageUpdatedEvent(channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, message: $message, messageId: $messageId, messageUpdate: $messageUpdate, receivedAt: $receivedAt, team: $team, type: $type, user: $user)';
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
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    MessageResponse message,
    String messageId,
    MessageUpdate? messageUpdate,
    DateTime? receivedAt,
    String? team,
    String type,
    UserResponseCommonFields? user,
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
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? message = null,
    Object? messageId = null,
    Object? messageUpdate = freezed,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      MessageUpdatedEvent(
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        message: null == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse,
        messageId: null == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String,
        messageUpdate: freezed == messageUpdate
            ? _self.messageUpdate
            : messageUpdate // ignore: cast_nullable_to_non_nullable
                  as MessageUpdate?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$ModerationCustomActionEvent {
  String get actionId;
  Map<String, Object?>? get actionOptions;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  MessageResponse? get message;
  DateTime? get receivedAt;
  ReviewQueueItemResponse get reviewQueueItem;
  String get type;

  /// Create a copy of ModerationCustomActionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ModerationCustomActionEventCopyWith<ModerationCustomActionEvent> get copyWith =>
      _$ModerationCustomActionEventCopyWithImpl<ModerationCustomActionEvent>(
        this as ModerationCustomActionEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ModerationCustomActionEvent &&
            (identical(other.actionId, actionId) || other.actionId == actionId) &&
            const DeepCollectionEquality().equals(
              other.actionOptions,
              actionOptions,
            ) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.reviewQueueItem, reviewQueueItem) || other.reviewQueueItem == reviewQueueItem) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    actionId,
    const DeepCollectionEquality().hash(actionOptions),
    createdAt,
    const DeepCollectionEquality().hash(custom),
    message,
    receivedAt,
    reviewQueueItem,
    type,
  );

  @override
  String toString() {
    return 'ModerationCustomActionEvent(actionId: $actionId, actionOptions: $actionOptions, createdAt: $createdAt, custom: $custom, message: $message, receivedAt: $receivedAt, reviewQueueItem: $reviewQueueItem, type: $type)';
  }
}

/// @nodoc
abstract mixin class $ModerationCustomActionEventCopyWith<$Res> {
  factory $ModerationCustomActionEventCopyWith(
    ModerationCustomActionEvent value,
    $Res Function(ModerationCustomActionEvent) _then,
  ) = _$ModerationCustomActionEventCopyWithImpl;
  @useResult
  $Res call({
    String actionId,
    Map<String, Object?>? actionOptions,
    DateTime createdAt,
    Map<String, Object?> custom,
    MessageResponse? message,
    DateTime? receivedAt,
    ReviewQueueItemResponse reviewQueueItem,
    String type,
  });
}

/// @nodoc
class _$ModerationCustomActionEventCopyWithImpl<$Res> implements $ModerationCustomActionEventCopyWith<$Res> {
  _$ModerationCustomActionEventCopyWithImpl(this._self, this._then);

  final ModerationCustomActionEvent _self;
  final $Res Function(ModerationCustomActionEvent) _then;

  /// Create a copy of ModerationCustomActionEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? actionId = null,
    Object? actionOptions = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? message = freezed,
    Object? receivedAt = freezed,
    Object? reviewQueueItem = null,
    Object? type = null,
  }) {
    return _then(
      ModerationCustomActionEvent(
        actionId: null == actionId
            ? _self.actionId
            : actionId // ignore: cast_nullable_to_non_nullable
                  as String,
        actionOptions: freezed == actionOptions
            ? _self.actionOptions
            : actionOptions // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        reviewQueueItem: null == reviewQueueItem
            ? _self.reviewQueueItem
            : reviewQueueItem // ignore: cast_nullable_to_non_nullable
                  as ReviewQueueItemResponse,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$ModerationFlaggedEvent {
  String get contentType;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  String get objectId;
  DateTime? get receivedAt;
  String get type;

  /// Create a copy of ModerationFlaggedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ModerationFlaggedEventCopyWith<ModerationFlaggedEvent> get copyWith =>
      _$ModerationFlaggedEventCopyWithImpl<ModerationFlaggedEvent>(
        this as ModerationFlaggedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ModerationFlaggedEvent &&
            (identical(other.contentType, contentType) || other.contentType == contentType) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.objectId, objectId) || other.objectId == objectId) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    contentType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    objectId,
    receivedAt,
    type,
  );

  @override
  String toString() {
    return 'ModerationFlaggedEvent(contentType: $contentType, createdAt: $createdAt, custom: $custom, objectId: $objectId, receivedAt: $receivedAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $ModerationFlaggedEventCopyWith<$Res> {
  factory $ModerationFlaggedEventCopyWith(
    ModerationFlaggedEvent value,
    $Res Function(ModerationFlaggedEvent) _then,
  ) = _$ModerationFlaggedEventCopyWithImpl;
  @useResult
  $Res call({
    String contentType,
    DateTime createdAt,
    Map<String, Object?> custom,
    String objectId,
    DateTime? receivedAt,
    String type,
  });
}

/// @nodoc
class _$ModerationFlaggedEventCopyWithImpl<$Res> implements $ModerationFlaggedEventCopyWith<$Res> {
  _$ModerationFlaggedEventCopyWithImpl(this._self, this._then);

  final ModerationFlaggedEvent _self;
  final $Res Function(ModerationFlaggedEvent) _then;

  /// Create a copy of ModerationFlaggedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? contentType = null,
    Object? createdAt = null,
    Object? custom = null,
    Object? objectId = null,
    Object? receivedAt = freezed,
    Object? type = null,
  }) {
    return _then(
      ModerationFlaggedEvent(
        contentType: null == contentType
            ? _self.contentType
            : contentType // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        objectId: null == objectId
            ? _self.objectId
            : objectId // ignore: cast_nullable_to_non_nullable
                  as String,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$ModerationMarkReviewedEvent {
  DateTime get createdAt;
  Map<String, Object?> get custom;
  ReviewQueueItemResponse get item;
  MessageResponse? get message;
  DateTime? get receivedAt;
  String get type;

  /// Create a copy of ModerationMarkReviewedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ModerationMarkReviewedEventCopyWith<ModerationMarkReviewedEvent> get copyWith =>
      _$ModerationMarkReviewedEventCopyWithImpl<ModerationMarkReviewedEvent>(
        this as ModerationMarkReviewedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ModerationMarkReviewedEvent &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.item, item) || other.item == item) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    item,
    message,
    receivedAt,
    type,
  );

  @override
  String toString() {
    return 'ModerationMarkReviewedEvent(createdAt: $createdAt, custom: $custom, item: $item, message: $message, receivedAt: $receivedAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $ModerationMarkReviewedEventCopyWith<$Res> {
  factory $ModerationMarkReviewedEventCopyWith(
    ModerationMarkReviewedEvent value,
    $Res Function(ModerationMarkReviewedEvent) _then,
  ) = _$ModerationMarkReviewedEventCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    Map<String, Object?> custom,
    ReviewQueueItemResponse item,
    MessageResponse? message,
    DateTime? receivedAt,
    String type,
  });
}

/// @nodoc
class _$ModerationMarkReviewedEventCopyWithImpl<$Res> implements $ModerationMarkReviewedEventCopyWith<$Res> {
  _$ModerationMarkReviewedEventCopyWithImpl(this._self, this._then);

  final ModerationMarkReviewedEvent _self;
  final $Res Function(ModerationMarkReviewedEvent) _then;

  /// Create a copy of ModerationMarkReviewedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? custom = null,
    Object? item = null,
    Object? message = freezed,
    Object? receivedAt = freezed,
    Object? type = null,
  }) {
    return _then(
      ModerationMarkReviewedEvent(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        item: null == item
            ? _self.item
            : item // ignore: cast_nullable_to_non_nullable
                  as ReviewQueueItemResponse,
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$NotificationAddedToChannelEvent {
  ChannelResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  Map<String, int>? get groupedUnreadChannels;
  ChannelMemberResponse get member;
  DateTime? get receivedAt;
  String? get team;
  int? get totalUnreadCount;
  String get type;
  int? get unreadChannels;
  int? get unreadCount;

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
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            const DeepCollectionEquality().equals(
              other.groupedUnreadChannels,
              groupedUnreadChannels,
            ) &&
            (identical(other.member, member) || other.member == member) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.totalUnreadCount, totalUnreadCount) || other.totalUnreadCount == totalUnreadCount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.unreadChannels, unreadChannels) || other.unreadChannels == unreadChannels) &&
            (identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    const DeepCollectionEquality().hash(groupedUnreadChannels),
    member,
    receivedAt,
    team,
    totalUnreadCount,
    type,
    unreadChannels,
    unreadCount,
  );

  @override
  String toString() {
    return 'NotificationAddedToChannelEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, groupedUnreadChannels: $groupedUnreadChannels, member: $member, receivedAt: $receivedAt, team: $team, totalUnreadCount: $totalUnreadCount, type: $type, unreadChannels: $unreadChannels, unreadCount: $unreadCount)';
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
    ChannelResponse channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    Map<String, int>? groupedUnreadChannels,
    ChannelMemberResponse member,
    DateTime? receivedAt,
    String? team,
    int? totalUnreadCount,
    String type,
    int? unreadChannels,
    int? unreadCount,
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
    Object? channel = null,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? groupedUnreadChannels = freezed,
    Object? member = null,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? totalUnreadCount = freezed,
    Object? type = null,
    Object? unreadChannels = freezed,
    Object? unreadCount = freezed,
  }) {
    return _then(
      NotificationAddedToChannelEvent(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        groupedUnreadChannels: freezed == groupedUnreadChannels
            ? _self.groupedUnreadChannels
            : groupedUnreadChannels // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>?,
        member: null == member
            ? _self.member
            : member // ignore: cast_nullable_to_non_nullable
                  as ChannelMemberResponse,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalUnreadCount: freezed == totalUnreadCount
            ? _self.totalUnreadCount
            : totalUnreadCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        unreadChannels: freezed == unreadChannels
            ? _self.unreadChannels
            : unreadChannels // ignore: cast_nullable_to_non_nullable
                  as int?,
        unreadCount: freezed == unreadCount
            ? _self.unreadCount
            : unreadCount // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
mixin _$NotificationChannelDeletedEvent {
  ChannelResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  Map<String, int>? get groupedUnreadChannels;
  DateTime? get receivedAt;
  String? get team;
  int? get totalUnreadCount;
  String get type;
  int? get unreadChannels;
  int? get unreadCount;

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
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            const DeepCollectionEquality().equals(
              other.groupedUnreadChannels,
              groupedUnreadChannels,
            ) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.totalUnreadCount, totalUnreadCount) || other.totalUnreadCount == totalUnreadCount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.unreadChannels, unreadChannels) || other.unreadChannels == unreadChannels) &&
            (identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    const DeepCollectionEquality().hash(groupedUnreadChannels),
    receivedAt,
    team,
    totalUnreadCount,
    type,
    unreadChannels,
    unreadCount,
  );

  @override
  String toString() {
    return 'NotificationChannelDeletedEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, groupedUnreadChannels: $groupedUnreadChannels, receivedAt: $receivedAt, team: $team, totalUnreadCount: $totalUnreadCount, type: $type, unreadChannels: $unreadChannels, unreadCount: $unreadCount)';
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
    ChannelResponse channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    Map<String, int>? groupedUnreadChannels,
    DateTime? receivedAt,
    String? team,
    int? totalUnreadCount,
    String type,
    int? unreadChannels,
    int? unreadCount,
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
    Object? channel = null,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? groupedUnreadChannels = freezed,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? totalUnreadCount = freezed,
    Object? type = null,
    Object? unreadChannels = freezed,
    Object? unreadCount = freezed,
  }) {
    return _then(
      NotificationChannelDeletedEvent(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        groupedUnreadChannels: freezed == groupedUnreadChannels
            ? _self.groupedUnreadChannels
            : groupedUnreadChannels // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalUnreadCount: freezed == totalUnreadCount
            ? _self.totalUnreadCount
            : totalUnreadCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        unreadChannels: freezed == unreadChannels
            ? _self.unreadChannels
            : unreadChannels // ignore: cast_nullable_to_non_nullable
                  as int?,
        unreadCount: freezed == unreadCount
            ? _self.unreadCount
            : unreadCount // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
mixin _$NotificationChannelMutesUpdatedEvent {
  DateTime get createdAt;
  Map<String, Object?> get custom;
  OwnUserResponse get me;
  DateTime? get receivedAt;
  String get type;

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
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.me, me) || other.me == me) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    me,
    receivedAt,
    type,
  );

  @override
  String toString() {
    return 'NotificationChannelMutesUpdatedEvent(createdAt: $createdAt, custom: $custom, me: $me, receivedAt: $receivedAt, type: $type)';
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
    DateTime createdAt,
    Map<String, Object?> custom,
    OwnUserResponse me,
    DateTime? receivedAt,
    String type,
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
    Object? createdAt = null,
    Object? custom = null,
    Object? me = null,
    Object? receivedAt = freezed,
    Object? type = null,
  }) {
    return _then(
      NotificationChannelMutesUpdatedEvent(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        me: null == me
            ? _self.me
            : me // ignore: cast_nullable_to_non_nullable
                  as OwnUserResponse,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$NotificationChannelPartialUpdatedEvent {
  ChannelPartialUpdateResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String? get team;
  String get type;

  /// Create a copy of NotificationChannelPartialUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationChannelPartialUpdatedEventCopyWith<NotificationChannelPartialUpdatedEvent> get copyWith =>
      _$NotificationChannelPartialUpdatedEventCopyWithImpl<NotificationChannelPartialUpdatedEvent>(
        this as NotificationChannelPartialUpdatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationChannelPartialUpdatedEvent &&
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    team,
    type,
  );

  @override
  String toString() {
    return 'NotificationChannelPartialUpdatedEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, team: $team, type: $type)';
  }
}

/// @nodoc
abstract mixin class $NotificationChannelPartialUpdatedEventCopyWith<$Res> {
  factory $NotificationChannelPartialUpdatedEventCopyWith(
    NotificationChannelPartialUpdatedEvent value,
    $Res Function(NotificationChannelPartialUpdatedEvent) _then,
  ) = _$NotificationChannelPartialUpdatedEventCopyWithImpl;
  @useResult
  $Res call({
    ChannelPartialUpdateResponse channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String? team,
    String type,
  });
}

/// @nodoc
class _$NotificationChannelPartialUpdatedEventCopyWithImpl<$Res>
    implements $NotificationChannelPartialUpdatedEventCopyWith<$Res> {
  _$NotificationChannelPartialUpdatedEventCopyWithImpl(this._self, this._then);

  final NotificationChannelPartialUpdatedEvent _self;
  final $Res Function(NotificationChannelPartialUpdatedEvent) _then;

  /// Create a copy of NotificationChannelPartialUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = null,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? type = null,
  }) {
    return _then(
      NotificationChannelPartialUpdatedEvent(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelPartialUpdateResponse,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$NotificationChannelRewoundEvent {
  ChannelResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  Map<String, int>? get groupedUnreadChannels;
  DateTime? get receivedAt;
  ChannelRewindResponse get rewind;
  String? get team;
  int? get totalUnreadCount;
  String get type;
  int? get unreadChannels;
  int? get unreadCount;

  /// Create a copy of NotificationChannelRewoundEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationChannelRewoundEventCopyWith<NotificationChannelRewoundEvent> get copyWith =>
      _$NotificationChannelRewoundEventCopyWithImpl<NotificationChannelRewoundEvent>(
        this as NotificationChannelRewoundEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationChannelRewoundEvent &&
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            const DeepCollectionEquality().equals(
              other.groupedUnreadChannels,
              groupedUnreadChannels,
            ) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.rewind, rewind) || other.rewind == rewind) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.totalUnreadCount, totalUnreadCount) || other.totalUnreadCount == totalUnreadCount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.unreadChannels, unreadChannels) || other.unreadChannels == unreadChannels) &&
            (identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    const DeepCollectionEquality().hash(groupedUnreadChannels),
    receivedAt,
    rewind,
    team,
    totalUnreadCount,
    type,
    unreadChannels,
    unreadCount,
  );

  @override
  String toString() {
    return 'NotificationChannelRewoundEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, groupedUnreadChannels: $groupedUnreadChannels, receivedAt: $receivedAt, rewind: $rewind, team: $team, totalUnreadCount: $totalUnreadCount, type: $type, unreadChannels: $unreadChannels, unreadCount: $unreadCount)';
  }
}

/// @nodoc
abstract mixin class $NotificationChannelRewoundEventCopyWith<$Res> {
  factory $NotificationChannelRewoundEventCopyWith(
    NotificationChannelRewoundEvent value,
    $Res Function(NotificationChannelRewoundEvent) _then,
  ) = _$NotificationChannelRewoundEventCopyWithImpl;
  @useResult
  $Res call({
    ChannelResponse channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    Map<String, int>? groupedUnreadChannels,
    DateTime? receivedAt,
    ChannelRewindResponse rewind,
    String? team,
    int? totalUnreadCount,
    String type,
    int? unreadChannels,
    int? unreadCount,
  });
}

/// @nodoc
class _$NotificationChannelRewoundEventCopyWithImpl<$Res> implements $NotificationChannelRewoundEventCopyWith<$Res> {
  _$NotificationChannelRewoundEventCopyWithImpl(this._self, this._then);

  final NotificationChannelRewoundEvent _self;
  final $Res Function(NotificationChannelRewoundEvent) _then;

  /// Create a copy of NotificationChannelRewoundEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = null,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? groupedUnreadChannels = freezed,
    Object? receivedAt = freezed,
    Object? rewind = null,
    Object? team = freezed,
    Object? totalUnreadCount = freezed,
    Object? type = null,
    Object? unreadChannels = freezed,
    Object? unreadCount = freezed,
  }) {
    return _then(
      NotificationChannelRewoundEvent(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        groupedUnreadChannels: freezed == groupedUnreadChannels
            ? _self.groupedUnreadChannels
            : groupedUnreadChannels // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        rewind: null == rewind
            ? _self.rewind
            : rewind // ignore: cast_nullable_to_non_nullable
                  as ChannelRewindResponse,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalUnreadCount: freezed == totalUnreadCount
            ? _self.totalUnreadCount
            : totalUnreadCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        unreadChannels: freezed == unreadChannels
            ? _self.unreadChannels
            : unreadChannels // ignore: cast_nullable_to_non_nullable
                  as int?,
        unreadCount: freezed == unreadCount
            ? _self.unreadCount
            : unreadCount // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
mixin _$NotificationChannelTruncatedEvent {
  ChannelResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  Map<String, int>? get groupedUnreadChannels;
  MessageResponse? get message;
  String? get messageId;
  DateTime? get receivedAt;
  String? get team;
  int? get totalUnreadCount;
  String get type;
  int? get unreadChannels;
  int? get unreadCount;

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
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            const DeepCollectionEquality().equals(
              other.groupedUnreadChannels,
              groupedUnreadChannels,
            ) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.totalUnreadCount, totalUnreadCount) || other.totalUnreadCount == totalUnreadCount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.unreadChannels, unreadChannels) || other.unreadChannels == unreadChannels) &&
            (identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    const DeepCollectionEquality().hash(groupedUnreadChannels),
    message,
    messageId,
    receivedAt,
    team,
    totalUnreadCount,
    type,
    unreadChannels,
    unreadCount,
  );

  @override
  String toString() {
    return 'NotificationChannelTruncatedEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, groupedUnreadChannels: $groupedUnreadChannels, message: $message, messageId: $messageId, receivedAt: $receivedAt, team: $team, totalUnreadCount: $totalUnreadCount, type: $type, unreadChannels: $unreadChannels, unreadCount: $unreadCount)';
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
    ChannelResponse channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    Map<String, int>? groupedUnreadChannels,
    MessageResponse? message,
    String? messageId,
    DateTime? receivedAt,
    String? team,
    int? totalUnreadCount,
    String type,
    int? unreadChannels,
    int? unreadCount,
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
    Object? channel = null,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? groupedUnreadChannels = freezed,
    Object? message = freezed,
    Object? messageId = freezed,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? totalUnreadCount = freezed,
    Object? type = null,
    Object? unreadChannels = freezed,
    Object? unreadCount = freezed,
  }) {
    return _then(
      NotificationChannelTruncatedEvent(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        groupedUnreadChannels: freezed == groupedUnreadChannels
            ? _self.groupedUnreadChannels
            : groupedUnreadChannels // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>?,
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse?,
        messageId: freezed == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalUnreadCount: freezed == totalUnreadCount
            ? _self.totalUnreadCount
            : totalUnreadCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        unreadChannels: freezed == unreadChannels
            ? _self.unreadChannels
            : unreadChannels // ignore: cast_nullable_to_non_nullable
                  as int?,
        unreadCount: freezed == unreadCount
            ? _self.unreadCount
            : unreadCount // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// @nodoc
mixin _$NotificationInviteAcceptedEvent {
  ChannelResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  ChannelMemberResponse get member;
  DateTime? get receivedAt;
  String? get team;
  String get type;
  UserResponseCommonFields? get user;

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
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.member, member) || other.member == member) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    member,
    receivedAt,
    team,
    type,
    user,
  );

  @override
  String toString() {
    return 'NotificationInviteAcceptedEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, member: $member, receivedAt: $receivedAt, team: $team, type: $type, user: $user)';
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
    ChannelResponse channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    ChannelMemberResponse member,
    DateTime? receivedAt,
    String? team,
    String type,
    UserResponseCommonFields? user,
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
    Object? channel = null,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? member = null,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      NotificationInviteAcceptedEvent(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        member: null == member
            ? _self.member
            : member // ignore: cast_nullable_to_non_nullable
                  as ChannelMemberResponse,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$NotificationInviteRejectedEvent {
  ChannelResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  ChannelMemberResponse get member;
  DateTime? get receivedAt;
  String? get team;
  String get type;
  UserResponseCommonFields? get user;

  /// Create a copy of NotificationInviteRejectedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationInviteRejectedEventCopyWith<NotificationInviteRejectedEvent> get copyWith =>
      _$NotificationInviteRejectedEventCopyWithImpl<NotificationInviteRejectedEvent>(
        this as NotificationInviteRejectedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationInviteRejectedEvent &&
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.member, member) || other.member == member) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    member,
    receivedAt,
    team,
    type,
    user,
  );

  @override
  String toString() {
    return 'NotificationInviteRejectedEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, member: $member, receivedAt: $receivedAt, team: $team, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $NotificationInviteRejectedEventCopyWith<$Res> {
  factory $NotificationInviteRejectedEventCopyWith(
    NotificationInviteRejectedEvent value,
    $Res Function(NotificationInviteRejectedEvent) _then,
  ) = _$NotificationInviteRejectedEventCopyWithImpl;
  @useResult
  $Res call({
    ChannelResponse channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    ChannelMemberResponse member,
    DateTime? receivedAt,
    String? team,
    String type,
    UserResponseCommonFields? user,
  });
}

/// @nodoc
class _$NotificationInviteRejectedEventCopyWithImpl<$Res> implements $NotificationInviteRejectedEventCopyWith<$Res> {
  _$NotificationInviteRejectedEventCopyWithImpl(this._self, this._then);

  final NotificationInviteRejectedEvent _self;
  final $Res Function(NotificationInviteRejectedEvent) _then;

  /// Create a copy of NotificationInviteRejectedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = null,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? member = null,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      NotificationInviteRejectedEvent(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        member: null == member
            ? _self.member
            : member // ignore: cast_nullable_to_non_nullable
                  as ChannelMemberResponse,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$NotificationInvitedEvent {
  ChannelResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  ChannelMemberResponse get member;
  DateTime? get receivedAt;
  String? get team;
  String get type;
  UserResponseCommonFields? get user;

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
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.member, member) || other.member == member) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    member,
    receivedAt,
    team,
    type,
    user,
  );

  @override
  String toString() {
    return 'NotificationInvitedEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, member: $member, receivedAt: $receivedAt, team: $team, type: $type, user: $user)';
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
    ChannelResponse channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    ChannelMemberResponse member,
    DateTime? receivedAt,
    String? team,
    String type,
    UserResponseCommonFields? user,
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
    Object? channel = null,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? member = null,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      NotificationInvitedEvent(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        member: null == member
            ? _self.member
            : member // ignore: cast_nullable_to_non_nullable
                  as ChannelMemberResponse,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$NotificationMarkReadEvent {
  ChannelResponse? get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  Map<String, int>? get groupedUnreadChannels;
  String? get lastReadMessageId;
  DateTime? get receivedAt;
  String? get team;
  ThreadResponse? get thread;
  String? get threadId;
  int get totalUnreadCount;
  String get type;
  int get unreadChannels;
  int get unreadCount;
  int? get unreadThreadMessages;
  int? get unreadThreads;
  UserResponseCommonFields? get user;

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
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            const DeepCollectionEquality().equals(
              other.groupedUnreadChannels,
              groupedUnreadChannels,
            ) &&
            (identical(other.lastReadMessageId, lastReadMessageId) || other.lastReadMessageId == lastReadMessageId) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.thread, thread) || other.thread == thread) &&
            (identical(other.threadId, threadId) || other.threadId == threadId) &&
            (identical(other.totalUnreadCount, totalUnreadCount) || other.totalUnreadCount == totalUnreadCount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.unreadChannels, unreadChannels) || other.unreadChannels == unreadChannels) &&
            (identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount) &&
            (identical(other.unreadThreadMessages, unreadThreadMessages) ||
                other.unreadThreadMessages == unreadThreadMessages) &&
            (identical(other.unreadThreads, unreadThreads) || other.unreadThreads == unreadThreads) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    const DeepCollectionEquality().hash(groupedUnreadChannels),
    lastReadMessageId,
    receivedAt,
    team,
    thread,
    threadId,
    totalUnreadCount,
    type,
    unreadChannels,
    unreadCount,
    unreadThreadMessages,
    unreadThreads,
    user,
  ]);

  @override
  String toString() {
    return 'NotificationMarkReadEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, groupedUnreadChannels: $groupedUnreadChannels, lastReadMessageId: $lastReadMessageId, receivedAt: $receivedAt, team: $team, thread: $thread, threadId: $threadId, totalUnreadCount: $totalUnreadCount, type: $type, unreadChannels: $unreadChannels, unreadCount: $unreadCount, unreadThreadMessages: $unreadThreadMessages, unreadThreads: $unreadThreads, user: $user)';
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
    ChannelResponse? channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    Map<String, int>? groupedUnreadChannels,
    String? lastReadMessageId,
    DateTime? receivedAt,
    String? team,
    ThreadResponse? thread,
    String? threadId,
    int totalUnreadCount,
    String type,
    int unreadChannels,
    int unreadCount,
    int? unreadThreadMessages,
    int? unreadThreads,
    UserResponseCommonFields? user,
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
    Object? channel = freezed,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? groupedUnreadChannels = freezed,
    Object? lastReadMessageId = freezed,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? thread = freezed,
    Object? threadId = freezed,
    Object? totalUnreadCount = null,
    Object? type = null,
    Object? unreadChannels = null,
    Object? unreadCount = null,
    Object? unreadThreadMessages = freezed,
    Object? unreadThreads = freezed,
    Object? user = freezed,
  }) {
    return _then(
      NotificationMarkReadEvent(
        channel: freezed == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse?,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        groupedUnreadChannels: freezed == groupedUnreadChannels
            ? _self.groupedUnreadChannels
            : groupedUnreadChannels // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>?,
        lastReadMessageId: freezed == lastReadMessageId
            ? _self.lastReadMessageId
            : lastReadMessageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        thread: freezed == thread
            ? _self.thread
            : thread // ignore: cast_nullable_to_non_nullable
                  as ThreadResponse?,
        threadId: freezed == threadId
            ? _self.threadId
            : threadId // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalUnreadCount: null == totalUnreadCount
            ? _self.totalUnreadCount
            : totalUnreadCount // ignore: cast_nullable_to_non_nullable
                  as int,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        unreadChannels: null == unreadChannels
            ? _self.unreadChannels
            : unreadChannels // ignore: cast_nullable_to_non_nullable
                  as int,
        unreadCount: null == unreadCount
            ? _self.unreadCount
            : unreadCount // ignore: cast_nullable_to_non_nullable
                  as int,
        unreadThreadMessages: freezed == unreadThreadMessages
            ? _self.unreadThreadMessages
            : unreadThreadMessages // ignore: cast_nullable_to_non_nullable
                  as int?,
        unreadThreads: freezed == unreadThreads
            ? _self.unreadThreads
            : unreadThreads // ignore: cast_nullable_to_non_nullable
                  as int?,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$NotificationMarkUnreadEvent {
  ChannelResponse? get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  String? get firstUnreadMessageId;
  Map<String, int>? get groupedUnreadChannels;
  DateTime? get lastReadAt;
  String? get lastReadMessageId;
  DateTime? get receivedAt;
  String? get team;
  String? get threadId;
  int? get totalUnreadCount;
  String get type;
  int? get unreadChannels;
  int? get unreadCount;
  int? get unreadMessages;
  int? get unreadThreadMessages;
  int? get unreadThreads;
  UserResponseCommonFields? get user;

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
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.firstUnreadMessageId, firstUnreadMessageId) ||
                other.firstUnreadMessageId == firstUnreadMessageId) &&
            const DeepCollectionEquality().equals(
              other.groupedUnreadChannels,
              groupedUnreadChannels,
            ) &&
            (identical(other.lastReadAt, lastReadAt) || other.lastReadAt == lastReadAt) &&
            (identical(other.lastReadMessageId, lastReadMessageId) || other.lastReadMessageId == lastReadMessageId) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.threadId, threadId) || other.threadId == threadId) &&
            (identical(other.totalUnreadCount, totalUnreadCount) || other.totalUnreadCount == totalUnreadCount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.unreadChannels, unreadChannels) || other.unreadChannels == unreadChannels) &&
            (identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount) &&
            (identical(other.unreadMessages, unreadMessages) || other.unreadMessages == unreadMessages) &&
            (identical(other.unreadThreadMessages, unreadThreadMessages) ||
                other.unreadThreadMessages == unreadThreadMessages) &&
            (identical(other.unreadThreads, unreadThreads) || other.unreadThreads == unreadThreads) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    firstUnreadMessageId,
    const DeepCollectionEquality().hash(groupedUnreadChannels),
    lastReadAt,
    lastReadMessageId,
    receivedAt,
    team,
    threadId,
    totalUnreadCount,
    type,
    unreadChannels,
    unreadCount,
    unreadMessages,
    unreadThreadMessages,
    unreadThreads,
    user,
  ]);

  @override
  String toString() {
    return 'NotificationMarkUnreadEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, firstUnreadMessageId: $firstUnreadMessageId, groupedUnreadChannels: $groupedUnreadChannels, lastReadAt: $lastReadAt, lastReadMessageId: $lastReadMessageId, receivedAt: $receivedAt, team: $team, threadId: $threadId, totalUnreadCount: $totalUnreadCount, type: $type, unreadChannels: $unreadChannels, unreadCount: $unreadCount, unreadMessages: $unreadMessages, unreadThreadMessages: $unreadThreadMessages, unreadThreads: $unreadThreads, user: $user)';
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
    ChannelResponse? channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    String? firstUnreadMessageId,
    Map<String, int>? groupedUnreadChannels,
    DateTime? lastReadAt,
    String? lastReadMessageId,
    DateTime? receivedAt,
    String? team,
    String? threadId,
    int? totalUnreadCount,
    String type,
    int? unreadChannels,
    int? unreadCount,
    int? unreadMessages,
    int? unreadThreadMessages,
    int? unreadThreads,
    UserResponseCommonFields? user,
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
    Object? channel = freezed,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? firstUnreadMessageId = freezed,
    Object? groupedUnreadChannels = freezed,
    Object? lastReadAt = freezed,
    Object? lastReadMessageId = freezed,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? threadId = freezed,
    Object? totalUnreadCount = freezed,
    Object? type = null,
    Object? unreadChannels = freezed,
    Object? unreadCount = freezed,
    Object? unreadMessages = freezed,
    Object? unreadThreadMessages = freezed,
    Object? unreadThreads = freezed,
    Object? user = freezed,
  }) {
    return _then(
      NotificationMarkUnreadEvent(
        channel: freezed == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse?,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        firstUnreadMessageId: freezed == firstUnreadMessageId
            ? _self.firstUnreadMessageId
            : firstUnreadMessageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        groupedUnreadChannels: freezed == groupedUnreadChannels
            ? _self.groupedUnreadChannels
            : groupedUnreadChannels // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>?,
        lastReadAt: freezed == lastReadAt
            ? _self.lastReadAt
            : lastReadAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastReadMessageId: freezed == lastReadMessageId
            ? _self.lastReadMessageId
            : lastReadMessageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        threadId: freezed == threadId
            ? _self.threadId
            : threadId // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalUnreadCount: freezed == totalUnreadCount
            ? _self.totalUnreadCount
            : totalUnreadCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        unreadChannels: freezed == unreadChannels
            ? _self.unreadChannels
            : unreadChannels // ignore: cast_nullable_to_non_nullable
                  as int?,
        unreadCount: freezed == unreadCount
            ? _self.unreadCount
            : unreadCount // ignore: cast_nullable_to_non_nullable
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
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$NotificationMutesUpdatedEvent {
  DateTime get createdAt;
  Map<String, Object?> get custom;
  OwnUserResponse get me;
  DateTime? get receivedAt;
  String get type;

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
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.me, me) || other.me == me) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    me,
    receivedAt,
    type,
  );

  @override
  String toString() {
    return 'NotificationMutesUpdatedEvent(createdAt: $createdAt, custom: $custom, me: $me, receivedAt: $receivedAt, type: $type)';
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
    DateTime createdAt,
    Map<String, Object?> custom,
    OwnUserResponse me,
    DateTime? receivedAt,
    String type,
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
    Object? createdAt = null,
    Object? custom = null,
    Object? me = null,
    Object? receivedAt = freezed,
    Object? type = null,
  }) {
    return _then(
      NotificationMutesUpdatedEvent(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        me: null == me
            ? _self.me
            : me // ignore: cast_nullable_to_non_nullable
                  as OwnUserResponse,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$NotificationNewMessageEvent {
  ChannelResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  Map<String, int>? get groupedUnreadChannels;
  MessageResponse get message;
  String get messageId;
  String? get parentAuthor;
  DateTime? get receivedAt;
  String? get team;
  List<UserResponseCommonFields>? get threadParticipants;
  int? get totalUnreadCount;
  String get type;
  int? get unreadChannels;
  int? get unreadCount;
  int get watcherCount;

  /// Create a copy of NotificationNewMessageEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationNewMessageEventCopyWith<NotificationNewMessageEvent> get copyWith =>
      _$NotificationNewMessageEventCopyWithImpl<NotificationNewMessageEvent>(
        this as NotificationNewMessageEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationNewMessageEvent &&
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            const DeepCollectionEquality().equals(
              other.groupedUnreadChannels,
              groupedUnreadChannels,
            ) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.parentAuthor, parentAuthor) || other.parentAuthor == parentAuthor) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            const DeepCollectionEquality().equals(
              other.threadParticipants,
              threadParticipants,
            ) &&
            (identical(other.totalUnreadCount, totalUnreadCount) || other.totalUnreadCount == totalUnreadCount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.unreadChannels, unreadChannels) || other.unreadChannels == unreadChannels) &&
            (identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount) &&
            (identical(other.watcherCount, watcherCount) || other.watcherCount == watcherCount));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    const DeepCollectionEquality().hash(groupedUnreadChannels),
    message,
    messageId,
    parentAuthor,
    receivedAt,
    team,
    const DeepCollectionEquality().hash(threadParticipants),
    totalUnreadCount,
    type,
    unreadChannels,
    unreadCount,
    watcherCount,
  ]);

  @override
  String toString() {
    return 'NotificationNewMessageEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, groupedUnreadChannels: $groupedUnreadChannels, message: $message, messageId: $messageId, parentAuthor: $parentAuthor, receivedAt: $receivedAt, team: $team, threadParticipants: $threadParticipants, totalUnreadCount: $totalUnreadCount, type: $type, unreadChannels: $unreadChannels, unreadCount: $unreadCount, watcherCount: $watcherCount)';
  }
}

/// @nodoc
abstract mixin class $NotificationNewMessageEventCopyWith<$Res> {
  factory $NotificationNewMessageEventCopyWith(
    NotificationNewMessageEvent value,
    $Res Function(NotificationNewMessageEvent) _then,
  ) = _$NotificationNewMessageEventCopyWithImpl;
  @useResult
  $Res call({
    ChannelResponse channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    Map<String, int>? groupedUnreadChannels,
    MessageResponse message,
    String messageId,
    String? parentAuthor,
    DateTime? receivedAt,
    String? team,
    List<UserResponseCommonFields>? threadParticipants,
    int? totalUnreadCount,
    String type,
    int? unreadChannels,
    int? unreadCount,
    int watcherCount,
  });
}

/// @nodoc
class _$NotificationNewMessageEventCopyWithImpl<$Res> implements $NotificationNewMessageEventCopyWith<$Res> {
  _$NotificationNewMessageEventCopyWithImpl(this._self, this._then);

  final NotificationNewMessageEvent _self;
  final $Res Function(NotificationNewMessageEvent) _then;

  /// Create a copy of NotificationNewMessageEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = null,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? groupedUnreadChannels = freezed,
    Object? message = null,
    Object? messageId = null,
    Object? parentAuthor = freezed,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? threadParticipants = freezed,
    Object? totalUnreadCount = freezed,
    Object? type = null,
    Object? unreadChannels = freezed,
    Object? unreadCount = freezed,
    Object? watcherCount = null,
  }) {
    return _then(
      NotificationNewMessageEvent(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        groupedUnreadChannels: freezed == groupedUnreadChannels
            ? _self.groupedUnreadChannels
            : groupedUnreadChannels // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>?,
        message: null == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse,
        messageId: null == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String,
        parentAuthor: freezed == parentAuthor
            ? _self.parentAuthor
            : parentAuthor // ignore: cast_nullable_to_non_nullable
                  as String?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        threadParticipants: freezed == threadParticipants
            ? _self.threadParticipants
            : threadParticipants // ignore: cast_nullable_to_non_nullable
                  as List<UserResponseCommonFields>?,
        totalUnreadCount: freezed == totalUnreadCount
            ? _self.totalUnreadCount
            : totalUnreadCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        unreadChannels: freezed == unreadChannels
            ? _self.unreadChannels
            : unreadChannels // ignore: cast_nullable_to_non_nullable
                  as int?,
        unreadCount: freezed == unreadCount
            ? _self.unreadCount
            : unreadCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        watcherCount: null == watcherCount
            ? _self.watcherCount
            : watcherCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
mixin _$NotificationRemovedFromChannelEvent {
  ChannelResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  ChannelMemberResponse get member;
  DateTime? get receivedAt;
  String? get team;
  String get type;
  UserResponseCommonFields? get user;

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
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.member, member) || other.member == member) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    member,
    receivedAt,
    team,
    type,
    user,
  );

  @override
  String toString() {
    return 'NotificationRemovedFromChannelEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, member: $member, receivedAt: $receivedAt, team: $team, type: $type, user: $user)';
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
    ChannelResponse channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    ChannelMemberResponse member,
    DateTime? receivedAt,
    String? team,
    String type,
    UserResponseCommonFields? user,
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
    Object? channel = null,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? member = null,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      NotificationRemovedFromChannelEvent(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        member: null == member
            ? _self.member
            : member // ignore: cast_nullable_to_non_nullable
                  as ChannelMemberResponse,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$NotificationThreadMessageNewEvent {
  ChannelResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  MessageResponse get message;
  String get messageId;
  String? get parentAuthor;
  DateTime? get receivedAt;
  String? get team;
  String get threadId;
  List<UserResponseCommonFields>? get threadParticipants;
  String get type;
  int? get unreadThreadMessages;
  int? get unreadThreads;
  int get watcherCount;

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
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.parentAuthor, parentAuthor) || other.parentAuthor == parentAuthor) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.threadId, threadId) || other.threadId == threadId) &&
            const DeepCollectionEquality().equals(
              other.threadParticipants,
              threadParticipants,
            ) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.unreadThreadMessages, unreadThreadMessages) ||
                other.unreadThreadMessages == unreadThreadMessages) &&
            (identical(other.unreadThreads, unreadThreads) || other.unreadThreads == unreadThreads) &&
            (identical(other.watcherCount, watcherCount) || other.watcherCount == watcherCount));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    message,
    messageId,
    parentAuthor,
    receivedAt,
    team,
    threadId,
    const DeepCollectionEquality().hash(threadParticipants),
    type,
    unreadThreadMessages,
    unreadThreads,
    watcherCount,
  ]);

  @override
  String toString() {
    return 'NotificationThreadMessageNewEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, message: $message, messageId: $messageId, parentAuthor: $parentAuthor, receivedAt: $receivedAt, team: $team, threadId: $threadId, threadParticipants: $threadParticipants, type: $type, unreadThreadMessages: $unreadThreadMessages, unreadThreads: $unreadThreads, watcherCount: $watcherCount)';
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
    ChannelResponse channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    MessageResponse message,
    String messageId,
    String? parentAuthor,
    DateTime? receivedAt,
    String? team,
    String threadId,
    List<UserResponseCommonFields>? threadParticipants,
    String type,
    int? unreadThreadMessages,
    int? unreadThreads,
    int watcherCount,
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
    Object? channel = null,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? message = null,
    Object? messageId = null,
    Object? parentAuthor = freezed,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? threadId = null,
    Object? threadParticipants = freezed,
    Object? type = null,
    Object? unreadThreadMessages = freezed,
    Object? unreadThreads = freezed,
    Object? watcherCount = null,
  }) {
    return _then(
      NotificationThreadMessageNewEvent(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        message: null == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse,
        messageId: null == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String,
        parentAuthor: freezed == parentAuthor
            ? _self.parentAuthor
            : parentAuthor // ignore: cast_nullable_to_non_nullable
                  as String?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        threadId: null == threadId
            ? _self.threadId
            : threadId // ignore: cast_nullable_to_non_nullable
                  as String,
        threadParticipants: freezed == threadParticipants
            ? _self.threadParticipants
            : threadParticipants // ignore: cast_nullable_to_non_nullable
                  as List<UserResponseCommonFields>?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        unreadThreadMessages: freezed == unreadThreadMessages
            ? _self.unreadThreadMessages
            : unreadThreadMessages // ignore: cast_nullable_to_non_nullable
                  as int?,
        unreadThreads: freezed == unreadThreads
            ? _self.unreadThreads
            : unreadThreads // ignore: cast_nullable_to_non_nullable
                  as int?,
        watcherCount: null == watcherCount
            ? _self.watcherCount
            : watcherCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
mixin _$PendingMessageEvent {
  ChannelResponse? get channel;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  MessageResponse? get message;
  Map<String, String>? get metadata;
  String get method;
  DateTime? get receivedAt;
  String get type;
  UserResponse? get user;

  /// Create a copy of PendingMessageEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PendingMessageEventCopyWith<PendingMessageEvent> get copyWith =>
      _$PendingMessageEventCopyWithImpl<PendingMessageEvent>(
        this as PendingMessageEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PendingMessageEvent &&
            (identical(other.channel, channel) || other.channel == channel) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality().equals(other.metadata, metadata) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    message,
    const DeepCollectionEquality().hash(metadata),
    method,
    receivedAt,
    type,
    user,
  );

  @override
  String toString() {
    return 'PendingMessageEvent(channel: $channel, createdAt: $createdAt, custom: $custom, message: $message, metadata: $metadata, method: $method, receivedAt: $receivedAt, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $PendingMessageEventCopyWith<$Res> {
  factory $PendingMessageEventCopyWith(
    PendingMessageEvent value,
    $Res Function(PendingMessageEvent) _then,
  ) = _$PendingMessageEventCopyWithImpl;
  @useResult
  $Res call({
    ChannelResponse? channel,
    DateTime createdAt,
    Map<String, Object?> custom,
    MessageResponse? message,
    Map<String, String>? metadata,
    String method,
    DateTime? receivedAt,
    String type,
    UserResponse? user,
  });
}

/// @nodoc
class _$PendingMessageEventCopyWithImpl<$Res> implements $PendingMessageEventCopyWith<$Res> {
  _$PendingMessageEventCopyWithImpl(this._self, this._then);

  final PendingMessageEvent _self;
  final $Res Function(PendingMessageEvent) _then;

  /// Create a copy of PendingMessageEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? message = freezed,
    Object? metadata = freezed,
    Object? method = null,
    Object? receivedAt = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      PendingMessageEvent(
        channel: freezed == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse?,
        metadata: freezed == metadata
            ? _self.metadata
            : metadata // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
        method: null == method
            ? _self.method
            : method // ignore: cast_nullable_to_non_nullable
                  as String,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponse?,
      ),
    );
  }
}

/// @nodoc
mixin _$PollClosedEvent {
  String? get activityId;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  String? get messageId;
  PollResponseData get poll;
  DateTime? get receivedAt;
  String get type;

  /// Create a copy of PollClosedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PollClosedEventCopyWith<PollClosedEvent> get copyWith => _$PollClosedEventCopyWithImpl<PollClosedEvent>(
    this as PollClosedEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PollClosedEvent &&
            (identical(other.activityId, activityId) || other.activityId == activityId) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.poll, poll) || other.poll == poll) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    activityId,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    messageId,
    poll,
    receivedAt,
    type,
  );

  @override
  String toString() {
    return 'PollClosedEvent(activityId: $activityId, cid: $cid, createdAt: $createdAt, custom: $custom, messageId: $messageId, poll: $poll, receivedAt: $receivedAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $PollClosedEventCopyWith<$Res> {
  factory $PollClosedEventCopyWith(
    PollClosedEvent value,
    $Res Function(PollClosedEvent) _then,
  ) = _$PollClosedEventCopyWithImpl;
  @useResult
  $Res call({
    String? activityId,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    String? messageId,
    PollResponseData poll,
    DateTime? receivedAt,
    String type,
  });
}

/// @nodoc
class _$PollClosedEventCopyWithImpl<$Res> implements $PollClosedEventCopyWith<$Res> {
  _$PollClosedEventCopyWithImpl(this._self, this._then);

  final PollClosedEvent _self;
  final $Res Function(PollClosedEvent) _then;

  /// Create a copy of PollClosedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityId = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? messageId = freezed,
    Object? poll = null,
    Object? receivedAt = freezed,
    Object? type = null,
  }) {
    return _then(
      PollClosedEvent(
        activityId: freezed == activityId
            ? _self.activityId
            : activityId // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        messageId: freezed == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        poll: null == poll
            ? _self.poll
            : poll // ignore: cast_nullable_to_non_nullable
                  as PollResponseData,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$PollDeletedEvent {
  String? get activityId;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  String? get messageId;
  PollResponseData get poll;
  DateTime? get receivedAt;
  String get type;

  /// Create a copy of PollDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PollDeletedEventCopyWith<PollDeletedEvent> get copyWith => _$PollDeletedEventCopyWithImpl<PollDeletedEvent>(
    this as PollDeletedEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PollDeletedEvent &&
            (identical(other.activityId, activityId) || other.activityId == activityId) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.poll, poll) || other.poll == poll) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    activityId,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    messageId,
    poll,
    receivedAt,
    type,
  );

  @override
  String toString() {
    return 'PollDeletedEvent(activityId: $activityId, cid: $cid, createdAt: $createdAt, custom: $custom, messageId: $messageId, poll: $poll, receivedAt: $receivedAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $PollDeletedEventCopyWith<$Res> {
  factory $PollDeletedEventCopyWith(
    PollDeletedEvent value,
    $Res Function(PollDeletedEvent) _then,
  ) = _$PollDeletedEventCopyWithImpl;
  @useResult
  $Res call({
    String? activityId,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    String? messageId,
    PollResponseData poll,
    DateTime? receivedAt,
    String type,
  });
}

/// @nodoc
class _$PollDeletedEventCopyWithImpl<$Res> implements $PollDeletedEventCopyWith<$Res> {
  _$PollDeletedEventCopyWithImpl(this._self, this._then);

  final PollDeletedEvent _self;
  final $Res Function(PollDeletedEvent) _then;

  /// Create a copy of PollDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityId = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? messageId = freezed,
    Object? poll = null,
    Object? receivedAt = freezed,
    Object? type = null,
  }) {
    return _then(
      PollDeletedEvent(
        activityId: freezed == activityId
            ? _self.activityId
            : activityId // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        messageId: freezed == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        poll: null == poll
            ? _self.poll
            : poll // ignore: cast_nullable_to_non_nullable
                  as PollResponseData,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$PollUpdatedEvent {
  String? get activityId;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  String? get messageId;
  PollResponseData get poll;
  DateTime? get receivedAt;
  String get type;

  /// Create a copy of PollUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PollUpdatedEventCopyWith<PollUpdatedEvent> get copyWith => _$PollUpdatedEventCopyWithImpl<PollUpdatedEvent>(
    this as PollUpdatedEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PollUpdatedEvent &&
            (identical(other.activityId, activityId) || other.activityId == activityId) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.poll, poll) || other.poll == poll) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    activityId,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    messageId,
    poll,
    receivedAt,
    type,
  );

  @override
  String toString() {
    return 'PollUpdatedEvent(activityId: $activityId, cid: $cid, createdAt: $createdAt, custom: $custom, messageId: $messageId, poll: $poll, receivedAt: $receivedAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $PollUpdatedEventCopyWith<$Res> {
  factory $PollUpdatedEventCopyWith(
    PollUpdatedEvent value,
    $Res Function(PollUpdatedEvent) _then,
  ) = _$PollUpdatedEventCopyWithImpl;
  @useResult
  $Res call({
    String? activityId,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    String? messageId,
    PollResponseData poll,
    DateTime? receivedAt,
    String type,
  });
}

/// @nodoc
class _$PollUpdatedEventCopyWithImpl<$Res> implements $PollUpdatedEventCopyWith<$Res> {
  _$PollUpdatedEventCopyWithImpl(this._self, this._then);

  final PollUpdatedEvent _self;
  final $Res Function(PollUpdatedEvent) _then;

  /// Create a copy of PollUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityId = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? messageId = freezed,
    Object? poll = null,
    Object? receivedAt = freezed,
    Object? type = null,
  }) {
    return _then(
      PollUpdatedEvent(
        activityId: freezed == activityId
            ? _self.activityId
            : activityId // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        messageId: freezed == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        poll: null == poll
            ? _self.poll
            : poll // ignore: cast_nullable_to_non_nullable
                  as PollResponseData,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$PollVoteCastedEvent {
  String? get activityId;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  String? get messageId;
  PollResponseData get poll;
  PollVoteResponseData get pollVote;
  DateTime? get receivedAt;
  String get type;

  /// Create a copy of PollVoteCastedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PollVoteCastedEventCopyWith<PollVoteCastedEvent> get copyWith =>
      _$PollVoteCastedEventCopyWithImpl<PollVoteCastedEvent>(
        this as PollVoteCastedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PollVoteCastedEvent &&
            (identical(other.activityId, activityId) || other.activityId == activityId) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.poll, poll) || other.poll == poll) &&
            (identical(other.pollVote, pollVote) || other.pollVote == pollVote) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    activityId,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    messageId,
    poll,
    pollVote,
    receivedAt,
    type,
  );

  @override
  String toString() {
    return 'PollVoteCastedEvent(activityId: $activityId, cid: $cid, createdAt: $createdAt, custom: $custom, messageId: $messageId, poll: $poll, pollVote: $pollVote, receivedAt: $receivedAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $PollVoteCastedEventCopyWith<$Res> {
  factory $PollVoteCastedEventCopyWith(
    PollVoteCastedEvent value,
    $Res Function(PollVoteCastedEvent) _then,
  ) = _$PollVoteCastedEventCopyWithImpl;
  @useResult
  $Res call({
    String? activityId,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    String? messageId,
    PollResponseData poll,
    PollVoteResponseData pollVote,
    DateTime? receivedAt,
    String type,
  });
}

/// @nodoc
class _$PollVoteCastedEventCopyWithImpl<$Res> implements $PollVoteCastedEventCopyWith<$Res> {
  _$PollVoteCastedEventCopyWithImpl(this._self, this._then);

  final PollVoteCastedEvent _self;
  final $Res Function(PollVoteCastedEvent) _then;

  /// Create a copy of PollVoteCastedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityId = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? messageId = freezed,
    Object? poll = null,
    Object? pollVote = null,
    Object? receivedAt = freezed,
    Object? type = null,
  }) {
    return _then(
      PollVoteCastedEvent(
        activityId: freezed == activityId
            ? _self.activityId
            : activityId // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        messageId: freezed == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        poll: null == poll
            ? _self.poll
            : poll // ignore: cast_nullable_to_non_nullable
                  as PollResponseData,
        pollVote: null == pollVote
            ? _self.pollVote
            : pollVote // ignore: cast_nullable_to_non_nullable
                  as PollVoteResponseData,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$PollVoteChangedEvent {
  String? get activityId;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  String? get messageId;
  PollResponseData get poll;
  PollVoteResponseData get pollVote;
  DateTime? get receivedAt;
  String get type;

  /// Create a copy of PollVoteChangedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PollVoteChangedEventCopyWith<PollVoteChangedEvent> get copyWith =>
      _$PollVoteChangedEventCopyWithImpl<PollVoteChangedEvent>(
        this as PollVoteChangedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PollVoteChangedEvent &&
            (identical(other.activityId, activityId) || other.activityId == activityId) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.poll, poll) || other.poll == poll) &&
            (identical(other.pollVote, pollVote) || other.pollVote == pollVote) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    activityId,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    messageId,
    poll,
    pollVote,
    receivedAt,
    type,
  );

  @override
  String toString() {
    return 'PollVoteChangedEvent(activityId: $activityId, cid: $cid, createdAt: $createdAt, custom: $custom, messageId: $messageId, poll: $poll, pollVote: $pollVote, receivedAt: $receivedAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $PollVoteChangedEventCopyWith<$Res> {
  factory $PollVoteChangedEventCopyWith(
    PollVoteChangedEvent value,
    $Res Function(PollVoteChangedEvent) _then,
  ) = _$PollVoteChangedEventCopyWithImpl;
  @useResult
  $Res call({
    String? activityId,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    String? messageId,
    PollResponseData poll,
    PollVoteResponseData pollVote,
    DateTime? receivedAt,
    String type,
  });
}

/// @nodoc
class _$PollVoteChangedEventCopyWithImpl<$Res> implements $PollVoteChangedEventCopyWith<$Res> {
  _$PollVoteChangedEventCopyWithImpl(this._self, this._then);

  final PollVoteChangedEvent _self;
  final $Res Function(PollVoteChangedEvent) _then;

  /// Create a copy of PollVoteChangedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityId = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? messageId = freezed,
    Object? poll = null,
    Object? pollVote = null,
    Object? receivedAt = freezed,
    Object? type = null,
  }) {
    return _then(
      PollVoteChangedEvent(
        activityId: freezed == activityId
            ? _self.activityId
            : activityId // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        messageId: freezed == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        poll: null == poll
            ? _self.poll
            : poll // ignore: cast_nullable_to_non_nullable
                  as PollResponseData,
        pollVote: null == pollVote
            ? _self.pollVote
            : pollVote // ignore: cast_nullable_to_non_nullable
                  as PollVoteResponseData,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$PollVoteRemovedEvent {
  String? get activityId;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  String? get messageId;
  PollResponseData get poll;
  PollVoteResponseData get pollVote;
  DateTime? get receivedAt;
  String get type;

  /// Create a copy of PollVoteRemovedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PollVoteRemovedEventCopyWith<PollVoteRemovedEvent> get copyWith =>
      _$PollVoteRemovedEventCopyWithImpl<PollVoteRemovedEvent>(
        this as PollVoteRemovedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PollVoteRemovedEvent &&
            (identical(other.activityId, activityId) || other.activityId == activityId) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.poll, poll) || other.poll == poll) &&
            (identical(other.pollVote, pollVote) || other.pollVote == pollVote) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    activityId,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    messageId,
    poll,
    pollVote,
    receivedAt,
    type,
  );

  @override
  String toString() {
    return 'PollVoteRemovedEvent(activityId: $activityId, cid: $cid, createdAt: $createdAt, custom: $custom, messageId: $messageId, poll: $poll, pollVote: $pollVote, receivedAt: $receivedAt, type: $type)';
  }
}

/// @nodoc
abstract mixin class $PollVoteRemovedEventCopyWith<$Res> {
  factory $PollVoteRemovedEventCopyWith(
    PollVoteRemovedEvent value,
    $Res Function(PollVoteRemovedEvent) _then,
  ) = _$PollVoteRemovedEventCopyWithImpl;
  @useResult
  $Res call({
    String? activityId,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    String? messageId,
    PollResponseData poll,
    PollVoteResponseData pollVote,
    DateTime? receivedAt,
    String type,
  });
}

/// @nodoc
class _$PollVoteRemovedEventCopyWithImpl<$Res> implements $PollVoteRemovedEventCopyWith<$Res> {
  _$PollVoteRemovedEventCopyWithImpl(this._self, this._then);

  final PollVoteRemovedEvent _self;
  final $Res Function(PollVoteRemovedEvent) _then;

  /// Create a copy of PollVoteRemovedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? activityId = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? messageId = freezed,
    Object? poll = null,
    Object? pollVote = null,
    Object? receivedAt = freezed,
    Object? type = null,
  }) {
    return _then(
      PollVoteRemovedEvent(
        activityId: freezed == activityId
            ? _self.activityId
            : activityId // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        messageId: freezed == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        poll: null == poll
            ? _self.poll
            : poll // ignore: cast_nullable_to_non_nullable
                  as PollResponseData,
        pollVote: null == pollVote
            ? _self.pollVote
            : pollVote // ignore: cast_nullable_to_non_nullable
                  as PollVoteResponseData,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$ReactionDeletedEvent {
  ChannelResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  MessageResponse? get message;
  String? get messageId;
  ReactionResponse? get reaction;
  DateTime? get receivedAt;
  String? get team;
  List<UserResponseCommonFields>? get threadParticipants;
  String get type;
  UserResponseCommonFields? get user;

  /// Create a copy of ReactionDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReactionDeletedEventCopyWith<ReactionDeletedEvent> get copyWith =>
      _$ReactionDeletedEventCopyWithImpl<ReactionDeletedEvent>(
        this as ReactionDeletedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReactionDeletedEvent &&
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.reaction, reaction) || other.reaction == reaction) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            const DeepCollectionEquality().equals(
              other.threadParticipants,
              threadParticipants,
            ) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    message,
    messageId,
    reaction,
    receivedAt,
    team,
    const DeepCollectionEquality().hash(threadParticipants),
    type,
    user,
  );

  @override
  String toString() {
    return 'ReactionDeletedEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, message: $message, messageId: $messageId, reaction: $reaction, receivedAt: $receivedAt, team: $team, threadParticipants: $threadParticipants, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $ReactionDeletedEventCopyWith<$Res> {
  factory $ReactionDeletedEventCopyWith(
    ReactionDeletedEvent value,
    $Res Function(ReactionDeletedEvent) _then,
  ) = _$ReactionDeletedEventCopyWithImpl;
  @useResult
  $Res call({
    ChannelResponse channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    MessageResponse? message,
    String? messageId,
    ReactionResponse? reaction,
    DateTime? receivedAt,
    String? team,
    List<UserResponseCommonFields>? threadParticipants,
    String type,
    UserResponseCommonFields? user,
  });
}

/// @nodoc
class _$ReactionDeletedEventCopyWithImpl<$Res> implements $ReactionDeletedEventCopyWith<$Res> {
  _$ReactionDeletedEventCopyWithImpl(this._self, this._then);

  final ReactionDeletedEvent _self;
  final $Res Function(ReactionDeletedEvent) _then;

  /// Create a copy of ReactionDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = null,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? message = freezed,
    Object? messageId = freezed,
    Object? reaction = freezed,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? threadParticipants = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      ReactionDeletedEvent(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse?,
        messageId: freezed == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        reaction: freezed == reaction
            ? _self.reaction
            : reaction // ignore: cast_nullable_to_non_nullable
                  as ReactionResponse?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        threadParticipants: freezed == threadParticipants
            ? _self.threadParticipants
            : threadParticipants // ignore: cast_nullable_to_non_nullable
                  as List<UserResponseCommonFields>?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$ReactionNewEvent {
  ChannelResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  MessageResponse? get message;
  String? get messageId;
  ReactionResponse? get reaction;
  DateTime? get receivedAt;
  String? get team;
  List<UserResponseCommonFields>? get threadParticipants;
  String get type;
  UserResponseCommonFields? get user;

  /// Create a copy of ReactionNewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReactionNewEventCopyWith<ReactionNewEvent> get copyWith => _$ReactionNewEventCopyWithImpl<ReactionNewEvent>(
    this as ReactionNewEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReactionNewEvent &&
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.reaction, reaction) || other.reaction == reaction) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            const DeepCollectionEquality().equals(
              other.threadParticipants,
              threadParticipants,
            ) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    message,
    messageId,
    reaction,
    receivedAt,
    team,
    const DeepCollectionEquality().hash(threadParticipants),
    type,
    user,
  );

  @override
  String toString() {
    return 'ReactionNewEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, message: $message, messageId: $messageId, reaction: $reaction, receivedAt: $receivedAt, team: $team, threadParticipants: $threadParticipants, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $ReactionNewEventCopyWith<$Res> {
  factory $ReactionNewEventCopyWith(
    ReactionNewEvent value,
    $Res Function(ReactionNewEvent) _then,
  ) = _$ReactionNewEventCopyWithImpl;
  @useResult
  $Res call({
    ChannelResponse channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    MessageResponse? message,
    String? messageId,
    ReactionResponse? reaction,
    DateTime? receivedAt,
    String? team,
    List<UserResponseCommonFields>? threadParticipants,
    String type,
    UserResponseCommonFields? user,
  });
}

/// @nodoc
class _$ReactionNewEventCopyWithImpl<$Res> implements $ReactionNewEventCopyWith<$Res> {
  _$ReactionNewEventCopyWithImpl(this._self, this._then);

  final ReactionNewEvent _self;
  final $Res Function(ReactionNewEvent) _then;

  /// Create a copy of ReactionNewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = null,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? message = freezed,
    Object? messageId = freezed,
    Object? reaction = freezed,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? threadParticipants = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      ReactionNewEvent(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse?,
        messageId: freezed == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        reaction: freezed == reaction
            ? _self.reaction
            : reaction // ignore: cast_nullable_to_non_nullable
                  as ReactionResponse?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        threadParticipants: freezed == threadParticipants
            ? _self.threadParticipants
            : threadParticipants // ignore: cast_nullable_to_non_nullable
                  as List<UserResponseCommonFields>?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$ReactionUpdatedEvent {
  ChannelResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  MessageResponse get message;
  String get messageId;
  ReactionResponse? get reaction;
  DateTime? get receivedAt;
  String? get team;
  String get type;
  UserResponseCommonFields? get user;

  /// Create a copy of ReactionUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReactionUpdatedEventCopyWith<ReactionUpdatedEvent> get copyWith =>
      _$ReactionUpdatedEventCopyWithImpl<ReactionUpdatedEvent>(
        this as ReactionUpdatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReactionUpdatedEvent &&
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.reaction, reaction) || other.reaction == reaction) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    message,
    messageId,
    reaction,
    receivedAt,
    team,
    type,
    user,
  );

  @override
  String toString() {
    return 'ReactionUpdatedEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, message: $message, messageId: $messageId, reaction: $reaction, receivedAt: $receivedAt, team: $team, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $ReactionUpdatedEventCopyWith<$Res> {
  factory $ReactionUpdatedEventCopyWith(
    ReactionUpdatedEvent value,
    $Res Function(ReactionUpdatedEvent) _then,
  ) = _$ReactionUpdatedEventCopyWithImpl;
  @useResult
  $Res call({
    ChannelResponse channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    MessageResponse message,
    String messageId,
    ReactionResponse? reaction,
    DateTime? receivedAt,
    String? team,
    String type,
    UserResponseCommonFields? user,
  });
}

/// @nodoc
class _$ReactionUpdatedEventCopyWithImpl<$Res> implements $ReactionUpdatedEventCopyWith<$Res> {
  _$ReactionUpdatedEventCopyWithImpl(this._self, this._then);

  final ReactionUpdatedEvent _self;
  final $Res Function(ReactionUpdatedEvent) _then;

  /// Create a copy of ReactionUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = null,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? message = null,
    Object? messageId = null,
    Object? reaction = freezed,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      ReactionUpdatedEvent(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        message: null == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse,
        messageId: null == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String,
        reaction: freezed == reaction
            ? _self.reaction
            : reaction // ignore: cast_nullable_to_non_nullable
                  as ReactionResponse?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$ReminderCreatedEvent {
  String get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  String get messageId;
  String? get parentId;
  DateTime? get receivedAt;
  ReminderResponseData get reminder;
  String get type;
  String get userId;

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
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.parentId, parentId) || other.parentId == parentId) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.reminder, reminder) || other.reminder == reminder) &&
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
    return 'ReminderCreatedEvent(cid: $cid, createdAt: $createdAt, custom: $custom, messageId: $messageId, parentId: $parentId, receivedAt: $receivedAt, reminder: $reminder, type: $type, userId: $userId)';
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
      ReminderCreatedEvent(
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
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.parentId, parentId) || other.parentId == parentId) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.reminder, reminder) || other.reminder == reminder) &&
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

/// @nodoc
mixin _$ReminderNotificationEvent {
  String get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  String get messageId;
  String? get parentId;
  DateTime? get receivedAt;
  ReminderResponseData get reminder;
  String get type;
  String get userId;

  /// Create a copy of ReminderNotificationEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReminderNotificationEventCopyWith<ReminderNotificationEvent> get copyWith =>
      _$ReminderNotificationEventCopyWithImpl<ReminderNotificationEvent>(
        this as ReminderNotificationEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReminderNotificationEvent &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.parentId, parentId) || other.parentId == parentId) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.reminder, reminder) || other.reminder == reminder) &&
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
    return 'ReminderNotificationEvent(cid: $cid, createdAt: $createdAt, custom: $custom, messageId: $messageId, parentId: $parentId, receivedAt: $receivedAt, reminder: $reminder, type: $type, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $ReminderNotificationEventCopyWith<$Res> {
  factory $ReminderNotificationEventCopyWith(
    ReminderNotificationEvent value,
    $Res Function(ReminderNotificationEvent) _then,
  ) = _$ReminderNotificationEventCopyWithImpl;
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
class _$ReminderNotificationEventCopyWithImpl<$Res> implements $ReminderNotificationEventCopyWith<$Res> {
  _$ReminderNotificationEventCopyWithImpl(this._self, this._then);

  final ReminderNotificationEvent _self;
  final $Res Function(ReminderNotificationEvent) _then;

  /// Create a copy of ReminderNotificationEvent
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
      ReminderNotificationEvent(
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

/// @nodoc
mixin _$ReminderUpdatedEvent {
  String get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  String get messageId;
  String? get parentId;
  DateTime? get receivedAt;
  ReminderResponseData get reminder;
  String get type;
  String get userId;

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
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.parentId, parentId) || other.parentId == parentId) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.reminder, reminder) || other.reminder == reminder) &&
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
    return 'ReminderUpdatedEvent(cid: $cid, createdAt: $createdAt, custom: $custom, messageId: $messageId, parentId: $parentId, receivedAt: $receivedAt, reminder: $reminder, type: $type, userId: $userId)';
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
      ReminderUpdatedEvent(
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

/// @nodoc
mixin _$ScheduledMessageCreatedEvent {
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  ScheduledMessageResponse? get scheduledMessage;
  String get type;
  UserResponseCommonFields get user;

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
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.scheduledMessage, scheduledMessage) || other.scheduledMessage == scheduledMessage) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    scheduledMessage,
    type,
    user,
  );

  @override
  String toString() {
    return 'ScheduledMessageCreatedEvent(cid: $cid, createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, scheduledMessage: $scheduledMessage, type: $type, user: $user)';
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
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    ScheduledMessageResponse? scheduledMessage,
    String type,
    UserResponseCommonFields user,
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
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? scheduledMessage = freezed,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      ScheduledMessageCreatedEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        scheduledMessage: freezed == scheduledMessage
            ? _self.scheduledMessage
            : scheduledMessage // ignore: cast_nullable_to_non_nullable
                  as ScheduledMessageResponse?,
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

/// @nodoc
mixin _$ScheduledMessageDeletedEvent {
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  ScheduledMessageResponse? get scheduledMessage;
  String get type;
  UserResponseCommonFields get user;

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
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.scheduledMessage, scheduledMessage) || other.scheduledMessage == scheduledMessage) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    scheduledMessage,
    type,
    user,
  );

  @override
  String toString() {
    return 'ScheduledMessageDeletedEvent(cid: $cid, createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, scheduledMessage: $scheduledMessage, type: $type, user: $user)';
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
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    ScheduledMessageResponse? scheduledMessage,
    String type,
    UserResponseCommonFields user,
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
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? scheduledMessage = freezed,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      ScheduledMessageDeletedEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        scheduledMessage: freezed == scheduledMessage
            ? _self.scheduledMessage
            : scheduledMessage // ignore: cast_nullable_to_non_nullable
                  as ScheduledMessageResponse?,
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

/// @nodoc
mixin _$ScheduledMessageFailedEvent {
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  ScheduledMessageResponse? get scheduledMessage;
  String get type;
  UserResponseCommonFields get user;

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
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.scheduledMessage, scheduledMessage) || other.scheduledMessage == scheduledMessage) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    scheduledMessage,
    type,
    user,
  );

  @override
  String toString() {
    return 'ScheduledMessageFailedEvent(cid: $cid, createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, scheduledMessage: $scheduledMessage, type: $type, user: $user)';
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
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    ScheduledMessageResponse? scheduledMessage,
    String type,
    UserResponseCommonFields user,
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
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? scheduledMessage = freezed,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      ScheduledMessageFailedEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        scheduledMessage: freezed == scheduledMessage
            ? _self.scheduledMessage
            : scheduledMessage // ignore: cast_nullable_to_non_nullable
                  as ScheduledMessageResponse?,
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

/// @nodoc
mixin _$ScheduledMessageSentEvent {
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  String get messageId;
  DateTime? get receivedAt;
  ScheduledMessageResponse? get scheduledMessage;
  String get type;
  UserResponseCommonFields get user;

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
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.scheduledMessage, scheduledMessage) || other.scheduledMessage == scheduledMessage) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    messageId,
    receivedAt,
    scheduledMessage,
    type,
    user,
  );

  @override
  String toString() {
    return 'ScheduledMessageSentEvent(cid: $cid, createdAt: $createdAt, custom: $custom, messageId: $messageId, receivedAt: $receivedAt, scheduledMessage: $scheduledMessage, type: $type, user: $user)';
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
    DateTime createdAt,
    Map<String, Object?> custom,
    String messageId,
    DateTime? receivedAt,
    ScheduledMessageResponse? scheduledMessage,
    String type,
    UserResponseCommonFields user,
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
    Object? createdAt = null,
    Object? custom = null,
    Object? messageId = null,
    Object? receivedAt = freezed,
    Object? scheduledMessage = freezed,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      ScheduledMessageSentEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
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
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        scheduledMessage: freezed == scheduledMessage
            ? _self.scheduledMessage
            : scheduledMessage // ignore: cast_nullable_to_non_nullable
                  as ScheduledMessageResponse?,
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

/// @nodoc
mixin _$ScheduledMessageUpdatedEvent {
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  ScheduledMessageResponse? get scheduledMessage;
  String get type;
  UserResponseCommonFields get user;

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
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.scheduledMessage, scheduledMessage) || other.scheduledMessage == scheduledMessage) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    scheduledMessage,
    type,
    user,
  );

  @override
  String toString() {
    return 'ScheduledMessageUpdatedEvent(cid: $cid, createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, scheduledMessage: $scheduledMessage, type: $type, user: $user)';
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
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    ScheduledMessageResponse? scheduledMessage,
    String type,
    UserResponseCommonFields user,
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
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? scheduledMessage = freezed,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      ScheduledMessageUpdatedEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        scheduledMessage: freezed == scheduledMessage
            ? _self.scheduledMessage
            : scheduledMessage // ignore: cast_nullable_to_non_nullable
                  as ScheduledMessageResponse?,
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

/// @nodoc
mixin _$ThreadUpdatedEvent {
  String? get channelId;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  ThreadResponse? get thread;
  String get type;

  /// Create a copy of ThreadUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ThreadUpdatedEventCopyWith<ThreadUpdatedEvent> get copyWith => _$ThreadUpdatedEventCopyWithImpl<ThreadUpdatedEvent>(
    this as ThreadUpdatedEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ThreadUpdatedEvent &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.thread, thread) || other.thread == thread) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channelId,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    thread,
    type,
  );

  @override
  String toString() {
    return 'ThreadUpdatedEvent(channelId: $channelId, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, thread: $thread, type: $type)';
  }
}

/// @nodoc
abstract mixin class $ThreadUpdatedEventCopyWith<$Res> {
  factory $ThreadUpdatedEventCopyWith(
    ThreadUpdatedEvent value,
    $Res Function(ThreadUpdatedEvent) _then,
  ) = _$ThreadUpdatedEventCopyWithImpl;
  @useResult
  $Res call({
    String? channelId,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    ThreadResponse? thread,
    String type,
  });
}

/// @nodoc
class _$ThreadUpdatedEventCopyWithImpl<$Res> implements $ThreadUpdatedEventCopyWith<$Res> {
  _$ThreadUpdatedEventCopyWithImpl(this._self, this._then);

  final ThreadUpdatedEvent _self;
  final $Res Function(ThreadUpdatedEvent) _then;

  /// Create a copy of ThreadUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? thread = freezed,
    Object? type = null,
  }) {
    return _then(
      ThreadUpdatedEvent(
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        thread: freezed == thread
            ? _self.thread
            : thread // ignore: cast_nullable_to_non_nullable
                  as ThreadResponse?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
mixin _$TypingStartEvent {
  String? get channelId;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  ChannelMemberPartialResponse? get member;
  String? get parentId;
  DateTime? get receivedAt;
  String get type;
  UserResponseCommonFields? get user;

  /// Create a copy of TypingStartEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TypingStartEventCopyWith<TypingStartEvent> get copyWith => _$TypingStartEventCopyWithImpl<TypingStartEvent>(
    this as TypingStartEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TypingStartEvent &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.member, member) || other.member == member) &&
            (identical(other.parentId, parentId) || other.parentId == parentId) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channelId,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    member,
    parentId,
    receivedAt,
    type,
    user,
  );

  @override
  String toString() {
    return 'TypingStartEvent(channelId: $channelId, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, member: $member, parentId: $parentId, receivedAt: $receivedAt, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $TypingStartEventCopyWith<$Res> {
  factory $TypingStartEventCopyWith(
    TypingStartEvent value,
    $Res Function(TypingStartEvent) _then,
  ) = _$TypingStartEventCopyWithImpl;
  @useResult
  $Res call({
    String? channelId,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    ChannelMemberPartialResponse? member,
    String? parentId,
    DateTime? receivedAt,
    String type,
    UserResponseCommonFields? user,
  });
}

/// @nodoc
class _$TypingStartEventCopyWithImpl<$Res> implements $TypingStartEventCopyWith<$Res> {
  _$TypingStartEventCopyWithImpl(this._self, this._then);

  final TypingStartEvent _self;
  final $Res Function(TypingStartEvent) _then;

  /// Create a copy of TypingStartEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? member = freezed,
    Object? parentId = freezed,
    Object? receivedAt = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      TypingStartEvent(
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        member: freezed == member
            ? _self.member
            : member // ignore: cast_nullable_to_non_nullable
                  as ChannelMemberPartialResponse?,
        parentId: freezed == parentId
            ? _self.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$TypingStopEvent {
  String? get channelId;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  ChannelMemberPartialResponse? get member;
  String? get parentId;
  DateTime? get receivedAt;
  String get type;
  UserResponseCommonFields? get user;

  /// Create a copy of TypingStopEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TypingStopEventCopyWith<TypingStopEvent> get copyWith => _$TypingStopEventCopyWithImpl<TypingStopEvent>(
    this as TypingStopEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TypingStopEvent &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.member, member) || other.member == member) &&
            (identical(other.parentId, parentId) || other.parentId == parentId) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channelId,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    member,
    parentId,
    receivedAt,
    type,
    user,
  );

  @override
  String toString() {
    return 'TypingStopEvent(channelId: $channelId, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, member: $member, parentId: $parentId, receivedAt: $receivedAt, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $TypingStopEventCopyWith<$Res> {
  factory $TypingStopEventCopyWith(
    TypingStopEvent value,
    $Res Function(TypingStopEvent) _then,
  ) = _$TypingStopEventCopyWithImpl;
  @useResult
  $Res call({
    String? channelId,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    ChannelMemberPartialResponse? member,
    String? parentId,
    DateTime? receivedAt,
    String type,
    UserResponseCommonFields? user,
  });
}

/// @nodoc
class _$TypingStopEventCopyWithImpl<$Res> implements $TypingStopEventCopyWith<$Res> {
  _$TypingStopEventCopyWithImpl(this._self, this._then);

  final TypingStopEvent _self;
  final $Res Function(TypingStopEvent) _then;

  /// Create a copy of TypingStopEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? member = freezed,
    Object? parentId = freezed,
    Object? receivedAt = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      TypingStopEvent(
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        member: freezed == member
            ? _self.member
            : member // ignore: cast_nullable_to_non_nullable
                  as ChannelMemberPartialResponse?,
        parentId: freezed == parentId
            ? _self.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}

/// @nodoc
mixin _$UserBannedEvent {
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  UserResponseCommonFields? get createdBy;
  Map<String, Object?> get custom;
  DateTime? get expiration;
  String? get reason;
  DateTime? get receivedAt;
  String? get reviewQueueItemId;
  bool? get shadow;
  String? get team;
  int? get totalBans;
  String get type;
  UserResponseCommonFields get user;

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
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) || other.createdBy == createdBy) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.expiration, expiration) || other.expiration == expiration) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.reviewQueueItemId, reviewQueueItemId) || other.reviewQueueItemId == reviewQueueItemId) &&
            (identical(other.shadow, shadow) || other.shadow == shadow) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.totalBans, totalBans) || other.totalBans == totalBans) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    createdBy,
    const DeepCollectionEquality().hash(custom),
    expiration,
    reason,
    receivedAt,
    reviewQueueItemId,
    shadow,
    team,
    totalBans,
    type,
    user,
  );

  @override
  String toString() {
    return 'UserBannedEvent(channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, createdBy: $createdBy, custom: $custom, expiration: $expiration, reason: $reason, receivedAt: $receivedAt, reviewQueueItemId: $reviewQueueItemId, shadow: $shadow, team: $team, totalBans: $totalBans, type: $type, user: $user)';
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
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    UserResponseCommonFields? createdBy,
    Map<String, Object?> custom,
    DateTime? expiration,
    String? reason,
    DateTime? receivedAt,
    String? reviewQueueItemId,
    bool? shadow,
    String? team,
    int? totalBans,
    String type,
    UserResponseCommonFields user,
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
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? createdBy = freezed,
    Object? custom = null,
    Object? expiration = freezed,
    Object? reason = freezed,
    Object? receivedAt = freezed,
    Object? reviewQueueItemId = freezed,
    Object? shadow = freezed,
    Object? team = freezed,
    Object? totalBans = freezed,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      UserBannedEvent(
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdBy: freezed == createdBy
            ? _self.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        expiration: freezed == expiration
            ? _self.expiration
            : expiration // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        reason: freezed == reason
            ? _self.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        reviewQueueItemId: freezed == reviewQueueItemId
            ? _self.reviewQueueItemId
            : reviewQueueItemId // ignore: cast_nullable_to_non_nullable
                  as String?,
        shadow: freezed == shadow
            ? _self.shadow
            : shadow // ignore: cast_nullable_to_non_nullable
                  as bool?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalBans: freezed == totalBans
            ? _self.totalBans
            : totalBans // ignore: cast_nullable_to_non_nullable
                  as int?,
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

/// @nodoc
mixin _$UserClaimedEvent {
  UserResponseCommonFields get claimedBy;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String get type;
  UserResponseCommonFields get user;

  /// Create a copy of UserClaimedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserClaimedEventCopyWith<UserClaimedEvent> get copyWith => _$UserClaimedEventCopyWithImpl<UserClaimedEvent>(
    this as UserClaimedEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserClaimedEvent &&
            (identical(other.claimedBy, claimedBy) || other.claimedBy == claimedBy) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    claimedBy,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    type,
    user,
  );

  @override
  String toString() {
    return 'UserClaimedEvent(claimedBy: $claimedBy, createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $UserClaimedEventCopyWith<$Res> {
  factory $UserClaimedEventCopyWith(
    UserClaimedEvent value,
    $Res Function(UserClaimedEvent) _then,
  ) = _$UserClaimedEventCopyWithImpl;
  @useResult
  $Res call({
    UserResponseCommonFields claimedBy,
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String type,
    UserResponseCommonFields user,
  });
}

/// @nodoc
class _$UserClaimedEventCopyWithImpl<$Res> implements $UserClaimedEventCopyWith<$Res> {
  _$UserClaimedEventCopyWithImpl(this._self, this._then);

  final UserClaimedEvent _self;
  final $Res Function(UserClaimedEvent) _then;

  /// Create a copy of UserClaimedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? claimedBy = null,
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      UserClaimedEvent(
        claimedBy: null == claimedBy
            ? _self.claimedBy
            : claimedBy // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
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

/// @nodoc
mixin _$UserDeactivatedEvent {
  DateTime get createdAt;
  UserResponseCommonFields? get createdBy;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String get type;
  UserResponseCommonFields get user;

  /// Create a copy of UserDeactivatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserDeactivatedEventCopyWith<UserDeactivatedEvent> get copyWith =>
      _$UserDeactivatedEventCopyWithImpl<UserDeactivatedEvent>(
        this as UserDeactivatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserDeactivatedEvent &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) || other.createdBy == createdBy) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    createdBy,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    type,
    user,
  );

  @override
  String toString() {
    return 'UserDeactivatedEvent(createdAt: $createdAt, createdBy: $createdBy, custom: $custom, receivedAt: $receivedAt, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $UserDeactivatedEventCopyWith<$Res> {
  factory $UserDeactivatedEventCopyWith(
    UserDeactivatedEvent value,
    $Res Function(UserDeactivatedEvent) _then,
  ) = _$UserDeactivatedEventCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    UserResponseCommonFields? createdBy,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String type,
    UserResponseCommonFields user,
  });
}

/// @nodoc
class _$UserDeactivatedEventCopyWithImpl<$Res> implements $UserDeactivatedEventCopyWith<$Res> {
  _$UserDeactivatedEventCopyWithImpl(this._self, this._then);

  final UserDeactivatedEvent _self;
  final $Res Function(UserDeactivatedEvent) _then;

  /// Create a copy of UserDeactivatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? createdBy = freezed,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      UserDeactivatedEvent(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdBy: freezed == createdBy
            ? _self.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
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
  $UserDeletedEventCopyWith<UserDeletedEvent> get copyWith => _$UserDeletedEventCopyWithImpl<UserDeletedEvent>(
    this as UserDeletedEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserDeletedEvent &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.deleteConversation, deleteConversation) ||
                other.deleteConversation == deleteConversation) &&
            (identical(
                  other.deleteConversationChannels,
                  deleteConversationChannels,
                ) ||
                other.deleteConversationChannels == deleteConversationChannels) &&
            (identical(other.deleteMessages, deleteMessages) || other.deleteMessages == deleteMessages) &&
            (identical(other.deleteUser, deleteUser) || other.deleteUser == deleteUser) &&
            (identical(other.hardDelete, hardDelete) || other.hardDelete == hardDelete) &&
            (identical(other.markMessagesDeleted, markMessagesDeleted) ||
                other.markMessagesDeleted == markMessagesDeleted) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
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
class _$UserDeletedEventCopyWithImpl<$Res> implements $UserDeletedEventCopyWith<$Res> {
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

/// @nodoc
mixin _$UserGroupCreatedEvent {
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String get type;
  UserResponseCommonFields? get user;
  UserGroup? get userGroup;

  /// Create a copy of UserGroupCreatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserGroupCreatedEventCopyWith<UserGroupCreatedEvent> get copyWith =>
      _$UserGroupCreatedEventCopyWithImpl<UserGroupCreatedEvent>(
        this as UserGroupCreatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserGroupCreatedEvent &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.userGroup, userGroup) || other.userGroup == userGroup));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    type,
    user,
    userGroup,
  );

  @override
  String toString() {
    return 'UserGroupCreatedEvent(createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, type: $type, user: $user, userGroup: $userGroup)';
  }
}

/// @nodoc
abstract mixin class $UserGroupCreatedEventCopyWith<$Res> {
  factory $UserGroupCreatedEventCopyWith(
    UserGroupCreatedEvent value,
    $Res Function(UserGroupCreatedEvent) _then,
  ) = _$UserGroupCreatedEventCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String type,
    UserResponseCommonFields? user,
    UserGroup? userGroup,
  });
}

/// @nodoc
class _$UserGroupCreatedEventCopyWithImpl<$Res> implements $UserGroupCreatedEventCopyWith<$Res> {
  _$UserGroupCreatedEventCopyWithImpl(this._self, this._then);

  final UserGroupCreatedEvent _self;
  final $Res Function(UserGroupCreatedEvent) _then;

  /// Create a copy of UserGroupCreatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? type = null,
    Object? user = freezed,
    Object? userGroup = freezed,
  }) {
    return _then(
      UserGroupCreatedEvent(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
        userGroup: freezed == userGroup
            ? _self.userGroup
            : userGroup // ignore: cast_nullable_to_non_nullable
                  as UserGroup?,
      ),
    );
  }
}

/// @nodoc
mixin _$UserGroupDeletedEvent {
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String get type;
  UserResponseCommonFields? get user;
  UserGroup? get userGroup;

  /// Create a copy of UserGroupDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserGroupDeletedEventCopyWith<UserGroupDeletedEvent> get copyWith =>
      _$UserGroupDeletedEventCopyWithImpl<UserGroupDeletedEvent>(
        this as UserGroupDeletedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserGroupDeletedEvent &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.userGroup, userGroup) || other.userGroup == userGroup));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    type,
    user,
    userGroup,
  );

  @override
  String toString() {
    return 'UserGroupDeletedEvent(createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, type: $type, user: $user, userGroup: $userGroup)';
  }
}

/// @nodoc
abstract mixin class $UserGroupDeletedEventCopyWith<$Res> {
  factory $UserGroupDeletedEventCopyWith(
    UserGroupDeletedEvent value,
    $Res Function(UserGroupDeletedEvent) _then,
  ) = _$UserGroupDeletedEventCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String type,
    UserResponseCommonFields? user,
    UserGroup? userGroup,
  });
}

/// @nodoc
class _$UserGroupDeletedEventCopyWithImpl<$Res> implements $UserGroupDeletedEventCopyWith<$Res> {
  _$UserGroupDeletedEventCopyWithImpl(this._self, this._then);

  final UserGroupDeletedEvent _self;
  final $Res Function(UserGroupDeletedEvent) _then;

  /// Create a copy of UserGroupDeletedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? type = null,
    Object? user = freezed,
    Object? userGroup = freezed,
  }) {
    return _then(
      UserGroupDeletedEvent(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
        userGroup: freezed == userGroup
            ? _self.userGroup
            : userGroup // ignore: cast_nullable_to_non_nullable
                  as UserGroup?,
      ),
    );
  }
}

/// @nodoc
mixin _$UserGroupMemberAddedEvent {
  DateTime get createdAt;
  Map<String, Object?> get custom;
  List<String> get members;
  DateTime? get receivedAt;
  String get type;
  UserResponseCommonFields? get user;
  UserGroup? get userGroup;

  /// Create a copy of UserGroupMemberAddedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserGroupMemberAddedEventCopyWith<UserGroupMemberAddedEvent> get copyWith =>
      _$UserGroupMemberAddedEventCopyWithImpl<UserGroupMemberAddedEvent>(
        this as UserGroupMemberAddedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserGroupMemberAddedEvent &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.userGroup, userGroup) || other.userGroup == userGroup));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    const DeepCollectionEquality().hash(members),
    receivedAt,
    type,
    user,
    userGroup,
  );

  @override
  String toString() {
    return 'UserGroupMemberAddedEvent(createdAt: $createdAt, custom: $custom, members: $members, receivedAt: $receivedAt, type: $type, user: $user, userGroup: $userGroup)';
  }
}

/// @nodoc
abstract mixin class $UserGroupMemberAddedEventCopyWith<$Res> {
  factory $UserGroupMemberAddedEventCopyWith(
    UserGroupMemberAddedEvent value,
    $Res Function(UserGroupMemberAddedEvent) _then,
  ) = _$UserGroupMemberAddedEventCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    Map<String, Object?> custom,
    List<String> members,
    DateTime? receivedAt,
    String type,
    UserResponseCommonFields? user,
    UserGroup? userGroup,
  });
}

/// @nodoc
class _$UserGroupMemberAddedEventCopyWithImpl<$Res> implements $UserGroupMemberAddedEventCopyWith<$Res> {
  _$UserGroupMemberAddedEventCopyWithImpl(this._self, this._then);

  final UserGroupMemberAddedEvent _self;
  final $Res Function(UserGroupMemberAddedEvent) _then;

  /// Create a copy of UserGroupMemberAddedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? custom = null,
    Object? members = null,
    Object? receivedAt = freezed,
    Object? type = null,
    Object? user = freezed,
    Object? userGroup = freezed,
  }) {
    return _then(
      UserGroupMemberAddedEvent(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        members: null == members
            ? _self.members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
        userGroup: freezed == userGroup
            ? _self.userGroup
            : userGroup // ignore: cast_nullable_to_non_nullable
                  as UserGroup?,
      ),
    );
  }
}

/// @nodoc
mixin _$UserGroupMemberRemovedEvent {
  DateTime get createdAt;
  Map<String, Object?> get custom;
  List<String> get members;
  DateTime? get receivedAt;
  String get type;
  UserResponseCommonFields? get user;
  UserGroup? get userGroup;

  /// Create a copy of UserGroupMemberRemovedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserGroupMemberRemovedEventCopyWith<UserGroupMemberRemovedEvent> get copyWith =>
      _$UserGroupMemberRemovedEventCopyWithImpl<UserGroupMemberRemovedEvent>(
        this as UserGroupMemberRemovedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserGroupMemberRemovedEvent &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.userGroup, userGroup) || other.userGroup == userGroup));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    const DeepCollectionEquality().hash(members),
    receivedAt,
    type,
    user,
    userGroup,
  );

  @override
  String toString() {
    return 'UserGroupMemberRemovedEvent(createdAt: $createdAt, custom: $custom, members: $members, receivedAt: $receivedAt, type: $type, user: $user, userGroup: $userGroup)';
  }
}

/// @nodoc
abstract mixin class $UserGroupMemberRemovedEventCopyWith<$Res> {
  factory $UserGroupMemberRemovedEventCopyWith(
    UserGroupMemberRemovedEvent value,
    $Res Function(UserGroupMemberRemovedEvent) _then,
  ) = _$UserGroupMemberRemovedEventCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    Map<String, Object?> custom,
    List<String> members,
    DateTime? receivedAt,
    String type,
    UserResponseCommonFields? user,
    UserGroup? userGroup,
  });
}

/// @nodoc
class _$UserGroupMemberRemovedEventCopyWithImpl<$Res> implements $UserGroupMemberRemovedEventCopyWith<$Res> {
  _$UserGroupMemberRemovedEventCopyWithImpl(this._self, this._then);

  final UserGroupMemberRemovedEvent _self;
  final $Res Function(UserGroupMemberRemovedEvent) _then;

  /// Create a copy of UserGroupMemberRemovedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? custom = null,
    Object? members = null,
    Object? receivedAt = freezed,
    Object? type = null,
    Object? user = freezed,
    Object? userGroup = freezed,
  }) {
    return _then(
      UserGroupMemberRemovedEvent(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        members: null == members
            ? _self.members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
        userGroup: freezed == userGroup
            ? _self.userGroup
            : userGroup // ignore: cast_nullable_to_non_nullable
                  as UserGroup?,
      ),
    );
  }
}

/// @nodoc
mixin _$UserGroupUpdatedEvent {
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String get type;
  UserResponseCommonFields? get user;
  UserGroup? get userGroup;

  /// Create a copy of UserGroupUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserGroupUpdatedEventCopyWith<UserGroupUpdatedEvent> get copyWith =>
      _$UserGroupUpdatedEventCopyWithImpl<UserGroupUpdatedEvent>(
        this as UserGroupUpdatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserGroupUpdatedEvent &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.userGroup, userGroup) || other.userGroup == userGroup));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    type,
    user,
    userGroup,
  );

  @override
  String toString() {
    return 'UserGroupUpdatedEvent(createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, type: $type, user: $user, userGroup: $userGroup)';
  }
}

/// @nodoc
abstract mixin class $UserGroupUpdatedEventCopyWith<$Res> {
  factory $UserGroupUpdatedEventCopyWith(
    UserGroupUpdatedEvent value,
    $Res Function(UserGroupUpdatedEvent) _then,
  ) = _$UserGroupUpdatedEventCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String type,
    UserResponseCommonFields? user,
    UserGroup? userGroup,
  });
}

/// @nodoc
class _$UserGroupUpdatedEventCopyWithImpl<$Res> implements $UserGroupUpdatedEventCopyWith<$Res> {
  _$UserGroupUpdatedEventCopyWithImpl(this._self, this._then);

  final UserGroupUpdatedEvent _self;
  final $Res Function(UserGroupUpdatedEvent) _then;

  /// Create a copy of UserGroupUpdatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? type = null,
    Object? user = freezed,
    Object? userGroup = freezed,
  }) {
    return _then(
      UserGroupUpdatedEvent(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
        userGroup: freezed == userGroup
            ? _self.userGroup
            : userGroup // ignore: cast_nullable_to_non_nullable
                  as UserGroup?,
      ),
    );
  }
}

/// @nodoc
mixin _$UserMessagesDeletedEvent {
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool? get hardDelete;
  DateTime? get receivedAt;
  String? get team;
  String get type;
  UserResponseCommonFields get user;

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
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.hardDelete, hardDelete) || other.hardDelete == hardDelete) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    hardDelete,
    receivedAt,
    team,
    type,
    user,
  );

  @override
  String toString() {
    return 'UserMessagesDeletedEvent(channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, hardDelete: $hardDelete, receivedAt: $receivedAt, team: $team, type: $type, user: $user)';
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
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    bool? hardDelete,
    DateTime? receivedAt,
    String? team,
    String type,
    UserResponseCommonFields user,
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
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? hardDelete = freezed,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      UserMessagesDeletedEvent(
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        hardDelete: freezed == hardDelete
            ? _self.hardDelete
            : hardDelete // ignore: cast_nullable_to_non_nullable
                  as bool?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
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

/// @nodoc
mixin _$UserMutedEvent {
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  UserResponseCommonFields? get targetUser;
  List<UserResponseCommonFields>? get targetUsers;
  String get type;
  UserResponseCommonFields get user;

  /// Create a copy of UserMutedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserMutedEventCopyWith<UserMutedEvent> get copyWith => _$UserMutedEventCopyWithImpl<UserMutedEvent>(
    this as UserMutedEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserMutedEvent &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.targetUser, targetUser) || other.targetUser == targetUser) &&
            const DeepCollectionEquality().equals(
              other.targetUsers,
              targetUsers,
            ) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    targetUser,
    const DeepCollectionEquality().hash(targetUsers),
    type,
    user,
  );

  @override
  String toString() {
    return 'UserMutedEvent(createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, targetUser: $targetUser, targetUsers: $targetUsers, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $UserMutedEventCopyWith<$Res> {
  factory $UserMutedEventCopyWith(
    UserMutedEvent value,
    $Res Function(UserMutedEvent) _then,
  ) = _$UserMutedEventCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    UserResponseCommonFields? targetUser,
    List<UserResponseCommonFields>? targetUsers,
    String type,
    UserResponseCommonFields user,
  });
}

/// @nodoc
class _$UserMutedEventCopyWithImpl<$Res> implements $UserMutedEventCopyWith<$Res> {
  _$UserMutedEventCopyWithImpl(this._self, this._then);

  final UserMutedEvent _self;
  final $Res Function(UserMutedEvent) _then;

  /// Create a copy of UserMutedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? targetUser = freezed,
    Object? targetUsers = freezed,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      UserMutedEvent(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        targetUser: freezed == targetUser
            ? _self.targetUser
            : targetUser // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
        targetUsers: freezed == targetUsers
            ? _self.targetUsers
            : targetUsers // ignore: cast_nullable_to_non_nullable
                  as List<UserResponseCommonFields>?,
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

/// @nodoc
mixin _$UserPresenceChangedEvent {
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String get type;
  UserResponseCommonFields get user;

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
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    type,
    user,
  );

  @override
  String toString() {
    return 'UserPresenceChangedEvent(createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, type: $type, user: $user)';
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
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String type,
    UserResponseCommonFields user,
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
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      UserPresenceChangedEvent(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
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

/// @nodoc
mixin _$UserReactivatedEvent {
  DateTime get createdAt;
  UserResponseCommonFields? get createdBy;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String get type;
  UserResponseCommonFields get user;

  /// Create a copy of UserReactivatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserReactivatedEventCopyWith<UserReactivatedEvent> get copyWith =>
      _$UserReactivatedEventCopyWithImpl<UserReactivatedEvent>(
        this as UserReactivatedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserReactivatedEvent &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) || other.createdBy == createdBy) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    createdBy,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    type,
    user,
  );

  @override
  String toString() {
    return 'UserReactivatedEvent(createdAt: $createdAt, createdBy: $createdBy, custom: $custom, receivedAt: $receivedAt, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $UserReactivatedEventCopyWith<$Res> {
  factory $UserReactivatedEventCopyWith(
    UserReactivatedEvent value,
    $Res Function(UserReactivatedEvent) _then,
  ) = _$UserReactivatedEventCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    UserResponseCommonFields? createdBy,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String type,
    UserResponseCommonFields user,
  });
}

/// @nodoc
class _$UserReactivatedEventCopyWithImpl<$Res> implements $UserReactivatedEventCopyWith<$Res> {
  _$UserReactivatedEventCopyWithImpl(this._self, this._then);

  final UserReactivatedEvent _self;
  final $Res Function(UserReactivatedEvent) _then;

  /// Create a copy of UserReactivatedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? createdBy = freezed,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      UserReactivatedEvent(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdBy: freezed == createdBy
            ? _self.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
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

/// @nodoc
mixin _$UserUnbannedEvent {
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  UserResponseCommonFields? get createdBy;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  bool? get shadow;
  String? get team;
  String get type;
  UserResponseCommonFields get user;

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
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) || other.createdBy == createdBy) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.shadow, shadow) || other.shadow == shadow) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    createdBy,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    shadow,
    team,
    type,
    user,
  );

  @override
  String toString() {
    return 'UserUnbannedEvent(channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, createdBy: $createdBy, custom: $custom, receivedAt: $receivedAt, shadow: $shadow, team: $team, type: $type, user: $user)';
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
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    UserResponseCommonFields? createdBy,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    bool? shadow,
    String? team,
    String type,
    UserResponseCommonFields user,
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
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? createdBy = freezed,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? shadow = freezed,
    Object? team = freezed,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      UserUnbannedEvent(
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdBy: freezed == createdBy
            ? _self.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        shadow: freezed == shadow
            ? _self.shadow
            : shadow // ignore: cast_nullable_to_non_nullable
                  as bool?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
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

/// @nodoc
mixin _$UserUpdatedEvent {
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String get type;
  UserResponsePrivacyFields get user;

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
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    type,
    user,
  );

  @override
  String toString() {
    return 'UserUpdatedEvent(createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, type: $type, user: $user)';
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
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String type,
    UserResponsePrivacyFields user,
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
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? type = null,
    Object? user = null,
  }) {
    return _then(
      UserUpdatedEvent(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
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
                  as UserResponsePrivacyFields,
      ),
    );
  }
}

/// @nodoc
mixin _$UserWatchingStartEvent {
  String? get channelId;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String get type;
  UserResponseCommonFields get user;
  int get watcherCount;

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
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.watcherCount, watcherCount) || other.watcherCount == watcherCount));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channelId,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    type,
    user,
    watcherCount,
  );

  @override
  String toString() {
    return 'UserWatchingStartEvent(channelId: $channelId, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, type: $type, user: $user, watcherCount: $watcherCount)';
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
    String? channelId,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String type,
    UserResponseCommonFields user,
    int watcherCount,
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
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? type = null,
    Object? user = null,
    Object? watcherCount = null,
  }) {
    return _then(
      UserWatchingStartEvent(
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
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
        watcherCount: null == watcherCount
            ? _self.watcherCount
            : watcherCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
mixin _$UserWatchingStopEvent {
  String? get channelId;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get receivedAt;
  String get type;
  UserResponseCommonFields get user;
  int get watcherCount;

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
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.watcherCount, watcherCount) || other.watcherCount == watcherCount));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channelId,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    receivedAt,
    type,
    user,
    watcherCount,
  );

  @override
  String toString() {
    return 'UserWatchingStopEvent(channelId: $channelId, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, receivedAt: $receivedAt, type: $type, user: $user, watcherCount: $watcherCount)';
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
    String? channelId,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? receivedAt,
    String type,
    UserResponseCommonFields user,
    int watcherCount,
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
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? receivedAt = freezed,
    Object? type = null,
    Object? user = null,
    Object? watcherCount = null,
  }) {
    return _then(
      UserWatchingStopEvent(
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
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
        watcherCount: null == watcherCount
            ? _self.watcherCount
            : watcherCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
