// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connection_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HealthCheckEvent {
  String get connectionId;
  OwnUser get me;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of HealthCheckEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HealthCheckEventCopyWith<HealthCheckEvent> get copyWith => _$HealthCheckEventCopyWithImpl<HealthCheckEvent>(
    this as HealthCheckEvent,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HealthCheckEvent &&
            (identical(other.connectionId, connectionId) || other.connectionId == connectionId) &&
            (identical(other.me, me) || other.me == me) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    connectionId,
    me,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'HealthCheckEvent(connectionId: $connectionId, me: $me, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $HealthCheckEventCopyWith<$Res> {
  factory $HealthCheckEventCopyWith(
    HealthCheckEvent value,
    $Res Function(HealthCheckEvent) _then,
  ) = _$HealthCheckEventCopyWithImpl;
  @useResult
  $Res call({
    String connectionId,
    OwnUser me,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$HealthCheckEventCopyWithImpl<$Res> implements $HealthCheckEventCopyWith<$Res> {
  _$HealthCheckEventCopyWithImpl(this._self, this._then);

  final HealthCheckEvent _self;
  final $Res Function(HealthCheckEvent) _then;

  /// Create a copy of HealthCheckEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? connectionId = null,
    Object? me = null,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      HealthCheckEvent(
        connectionId: null == connectionId
            ? _self.connectionId
            : connectionId // ignore: cast_nullable_to_non_nullable
                  as String,
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
mixin _$ConnectionErrorEvent {
  StreamApiError get error;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of ConnectionErrorEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConnectionErrorEventCopyWith<ConnectionErrorEvent> get copyWith =>
      _$ConnectionErrorEventCopyWithImpl<ConnectionErrorEvent>(
        this as ConnectionErrorEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConnectionErrorEvent &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    error,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'ConnectionErrorEvent(error: $error, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $ConnectionErrorEventCopyWith<$Res> {
  factory $ConnectionErrorEventCopyWith(
    ConnectionErrorEvent value,
    $Res Function(ConnectionErrorEvent) _then,
  ) = _$ConnectionErrorEventCopyWithImpl;
  @useResult
  $Res call({
    StreamApiError error,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$ConnectionErrorEventCopyWithImpl<$Res> implements $ConnectionErrorEventCopyWith<$Res> {
  _$ConnectionErrorEventCopyWithImpl(this._self, this._then);

  final ConnectionErrorEvent _self;
  final $Res Function(ConnectionErrorEvent) _then;

  /// Create a copy of ConnectionErrorEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      ConnectionErrorEvent(
        error: null == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as StreamApiError,
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
mixin _$ConnectionChangedEvent {
  bool get online;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of ConnectionChangedEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConnectionChangedEventCopyWith<ConnectionChangedEvent> get copyWith =>
      _$ConnectionChangedEventCopyWithImpl<ConnectionChangedEvent>(
        this as ConnectionChangedEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConnectionChangedEvent &&
            (identical(other.online, online) || other.online == online) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    online,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'ConnectionChangedEvent(online: $online, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $ConnectionChangedEventCopyWith<$Res> {
  factory $ConnectionChangedEventCopyWith(
    ConnectionChangedEvent value,
    $Res Function(ConnectionChangedEvent) _then,
  ) = _$ConnectionChangedEventCopyWithImpl;
  @useResult
  $Res call({
    bool online,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
  });
}

/// @nodoc
class _$ConnectionChangedEventCopyWithImpl<$Res> implements $ConnectionChangedEventCopyWith<$Res> {
  _$ConnectionChangedEventCopyWithImpl(this._self, this._then);

  final ConnectionChangedEvent _self;
  final $Res Function(ConnectionChangedEvent) _then;

  /// Create a copy of ConnectionChangedEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? online = null,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      ConnectionChangedEvent(
        online: null == online
            ? _self.online
            : online // ignore: cast_nullable_to_non_nullable
                  as bool,
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
mixin _$ConnectionRecoveredEvent {
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

  /// Create a copy of ConnectionRecoveredEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ConnectionRecoveredEventCopyWith<ConnectionRecoveredEvent> get copyWith =>
      _$ConnectionRecoveredEventCopyWithImpl<ConnectionRecoveredEvent>(
        this as ConnectionRecoveredEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ConnectionRecoveredEvent &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'ConnectionRecoveredEvent(createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
  }
}

/// @nodoc
abstract mixin class $ConnectionRecoveredEventCopyWith<$Res> {
  factory $ConnectionRecoveredEventCopyWith(
    ConnectionRecoveredEvent value,
    $Res Function(ConnectionRecoveredEvent) _then,
  ) = _$ConnectionRecoveredEventCopyWithImpl;
  @useResult
  $Res call({DateTime? createdAt, Map<String, Object?> custom, bool isLocal});
}

/// @nodoc
class _$ConnectionRecoveredEventCopyWithImpl<$Res> implements $ConnectionRecoveredEventCopyWith<$Res> {
  _$ConnectionRecoveredEventCopyWithImpl(this._self, this._then);

  final ConnectionRecoveredEvent _self;
  final $Res Function(ConnectionRecoveredEvent) _then;

  /// Create a copy of ConnectionRecoveredEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      ConnectionRecoveredEvent(
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
