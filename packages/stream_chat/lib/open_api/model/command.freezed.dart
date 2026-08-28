// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Command {
  String get args;
  DateTime? get createdAt;
  String get description;
  String get name;
  String get set;
  DateTime? get updatedAt;

  /// Create a copy of Command
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CommandCopyWith<Command> get copyWith =>
      _$CommandCopyWithImpl<Command>(this as Command, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Command &&
            (identical(other.args, args) || other.args == args) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.set, set) || other.set == set) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    args,
    createdAt,
    description,
    name,
    set,
    updatedAt,
  );

  @override
  String toString() {
    return 'Command(args: $args, createdAt: $createdAt, description: $description, name: $name, set: $set, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $CommandCopyWith<$Res> {
  factory $CommandCopyWith(Command value, $Res Function(Command) _then) =
      _$CommandCopyWithImpl;
  @useResult
  $Res call({
    String args,
    DateTime? createdAt,
    String description,
    String name,
    String set,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$CommandCopyWithImpl<$Res> implements $CommandCopyWith<$Res> {
  _$CommandCopyWithImpl(this._self, this._then);

  final Command _self;
  final $Res Function(Command) _then;

  /// Create a copy of Command
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? args = null,
    Object? createdAt = freezed,
    Object? description = null,
    Object? name = null,
    Object? set = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      Command(
        args: null == args
            ? _self.args
            : args // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        description: null == description
            ? _self.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        set: null == set
            ? _self.set
            : set // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: freezed == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}
