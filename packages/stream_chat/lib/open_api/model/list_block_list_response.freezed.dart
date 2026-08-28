// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_block_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ListBlockListResponse {
  List<BlockListResponse> get blocklists;
  String get duration;
  String? get nextCursor;

  /// Create a copy of ListBlockListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ListBlockListResponseCopyWith<ListBlockListResponse> get copyWith =>
      _$ListBlockListResponseCopyWithImpl<ListBlockListResponse>(
        this as ListBlockListResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ListBlockListResponse &&
            const DeepCollectionEquality().equals(
              other.blocklists,
              blocklists,
            ) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.nextCursor, nextCursor) ||
                other.nextCursor == nextCursor));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(blocklists),
    duration,
    nextCursor,
  );

  @override
  String toString() {
    return 'ListBlockListResponse(blocklists: $blocklists, duration: $duration, nextCursor: $nextCursor)';
  }
}

/// @nodoc
abstract mixin class $ListBlockListResponseCopyWith<$Res> {
  factory $ListBlockListResponseCopyWith(
    ListBlockListResponse value,
    $Res Function(ListBlockListResponse) _then,
  ) = _$ListBlockListResponseCopyWithImpl;
  @useResult
  $Res call({
    List<BlockListResponse> blocklists,
    String duration,
    String? nextCursor,
  });
}

/// @nodoc
class _$ListBlockListResponseCopyWithImpl<$Res>
    implements $ListBlockListResponseCopyWith<$Res> {
  _$ListBlockListResponseCopyWithImpl(this._self, this._then);

  final ListBlockListResponse _self;
  final $Res Function(ListBlockListResponse) _then;

  /// Create a copy of ListBlockListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? blocklists = null,
    Object? duration = null,
    Object? nextCursor = freezed,
  }) {
    return _then(
      ListBlockListResponse(
        blocklists: null == blocklists
            ? _self.blocklists
            : blocklists // ignore: cast_nullable_to_non_nullable
                  as List<BlockListResponse>,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        nextCursor: freezed == nextCursor
            ? _self.nextCursor
            : nextCursor // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
