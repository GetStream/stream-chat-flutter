// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bulk_upsert_action_config_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BulkUpsertActionConfigResponse {
  List<ModerationActionConfigResponse> get actionConfigs;
  String get duration;

  /// Create a copy of BulkUpsertActionConfigResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BulkUpsertActionConfigResponseCopyWith<BulkUpsertActionConfigResponse>
  get copyWith =>
      _$BulkUpsertActionConfigResponseCopyWithImpl<
        BulkUpsertActionConfigResponse
      >(this as BulkUpsertActionConfigResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BulkUpsertActionConfigResponse &&
            const DeepCollectionEquality().equals(
              other.actionConfigs,
              actionConfigs,
            ) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(actionConfigs),
    duration,
  );

  @override
  String toString() {
    return 'BulkUpsertActionConfigResponse(actionConfigs: $actionConfigs, duration: $duration)';
  }
}

/// @nodoc
abstract mixin class $BulkUpsertActionConfigResponseCopyWith<$Res> {
  factory $BulkUpsertActionConfigResponseCopyWith(
    BulkUpsertActionConfigResponse value,
    $Res Function(BulkUpsertActionConfigResponse) _then,
  ) = _$BulkUpsertActionConfigResponseCopyWithImpl;
  @useResult
  $Res call({
    List<ModerationActionConfigResponse> actionConfigs,
    String duration,
  });
}

/// @nodoc
class _$BulkUpsertActionConfigResponseCopyWithImpl<$Res>
    implements $BulkUpsertActionConfigResponseCopyWith<$Res> {
  _$BulkUpsertActionConfigResponseCopyWithImpl(this._self, this._then);

  final BulkUpsertActionConfigResponse _self;
  final $Res Function(BulkUpsertActionConfigResponse) _then;

  /// Create a copy of BulkUpsertActionConfigResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? actionConfigs = null, Object? duration = null}) {
    return _then(
      BulkUpsertActionConfigResponse(
        actionConfigs: null == actionConfigs
            ? _self.actionConfigs
            : actionConfigs // ignore: cast_nullable_to_non_nullable
                  as List<ModerationActionConfigResponse>,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
