// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_draft_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateDraftRequest {
  MessageRequest get message;

  /// Create a copy of CreateDraftRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateDraftRequestCopyWith<CreateDraftRequest> get copyWith =>
      _$CreateDraftRequestCopyWithImpl<CreateDraftRequest>(
        this as CreateDraftRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateDraftRequest &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'CreateDraftRequest(message: $message)';
  }
}

/// @nodoc
abstract mixin class $CreateDraftRequestCopyWith<$Res> {
  factory $CreateDraftRequestCopyWith(
    CreateDraftRequest value,
    $Res Function(CreateDraftRequest) _then,
  ) = _$CreateDraftRequestCopyWithImpl;
  @useResult
  $Res call({MessageRequest message});
}

/// @nodoc
class _$CreateDraftRequestCopyWithImpl<$Res>
    implements $CreateDraftRequestCopyWith<$Res> {
  _$CreateDraftRequestCopyWithImpl(this._self, this._then);

  final CreateDraftRequest _self;
  final $Res Function(CreateDraftRequest) _then;

  /// Create a copy of CreateDraftRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      CreateDraftRequest(
        message: null == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageRequest,
      ),
    );
  }
}
