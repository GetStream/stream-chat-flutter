// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channel_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChannelMetadata {
  String get cid;
  Map<String, Object?> get custom;
  String get id;
  DateTime? get lastMessageAt;
  int? get memberCount;
  int? get messageCount;
  String? get pushLevel;
  String? get team;
  String get type;

  /// Create a copy of ChannelMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChannelMetadataCopyWith<ChannelMetadata> get copyWith =>
      _$ChannelMetadataCopyWithImpl<ChannelMetadata>(
        this as ChannelMetadata,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChannelMetadata &&
            (identical(other.cid, cid) || other.cid == cid) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            (identical(other.memberCount, memberCount) ||
                other.memberCount == memberCount) &&
            (identical(other.messageCount, messageCount) ||
                other.messageCount == messageCount) &&
            (identical(other.pushLevel, pushLevel) ||
                other.pushLevel == pushLevel) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    cid,
    const DeepCollectionEquality().hash(custom),
    id,
    lastMessageAt,
    memberCount,
    messageCount,
    pushLevel,
    team,
    type,
  );

  @override
  String toString() {
    return 'ChannelMetadata(cid: $cid, custom: $custom, id: $id, lastMessageAt: $lastMessageAt, memberCount: $memberCount, messageCount: $messageCount, pushLevel: $pushLevel, team: $team, type: $type)';
  }
}

/// @nodoc
abstract mixin class $ChannelMetadataCopyWith<$Res> {
  factory $ChannelMetadataCopyWith(
    ChannelMetadata value,
    $Res Function(ChannelMetadata) _then,
  ) = _$ChannelMetadataCopyWithImpl;
  @useResult
  $Res call({
    String cid,
    Map<String, Object?> custom,
    String id,
    DateTime? lastMessageAt,
    int? memberCount,
    int? messageCount,
    String? pushLevel,
    String? team,
    String type,
  });
}

/// @nodoc
class _$ChannelMetadataCopyWithImpl<$Res>
    implements $ChannelMetadataCopyWith<$Res> {
  _$ChannelMetadataCopyWithImpl(this._self, this._then);

  final ChannelMetadata _self;
  final $Res Function(ChannelMetadata) _then;

  /// Create a copy of ChannelMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? cid = null,
    Object? custom = null,
    Object? id = null,
    Object? lastMessageAt = freezed,
    Object? memberCount = freezed,
    Object? messageCount = freezed,
    Object? pushLevel = freezed,
    Object? team = freezed,
    Object? type = null,
  }) {
    return _then(
      ChannelMetadata(
        cid: null == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        lastMessageAt: freezed == lastMessageAt
            ? _self.lastMessageAt
            : lastMessageAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        memberCount: freezed == memberCount
            ? _self.memberCount
            : memberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        messageCount: freezed == messageCount
            ? _self.messageCount
            : messageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        pushLevel: freezed == pushLevel
            ? _self.pushLevel
            : pushLevel // ignore: cast_nullable_to_non_nullable
                  as String?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
