// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poll_option_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PollOptionRequest {
  Map<String, Object?>? get custom;
  String get id;
  String? get text;

  /// Create a copy of PollOptionRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PollOptionRequestCopyWith<PollOptionRequest> get copyWith =>
      _$PollOptionRequestCopyWithImpl<PollOptionRequest>(
        this as PollOptionRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PollOptionRequest &&
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
    return 'PollOptionRequest(custom: $custom, id: $id, text: $text)';
  }
}

/// @nodoc
abstract mixin class $PollOptionRequestCopyWith<$Res> {
  factory $PollOptionRequestCopyWith(
    PollOptionRequest value,
    $Res Function(PollOptionRequest) _then,
  ) = _$PollOptionRequestCopyWithImpl;
  @useResult
  $Res call({Map<String, Object?>? custom, String id, String? text});
}

/// @nodoc
class _$PollOptionRequestCopyWithImpl<$Res>
    implements $PollOptionRequestCopyWith<$Res> {
  _$PollOptionRequestCopyWithImpl(this._self, this._then);

  final PollOptionRequest _self;
  final $Res Function(PollOptionRequest) _then;

  /// Create a copy of PollOptionRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? custom = freezed,
    Object? id = null,
    Object? text = freezed,
  }) {
    return _then(
      PollOptionRequest(
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        text: freezed == text
            ? _self.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
