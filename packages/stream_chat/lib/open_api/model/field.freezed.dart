// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'field.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Field {
  bool get short;
  String get title;
  String get value;

  /// Create a copy of Field
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FieldCopyWith<Field> get copyWith =>
      _$FieldCopyWithImpl<Field>(this as Field, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Field &&
            (identical(other.short, short) || other.short == short) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, short, title, value);

  @override
  String toString() {
    return 'Field(short: $short, title: $title, value: $value)';
  }
}

/// @nodoc
abstract mixin class $FieldCopyWith<$Res> {
  factory $FieldCopyWith(Field value, $Res Function(Field) _then) =
      _$FieldCopyWithImpl;
  @useResult
  $Res call({bool short, String title, String value});
}

/// @nodoc
class _$FieldCopyWithImpl<$Res> implements $FieldCopyWith<$Res> {
  _$FieldCopyWithImpl(this._self, this._then);

  final Field _self;
  final $Res Function(Field) _then;

  /// Create a copy of Field
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? short = null,
    Object? title = null,
    Object? value = null,
  }) {
    return _then(
      Field(
        short: null == short
            ? _self.short
            : short // ignore: cast_nullable_to_non_nullable
                  as bool,
        title: null == title
            ? _self.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        value: null == value
            ? _self.value
            : value // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
