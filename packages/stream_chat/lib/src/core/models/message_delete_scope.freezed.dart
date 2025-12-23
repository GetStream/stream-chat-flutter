// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_delete_scope.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
MessageDeleteScope _$MessageDeleteScopeFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'deleteForMe':
      return DeleteForMe.fromJson(json);
    case 'deleteForAll':
      return DeleteForAll.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'MessageDeleteScope',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$MessageDeleteScope {
  /// Serializes this MessageDeleteScope to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is MessageDeleteScope);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MessageDeleteScope()';
  }
}

/// @nodoc
class $MessageDeleteScopeCopyWith<$Res> {
  $MessageDeleteScopeCopyWith(
      MessageDeleteScope _, $Res Function(MessageDeleteScope) __);
}

/// @nodoc
@JsonSerializable()
class DeleteForMe implements MessageDeleteScope {
  const DeleteForMe({final String? $type}) : $type = $type ?? 'deleteForMe';
  factory DeleteForMe.fromJson(Map<String, dynamic> json) =>
      _$DeleteForMeFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  Map<String, dynamic> toJson() {
    return _$DeleteForMeToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is DeleteForMe);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'MessageDeleteScope.deleteForMe()';
  }
}

/// @nodoc
@JsonSerializable()
class DeleteForAll implements MessageDeleteScope {
  const DeleteForAll({this.hard = false, final String? $type})
      : $type = $type ?? 'deleteForAll';
  factory DeleteForAll.fromJson(Map<String, dynamic> json) =>
      _$DeleteForAllFromJson(json);

  @JsonKey()
  final bool hard;

  @JsonKey(name: 'runtimeType')
  final String $type;

  /// Create a copy of MessageDeleteScope
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeleteForAllCopyWith<DeleteForAll> get copyWith =>
      _$DeleteForAllCopyWithImpl<DeleteForAll>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DeleteForAllToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeleteForAll &&
            (identical(other.hard, hard) || other.hard == hard));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, hard);

  @override
  String toString() {
    return 'MessageDeleteScope.deleteForAll(hard: $hard)';
  }
}

/// @nodoc
abstract mixin class $DeleteForAllCopyWith<$Res>
    implements $MessageDeleteScopeCopyWith<$Res> {
  factory $DeleteForAllCopyWith(
          DeleteForAll value, $Res Function(DeleteForAll) _then) =
      _$DeleteForAllCopyWithImpl;
  @useResult
  $Res call({bool hard});
}

/// @nodoc
class _$DeleteForAllCopyWithImpl<$Res> implements $DeleteForAllCopyWith<$Res> {
  _$DeleteForAllCopyWithImpl(this._self, this._then);

  final DeleteForAll _self;
  final $Res Function(DeleteForAll) _then;

  /// Create a copy of MessageDeleteScope
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? hard = null,
  }) {
    return _then(DeleteForAll(
      hard: null == hard
          ? _self.hard
          : hard // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
