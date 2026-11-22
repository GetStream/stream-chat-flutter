// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_partial_update_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelPartialUpdateResponse {
  String get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  bool get disabled;
  bool get frozen;
  String get id;
  DateTime? get lastMessageAt;
  String? get team;
  String get type;
  DateTime get updatedAt;

  /// Create a copy of ChannelPartialUpdateResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelPartialUpdateResponseCopyWith<ChannelPartialUpdateResponse> get copyWith =>
      _$ChannelPartialUpdateResponseCopyWithImpl<ChannelPartialUpdateResponse>(
        this as ChannelPartialUpdateResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelPartialUpdateResponse &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.disabled, disabled) || other.disabled == disabled) &&
            (identical(other.frozen, frozen) || other.frozen == frozen) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.lastMessageAt, lastMessageAt) || other.lastMessageAt == lastMessageAt) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    disabled,
    frozen,
    id,
    lastMessageAt,
    team,
    type,
    updatedAt,
  );

  @override
  String toString() {
    return 'ChannelPartialUpdateResponse(cid: $cid, createdAt: $createdAt, custom: $custom, disabled: $disabled, frozen: $frozen, id: $id, lastMessageAt: $lastMessageAt, team: $team, type: $type, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $ChannelPartialUpdateResponseCopyWith<$Res> {
  factory $ChannelPartialUpdateResponseCopyWith(
    ChannelPartialUpdateResponse value,
    $Res Function(ChannelPartialUpdateResponse) _then,
  ) = _$ChannelPartialUpdateResponseCopyWithImpl;
  @useResult
  $Res call({
    String cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    bool disabled,
    bool frozen,
    String id,
    DateTime? lastMessageAt,
    String? team,
    String type,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$ChannelPartialUpdateResponseCopyWithImpl<$Res> implements $ChannelPartialUpdateResponseCopyWith<$Res> {
  _$ChannelPartialUpdateResponseCopyWithImpl(this._self, this._then);

  final ChannelPartialUpdateResponse _self;
  final $Res Function(ChannelPartialUpdateResponse) _then;

  /// Create a copy of ChannelPartialUpdateResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = null,
    Object? createdAt = null,
    Object? custom = null,
    Object? disabled = null,
    Object? frozen = null,
    Object? id = null,
    Object? lastMessageAt = freezed,
    Object? team = freezed,
    Object? type = null,
    Object? updatedAt = null,
  }) {
    return _then(
      ChannelPartialUpdateResponse(
        cid: null == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        disabled: null == disabled
            ? _self.disabled
            : disabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        frozen: null == frozen
            ? _self.frozen
            : frozen // ignore: cast_nullable_to_non_nullable
                  as bool,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        lastMessageAt: freezed == lastMessageAt
            ? _self.lastMessageAt
            : lastMessageAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}
