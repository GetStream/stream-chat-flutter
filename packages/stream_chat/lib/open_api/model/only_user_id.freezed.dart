// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'only_user_id.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OnlyUserID {
  String get id;

  /// Create a copy of OnlyUserID
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $OnlyUserIDCopyWith<OnlyUserID> get copyWith =>
      _$OnlyUserIDCopyWithImpl<OnlyUserID>(this as OnlyUserID, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is OnlyUserID &&
            (identical(other.id, id) || other.id == id));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id);

  @override
  String toString() {
    return 'OnlyUserID(id: $id)';
  }
}

/// @nodoc
abstract mixin class $OnlyUserIDCopyWith<$Res> {
  factory $OnlyUserIDCopyWith(
    OnlyUserID value,
    $Res Function(OnlyUserID) _then,
  ) = _$OnlyUserIDCopyWithImpl;
  @useResult
  $Res call({String id});
}

/// @nodoc
class _$OnlyUserIDCopyWithImpl<$Res> implements $OnlyUserIDCopyWith<$Res> {
  _$OnlyUserIDCopyWithImpl(this._self, this._then);

  final OnlyUserID _self;
  final $Res Function(OnlyUserID) _then;

  /// Create a copy of OnlyUserID
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null}) {
    return _then(
      OnlyUserID(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
