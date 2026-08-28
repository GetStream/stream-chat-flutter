// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'draft_deleted_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

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
