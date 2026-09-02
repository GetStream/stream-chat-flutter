// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_channels_result_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeleteChannelsResultResponse {
  String? get error;
  String get status;

  /// Create a copy of DeleteChannelsResultResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeleteChannelsResultResponseCopyWith<DeleteChannelsResultResponse> get copyWith =>
      _$DeleteChannelsResultResponseCopyWithImpl<DeleteChannelsResultResponse>(
        this as DeleteChannelsResultResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeleteChannelsResultResponse &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, error, status);

  @override
  String toString() {
    return 'DeleteChannelsResultResponse(error: $error, status: $status)';
  }
}

/// @nodoc
abstract mixin class $DeleteChannelsResultResponseCopyWith<$Res> {
  factory $DeleteChannelsResultResponseCopyWith(
    DeleteChannelsResultResponse value,
    $Res Function(DeleteChannelsResultResponse) _then,
  ) = _$DeleteChannelsResultResponseCopyWithImpl;
  @useResult
  $Res call({String? error, String status});
}

/// @nodoc
class _$DeleteChannelsResultResponseCopyWithImpl<$Res> implements $DeleteChannelsResultResponseCopyWith<$Res> {
  _$DeleteChannelsResultResponseCopyWithImpl(this._self, this._then);

  final DeleteChannelsResultResponse _self;
  final $Res Function(DeleteChannelsResultResponse) _then;

  /// Create a copy of DeleteChannelsResultResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? error = freezed, Object? status = null}) {
    return _then(
      DeleteChannelsResultResponse(
        error: freezed == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
        status: null == status
            ? _self.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
