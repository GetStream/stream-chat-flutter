// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'get_action_config_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GetActionConfigResponse {
  Map<String, List<ModerationActionConfigResponse>> get actionConfig;
  String get duration;

  /// Create a copy of GetActionConfigResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GetActionConfigResponseCopyWith<GetActionConfigResponse> get copyWith =>
      _$GetActionConfigResponseCopyWithImpl<GetActionConfigResponse>(
        this as GetActionConfigResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GetActionConfigResponse &&
            const DeepCollectionEquality().equals(
              other.actionConfig,
              actionConfig,
            ) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(actionConfig),
    duration,
  );

  @override
  String toString() {
    return 'GetActionConfigResponse(actionConfig: $actionConfig, duration: $duration)';
  }
}

/// @nodoc
abstract mixin class $GetActionConfigResponseCopyWith<$Res> {
  factory $GetActionConfigResponseCopyWith(
    GetActionConfigResponse value,
    $Res Function(GetActionConfigResponse) _then,
  ) = _$GetActionConfigResponseCopyWithImpl;
  @useResult
  $Res call({
    Map<String, List<ModerationActionConfigResponse>> actionConfig,
    String duration,
  });
}

/// @nodoc
class _$GetActionConfigResponseCopyWithImpl<$Res>
    implements $GetActionConfigResponseCopyWith<$Res> {
  _$GetActionConfigResponseCopyWithImpl(this._self, this._then);

  final GetActionConfigResponse _self;
  final $Res Function(GetActionConfigResponse) _then;

  /// Create a copy of GetActionConfigResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? actionConfig = null, Object? duration = null}) {
    return _then(
      GetActionConfigResponse(
        actionConfig: null == actionConfig
            ? _self.actionConfig
            : actionConfig // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<ModerationActionConfigResponse>>,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
