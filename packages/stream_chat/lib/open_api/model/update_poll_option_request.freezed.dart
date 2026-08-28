// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_poll_option_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdatePollOptionRequest {
  Map<String, Object?>? get custom;
  String get id;
  String get text;

  /// Create a copy of UpdatePollOptionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdatePollOptionRequestCopyWith<UpdatePollOptionRequest> get copyWith =>
      _$UpdatePollOptionRequestCopyWithImpl<UpdatePollOptionRequest>(
        this as UpdatePollOptionRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdatePollOptionRequest &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(custom),
    id,
    text,
  );

  @override
  String toString() {
    return 'UpdatePollOptionRequest(custom: $custom, id: $id, text: $text)';
  }
}

/// @nodoc
abstract mixin class $UpdatePollOptionRequestCopyWith<$Res> {
  factory $UpdatePollOptionRequestCopyWith(
    UpdatePollOptionRequest value,
    $Res Function(UpdatePollOptionRequest) _then,
  ) = _$UpdatePollOptionRequestCopyWithImpl;
  @useResult
  $Res call({Map<String, Object?>? custom, String id, String text});
}

/// @nodoc
class _$UpdatePollOptionRequestCopyWithImpl<$Res>
    implements $UpdatePollOptionRequestCopyWith<$Res> {
  _$UpdatePollOptionRequestCopyWithImpl(this._self, this._then);

  final UpdatePollOptionRequest _self;
  final $Res Function(UpdatePollOptionRequest) _then;

  /// Create a copy of UpdatePollOptionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? custom = freezed,
    Object? id = null,
    Object? text = null,
  }) {
    return _then(
      UpdatePollOptionRequest(
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        text: null == text
            ? _self.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
