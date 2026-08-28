// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reaction_new_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReactionNewEvent {
  ChannelResponse get channel;
  Map<String, Object?>? get channelCustom;
  String? get channelId;
  int? get channelMemberCount;
  int? get channelMessageCount;
  String? get channelType;
  String? get cid;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  MessageResponse? get message;
  String? get messageId;
  ReactionResponse? get reaction;
  DateTime? get receivedAt;
  String? get team;
  List<UserResponseCommonFields>? get threadParticipants;
  String get type;
  UserResponseCommonFields? get user;

  /// Create a copy of ReactionNewEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReactionNewEventCopyWith<ReactionNewEvent> get copyWith =>
      _$ReactionNewEventCopyWithImpl<ReactionNewEvent>(
        this as ReactionNewEvent,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReactionNewEvent &&
            (identical(other.channel, channel) || other.channel == channel) &&
            const DeepCollectionEquality().equals(
              other.channelCustom,
              channelCustom,
            ) &&
            (identical(other.channelId, channelId) ||
                other.channelId == channelId) &&
            (identical(other.channelMemberCount, channelMemberCount) ||
                other.channelMemberCount == channelMemberCount) &&
            (identical(other.channelMessageCount, channelMessageCount) ||
                other.channelMessageCount == channelMessageCount) &&
            (identical(other.channelType, channelType) ||
                other.channelType == channelType) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.reaction, reaction) ||
                other.reaction == reaction) &&
            (identical(other.receivedAt, receivedAt) ||
                other.receivedAt == receivedAt) &&
            (identical(other.team, team) || other.team == team) &&
            const DeepCollectionEquality().equals(
              other.threadParticipants,
              threadParticipants,
            ) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    channel,
    const DeepCollectionEquality().hash(channelCustom),
    channelId,
    channelMemberCount,
    channelMessageCount,
    channelType,
    cid,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    message,
    messageId,
    reaction,
    receivedAt,
    team,
    const DeepCollectionEquality().hash(threadParticipants),
    type,
    user,
  );

  @override
  String toString() {
    return 'ReactionNewEvent(channel: $channel, channelCustom: $channelCustom, channelId: $channelId, channelMemberCount: $channelMemberCount, channelMessageCount: $channelMessageCount, channelType: $channelType, cid: $cid, createdAt: $createdAt, custom: $custom, message: $message, messageId: $messageId, reaction: $reaction, receivedAt: $receivedAt, team: $team, threadParticipants: $threadParticipants, type: $type, user: $user)';
  }
}

/// @nodoc
abstract mixin class $ReactionNewEventCopyWith<$Res> {
  factory $ReactionNewEventCopyWith(
    ReactionNewEvent value,
    $Res Function(ReactionNewEvent) _then,
  ) = _$ReactionNewEventCopyWithImpl;
  @useResult
  $Res call({
    ChannelResponse channel,
    Map<String, Object?>? channelCustom,
    String? channelId,
    int? channelMemberCount,
    int? channelMessageCount,
    String? channelType,
    String? cid,
    DateTime createdAt,
    Map<String, Object?> custom,
    MessageResponse? message,
    String? messageId,
    ReactionResponse? reaction,
    DateTime? receivedAt,
    String? team,
    List<UserResponseCommonFields>? threadParticipants,
    String type,
    UserResponseCommonFields? user,
  });
}

/// @nodoc
class _$ReactionNewEventCopyWithImpl<$Res>
    implements $ReactionNewEventCopyWith<$Res> {
  _$ReactionNewEventCopyWithImpl(this._self, this._then);

  final ReactionNewEvent _self;
  final $Res Function(ReactionNewEvent) _then;

  /// Create a copy of ReactionNewEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channel = null,
    Object? channelCustom = freezed,
    Object? channelId = freezed,
    Object? channelMemberCount = freezed,
    Object? channelMessageCount = freezed,
    Object? channelType = freezed,
    Object? cid = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? message = freezed,
    Object? messageId = freezed,
    Object? reaction = freezed,
    Object? receivedAt = freezed,
    Object? team = freezed,
    Object? threadParticipants = freezed,
    Object? type = null,
    Object? user = freezed,
  }) {
    return _then(
      ReactionNewEvent(
        channel: null == channel
            ? _self.channel
            : channel // ignore: cast_nullable_to_non_nullable
                  as ChannelResponse,
        channelCustom: freezed == channelCustom
            ? _self.channelCustom
            : channelCustom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        channelId: freezed == channelId
            ? _self.channelId
            : channelId // ignore: cast_nullable_to_non_nullable
                  as String?,
        channelMemberCount: freezed == channelMemberCount
            ? _self.channelMemberCount
            : channelMemberCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelMessageCount: freezed == channelMessageCount
            ? _self.channelMessageCount
            : channelMessageCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        channelType: freezed == channelType
            ? _self.channelType
            : channelType // ignore: cast_nullable_to_non_nullable
                  as String?,
        cid: freezed == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        message: freezed == message
            ? _self.message
            : message // ignore: cast_nullable_to_non_nullable
                  as MessageResponse?,
        messageId: freezed == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        reaction: freezed == reaction
            ? _self.reaction
            : reaction // ignore: cast_nullable_to_non_nullable
                  as ReactionResponse?,
        receivedAt: freezed == receivedAt
            ? _self.receivedAt
            : receivedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        team: freezed == team
            ? _self.team
            : team // ignore: cast_nullable_to_non_nullable
                  as String?,
        threadParticipants: freezed == threadParticipants
            ? _self.threadParticipants
            : threadParticipants // ignore: cast_nullable_to_non_nullable
                  as List<UserResponseCommonFields>?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponseCommonFields?,
      ),
    );
  }
}
