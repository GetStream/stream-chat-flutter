// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'moderation_queue_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ModerationQueueResponse {
  DateTime get createdAt;
  String get createdBy;
  String get description;
  Map<String, Object?> get filters;
  String get id;
  int get itemCount;
  String get name;
  List<Map<String, Object?>> get sort;
  String get type;
  DateTime get updatedAt;

  /// Create a copy of ModerationQueueResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ModerationQueueResponseCopyWith<ModerationQueueResponse> get copyWith =>
      _$ModerationQueueResponseCopyWithImpl<ModerationQueueResponse>(
        this as ModerationQueueResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ModerationQueueResponse &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) || other.createdBy == createdBy) &&
            (identical(other.description, description) || other.description == description) &&
            const DeepCollectionEquality().equals(other.filters, filters) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.itemCount, itemCount) || other.itemCount == itemCount) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other.sort, sort) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    createdBy,
    description,
    const DeepCollectionEquality().hash(filters),
    id,
    itemCount,
    name,
    const DeepCollectionEquality().hash(sort),
    type,
    updatedAt,
  );

  @override
  String toString() {
    return 'ModerationQueueResponse(createdAt: $createdAt, createdBy: $createdBy, description: $description, filters: $filters, id: $id, itemCount: $itemCount, name: $name, sort: $sort, type: $type, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $ModerationQueueResponseCopyWith<$Res> {
  factory $ModerationQueueResponseCopyWith(
    ModerationQueueResponse value,
    $Res Function(ModerationQueueResponse) _then,
  ) = _$ModerationQueueResponseCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    String createdBy,
    String description,
    Map<String, Object?> filters,
    String id,
    int itemCount,
    String name,
    List<Map<String, Object?>> sort,
    String type,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$ModerationQueueResponseCopyWithImpl<$Res> implements $ModerationQueueResponseCopyWith<$Res> {
  _$ModerationQueueResponseCopyWithImpl(this._self, this._then);

  final ModerationQueueResponse _self;
  final $Res Function(ModerationQueueResponse) _then;

  /// Create a copy of ModerationQueueResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? createdBy = null,
    Object? description = null,
    Object? filters = null,
    Object? id = null,
    Object? itemCount = null,
    Object? name = null,
    Object? sort = null,
    Object? type = null,
    Object? updatedAt = null,
  }) {
    return _then(
      ModerationQueueResponse(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdBy: null == createdBy
            ? _self.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String,
        description: null == description
            ? _self.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        filters: null == filters
            ? _self.filters
            : filters // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        itemCount: null == itemCount
            ? _self.itemCount
            : itemCount // ignore: cast_nullable_to_non_nullable
                  as int,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        sort: null == sort
            ? _self.sort
            : sort // ignore: cast_nullable_to_non_nullable
                  as List<Map<String, Object?>>,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}
