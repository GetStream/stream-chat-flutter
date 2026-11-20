// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_poll_answer_request_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeletePollAnswerRequestPayload {
  String? get reason;

  /// Create a copy of DeletePollAnswerRequestPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeletePollAnswerRequestPayloadCopyWith<DeletePollAnswerRequestPayload> get copyWith =>
      _$DeletePollAnswerRequestPayloadCopyWithImpl<DeletePollAnswerRequestPayload>(
        this as DeletePollAnswerRequestPayload,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeletePollAnswerRequestPayload &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  @override
  String toString() {
    return 'DeletePollAnswerRequestPayload(reason: $reason)';
  }
}

/// @nodoc
abstract mixin class $DeletePollAnswerRequestPayloadCopyWith<$Res> {
  factory $DeletePollAnswerRequestPayloadCopyWith(
    DeletePollAnswerRequestPayload value,
    $Res Function(DeletePollAnswerRequestPayload) _then,
  ) = _$DeletePollAnswerRequestPayloadCopyWithImpl;
  @useResult
  $Res call({String? reason});
}

/// @nodoc
class _$DeletePollAnswerRequestPayloadCopyWithImpl<$Res> implements $DeletePollAnswerRequestPayloadCopyWith<$Res> {
  _$DeletePollAnswerRequestPayloadCopyWithImpl(this._self, this._then);

  final DeletePollAnswerRequestPayload _self;
  final $Res Function(DeletePollAnswerRequestPayload) _then;

  /// Create a copy of DeletePollAnswerRequestPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reason = freezed}) {
    return _then(
      DeletePollAnswerRequestPayload(
        reason: freezed == reason
            ? _self.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
