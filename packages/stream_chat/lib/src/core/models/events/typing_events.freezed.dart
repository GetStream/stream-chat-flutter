// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'typing_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TypingStartEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  User? get user;
  String? get parentId;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

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
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.parentId, parentId) || other.parentId == parentId) &&
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
    parentId,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'TypingStartEvent(cid: $cid, channelId: $channelId, channelType: $channelType, user: $user, parentId: $parentId, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
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
    String? cid,
    String? channelId,
    String? channelType,
    User? user,
    String? parentId,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
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
    Object? cid = freezed,
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? user = freezed,
    Object? parentId = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      TypingStartEvent(
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
        parentId: freezed == parentId
            ? _self.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
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

/// @nodoc
mixin _$TypingStopEvent {
  String? get cid;
  String? get channelId;
  String? get channelType;
  User? get user;
  String? get parentId;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

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
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.channelId, channelId) || other.channelId == channelId) &&
            (identical(other.channelType, channelType) || other.channelType == channelType) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.parentId, parentId) || other.parentId == parentId) &&
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
    parentId,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'TypingStopEvent(cid: $cid, channelId: $channelId, channelType: $channelType, user: $user, parentId: $parentId, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
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
    String? cid,
    String? channelId,
    String? channelType,
    User? user,
    String? parentId,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
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
    Object? cid = freezed,
    Object? channelId = freezed,
    Object? channelType = freezed,
    Object? user = freezed,
    Object? parentId = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      TypingStopEvent(
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
        parentId: freezed == parentId
            ? _self.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
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
