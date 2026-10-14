// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_poll_option_request_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeletePollOptionRequestPayload {
  String? get optionId;
  String? get reason;

  /// Create a copy of DeletePollOptionRequestPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeletePollOptionRequestPayloadCopyWith<DeletePollOptionRequestPayload> get copyWith =>
      _$DeletePollOptionRequestPayloadCopyWithImpl<DeletePollOptionRequestPayload>(
        this as DeletePollOptionRequestPayload,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeletePollOptionRequestPayload &&
            (identical(other.optionId, optionId) || other.optionId == optionId) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, optionId, reason);

  @override
  String toString() {
    return 'DeletePollOptionRequestPayload(optionId: $optionId, reason: $reason)';
  }
}

/// @nodoc
abstract mixin class $DeletePollOptionRequestPayloadCopyWith<$Res> {
  factory $DeletePollOptionRequestPayloadCopyWith(
    DeletePollOptionRequestPayload value,
    $Res Function(DeletePollOptionRequestPayload) _then,
  ) = _$DeletePollOptionRequestPayloadCopyWithImpl;
  @useResult
  $Res call({String? optionId, String? reason});
}

/// @nodoc
class _$DeletePollOptionRequestPayloadCopyWithImpl<$Res> implements $DeletePollOptionRequestPayloadCopyWith<$Res> {
  _$DeletePollOptionRequestPayloadCopyWithImpl(this._self, this._then);

  final DeletePollOptionRequestPayload _self;
  final $Res Function(DeletePollOptionRequestPayload) _then;

  /// Create a copy of DeletePollOptionRequestPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? optionId = freezed, Object? reason = freezed}) {
    return _then(
      DeletePollOptionRequestPayload(
        optionId: freezed == optionId
            ? _self.optionId
            : optionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        reason: freezed == reason
            ? _self.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
