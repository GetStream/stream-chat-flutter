// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_channel_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateChannelData {
  List<ChannelMemberData>? get members;
  List<ChannelMemberData>? get invites;
  String? get team;
  bool? get frozen;
  bool? get disabled;
  Map<String, Object?> get custom;

  /// Create a copy of CreateChannelData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateChannelDataCopyWith<CreateChannelData> get copyWith =>
      _$CreateChannelDataCopyWithImpl<CreateChannelData>(this as CreateChannelData, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateChannelData &&
            const DeepCollectionEquality().equals(other.members, members) &&
            const DeepCollectionEquality().equals(other.invites, invites) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.frozen, frozen) || other.frozen == frozen) &&
            (identical(other.disabled, disabled) || other.disabled == disabled) &&
            const DeepCollectionEquality().equals(other.custom, custom));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(members),
    const DeepCollectionEquality().hash(invites),
    team,
    frozen,
    disabled,
    const DeepCollectionEquality().hash(custom),
  );

  @override
  String toString() {
    return 'CreateChannelData(members: $members, invites: $invites, team: $team, frozen: $frozen, disabled: $disabled, custom: $custom)';
  }
}

/// @nodoc
abstract mixin class $CreateChannelDataCopyWith<$Res> {
  factory $CreateChannelDataCopyWith(CreateChannelData value, $Res Function(CreateChannelData) _then) =
      _$CreateChannelDataCopyWithImpl;
  @useResult
  $Res call({
    List<ChannelMemberData>? members,
    List<ChannelMemberData>? invites,
    String? team,
    bool? frozen,
    bool? disabled,
    Map<String, Object?> custom,
  });
}

/// @nodoc
class _$CreateChannelDataCopyWithImpl<$Res> implements $CreateChannelDataCopyWith<$Res> {
  _$CreateChannelDataCopyWithImpl(this._self, this._then);

  final CreateChannelData _self;
  final $Res Function(CreateChannelData) _then;

  /// Create a copy of CreateChannelData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? members = freezed,
    Object? invites = freezed,
    Object? team = freezed,
    Object? frozen = freezed,
    Object? disabled = freezed,
    Object? custom = null,
  }) {
    return _then(
      CreateChannelData(
        members: freezed == members
            ? _self.members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<ChannelMemberData>?,
        invites: freezed == invites
            ? _self.invites
            : invites // ignore: cast_nullable_to_non_nullable
                  as List<ChannelMemberData>?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        frozen: freezed == frozen
            ? _self.frozen
            : frozen // ignore: cast_nullable_to_non_nullable
                  as bool?,
        disabled: freezed == disabled
            ? _self.disabled
            : disabled // ignore: cast_nullable_to_non_nullable
                  as bool?,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
      ),
    );
  }
}
