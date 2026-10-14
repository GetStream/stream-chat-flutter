// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'import_block_list_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ImportBlockListResponse {
  String get duration;
  String get taskId;

  /// Create a copy of ImportBlockListResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ImportBlockListResponseCopyWith<ImportBlockListResponse> get copyWith =>
      _$ImportBlockListResponseCopyWithImpl<ImportBlockListResponse>(
        this as ImportBlockListResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ImportBlockListResponse &&
            (identical(other.duration, duration) || other.duration == duration) &&
            (identical(other.taskId, taskId) || other.taskId == taskId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration, taskId);

  @override
  String toString() {
    return 'ImportBlockListResponse(duration: $duration, taskId: $taskId)';
  }
}

/// @nodoc
abstract mixin class $ImportBlockListResponseCopyWith<$Res> {
  factory $ImportBlockListResponseCopyWith(
    ImportBlockListResponse value,
    $Res Function(ImportBlockListResponse) _then,
  ) = _$ImportBlockListResponseCopyWithImpl;
  @useResult
  $Res call({String duration, String taskId});
}

/// @nodoc
class _$ImportBlockListResponseCopyWithImpl<$Res> implements $ImportBlockListResponseCopyWith<$Res> {
  _$ImportBlockListResponseCopyWithImpl(this._self, this._then);

  final ImportBlockListResponse _self;
  final $Res Function(ImportBlockListResponse) _then;

  /// Create a copy of ImportBlockListResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? taskId = null}) {
    return _then(
      ImportBlockListResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        taskId: null == taskId
            ? _self.taskId
            : taskId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
