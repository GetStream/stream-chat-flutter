// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feeds_enriched_collection_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedsEnrichedCollectionResponse {
  DateTime get createdAt;
  Map<String, Object?> get custom;
  String get id;
  String get name;
  String get status;
  DateTime get updatedAt;
  String get userId;

  /// Create a copy of FeedsEnrichedCollectionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FeedsEnrichedCollectionResponseCopyWith<FeedsEnrichedCollectionResponse>
  get copyWith =>
      _$FeedsEnrichedCollectionResponseCopyWithImpl<
        FeedsEnrichedCollectionResponse
      >(this as FeedsEnrichedCollectionResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FeedsEnrichedCollectionResponse &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    id,
    name,
    status,
    updatedAt,
    userId,
  );

  @override
  String toString() {
    return 'FeedsEnrichedCollectionResponse(createdAt: $createdAt, custom: $custom, id: $id, name: $name, status: $status, updatedAt: $updatedAt, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $FeedsEnrichedCollectionResponseCopyWith<$Res> {
  factory $FeedsEnrichedCollectionResponseCopyWith(
    FeedsEnrichedCollectionResponse value,
    $Res Function(FeedsEnrichedCollectionResponse) _then,
  ) = _$FeedsEnrichedCollectionResponseCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    Map<String, Object?> custom,
    String id,
    String name,
    String status,
    DateTime updatedAt,
    String userId,
  });
}

/// @nodoc
class _$FeedsEnrichedCollectionResponseCopyWithImpl<$Res>
    implements $FeedsEnrichedCollectionResponseCopyWith<$Res> {
  _$FeedsEnrichedCollectionResponseCopyWithImpl(this._self, this._then);

  final FeedsEnrichedCollectionResponse _self;
  final $Res Function(FeedsEnrichedCollectionResponse) _then;

  /// Create a copy of FeedsEnrichedCollectionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? custom = null,
    Object? id = null,
    Object? name = null,
    Object? status = null,
    Object? updatedAt = null,
    Object? userId = null,
  }) {
    return _then(
      FeedsEnrichedCollectionResponse(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
