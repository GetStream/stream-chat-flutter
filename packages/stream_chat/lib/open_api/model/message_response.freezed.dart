// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MessageResponse {
  List<Attachment> get attachments;
  String get cid;
  String? get command;
  DateTime get createdAt;
  Map<String, Object?> get custom;
  DateTime? get deletedAt;
  bool? get deletedForMe;
  int get deletedReplyCount;
  DraftResponse? get draft;
  String get html;
  Map<String, String>? get i18n;
  String get id;
  Map<String, List<String>>? get imageLabels;
  List<ReactionResponse> get latestReactions;
  ChannelMemberPartialResponse? get member;
  bool get mentionedChannel;
  Map<String, ChannelMemberPartialResponse>? get mentionedChannelMembers;
  List<String>? get mentionedGroupIds;
  List<UserGroupResponse>? get mentionedGroups;
  bool get mentionedHere;
  List<String>? get mentionedRoles;
  List<UserResponse> get mentionedUsers;
  DateTime? get messageTextUpdatedAt;
  String? get mml;
  ModerationV2Response? get moderation;
  List<ReactionResponse> get ownReactions;
  String? get parentId;
  DateTime? get pinExpires;
  bool get pinned;
  DateTime? get pinnedAt;
  UserResponse? get pinnedBy;
  PollResponseData? get poll;
  String? get pollId;
  MessageResponse? get quotedMessage;
  String? get quotedMessageId;
  Map<String, int> get reactionCounts;
  Map<String, ReactionGroupResponse>? get reactionGroups;
  Map<String, int> get reactionScores;
  ReminderResponseData? get reminder;
  int get replyCount;
  List<String> get restrictedVisibility;
  bool get shadowed;
  SharedLocationResponseData? get sharedLocation;
  bool? get showInChannel;
  bool get silent;
  String get text;
  List<UserResponse>? get threadParticipants;
  String get type;
  DateTime get updatedAt;
  UserResponse get user;

  /// Create a copy of MessageResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MessageResponseCopyWith<MessageResponse> get copyWith =>
      _$MessageResponseCopyWithImpl<MessageResponse>(
        this as MessageResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MessageResponse &&
            const DeepCollectionEquality().equals(
              other.attachments,
              attachments,
            ) &&
            (identical(other.cid, cid) || other.cid == cid) &&
            (identical(other.command, command) || other.command == command) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.deletedForMe, deletedForMe) ||
                other.deletedForMe == deletedForMe) &&
            (identical(other.deletedReplyCount, deletedReplyCount) ||
                other.deletedReplyCount == deletedReplyCount) &&
            (identical(other.draft, draft) || other.draft == draft) &&
            (identical(other.html, html) || other.html == html) &&
            const DeepCollectionEquality().equals(other.i18n, i18n) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(
              other.imageLabels,
              imageLabels,
            ) &&
            const DeepCollectionEquality().equals(
              other.latestReactions,
              latestReactions,
            ) &&
            (identical(other.member, member) || other.member == member) &&
            (identical(other.mentionedChannel, mentionedChannel) ||
                other.mentionedChannel == mentionedChannel) &&
            const DeepCollectionEquality().equals(
              other.mentionedChannelMembers,
              mentionedChannelMembers,
            ) &&
            const DeepCollectionEquality().equals(
              other.mentionedGroupIds,
              mentionedGroupIds,
            ) &&
            const DeepCollectionEquality().equals(
              other.mentionedGroups,
              mentionedGroups,
            ) &&
            (identical(other.mentionedHere, mentionedHere) ||
                other.mentionedHere == mentionedHere) &&
            const DeepCollectionEquality().equals(
              other.mentionedRoles,
              mentionedRoles,
            ) &&
            const DeepCollectionEquality().equals(
              other.mentionedUsers,
              mentionedUsers,
            ) &&
            (identical(other.messageTextUpdatedAt, messageTextUpdatedAt) ||
                other.messageTextUpdatedAt == messageTextUpdatedAt) &&
            (identical(other.mml, mml) || other.mml == mml) &&
            (identical(other.moderation, moderation) ||
                other.moderation == moderation) &&
            const DeepCollectionEquality().equals(
              other.ownReactions,
              ownReactions,
            ) &&
            (identical(other.parentId, parentId) ||
                other.parentId == parentId) &&
            (identical(other.pinExpires, pinExpires) ||
                other.pinExpires == pinExpires) &&
            (identical(other.pinned, pinned) || other.pinned == pinned) &&
            (identical(other.pinnedAt, pinnedAt) ||
                other.pinnedAt == pinnedAt) &&
            (identical(other.pinnedBy, pinnedBy) ||
                other.pinnedBy == pinnedBy) &&
            (identical(other.poll, poll) || other.poll == poll) &&
            (identical(other.pollId, pollId) || other.pollId == pollId) &&
            (identical(other.quotedMessage, quotedMessage) ||
                other.quotedMessage == quotedMessage) &&
            (identical(other.quotedMessageId, quotedMessageId) ||
                other.quotedMessageId == quotedMessageId) &&
            const DeepCollectionEquality().equals(
              other.reactionCounts,
              reactionCounts,
            ) &&
            const DeepCollectionEquality().equals(
              other.reactionGroups,
              reactionGroups,
            ) &&
            const DeepCollectionEquality().equals(
              other.reactionScores,
              reactionScores,
            ) &&
            (identical(other.reminder, reminder) ||
                other.reminder == reminder) &&
            (identical(other.replyCount, replyCount) ||
                other.replyCount == replyCount) &&
            const DeepCollectionEquality().equals(
              other.restrictedVisibility,
              restrictedVisibility,
            ) &&
            (identical(other.shadowed, shadowed) ||
                other.shadowed == shadowed) &&
            (identical(other.sharedLocation, sharedLocation) ||
                other.sharedLocation == sharedLocation) &&
            (identical(other.showInChannel, showInChannel) ||
                other.showInChannel == showInChannel) &&
            (identical(other.silent, silent) || other.silent == silent) &&
            (identical(other.text, text) || other.text == text) &&
            const DeepCollectionEquality().equals(
              other.threadParticipants,
              threadParticipants,
            ) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    const DeepCollectionEquality().hash(attachments),
    cid,
    command,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    deletedAt,
    deletedForMe,
    deletedReplyCount,
    draft,
    html,
    const DeepCollectionEquality().hash(i18n),
    id,
    const DeepCollectionEquality().hash(imageLabels),
    const DeepCollectionEquality().hash(latestReactions),
    member,
    mentionedChannel,
    const DeepCollectionEquality().hash(mentionedChannelMembers),
    const DeepCollectionEquality().hash(mentionedGroupIds),
    const DeepCollectionEquality().hash(mentionedGroups),
    mentionedHere,
    const DeepCollectionEquality().hash(mentionedRoles),
    const DeepCollectionEquality().hash(mentionedUsers),
    messageTextUpdatedAt,
    mml,
    moderation,
    const DeepCollectionEquality().hash(ownReactions),
    parentId,
    pinExpires,
    pinned,
    pinnedAt,
    pinnedBy,
    poll,
    pollId,
    quotedMessage,
    quotedMessageId,
    const DeepCollectionEquality().hash(reactionCounts),
    const DeepCollectionEquality().hash(reactionGroups),
    const DeepCollectionEquality().hash(reactionScores),
    reminder,
    replyCount,
    const DeepCollectionEquality().hash(restrictedVisibility),
    shadowed,
    sharedLocation,
    showInChannel,
    silent,
    text,
    const DeepCollectionEquality().hash(threadParticipants),
    type,
    updatedAt,
    user,
  ]);

  @override
  String toString() {
    return 'MessageResponse(attachments: $attachments, cid: $cid, command: $command, createdAt: $createdAt, custom: $custom, deletedAt: $deletedAt, deletedForMe: $deletedForMe, deletedReplyCount: $deletedReplyCount, draft: $draft, html: $html, i18n: $i18n, id: $id, imageLabels: $imageLabels, latestReactions: $latestReactions, member: $member, mentionedChannel: $mentionedChannel, mentionedChannelMembers: $mentionedChannelMembers, mentionedGroupIds: $mentionedGroupIds, mentionedGroups: $mentionedGroups, mentionedHere: $mentionedHere, mentionedRoles: $mentionedRoles, mentionedUsers: $mentionedUsers, messageTextUpdatedAt: $messageTextUpdatedAt, mml: $mml, moderation: $moderation, ownReactions: $ownReactions, parentId: $parentId, pinExpires: $pinExpires, pinned: $pinned, pinnedAt: $pinnedAt, pinnedBy: $pinnedBy, poll: $poll, pollId: $pollId, quotedMessage: $quotedMessage, quotedMessageId: $quotedMessageId, reactionCounts: $reactionCounts, reactionGroups: $reactionGroups, reactionScores: $reactionScores, reminder: $reminder, replyCount: $replyCount, restrictedVisibility: $restrictedVisibility, shadowed: $shadowed, sharedLocation: $sharedLocation, showInChannel: $showInChannel, silent: $silent, text: $text, threadParticipants: $threadParticipants, type: $type, updatedAt: $updatedAt, user: $user)';
  }
}

