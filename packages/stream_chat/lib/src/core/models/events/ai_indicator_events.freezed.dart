// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_indicator_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AIIndicatorUpdateEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  User? get user;
  AITypingState get aiState;
  String? get aiMessage;
  String get messageId;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

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
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.aiState, aiState) || other.aiState == aiState) &&
            (identical(other.aiMessage, aiMessage) || other.aiMessage == aiMessage) &&
            (identical(other.messageId, messageId) || other.messageId == messageId) &&
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
    aiState,
    aiMessage,
    messageId,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'AIIndicatorUpdateEvent(cid: $cid, channelId: $channelId, channelType: $channelType, user: $user, aiState: $aiState, aiMessage: $aiMessage, messageId: $messageId, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
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
    String? cid,
    String? channelId,
    String? channelType,
    User? user,
    AITypingState aiState,
    String? aiMessage,
    String messageId,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
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
    Object? cid = freezed,
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? user = freezed,
    Object? aiState = null,
    Object? aiMessage = freezed,
    Object? messageId = null,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      AIIndicatorUpdateEvent(
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
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User?,
        aiState: null == aiState
            ? _self.aiState
            : aiState // ignore: cast_nullable_to_non_nullable
                  as AITypingState,
        aiMessage: freezed == aiMessage
            ? _self.aiMessage
            : aiMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        messageId: null == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
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
mixin _$AIIndicatorStopEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  User? get user;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

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
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
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
    user,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'AIIndicatorStopEvent(cid: $cid, channelId: $channelId, channelType: $channelType, user: $user, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
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
    String? cid,
    String? channelId,
    String? channelType,
    User? user,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
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
    Object? cid = freezed,
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? user = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      AIIndicatorStopEvent(
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
mixin _$AIIndicatorClearEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  User? get user;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

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
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
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
    user,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'AIIndicatorClearEvent(cid: $cid, channelId: $channelId, channelType: $channelType, user: $user, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
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
    String? cid,
    String? channelId,
    String? channelType,
    User? user,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
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
    Object? cid = freezed,
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? user = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      AIIndicatorClearEvent(
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
