// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_moderation_configs_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryModerationConfigsResponse {
  List<ConfigResponse> get configs;
  String get duration;
  String? get next;
  String? get prev;

  /// Create a copy of QueryModerationConfigsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryModerationConfigsResponseCopyWith<QueryModerationConfigsResponse>
  get copyWith =>
      _$QueryModerationConfigsResponseCopyWithImpl<
        QueryModerationConfigsResponse
      >(this as QueryModerationConfigsResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryModerationConfigsResponse &&
            const DeepCollectionEquality().equals(other.configs, configs) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.next, next) || other.next == next) &&
            (identical(other.prev, prev) || other.prev == prev));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(configs),
    duration,
    next,
    prev,
  );

  @override
  String toString() {
    return 'QueryModerationConfigsResponse(configs: $configs, duration: $duration, next: $next, prev: $prev)';
  }
}

/// @nodoc
abstract mixin class $QueryModerationConfigsResponseCopyWith<$Res> {
  factory $QueryModerationConfigsResponseCopyWith(
    QueryModerationConfigsResponse value,
    $Res Function(QueryModerationConfigsResponse) _then,
  ) = _$QueryModerationConfigsResponseCopyWithImpl;
  @useResult
  $Res call({
    List<ConfigResponse> configs,
    String duration,
    String? next,
    String? prev,
  });
}

/// @nodoc
class _$QueryModerationConfigsResponseCopyWithImpl<$Res>
    implements $QueryModerationConfigsResponseCopyWith<$Res> {
  _$QueryModerationConfigsResponseCopyWithImpl(this._self, this._then);

  final QueryModerationConfigsResponse _self;
  final $Res Function(QueryModerationConfigsResponse) _then;

  /// Create a copy of QueryModerationConfigsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? configs = null,
    Object? duration = null,
    Object? next = freezed,
    Object? prev = freezed,
  }) {
    return _then(
      QueryModerationConfigsResponse(
        configs: null == configs
            ? _self.configs
            : configs // ignore: cast_nullable_to_non_nullable
                  as List<ConfigResponse>,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
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