/// @nodoc
abstract mixin class $MessageResponseCopyWith<$Res> {
  factory $MessageResponseCopyWith(
    MessageResponse value,
    $Res Function(MessageResponse) _then,
  ) = _$MessageResponseCopyWithImpl;
  @useResult
  $Res call({
    List<Attachment> attachments,
    String cid,
    String? command,
    DateTime createdAt,
    Map<String, Object?> custom,
    DateTime? deletedAt,
    bool? deletedForMe,
    int deletedReplyCount,
    DraftResponse? draft,
    String html,
    Map<String, String>? i18n,
    String id,
    Map<String, List<String>>? imageLabels,
    List<ReactionResponse> latestReactions,
    ChannelMemberPartialResponse? member,
    bool mentionedChannel,
    Map<String, ChannelMemberPartialResponse>? mentionedChannelMembers,
    List<String>? mentionedGroupIds,
    List<UserGroupResponse>? mentionedGroups,
    bool mentionedHere,
    List<String>? mentionedRoles,
    List<UserResponse> mentionedUsers,
    DateTime? messageTextUpdatedAt,
    String? mml,
    ModerationV2Response? moderation,
    List<ReactionResponse> ownReactions,
    String? parentId,
    DateTime? pinExpires,
    bool pinned,
    DateTime? pinnedAt,
    UserResponse? pinnedBy,
    PollResponseData? poll,
    String? pollId,
    MessageResponse? quotedMessage,
    String? quotedMessageId,
    Map<String, int> reactionCounts,
    Map<String, ReactionGroupResponse>? reactionGroups,
    Map<String, int> reactionScores,
    ReminderResponseData? reminder,
    int replyCount,
    List<String> restrictedVisibility,
    bool shadowed,
    SharedLocationResponseData? sharedLocation,
    bool? showInChannel,
    bool silent,
    String text,
    List<UserResponse>? threadParticipants,
    String type,
    DateTime updatedAt,
    UserResponse user,
  });
}

