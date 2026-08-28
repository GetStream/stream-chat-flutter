// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_pagination_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessagePaginationParams {
  DateTime? get createdAtAfter;
  DateTime? get createdAtAfterOrEqual;
  DateTime? get createdAtAround;
  DateTime? get createdAtBefore;
  DateTime? get createdAtBeforeOrEqual;
  String? get idAround;
  String? get idGt;
  String? get idGte;
  String? get idLt;
  String? get idLte;
  int? get limit;

  /// Create a copy of MessagePaginationParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessagePaginationParamsCopyWith<MessagePaginationParams> get copyWith =>
      _$MessagePaginationParamsCopyWithImpl<MessagePaginationParams>(
        this as MessagePaginationParams,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MessagePaginationParams &&
            (identical(other.createdAtAfter, createdAtAfter) ||
                other.createdAtAfter == createdAtAfter) &&
            (identical(other.createdAtAfterOrEqual, createdAtAfterOrEqual) ||
                other.createdAtAfterOrEqual == createdAtAfterOrEqual) &&
            (identical(other.createdAtAround, createdAtAround) ||
                other.createdAtAround == createdAtAround) &&
            (identical(other.createdAtBefore, createdAtBefore) ||
                other.createdAtBefore == createdAtBefore) &&
            (identical(other.createdAtBeforeOrEqual, createdAtBeforeOrEqual) ||
                other.createdAtBeforeOrEqual == createdAtBeforeOrEqual) &&
            (identical(other.idAround, idAround) ||
                other.idAround == idAround) &&
            (identical(other.idGt, idGt) || other.idGt == idGt) &&
            (identical(other.idGte, idGte) || other.idGte == idGte) &&
            (identical(other.idLt, idLt) || other.idLt == idLt) &&
            (identical(other.idLte, idLte) || other.idLte == idLte) &&
            (identical(other.limit, limit) || other.limit == limit));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAtAfter,
    createdAtAfterOrEqual,
    createdAtAround,
    createdAtBefore,
    createdAtBeforeOrEqual,
    idAround,
    idGt,
    idGte,
    idLt,
    idLte,
    limit,
  );

  @override
  String toString() {
    return 'MessagePaginationParams(createdAtAfter: $createdAtAfter, createdAtAfterOrEqual: $createdAtAfterOrEqual, createdAtAround: $createdAtAround, createdAtBefore: $createdAtBefore, createdAtBeforeOrEqual: $createdAtBeforeOrEqual, idAround: $idAround, idGt: $idGt, idGte: $idGte, idLt: $idLt, idLte: $idLte, limit: $limit)';
  }
}

/// @nodoc
abstract mixin class $MessagePaginationParamsCopyWith<$Res> {
  factory $MessagePaginationParamsCopyWith(
    MessagePaginationParams value,
    $Res Function(MessagePaginationParams) _then,
  ) = _$MessagePaginationParamsCopyWithImpl;
  @useResult
  $Res call({
    DateTime? createdAtAfter,
    DateTime? createdAtAfterOrEqual,
    DateTime? createdAtAround,
    DateTime? createdAtBefore,
    DateTime? createdAtBeforeOrEqual,
    String? idAround,
    String? idGt,
    String? idGte,
    String? idLt,
    String? idLte,
    int? limit,
  });
}

/// @nodoc
class _$MessagePaginationParamsCopyWithImpl<$Res>
    implements $MessagePaginationParamsCopyWith<$Res> {
  _$MessagePaginationParamsCopyWithImpl(this._self, this._then);

  final MessagePaginationParams _self;
  final $Res Function(MessagePaginationParams) _then;

  /// Create a copy of MessagePaginationParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAtAfter = freezed,
    Object? createdAtAfterOrEqual = freezed,
    Object? createdAtAround = freezed,
    Object? createdAtBefore = freezed,
    Object? createdAtBeforeOrEqual = freezed,
    Object? idAround = freezed,
    Object? idGt = freezed,
    Object? idGte = freezed,
    Object? idLt = freezed,
    Object? idLte = freezed,
    Object? limit = freezed,
  }) {
    return _then(
      MessagePaginationParams(
        createdAtAfter: freezed == createdAtAfter
            ? _self.createdAtAfter
            : createdAtAfter // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAtAfterOrEqual: freezed == createdAtAfterOrEqual
            ? _self.createdAtAfterOrEqual
            : createdAtAfterOrEqual // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAtAround: freezed == createdAtAround
            ? _self.createdAtAround
            : createdAtAround // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAtBefore: freezed == createdAtBefore
            ? _self.createdAtBefore
            : createdAtBefore // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAtBeforeOrEqual: freezed == createdAtBeforeOrEqual
            ? _self.createdAtBeforeOrEqual
            : createdAtBeforeOrEqual // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        idAround: freezed == idAround
            ? _self.idAround
            : idAround // ignore: cast_nullable_to_non_nullable
                  as String?,
        idGt: freezed == idGt
            ? _self.idGt
            : idGt // ignore: cast_nullable_to_non_nullable
                  as String?,
        idGte: freezed == idGte
            ? _self.idGte
            : idGte // ignore: cast_nullable_to_non_nullable
                  as String?,
        idLt: freezed == idLt
            ? _self.idLt
            : idLt // ignore: cast_nullable_to_non_nullable
                  as String?,
        idLte: freezed == idLte
            ? _self.idLte
            : idLte // ignore: cast_nullable_to_non_nullable
                  as String?,
        limit: freezed == limit
            ? _self.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}
