// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fork_channel_target.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ForkChannelTarget {
  ChannelInput? get data;
  String get id;
  List<ChannelMemberRequest>? get members;

  /// Create a copy of ForkChannelTarget
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ForkChannelTargetCopyWith<ForkChannelTarget> get copyWith => _$ForkChannelTargetCopyWithImpl<ForkChannelTarget>(
    this as ForkChannelTarget,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ForkChannelTarget &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other.members, members));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    data,
    id,
    const DeepCollectionEquality().hash(members),
  );

  @override
  String toString() {
    return 'ForkChannelTarget(data: $data, id: $id, members: $members)';
  }
}

/// @nodoc
abstract mixin class $ForkChannelTargetCopyWith<$Res> {
  factory $ForkChannelTargetCopyWith(
    ForkChannelTarget value,
    $Res Function(ForkChannelTarget) _then,
  ) = _$ForkChannelTargetCopyWithImpl;
  @useResult
  $Res call({
    ChannelInput? data,
    String id,
    List<ChannelMemberRequest>? members,
  });
}

/// @nodoc
class _$ForkChannelTargetCopyWithImpl<$Res> implements $ForkChannelTargetCopyWith<$Res> {
  _$ForkChannelTargetCopyWithImpl(this._self, this._then);

  final ForkChannelTarget _self;
  final $Res Function(ForkChannelTarget) _then;

  /// Create a copy of ForkChannelTarget
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? id = null,
    Object? members = freezed,
  }) {
    return _then(
      ForkChannelTarget(
        data: freezed == data
            ? _self.data
            : data // ignore: cast_nullable_to_non_nullable
                  as ChannelInput?,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        members: freezed == members
            ? _self.members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<ChannelMemberRequest>?,
      ),
    );
  }
}
