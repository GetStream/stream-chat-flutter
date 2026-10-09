// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_message_flags_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryMessageFlagsPayload {
  Map<String, Object?>? get filterConditions;
  int? get limit;
  int? get offset;
  bool? get showDeletedMessages;
  List<SortParamRequest>? get sort;

  /// Create a copy of QueryMessageFlagsPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryMessageFlagsPayloadCopyWith<QueryMessageFlagsPayload> get copyWith =>
      _$QueryMessageFlagsPayloadCopyWithImpl<QueryMessageFlagsPayload>(
        this as QueryMessageFlagsPayload,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryMessageFlagsPayload &&
            const DeepCollectionEquality().equals(
              other.filterConditions,
              filterConditions,
            ) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.showDeletedMessages, showDeletedMessages) ||
                other.showDeletedMessages == showDeletedMessages) &&
            const DeepCollectionEquality().equals(other.sort, sort));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(filterConditions),
    limit,
    offset,
    showDeletedMessages,
    const DeepCollectionEquality().hash(sort),
  );

  @override
  String toString() {
    return 'QueryMessageFlagsPayload(filterConditions: $filterConditions, limit: $limit, offset: $offset, showDeletedMessages: $showDeletedMessages, sort: $sort)';
  }
}

/// @nodoc
abstract mixin class $QueryMessageFlagsPayloadCopyWith<$Res> {
  factory $QueryMessageFlagsPayloadCopyWith(
    QueryMessageFlagsPayload value,
    $Res Function(QueryMessageFlagsPayload) _then,
  ) = _$QueryMessageFlagsPayloadCopyWithImpl;
  @useResult
  $Res call({
    Map<String, Object?>? filterConditions,
    int? limit,
    int? offset,
    bool? showDeletedMessages,
    List<SortParamRequest>? sort,
  });
}

/// @nodoc
class _$QueryMessageFlagsPayloadCopyWithImpl<$Res> implements $QueryMessageFlagsPayloadCopyWith<$Res> {
  _$QueryMessageFlagsPayloadCopyWithImpl(this._self, this._then);

  final QueryMessageFlagsPayload _self;
  final $Res Function(QueryMessageFlagsPayload) _then;

  /// Create a copy of QueryMessageFlagsPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filterConditions = freezed,
    Object? limit = freezed,
    Object? offset = freezed,
    Object? showDeletedMessages = freezed,
    Object? sort = freezed,
  }) {
    return _then(
      QueryMessageFlagsPayload(
        filterConditions: freezed == filterConditions
            ? _self.filterConditions
            : filterConditions // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        limit: freezed == limit
            ? _self.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
        offset: freezed == offset
            ? _self.offset
            : offset // ignore: cast_nullable_to_non_nullable
                  as int?,
        showDeletedMessages: freezed == showDeletedMessages
            ? _self.showDeletedMessages
            : showDeletedMessages // ignore: cast_nullable_to_non_nullable
                  as bool?,
        sort: freezed == sort
            ? _self.sort
            : sort // ignore: cast_nullable_to_non_nullable
                  as List<SortParamRequest>?,
      ),
    );
  }
}
