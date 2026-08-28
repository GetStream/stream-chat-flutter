// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poll_option_input.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PollOptionInput {
  Map<String, Object?>? get custom;
  String? get text;

  /// Create a copy of PollOptionInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PollOptionInputCopyWith<PollOptionInput> get copyWith =>
      _$PollOptionInputCopyWithImpl<PollOptionInput>(
        this as PollOptionInput,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PollOptionInput &&
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
    return 'PollOptionInput(custom: $custom, text: $text)';
  }
}

/// @nodoc
abstract mixin class $PollOptionInputCopyWith<$Res> {
  factory $PollOptionInputCopyWith(
    PollOptionInput value,
    $Res Function(PollOptionInput) _then,
  ) = _$PollOptionInputCopyWithImpl;
  @useResult
  $Res call({Map<String, Object?>? custom, String? text});
}

/// @nodoc
class _$PollOptionInputCopyWithImpl<$Res>
    implements $PollOptionInputCopyWith<$Res> {
  _$PollOptionInputCopyWithImpl(this._self, this._then);

  final PollOptionInput _self;
  final $Res Function(PollOptionInput) _then;

  /// Create a copy of PollOptionInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? custom = freezed, Object? text = freezed}) {
    return _then(
      PollOptionInput(
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        text: freezed == text
            ? _self.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
