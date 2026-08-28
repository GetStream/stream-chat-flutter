// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grouped_query_channels_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GroupedQueryChannelsResponse {
  String get duration;
  Map<String, GroupedChannelsBucket> get groups;

  /// Create a copy of GroupedQueryChannelsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GroupedQueryChannelsResponseCopyWith<GroupedQueryChannelsResponse>
  get copyWith =>
      _$GroupedQueryChannelsResponseCopyWithImpl<GroupedQueryChannelsResponse>(
        this as GroupedQueryChannelsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GroupedQueryChannelsResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            const DeepCollectionEquality().equals(other.groups, groups));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    const DeepCollectionEquality().hash(groups),
  );

  @override
  String toString() {
    return 'GroupedQueryChannelsResponse(duration: $duration, groups: $groups)';
  }
}

/// @nodoc
abstract mixin class $GroupedQueryChannelsResponseCopyWith<$Res> {
  factory $GroupedQueryChannelsResponseCopyWith(
    GroupedQueryChannelsResponse value,
    $Res Function(GroupedQueryChannelsResponse) _then,
  ) = _$GroupedQueryChannelsResponseCopyWithImpl;
  @useResult
  $Res call({String duration, Map<String, GroupedChannelsBucket> groups});
}

/// @nodoc
class _$GroupedQueryChannelsResponseCopyWithImpl<$Res>
    implements $GroupedQueryChannelsResponseCopyWith<$Res> {
  _$GroupedQueryChannelsResponseCopyWithImpl(this._self, this._then);

  final GroupedQueryChannelsResponse _self;
  final $Res Function(GroupedQueryChannelsResponse) _then;

  /// Create a copy of GroupedQueryChannelsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? groups = null}) {
    return _then(
      GroupedQueryChannelsResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        groups: null == groups
            ? _self.groups
            : groups // ignore: cast_nullable_to_non_nullable
                  as Map<String, GroupedChannelsBucket>,
      ),
    );
  }
}
