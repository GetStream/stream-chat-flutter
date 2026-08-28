// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'role.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Role {
  DateTime get createdAt;
  bool get custom;
  String get name;
  List<String> get scopes;
  DateTime get updatedAt;

  /// Create a copy of Role
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RoleCopyWith<Role> get copyWith =>
      _$RoleCopyWithImpl<Role>(this as Role, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Role &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.custom, custom) || other.custom == custom) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other.scopes, scopes) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    custom,
    name,
    const DeepCollectionEquality().hash(scopes),
    updatedAt,
  );

  @override
  String toString() {
    return 'Role(createdAt: $createdAt, custom: $custom, name: $name, scopes: $scopes, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $RoleCopyWith<$Res> {
  factory $RoleCopyWith(Role value, $Res Function(Role) _then) =
      _$RoleCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    bool custom,
    String name,
    List<String> scopes,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$RoleCopyWithImpl<$Res> implements $RoleCopyWith<$Res> {
  _$RoleCopyWithImpl(this._self, this._then);

  final Role _self;
  final $Res Function(Role) _then;

  /// Create a copy of Role
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? custom = null,
    Object? name = null,
    Object? scopes = null,
    Object? updatedAt = null,
  }) {
    return _then(
      Role(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as bool,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        scopes: null == scopes
            ? _self.scopes
            : scopes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}
