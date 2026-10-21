// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_channels_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeleteChannelsResponse {
  String get duration;
  Map<String, DeleteChannelsResultResponse>? get result;
  String? get taskId;

  /// Create a copy of DeleteChannelsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeleteChannelsResponseCopyWith<DeleteChannelsResponse> get copyWith =>
      _$DeleteChannelsResponseCopyWithImpl<DeleteChannelsResponse>(
        this as DeleteChannelsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeleteChannelsResponse &&
            (identical(other.duration, duration) || other.duration == duration) &&
            const DeepCollectionEquality().equals(other.result, result) &&
            (identical(other.taskId, taskId) || other.taskId == taskId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    const DeepCollectionEquality().hash(result),
    taskId,
  );

  @override
  String toString() {
    return 'DeleteChannelsResponse(duration: $duration, result: $result, taskId: $taskId)';
  }
}

/// @nodoc
abstract mixin class $DeleteChannelsResponseCopyWith<$Res> {
  factory $DeleteChannelsResponseCopyWith(
    DeleteChannelsResponse value,
    $Res Function(DeleteChannelsResponse) _then,
  ) = _$DeleteChannelsResponseCopyWithImpl;
  @useResult
  $Res call({
    String duration,
    Map<String, DeleteChannelsResultResponse>? result,
    String? taskId,
  });
}

/// @nodoc
class _$DeleteChannelsResponseCopyWithImpl<$Res> implements $DeleteChannelsResponseCopyWith<$Res> {
  _$DeleteChannelsResponseCopyWithImpl(this._self, this._then);

  final DeleteChannelsResponse _self;
  final $Res Function(DeleteChannelsResponse) _then;

  /// Create a copy of DeleteChannelsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? result = freezed,
    Object? taskId = freezed,
  }) {
    return _then(
      DeleteChannelsResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        result: freezed == result
            ? _self.result
            : result // ignore: cast_nullable_to_non_nullable
                  as Map<String, DeleteChannelsResultResponse>?,
        taskId: freezed == taskId
            ? _self.taskId
            : taskId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
