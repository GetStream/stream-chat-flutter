// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_action_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageActionRequest {
  Map<String, String> get formData;

  /// Create a copy of MessageActionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessageActionRequestCopyWith<MessageActionRequest> get copyWith =>
      _$MessageActionRequestCopyWithImpl<MessageActionRequest>(
        this as MessageActionRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MessageActionRequest &&
            const DeepCollectionEquality().equals(other.formData, formData));
  }

  @override
  int get hashCode => Object.hash(runtimeType, const DeepCollectionEquality().hash(formData));

  @override
  String toString() {
    return 'MessageActionRequest(formData: $formData)';
  }
}

/// @nodoc
abstract mixin class $MessageActionRequestCopyWith<$Res> {
  factory $MessageActionRequestCopyWith(
    MessageActionRequest value,
    $Res Function(MessageActionRequest) _then,
  ) = _$MessageActionRequestCopyWithImpl;
  @useResult
  $Res call({Map<String, String> formData});
}

/// @nodoc
class _$MessageActionRequestCopyWithImpl<$Res> implements $MessageActionRequestCopyWith<$Res> {
  _$MessageActionRequestCopyWithImpl(this._self, this._then);

  final MessageActionRequest _self;
  final $Res Function(MessageActionRequest) _then;

  /// Create a copy of MessageActionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? formData = null}) {
    return _then(
      MessageActionRequest(
        formData: null == formData
            ? _self.formData
            : formData // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>,
      ),
    );
  }
}
