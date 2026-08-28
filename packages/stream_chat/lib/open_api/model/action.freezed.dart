// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Action {
  String get name;
  String? get style;
  String get text;
  String get type;
  String? get value;

  /// Create a copy of Action
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ActionCopyWith<Action> get copyWith =>
      _$ActionCopyWithImpl<Action>(this as Action, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Action &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.style, style) || other.style == style) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, style, text, type, value);

  @override
  String toString() {
    return 'Action(name: $name, style: $style, text: $text, type: $type, value: $value)';
  }
}

/// @nodoc
abstract mixin class $ActionCopyWith<$Res> {
  factory $ActionCopyWith(Action value, $Res Function(Action) _then) =
      _$ActionCopyWithImpl;
  @useResult
  $Res call({
    String name,
    String? style,
    String text,
    String type,
    String? value,
  });
}

/// @nodoc
class _$ActionCopyWithImpl<$Res> implements $ActionCopyWith<$Res> {
  _$ActionCopyWithImpl(this._self, this._then);

  final Action _self;
  final $Res Function(Action) _then;

  /// Create a copy of Action
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? style = freezed,
    Object? text = null,
    Object? type = null,
    Object? value = freezed,
  }) {
    return _then(
      Action(
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        style: freezed == style
            ? _self.style
            : style // ignore: cast_nullable_to_non_nullable
                  as String?,
        text: null == text
            ? _self.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        value: freezed == value
            ? _self.value
            : value // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
