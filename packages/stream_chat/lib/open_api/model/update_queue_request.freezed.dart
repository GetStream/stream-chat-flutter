// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_queue_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateQueueRequest {
  String? get description;
  Map<String, Object?>? get filters;
  String? get name;
  List<Map<String, Object?>>? get sort;

  /// Create a copy of UpdateQueueRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateQueueRequestCopyWith<UpdateQueueRequest> get copyWith => _$UpdateQueueRequestCopyWithImpl<UpdateQueueRequest>(
    this as UpdateQueueRequest,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateQueueRequest &&
            (identical(other.description, description) || other.description == description) &&
            const DeepCollectionEquality().equals(other.filters, filters) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other.sort, sort));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    description,
    const DeepCollectionEquality().hash(filters),
    name,
    const DeepCollectionEquality().hash(sort),
  );

  @override
  String toString() {
    return 'UpdateQueueRequest(description: $description, filters: $filters, name: $name, sort: $sort)';
  }
}

/// @nodoc
abstract mixin class $UpdateQueueRequestCopyWith<$Res> {
  factory $UpdateQueueRequestCopyWith(
    UpdateQueueRequest value,
    $Res Function(UpdateQueueRequest) _then,
  ) = _$UpdateQueueRequestCopyWithImpl;
  @useResult
  $Res call({
    String? description,
    Map<String, Object?>? filters,
    String? name,
    List<Map<String, Object?>>? sort,
  });
}

/// @nodoc
class _$UpdateQueueRequestCopyWithImpl<$Res> implements $UpdateQueueRequestCopyWith<$Res> {
  _$UpdateQueueRequestCopyWithImpl(this._self, this._then);

  final UpdateQueueRequest _self;
  final $Res Function(UpdateQueueRequest) _then;

  /// Create a copy of UpdateQueueRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = freezed,
    Object? filters = freezed,
    Object? name = freezed,
    Object? sort = freezed,
  }) {
    return _then(
      UpdateQueueRequest(
        description: freezed == description
            ? _self.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        filters: freezed == filters
            ? _self.filters
            : filters // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        name: freezed == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        sort: freezed == sort
            ? _self.sort
            : sort // ignore: cast_nullable_to_non_nullable
                  as List<Map<String, Object?>>?,
      ),
    );
  }
}
