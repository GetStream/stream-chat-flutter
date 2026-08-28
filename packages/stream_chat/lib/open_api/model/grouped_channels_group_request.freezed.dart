// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grouped_channels_group_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupedChannelsGroupRequest {
  int? get limit;
  String? get next;
  String? get prev;

  /// Create a copy of GroupedChannelsGroupRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GroupedChannelsGroupRequestCopyWith<GroupedChannelsGroupRequest> get copyWith =>
      _$GroupedChannelsGroupRequestCopyWithImpl<GroupedChannelsGroupRequest>(
        this as GroupedChannelsGroupRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GroupedChannelsGroupRequest &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.next, next) || other.next == next) &&
            (identical(other.prev, prev) || other.prev == prev));
  }

  @override
  int get hashCode => Object.hash(runtimeType, limit, next, prev);

  @override
  String toString() {
    return 'GroupedChannelsGroupRequest(limit: $limit, next: $next, prev: $prev)';
  }
}

/// @nodoc
abstract mixin class $GroupedChannelsGroupRequestCopyWith<$Res> {
  factory $GroupedChannelsGroupRequestCopyWith(
    GroupedChannelsGroupRequest value,
    $Res Function(GroupedChannelsGroupRequest) _then,
  ) = _$GroupedChannelsGroupRequestCopyWithImpl;
  @useResult
  $Res call({int? limit, String? next, String? prev});
}

/// @nodoc
class _$GroupedChannelsGroupRequestCopyWithImpl<$Res> implements $GroupedChannelsGroupRequestCopyWith<$Res> {
  _$GroupedChannelsGroupRequestCopyWithImpl(this._self, this._then);

  final GroupedChannelsGroupRequest _self;
  final $Res Function(GroupedChannelsGroupRequest) _then;

  /// Create a copy of GroupedChannelsGroupRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? limit = freezed,
    Object? next = freezed,
    Object? prev = freezed,
  }) {
    return _then(
      GroupedChannelsGroupRequest(
        limit: freezed == limit
            ? _self.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
        next: freezed == next
            ? _self.next
            : next // ignore: cast_nullable_to_non_nullable
                  as String?,
        prev: freezed == prev
            ? _self.prev
            : prev // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
