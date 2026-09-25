// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_members_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryMembersPayload {
  DateTime? get createdAtAfter;
  DateTime? get createdAtAfterOrEqual;
  DateTime? get createdAtBefore;
  DateTime? get createdAtBeforeOrEqual;
  Map<String, Object?>? get filterConditions;
  String? get id;
  int? get limit;
  List<ChannelMemberRequest>? get members;
  int? get offset;
  List<SortParamRequest>? get sort;
  String get type;
  String? get userIdGt;
  String? get userIdGte;
  String? get userIdLt;
  String? get userIdLte;

  /// Create a copy of QueryMembersPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryMembersPayloadCopyWith<QueryMembersPayload> get copyWith =>
      _$QueryMembersPayloadCopyWithImpl<QueryMembersPayload>(
        this as QueryMembersPayload,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryMembersPayload &&
            (identical(other.createdAtAfter, createdAtAfter) || other.createdAtAfter == createdAtAfter) &&
            (identical(other.createdAtAfterOrEqual, createdAtAfterOrEqual) ||
                other.createdAtAfterOrEqual == createdAtAfterOrEqual) &&
            (identical(other.createdAtBefore, createdAtBefore) || other.createdAtBefore == createdAtBefore) &&
            (identical(other.createdAtBeforeOrEqual, createdAtBeforeOrEqual) ||
                other.createdAtBeforeOrEqual == createdAtBeforeOrEqual) &&
            const DeepCollectionEquality().equals(
              other.filterConditions,
              filterConditions,
            ) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            const DeepCollectionEquality().equals(other.sort, sort) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.userIdGt, userIdGt) || other.userIdGt == userIdGt) &&
            (identical(other.userIdGte, userIdGte) || other.userIdGte == userIdGte) &&
            (identical(other.userIdLt, userIdLt) || other.userIdLt == userIdLt) &&
            (identical(other.userIdLte, userIdLte) || other.userIdLte == userIdLte));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAtAfter,
    createdAtAfterOrEqual,
    createdAtBefore,
    createdAtBeforeOrEqual,
    const DeepCollectionEquality().hash(filterConditions),
    id,
    limit,
    const DeepCollectionEquality().hash(members),
    offset,
    const DeepCollectionEquality().hash(sort),
    type,
    userIdGt,
    userIdGte,
    userIdLt,
    userIdLte,
  );

  @override
  String toString() {
    return 'QueryMembersPayload(createdAtAfter: $createdAtAfter, createdAtAfterOrEqual: $createdAtAfterOrEqual, createdAtBefore: $createdAtBefore, createdAtBeforeOrEqual: $createdAtBeforeOrEqual, filterConditions: $filterConditions, id: $id, limit: $limit, members: $members, offset: $offset, sort: $sort, type: $type, userIdGt: $userIdGt, userIdGte: $userIdGte, userIdLt: $userIdLt, userIdLte: $userIdLte)';
  }
}

/// @nodoc
abstract mixin class $QueryMembersPayloadCopyWith<$Res> {
  factory $QueryMembersPayloadCopyWith(
    QueryMembersPayload value,
    $Res Function(QueryMembersPayload) _then,
  ) = _$QueryMembersPayloadCopyWithImpl;
  @useResult
  $Res call({
    DateTime? createdAtAfter,
    DateTime? createdAtAfterOrEqual,
    DateTime? createdAtBefore,
    DateTime? createdAtBeforeOrEqual,
    Map<String, Object?>? filterConditions,
    String? id,
    int? limit,
    List<ChannelMemberRequest>? members,
    int? offset,
    List<SortParamRequest>? sort,
    String type,
    String? userIdGt,
    String? userIdGte,
    String? userIdLt,
    String? userIdLte,
  });
}

/// @nodoc
class _$QueryMembersPayloadCopyWithImpl<$Res> implements $QueryMembersPayloadCopyWith<$Res> {
  _$QueryMembersPayloadCopyWithImpl(this._self, this._then);

  final QueryMembersPayload _self;
  final $Res Function(QueryMembersPayload) _then;

  /// Create a copy of QueryMembersPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAtAfter = freezed,
    Object? createdAtAfterOrEqual = freezed,
    Object? createdAtBefore = freezed,
    Object? createdAtBeforeOrEqual = freezed,
    Object? filterConditions = freezed,
    Object? id = freezed,
    Object? limit = freezed,
    Object? members = freezed,
    Object? offset = freezed,
    Object? sort = freezed,
    Object? type = null,
    Object? userIdGt = freezed,
    Object? userIdGte = freezed,
    Object? userIdLt = freezed,
    Object? userIdLte = freezed,
  }) {
    return _then(
      QueryMembersPayload(
        createdAtAfter: freezed == createdAtAfter
            ? _self.createdAtAfter
            : createdAtAfter // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAtAfterOrEqual: freezed == createdAtAfterOrEqual
            ? _self.createdAtAfterOrEqual
            : createdAtAfterOrEqual // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAtBefore: freezed == createdAtBefore
            ? _self.createdAtBefore
            : createdAtBefore // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        createdAtBeforeOrEqual: freezed == createdAtBeforeOrEqual
            ? _self.createdAtBeforeOrEqual
            : createdAtBeforeOrEqual // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        filterConditions: freezed == filterConditions
            ? _self.filterConditions
            : filterConditions // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        id: freezed == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        limit: freezed == limit
            ? _self.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
        members: freezed == members
            ? _self.members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<ChannelMemberRequest>?,
        offset: freezed == offset
            ? _self.offset
            : offset // ignore: cast_nullable_to_non_nullable
                  as int?,
        sort: freezed == sort
            ? _self.sort
            : sort // ignore: cast_nullable_to_non_nullable
                  as List<SortParamRequest>?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        userIdGt: freezed == userIdGt
            ? _self.userIdGt
            : userIdGt // ignore: cast_nullable_to_non_nullable
                  as String?,
        userIdGte: freezed == userIdGte
            ? _self.userIdGte
            : userIdGte // ignore: cast_nullable_to_non_nullable
                  as String?,
        userIdLt: freezed == userIdLt
            ? _self.userIdLt
            : userIdLt // ignore: cast_nullable_to_non_nullable
                  as String?,
        userIdLte: freezed == userIdLte
            ? _self.userIdLte
            : userIdLte // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
