// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_poll_request_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeletePollRequestPayload {
  String? get reason;

  /// Create a copy of DeletePollRequestPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeletePollRequestPayloadCopyWith<DeletePollRequestPayload> get copyWith =>
      _$DeletePollRequestPayloadCopyWithImpl<DeletePollRequestPayload>(
        this as DeletePollRequestPayload,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeletePollRequestPayload &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  @override
  String toString() {
    return 'DeletePollRequestPayload(reason: $reason)';
  }
}

/// @nodoc
abstract mixin class $DeletePollRequestPayloadCopyWith<$Res> {
  factory $DeletePollRequestPayloadCopyWith(
    DeletePollRequestPayload value,
    $Res Function(DeletePollRequestPayload) _then,
  ) = _$DeletePollRequestPayloadCopyWithImpl;
  @useResult
  $Res call({String? reason});
}

/// @nodoc
class _$DeletePollRequestPayloadCopyWithImpl<$Res> implements $DeletePollRequestPayloadCopyWith<$Res> {
  _$DeletePollRequestPayloadCopyWithImpl(this._self, this._then);

  final DeletePollRequestPayload _self;
  final $Res Function(DeletePollRequestPayload) _then;

  /// Create a copy of DeletePollRequestPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reason = freezed}) {
    return _then(
      DeletePollRequestPayload(
        reason: freezed == reason
            ? _self.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
