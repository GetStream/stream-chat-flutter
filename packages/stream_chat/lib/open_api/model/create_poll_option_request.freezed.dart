// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_poll_option_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreatePollOptionRequest {
  Map<String, Object?>? get custom;
  String get text;

  /// Create a copy of CreatePollOptionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreatePollOptionRequestCopyWith<CreatePollOptionRequest> get copyWith =>
      _$CreatePollOptionRequestCopyWithImpl<CreatePollOptionRequest>(
        this as CreatePollOptionRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreatePollOptionRequest &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.text, text) || other.text == text));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(custom),
    text,
  );

  @override
  String toString() {
    return 'CreatePollOptionRequest(custom: $custom, text: $text)';
  }
}

/// @nodoc
abstract mixin class $CreatePollOptionRequestCopyWith<$Res> {
  factory $CreatePollOptionRequestCopyWith(
    CreatePollOptionRequest value,
    $Res Function(CreatePollOptionRequest) _then,
  ) = _$CreatePollOptionRequestCopyWithImpl;
  @useResult
  $Res call({Map<String, Object?>? custom, String text});
}

/// @nodoc
class _$CreatePollOptionRequestCopyWithImpl<$Res>
    implements $CreatePollOptionRequestCopyWith<$Res> {
  _$CreatePollOptionRequestCopyWithImpl(this._self, this._then);

  final CreatePollOptionRequest _self;
  final $Res Function(CreatePollOptionRequest) _then;

  /// Create a copy of CreatePollOptionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? custom = freezed, Object? text = null}) {
    return _then(
      CreatePollOptionRequest(
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        text: null == text
            ? _self.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
