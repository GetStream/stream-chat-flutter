// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'draft_events.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DraftUpdatedEvent {
  String? get cid;
  Draft? get draft;
  String? get parentId;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

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
            (identical(other.draft, draft) || other.draft == draft) &&
            (identical(other.parentId, parentId) || other.parentId == parentId) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    draft,
    parentId,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'DraftUpdatedEvent(cid: $cid, draft: $draft, parentId: $parentId, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
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
    Draft? draft,
    String? parentId,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
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
    Object? draft = freezed,
    Object? parentId = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      DraftUpdatedEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        draft: freezed == draft
            ? _self.draft
            : draft // ignore: cast_nullable_to_non_nullable
                  as Draft?,
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
mixin _$DraftDeletedEvent {
  String? get cid;
  Draft? get draft;
  String? get parentId;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get isLocal;

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
            (identical(other.draft, draft) || other.draft == draft) &&
            (identical(other.parentId, parentId) || other.parentId == parentId) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.isLocal, isLocal) || other.isLocal == isLocal));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    draft,
    parentId,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    isLocal,
  );

  @override
  String toString() {
    return 'DraftDeletedEvent(cid: $cid, draft: $draft, parentId: $parentId, createdAt: $createdAt, custom: $custom, isLocal: $isLocal)';
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
    Draft? draft,
    String? parentId,
    DateTime? createdAt,
    Map<String, Object?> custom,
    bool isLocal,
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
    Object? draft = freezed,
    Object? parentId = freezed,
    Object? createdAt = freezed,
    Object? custom = null,
    Object? isLocal = null,
  }) {
    return _then(
      DraftDeletedEvent(
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        draft: freezed == draft
            ? _self.draft
            : draft // ignore: cast_nullable_to_non_nullable
                  as Draft?,
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
