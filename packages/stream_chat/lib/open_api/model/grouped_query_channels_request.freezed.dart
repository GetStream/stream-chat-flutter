// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grouped_query_channels_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupedQueryChannelsRequest {
  Map<String, GroupedChannelsGroupRequest>? get groups;
  int? get limit;
  bool? get presence;
  bool? get watch;

  /// Create a copy of GroupedQueryChannelsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GroupedQueryChannelsRequestCopyWith<GroupedQueryChannelsRequest>
  get copyWith =>
      _$GroupedQueryChannelsRequestCopyWithImpl<GroupedQueryChannelsRequest>(
        this as GroupedQueryChannelsRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GroupedQueryChannelsRequest &&
            const DeepCollectionEquality().equals(other.groups, groups) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.presence, presence) ||
                other.presence == presence) &&
            (identical(other.watch, watch) || other.watch == watch));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(groups),
    limit,
    presence,
    watch,
  );

  @override
  String toString() {
    return 'GroupedQueryChannelsRequest(groups: $groups, limit: $limit, presence: $presence, watch: $watch)';
  }
}

/// @nodoc
abstract mixin class $GroupedQueryChannelsRequestCopyWith<$Res> {
  factory $GroupedQueryChannelsRequestCopyWith(
    GroupedQueryChannelsRequest value,
    $Res Function(GroupedQueryChannelsRequest) _then,
  ) = _$GroupedQueryChannelsRequestCopyWithImpl;
  @useResult
  $Res call({
    Map<String, GroupedChannelsGroupRequest>? groups,
    int? limit,
    bool? presence,
    bool? watch,
  });
}

/// @nodoc
class _$GroupedQueryChannelsRequestCopyWithImpl<$Res>
    implements $GroupedQueryChannelsRequestCopyWith<$Res> {
  _$GroupedQueryChannelsRequestCopyWithImpl(this._self, this._then);

  final GroupedQueryChannelsRequest _self;
  final $Res Function(GroupedQueryChannelsRequest) _then;

  /// Create a copy of GroupedQueryChannelsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? groups = freezed,
    Object? limit = freezed,
    Object? presence = freezed,
    Object? watch = freezed,
  }) {
    return _then(
      GroupedQueryChannelsRequest(
        groups: freezed == groups
            ? _self.groups
            : groups // ignore: cast_nullable_to_non_nullable
                  as Map<String, GroupedChannelsGroupRequest>?,
        limit: freezed == limit
            ? _self.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
        presence: freezed == presence
            ? _self.presence
            : presence // ignore: cast_nullable_to_non_nullable
                  as bool?,
        watch: freezed == watch
            ? _self.watch
            : watch // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}
