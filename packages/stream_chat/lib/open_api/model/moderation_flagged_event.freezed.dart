// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'moderation_flagged_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

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
            (identical(other.contentType, contentType) ||
                other.contentType == contentType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.objectId, objectId) ||
                other.objectId == objectId) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
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
class _$ModerationFlaggedEventCopyWithImpl<$Res>
    implements $ModerationFlaggedEventCopyWith<$Res> {
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
