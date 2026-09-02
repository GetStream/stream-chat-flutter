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
  Map<String, Object?>? get filterConditions;
  String? get id;
  int? get limit;
  List<ChannelMemberRequest>? get members;
  int? get offset;
  List<SortParamRequest>? get sort;
  String get type;

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
            const DeepCollectionEquality().equals(
              other.filterConditions,
              filterConditions,
            ) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            const DeepCollectionEquality().equals(other.sort, sort) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(filterConditions),
    id,
    limit,
    const DeepCollectionEquality().hash(members),
    offset,
    const DeepCollectionEquality().hash(sort),
    type,
  );

  @override
  String toString() {
    return 'QueryMembersPayload(filterConditions: $filterConditions, id: $id, limit: $limit, members: $members, offset: $offset, sort: $sort, type: $type)';
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
    Map<String, Object?>? filterConditions,
    String? id,
    int? limit,
    List<ChannelMemberRequest>? members,
    int? offset,
    List<SortParamRequest>? sort,
    String type,
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
    Object? filterConditions = freezed,
    Object? id = freezed,
    Object? limit = freezed,
    Object? members = freezed,
    Object? offset = freezed,
    Object? sort = freezed,
    Object? type = null,
  }) {
    return _then(
      QueryMembersPayload(
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
      ),
    );
  }
}
