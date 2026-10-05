// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poll_option.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PollOption {
  String? get id;
  String get text;
  Map<String, String>? get textI18n;
  Map<String, Object?> get extraData;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PollOption &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality().equals(other.textI18n, textI18n) &&
            const DeepCollectionEquality().equals(other.extraData, extraData));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    text,
    const DeepCollectionEquality().hash(textI18n),
    const DeepCollectionEquality().hash(extraData),
  );

  @override
  String toString() {
    return 'PollOption(id: $id, text: $text, textI18n: $textI18n, extraData: $extraData)';
  }
}
