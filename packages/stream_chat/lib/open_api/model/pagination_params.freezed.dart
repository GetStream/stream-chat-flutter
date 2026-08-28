// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pagination_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaginationParams {
  int? get limit;
  int? get offset;

  /// Create a copy of PaginationParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PaginationParamsCopyWith<PaginationParams> get copyWith =>
      _$PaginationParamsCopyWithImpl<PaginationParams>(
        this as PaginationParams,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PaginationParams &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.offset, offset) || other.offset == offset));
  }

  @override
  int get hashCode => Object.hash(runtimeType, limit, offset);

  @override
  String toString() {
    return 'PaginationParams(limit: $limit, offset: $offset)';
  }
}

/// @nodoc
abstract mixin class $PaginationParamsCopyWith<$Res> {
  factory $PaginationParamsCopyWith(
    PaginationParams value,
    $Res Function(PaginationParams) _then,
  ) = _$PaginationParamsCopyWithImpl;
  @useResult
  $Res call({int? limit, int? offset});
}

/// @nodoc
class _$PaginationParamsCopyWithImpl<$Res>
    implements $PaginationParamsCopyWith<$Res> {
  _$PaginationParamsCopyWithImpl(this._self, this._then);

  final PaginationParams _self;
  final $Res Function(PaginationParams) _then;

  /// Create a copy of PaginationParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? limit = freezed, Object? offset = freezed}) {
    return _then(
      PaginationParams(
        limit: freezed == limit
            ? _self.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
        offset: freezed == offset
            ? _self.offset
            : offset // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}