/// @nodoc
class _$MessageResponseCopyWithImpl<$Res>
    implements $MessageResponseCopyWith<$Res> {
  _$MessageResponseCopyWithImpl(this._self, this._then);

  final MessageResponse _self;
  final $Res Function(MessageResponse) _then;

  /// Create a copy of MessageResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? attachments = null,
    Object? cid = null,
    Object? command = freezed,
    Object? createdAt = null,
    Object? custom = null,
    Object? deletedAt = freezed,
    Object? deletedForMe = freezed,
    Object? deletedReplyCount = null,
    Object? draft = freezed,
    Object? html = null,
    Object? i18n = freezed,
    Object? id = null,
    Object? imageLabels = freezed,
    Object? latestReactions = null,
    Object? member = freezed,
    Object? mentionedChannel = null,
    Object? mentionedChannelMembers = freezed,
    Object? mentionedGroupIds = freezed,
    Object? mentionedGroups = freezed,
    Object? mentionedHere = null,
    Object? mentionedRoles = freezed,
    Object? mentionedUsers = null,
    Object? messageTextUpdatedAt = freezed,
    Object? mml = freezed,
    Object? moderation = freezed,
    Object? ownReactions = null,
    Object? parentId = freezed,
    Object? pinExpires = freezed,
    Object? pinned = null,
    Object? pinnedAt = freezed,
    Object? pinnedBy = freezed,
    Object? poll = freezed,
    Object? pollId = freezed,
    Object? quotedMessage = freezed,
    Object? quotedMessageId = freezed,
    Object? reactionCounts = null,
    Object? reactionGroups = freezed,
    Object? reactionScores = null,
    Object? reminder = freezed,
    Object? replyCount = null,
    Object? restrictedVisibility = null,
    Object? shadowed = null,
    Object? sharedLocation = freezed,
    Object? showInChannel = freezed,
    Object? silent = null,
    Object? text = null,
    Object? threadParticipants = freezed,
    Object? type = null,
    Object? updatedAt = null,
    Object? user = null,
  }) {
    return _then(
      MessageResponse(
        attachments: null == attachments
            ? _self.attachments
            : attachments // ignore: cast_nullable_to_non_nullable
                  as List<Attachment>,
        cid: null == cid
            ? _self.cid
            : cid // ignore: cast_nullable_to_non_nullable
                  as String,
        command: freezed == command
            ? _self.command
            : command // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        deletedAt: freezed == deletedAt
            ? _self.deletedAt
            : deletedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        deletedForMe: freezed == deletedForMe
            ? _self.deletedForMe
            : deletedForMe // ignore: cast_nullable_to_non_nullable
                  as bool?,
        deletedReplyCount: null == deletedReplyCount
            ? _self.deletedReplyCount
            : deletedReplyCount // ignore: cast_nullable_to_non_nullable
                  as int,
        draft: freezed == draft
            ? _self.draft
            : draft // ignore: cast_nullable_to_non_nullable
                  as DraftResponse?,
        html: null == html
            ? _self.html
            : html // ignore: cast_nullable_to_non_nullable
                  as String,
        i18n: freezed == i18n
            ? _self.i18n
            : i18n // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        imageLabels: freezed == imageLabels
            ? _self.imageLabels
            : imageLabels // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<String>>?,
        latestReactions: null == latestReactions
            ? _self.latestReactions
            : latestReactions // ignore: cast_nullable_to_non_nullable
                  as List<ReactionResponse>,
        member: freezed == member
            ? _self.member
            : member // ignore: cast_nullable_to_non_nullable
                  as ChannelMemberPartialResponse?,
        mentionedChannel: null == mentionedChannel
            ? _self.mentionedChannel
            : mentionedChannel // ignore: cast_nullable_to_non_nullable
                  as bool,
        mentionedChannelMembers: freezed == mentionedChannelMembers
            ? _self.mentionedChannelMembers
            : mentionedChannelMembers // ignore: cast_nullable_to_non_nullable
                  as Map<String, ChannelMemberPartialResponse>?,
        mentionedGroupIds: freezed == mentionedGroupIds
            ? _self.mentionedGroupIds
            : mentionedGroupIds // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        mentionedGroups: freezed == mentionedGroups
            ? _self.mentionedGroups
            : mentionedGroups // ignore: cast_nullable_to_non_nullable
                  as List<UserGroupResponse>?,
        mentionedHere: null == mentionedHere
            ? _self.mentionedHere
            : mentionedHere // ignore: cast_nullable_to_non_nullable
                  as bool,
        mentionedRoles: freezed == mentionedRoles
            ? _self.mentionedRoles
            : mentionedRoles // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        mentionedUsers: null == mentionedUsers
            ? _self.mentionedUsers
            : mentionedUsers // ignore: cast_nullable_to_non_nullable
                  as List<UserResponse>,
        messageTextUpdatedAt: freezed == messageTextUpdatedAt
            ? _self.messageTextUpdatedAt
            : messageTextUpdatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        mml: freezed == mml
            ? _self.mml
            : mml // ignore: cast_nullable_to_non_nullable
                  as String?,
        moderation: freezed == moderation
            ? _self.moderation
            : moderation // ignore: cast_nullable_to_non_nullable
                  as ModerationV2Response?,
        ownReactions: null == ownReactions
            ? _self.ownReactions
            : ownReactions // ignore: cast_nullable_to_non_nullable
                  as List<ReactionResponse>,
        parentId: freezed == parentId
            ? _self.parentId
            : parentId // ignore: cast_nullable_to_non_nullable
                  as String?,
        pinExpires: freezed == pinExpires
            ? _self.pinExpires
            : pinExpires // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        pinned: null == pinned
            ? _self.pinned
            : pinned // ignore: cast_nullable_to_non_nullable
                  as bool,
        pinnedAt: freezed == pinnedAt
            ? _self.pinnedAt
            : pinnedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        pinnedBy: freezed == pinnedBy
            ? _self.pinnedBy
            : pinnedBy // ignore: cast_nullable_to_non_nullable
                  as UserResponse?,
        poll: freezed == poll
            ? _self.poll
            : poll // ignore: cast_nullable_to_non_nullable
                  as PollResponseData?,
        pollId: freezed == pollId
            ? _self.pollId
            : pollId // ignore: cast_nullable_to_non_nullable
                  as String?,
        quotedMessage: freezed == quotedMessage
            ? _self.quotedMessage
            : quotedMessage // ignore: cast_nullable_to_non_nullable
                  as MessageResponse?,
        quotedMessageId: freezed == quotedMessageId
            ? _self.quotedMessageId
            : quotedMessageId // ignore: cast_nullable_to_non_nullable
                  as String?,
        reactionCounts: null == reactionCounts
            ? _self.reactionCounts
            : reactionCounts // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        reactionGroups: freezed == reactionGroups
            ? _self.reactionGroups
            : reactionGroups // ignore: cast_nullable_to_non_nullable
                  as Map<String, ReactionGroupResponse>?,
        reactionScores: null == reactionScores
            ? _self.reactionScores
            : reactionScores // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        reminder: freezed == reminder
            ? _self.reminder
            : reminder // ignore: cast_nullable_to_non_nullable
                  as ReminderResponseData?,
        replyCount: null == replyCount
            ? _self.replyCount
            : replyCount // ignore: cast_nullable_to_non_nullable
                  as int,
        restrictedVisibility: null == restrictedVisibility
            ? _self.restrictedVisibility
            : restrictedVisibility // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        shadowed: null == shadowed
            ? _self.shadowed
            : shadowed // ignore: cast_nullable_to_non_nullable
                  as bool,
        sharedLocation: freezed == sharedLocation
            ? _self.sharedLocation
            : sharedLocation // ignore: cast_nullable_to_non_nullable
                  as SharedLocationResponseData?,
        showInChannel: freezed == showInChannel
            ? _self.showInChannel
            : showInChannel // ignore: cast_nullable_to_non_nullable
                  as bool?,
        silent: null == silent
            ? _self.silent
            : silent // ignore: cast_nullable_to_non_nullable
                  as bool,
        text: null == text
            ? _self.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        threadParticipants: freezed == threadParticipants
            ? _self.threadParticipants
            : threadParticipants // ignore: cast_nullable_to_non_nullable
                  as List<UserResponse>?,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponse,
      ),
    );
  }
}
