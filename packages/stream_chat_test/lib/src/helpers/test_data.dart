// Canonical fixture factories for chat models and API responses.
//
// Conventions:
//  - One `createDefaultXxx` factory per model/response, with every parameter
//    defaulted so call sites only pass what the test cares about.
//  - Deterministic timestamps: `DateTime(2021, 1, 1)` for creation and
//    `DateTime(2021, 2, 1)` for updates, so equality-based mock matching is
//    stable across runs.
//  - Derived fields are computed from the provided values instead of being
//    accepted separately, so fixtures cannot be internally inconsistent.
//  - Response classes are mutable `json_serializable` models with `late`
//    fields, so response fixtures are built with cascades
//    (`SendMessageResponse()..message = message`) rather than constructors.

import 'package:stream_chat/src/core/http/token.dart';
import 'package:stream_chat/stream_chat.dart';

/// The creation timestamp used by all fixtures.
final testCreatedAt = DateTime(2021);

/// The update timestamp used by all fixtures.
final testUpdatedAt = DateTime(2021, 2);

/// Creates a development [Token] for the given [userId], decodable by the
/// SDK's token validation.
Token createTestToken(String userId) => Token.development(userId);

/// Creates a [User] with sensible defaults.
User createDefaultUser({
  String id = 'luke_skywalker',
  String name = 'Luke Skywalker',
  String role = 'user',
  DateTime? createdAt,
  DateTime? updatedAt,
  bool online = false,
  Map<String, Object?> extraData = const {},
}) {
  return User(
    id: id,
    name: name,
    role: role,
    createdAt: createdAt ?? testCreatedAt,
    updatedAt: updatedAt ?? testUpdatedAt,
    online: online,
    extraData: extraData,
  );
}

/// Creates an [OwnUser] with sensible defaults.
OwnUser createDefaultOwnUser({
  String id = 'luke_skywalker',
  String name = 'Luke Skywalker',
  String role = 'user',
  int totalUnreadCount = 0,
  int unreadChannels = 0,
  List<Device> devices = const [],
  List<Mute> mutes = const [],
  PrivacySettings? privacySettings,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  return OwnUser(
    id: id,
    name: name,
    role: role,
    totalUnreadCount: totalUnreadCount,
    unreadChannels: unreadChannels,
    devices: devices,
    mutes: mutes,
    privacySettings: privacySettings,
    createdAt: createdAt ?? testCreatedAt,
    updatedAt: updatedAt ?? testUpdatedAt,
  );
}

/// Creates the `health.check` [Event] a server sends to acknowledge a
/// successful connection.
///
/// The `me` payload identifies the connected user and is what the client uses
/// to populate its current user.
Event createDefaultConnectedEvent({
  String userId = 'luke_skywalker',
  String connectionId = 'test-connection-id',
  OwnUser? me,
}) {
  return Event(
    type: EventType.healthCheck,
    connectionId: connectionId,
    createdAt: testCreatedAt,
    me: me ?? createDefaultOwnUser(id: userId),
  );
}

/// Creates the raw error frame a server sends when a connection attempt is
/// rejected.
///
/// [code] is the backend error code (see [ChatErrorCode]); the default `40`
/// is `tokenExpired`.
Map<String, Object?> createDefaultConnectionErrorFrame({
  int code = 40,
  int statusCode = 401,
  String message = 'connection rejected',
}) {
  return {
    'error': {
      'code': code,
      'message': message,
      'StatusCode': statusCode,
    },
  };
}

/// Creates an [Event] with sensible defaults.
Event createDefaultEvent({
  String type = 'message.new',
  String? cid,
  String? channelId,
  String? channelType,
  User? user,
  Message? message,
  Poll? poll,
  PollVote? pollVote,
  Reaction? reaction,
  Member? member,
  ChannelModel? channel,
  Draft? draft,
  MessageReminder? reminder,
  PushPreference? pushPreference,
  ChannelPushPreference? channelPushPreference,
  OwnUser? me,
  int? totalUnreadCount,
  int? unreadChannels,
  int? channelMemberCount,
  int? channelMessageCount,
  int? watcherCount,
  bool? hardDelete,
  bool? deletedForMe,
  Thread? thread,
  DateTime? lastReadAt,
  int? unreadMessages,
  String? lastReadMessageId,
  DateTime? lastDeliveredAt,
  String? lastDeliveredMessageId,
  DateTime? createdAt,
  Map<String, Object?> extraData = const {},
}) {
  return Event(
    type: type,
    cid: cid,
    channelId: channelId,
    channelType: channelType,
    user: user,
    message: message,
    poll: poll,
    pollVote: pollVote,
    reaction: reaction,
    member: member,
    channel: channel,
    draft: draft,
    reminder: reminder,
    pushPreference: pushPreference,
    channelPushPreference: channelPushPreference,
    me: me,
    totalUnreadCount: totalUnreadCount,
    unreadChannels: unreadChannels,
    channelMemberCount: channelMemberCount,
    channelMessageCount: channelMessageCount,
    watcherCount: watcherCount,
    hardDelete: hardDelete,
    deletedForMe: deletedForMe,
    thread: thread,
    lastReadAt: lastReadAt,
    unreadMessages: unreadMessages,
    lastReadMessageId: lastReadMessageId,
    lastDeliveredAt: lastDeliveredAt,
    lastDeliveredMessageId: lastDeliveredMessageId,
    createdAt: createdAt ?? testCreatedAt,
    extraData: extraData,
  );
}

/// Creates a [Message] with sensible defaults.
Message createDefaultMessage({
  String id = 'message-id',
  String text = 'hello world',
  User? user,
  String? parentId,
  List<Attachment> attachments = const [],
  List<Reaction> ownReactions = const [],
  List<Reaction> latestReactions = const [],
  DateTime? createdAt,
  DateTime? updatedAt,
  Map<String, Object?> extraData = const {},
}) {
  return Message(
    id: id,
    text: text,
    user: user ?? createDefaultUser(),
    parentId: parentId,
    attachments: attachments,
    ownReactions: ownReactions,
    latestReactions: latestReactions,
    createdAt: createdAt ?? testCreatedAt,
    updatedAt: updatedAt ?? testUpdatedAt,
    extraData: extraData,
  );
}

/// Creates a [ChannelModel] with sensible defaults.
///
/// Timestamps are always passed explicitly because the constructor defaults
/// them to `DateTime.now()`, which would break deterministic matching. The
/// same applies to [config]: leaving it unset would build a [ChannelConfig]
/// carrying `DateTime.now()` timestamps, so it defaults to
/// [createDefaultChannelConfig] instead.
ChannelModel createDefaultChannelModel({
  String cid = 'messaging:test-channel',
  User? createdBy,
  int memberCount = 0,
  int cooldown = 0,
  List<Member>? members,
  List<String>? ownCapabilities,
  ChannelConfig? config,
  List<String>? filterTags,
  DateTime? createdAt,
  DateTime? updatedAt,
  DateTime? lastMessageAt,
  Map<String, Object?> extraData = const {},
}) {
  return ChannelModel(
    cid: cid,
    createdBy: createdBy,
    memberCount: memberCount,
    cooldown: cooldown,
    members: members,
    ownCapabilities: ownCapabilities,
    config: config ?? createDefaultChannelConfig(),
    filterTags: filterTags,
    createdAt: createdAt ?? testCreatedAt,
    updatedAt: updatedAt ?? testUpdatedAt,
    lastMessageAt: lastMessageAt,
    extraData: extraData,
  );
}

/// Creates a [ChannelConfig] with sensible defaults.
///
/// Timestamps are always passed explicitly because the constructor defaults
/// them to `DateTime.now()`, which would break deterministic matching.
ChannelConfig createDefaultChannelConfig({
  bool readEvents = false,
  bool typingEvents = false,
  bool reactions = false,
  bool replies = false,
  bool mutes = false,
  bool skipLastMsgUpdateForSystemMsgs = false,
  List<Command> commands = const [],
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  return ChannelConfig(
    readEvents: readEvents,
    typingEvents: typingEvents,
    reactions: reactions,
    replies: replies,
    mutes: mutes,
    skipLastMsgUpdateForSystemMsgs: skipLastMsgUpdateForSystemMsgs,
    commands: commands,
    createdAt: createdAt ?? testCreatedAt,
    updatedAt: updatedAt ?? testUpdatedAt,
  );
}

/// Creates a [ChannelState] with sensible defaults.
ChannelState createDefaultChannelState({
  ChannelModel? channel,
  List<Message> messages = const [],
  List<Member> members = const [],
  List<Message> pinnedMessages = const [],
  List<Read> read = const [],
  Member? membership,
  int? watcherCount,
}) {
  return ChannelState(
    channel: channel ?? createDefaultChannelModel(),
    messages: messages,
    members: members,
    pinnedMessages: pinnedMessages,
    read: read,
    membership: membership,
    watcherCount: watcherCount,
  );
}

/// Creates a [Member] with sensible defaults.
Member createDefaultMember({
  User? user,
  String channelRole = 'channel_member',
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  return Member(
    user: user ?? createDefaultUser(),
    channelRole: channelRole,
    createdAt: createdAt ?? testCreatedAt,
    updatedAt: updatedAt ?? testUpdatedAt,
  );
}

/// Creates a [Read] with sensible defaults.
Read createDefaultRead({
  User? user,
  DateTime? lastRead,
  DateTime? lastDeliveredAt,
  int unreadMessages = 0,
}) {
  return Read(
    user: user ?? createDefaultUser(),
    lastRead: lastRead ?? testCreatedAt,
    lastDeliveredAt: lastDeliveredAt,
    unreadMessages: unreadMessages,
  );
}

/// Creates a [Reaction] with sensible defaults.
Reaction createDefaultReaction({
  String type = 'like',
  String? messageId,
  User? user,
  int score = 1,
  DateTime? createdAt,
}) {
  return Reaction(
    type: type,
    messageId: messageId,
    user: user ?? createDefaultUser(),
    score: score,
    createdAt: createdAt ?? testCreatedAt,
  );
}

/// Creates a [Draft] with sensible defaults.
///
/// The default [DraftMessage] is given an explicit id because the constructor
/// defaults it to a random UUID, which would break deterministic matching.
Draft createDefaultDraft({
  String channelCid = 'messaging:test-channel',
  DraftMessage? message,
  String? parentId,
  DateTime? createdAt,
}) {
  return Draft(
    channelCid: channelCid,
    message: message ?? DraftMessage(id: 'draft-message-id', text: 'draft message text'),
    parentId: parentId,
    createdAt: createdAt ?? testCreatedAt,
  );
}

/// Creates a [MessageReminder] with sensible defaults.
///
/// Timestamps are always passed explicitly because the constructor defaults
/// them to `DateTime.now()`, which would break deterministic matching.
MessageReminder createDefaultMessageReminder({
  String channelCid = 'messaging:test-channel',
  String messageId = 'message-id',
  String userId = 'luke_skywalker',
  ChannelModel? channel,
  Message? message,
  User? user,
  DateTime? remindAt,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  return MessageReminder(
    channelCid: channelCid,
    channel: channel,
    messageId: messageId,
    message: message,
    userId: userId,
    user: user,
    remindAt: remindAt,
    createdAt: createdAt ?? testCreatedAt,
    updatedAt: updatedAt ?? testUpdatedAt,
  );
}

/// Creates a [Poll] with sensible defaults.
///
/// The id and timestamps are always passed explicitly because the constructor
/// defaults them to a random UUID and `DateTime.now()` respectively, which
/// would break deterministic matching.
Poll createDefaultPoll({
  String id = 'test-poll-id',
  String name = 'What is your favorite color?',
  List<PollOption>? options,
  DateTime? createdAt,
  DateTime? updatedAt,
  Map<String, Object?> extraData = const {},
}) {
  return Poll(
    id: id,
    name: name,
    options:
        options ??
        [
          createDefaultPollOption(text: 'Red'),
          createDefaultPollOption(text: 'Blue'),
        ],
    createdAt: createdAt ?? testCreatedAt,
    updatedAt: updatedAt ?? testUpdatedAt,
    extraData: extraData,
  );
}

/// Creates a [PollOption] with sensible defaults.
PollOption createDefaultPollOption({
  String? id,
  String text = 'Red',
  Map<String, Object?> extraData = const {},
}) {
  return PollOption(
    id: id,
    text: text,
    extraData: extraData,
  );
}

/// Creates a [PollVote] with sensible defaults.
///
/// A vote must carry either an [optionId] or an [answerText]; when neither is
/// provided, the vote defaults to an option vote for `test-option-id`.
/// Timestamps are always passed explicitly because the constructor defaults
/// them to `DateTime.now()`, which would break deterministic matching.
PollVote createDefaultPollVote({
  String? id,
  String? pollId,
  String? optionId,
  String? answerText,
  String? userId,
  User? user,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final resolvedOptionId = optionId ?? (answerText == null ? 'test-option-id' : null);
  return PollVote(
    id: id,
    pollId: pollId,
    optionId: resolvedOptionId,
    answerText: answerText,
    userId: userId,
    user: user,
    createdAt: createdAt ?? testCreatedAt,
    updatedAt: updatedAt ?? testUpdatedAt,
  );
}

/// Creates a [GetMessageResponse] wrapping [message].
GetMessageResponse createDefaultGetMessageResponse({
  Message? message,
  ChannelModel? channel,
}) {
  return GetMessageResponse()
    ..duration = '10ms'
    ..message = message ?? createDefaultMessage()
    ..channel = channel;
}

/// Creates a [SendMessageResponse] wrapping [message].
SendMessageResponse createDefaultSendMessageResponse({
  Message? message,
}) {
  return SendMessageResponse()
    ..duration = '10ms'
    ..message = message ?? createDefaultMessage();
}

/// Creates a [CreateDraftResponse] wrapping [draft].
CreateDraftResponse createDefaultCreateDraftResponse({
  Draft? draft,
}) {
  return CreateDraftResponse()
    ..duration = '10ms'
    ..draft = draft ?? createDefaultDraft();
}

/// Creates a [GetDraftResponse] wrapping [draft].
GetDraftResponse createDefaultGetDraftResponse({
  Draft? draft,
}) {
  return GetDraftResponse()
    ..duration = '10ms'
    ..draft = draft ?? createDefaultDraft();
}

/// Creates a [CreateReminderResponse] wrapping [reminder].
CreateReminderResponse createDefaultCreateReminderResponse({
  MessageReminder? reminder,
}) {
  return CreateReminderResponse()
    ..duration = '10ms'
    ..reminder = reminder ?? createDefaultMessageReminder();
}

/// Creates an [UpdateReminderResponse] wrapping [reminder].
UpdateReminderResponse createDefaultUpdateReminderResponse({
  MessageReminder? reminder,
}) {
  return UpdateReminderResponse()
    ..duration = '10ms'
    ..reminder = reminder ?? createDefaultMessageReminder();
}

/// Creates an [UpdateMessageResponse] wrapping [message].
UpdateMessageResponse createDefaultUpdateMessageResponse({
  Message? message,
}) {
  return UpdateMessageResponse()
    ..duration = '10ms'
    ..message = message ?? createDefaultMessage();
}

/// Creates a [SendActionResponse] wrapping the optional [message].
SendActionResponse createDefaultSendActionResponse({
  Message? message,
}) {
  return SendActionResponse()
    ..duration = '10ms'
    ..message = message;
}

/// Creates a [SendReactionResponse] wrapping [message] and [reaction].
SendReactionResponse createDefaultSendReactionResponse({
  Message? message,
  Reaction? reaction,
}) {
  return SendReactionResponse()
    ..duration = '10ms'
    ..message = message ?? createDefaultMessage()
    ..reaction = reaction ?? createDefaultReaction();
}

/// Creates a [SearchMessagesResponse] wrapping [results].
SearchMessagesResponse createDefaultSearchMessagesResponse({
  List<GetMessageResponse> results = const [],
  String? next,
  String? previous,
}) {
  return SearchMessagesResponse()
    ..duration = '10ms'
    ..results = results
    ..next = next
    ..previous = previous;
}

/// Creates a [QueryRepliesResponse] wrapping [messages].
QueryRepliesResponse createDefaultQueryRepliesResponse({
  List<Message> messages = const [],
}) {
  return QueryRepliesResponse()
    ..duration = '10ms'
    ..messages = messages;
}

/// Creates a [QueryReactionsResponse] wrapping [reactions].
QueryReactionsResponse createDefaultQueryReactionsResponse({
  List<Reaction> reactions = const [],
  String? next,
}) {
  return QueryReactionsResponse()
    ..duration = '10ms'
    ..reactions = reactions
    ..next = next;
}

/// Creates a [GetMessagesByIdResponse] wrapping [messages].
GetMessagesByIdResponse createDefaultGetMessagesByIdResponse({
  List<Message> messages = const [],
}) {
  return GetMessagesByIdResponse()
    ..duration = '10ms'
    ..messages = messages;
}

/// Creates a [TranslateMessageResponse] wrapping [message].
TranslateMessageResponse createDefaultTranslateMessageResponse({
  Message? message,
}) {
  return TranslateMessageResponse()
    ..duration = '10ms'
    ..message = message ?? createDefaultMessage();
}

/// Creates a [QueryChannelsResponse] wrapping [channels] and the optional
/// server-resolved [predefinedFilter] spec.
QueryChannelsResponse createDefaultQueryChannelsResponse({
  List<ChannelState> channels = const [],
  PredefinedFilter? predefinedFilter,
}) {
  return QueryChannelsResponse()
    ..duration = '10ms'
    ..channels = channels
    ..predefinedFilter = predefinedFilter;
}

/// Creates a [SyncResponse] wrapping [events].
SyncResponse createDefaultSyncResponse({
  List<Event> events = const [],
}) {
  return SyncResponse()
    ..duration = '10ms'
    ..events = events;
}

/// Creates a [PartialUpdateChannelResponse] wrapping [channel].
PartialUpdateChannelResponse createDefaultPartialUpdateChannelResponse({
  ChannelModel? channel,
}) {
  return PartialUpdateChannelResponse()
    ..duration = '10ms'
    ..channel = channel ?? createDefaultChannelModel();
}

/// Creates a [PartialUpdateMemberResponse] wrapping [channelMember].
PartialUpdateMemberResponse createDefaultPartialUpdateMemberResponse({
  Member? channelMember,
}) {
  return PartialUpdateMemberResponse()
    ..duration = '10ms'
    ..channelMember = channelMember ?? createDefaultMember();
}

/// Creates an [AddMembersResponse] wrapping [channel], [members] and
/// [message].
AddMembersResponse createDefaultAddMembersResponse({
  ChannelModel? channel,
  List<Member> members = const [],
  Message? message,
}) {
  return AddMembersResponse()
    ..duration = '10ms'
    ..channel = channel ?? createDefaultChannelModel()
    ..members = members
    ..message = message;
}

/// Creates a [GetAppSettingsResponse] with default [AppSettings].
GetAppSettingsResponse createDefaultGetAppSettingsResponse({
  AppSettings app = const AppSettings(),
}) {
  return GetAppSettingsResponse()
    ..duration = '10ms'
    ..app = app;
}

/// Creates a [ConnectGuestUserResponse] wrapping [user] and [accessToken].
///
/// The default access token is a decodable development token for the guest
/// user's id.
ConnectGuestUserResponse createDefaultConnectGuestUserResponse({
  User? user,
  String? accessToken,
}) {
  final guestUser = user ?? createDefaultUser();
  return ConnectGuestUserResponse()
    ..duration = '10ms'
    ..user = guestUser
    ..accessToken = accessToken ?? createTestToken(guestUser.id).rawValue;
}

/// Creates an [UpdatePollResponse] wrapping [poll].
UpdatePollResponse createDefaultUpdatePollResponse({
  Poll? poll,
}) {
  return UpdatePollResponse()
    ..duration = '10ms'
    ..poll = poll ?? createDefaultPoll();
}

/// Creates a [CastPollVoteResponse] wrapping [vote].
CastPollVoteResponse createDefaultCastPollVoteResponse({
  PollVote? vote,
}) {
  return CastPollVoteResponse()
    ..duration = '10ms'
    ..vote = vote ?? createDefaultPollVote();
}

/// Creates an [UpdateUsersResponse] wrapping the updated [users].
UpdateUsersResponse createDefaultUpdateUsersResponse({
  Map<String, User>? users,
}) {
  final updatedUser = createDefaultUser();
  return UpdateUsersResponse()
    ..duration = '10ms'
    ..users = users ?? {updatedUser.id: updatedUser};
}

/// Creates a [UserBlockResponse] with sensible defaults.
UserBlockResponse createDefaultUserBlockResponse({
  String blockedUserId = 'darth_vader',
  String blockedByUserId = 'luke_skywalker',
  DateTime? createdAt,
}) {
  return UserBlockResponse()
    ..duration = '10ms'
    ..blockedUserId = blockedUserId
    ..blockedByUserId = blockedByUserId
    ..createdAt = createdAt ?? testCreatedAt;
}

/// Creates a [BlockedUsersResponse] wrapping [blocks].
BlockedUsersResponse createDefaultBlockedUsersResponse({
  List<UserBlock> blocks = const [],
}) {
  return BlockedUsersResponse()
    ..duration = '10ms'
    ..blocks = blocks;
}

/// Creates a [GetUnreadCountResponse] with sensible defaults.
GetUnreadCountResponse createDefaultGetUnreadCountResponse({
  int totalUnreadCount = 0,
  int totalUnreadThreadsCount = 0,
  List<UnreadCountsChannelType> channelType = const [],
  List<UnreadCountsChannel> channels = const [],
  List<UnreadCountsThread> threads = const [],
}) {
  return GetUnreadCountResponse()
    ..duration = '10ms'
    ..totalUnreadCount = totalUnreadCount
    ..totalUnreadThreadsCount = totalUnreadThreadsCount
    ..channelType = channelType
    ..channels = channels
    ..threads = threads;
}

/// Creates an [EmptyResponse].
EmptyResponse createDefaultEmptyResponse() => EmptyResponse()..duration = '10ms';

/// Creates an [ErrorResponse] with sensible defaults.
ErrorResponse createDefaultErrorResponse({
  int code = 500,
  String message = 'internal server error',
  int statusCode = 500,
}) {
  return ErrorResponse()
    ..code = code
    ..message = message
    ..statusCode = statusCode;
}

/// Creates a [StreamChatNetworkError] for [errorCode].
///
/// Non-retriable by default: the error carries an [ErrorResponse], the shape a
/// server-rejected request produces, which the SDK's default retry policy does
/// not retry. Pass `retriable: true` to omit the response data, making the
/// error retriable and eligible for the SDK's retry queue.
StreamChatNetworkError createDefaultNetworkError({
  ChatErrorCode errorCode = ChatErrorCode.internalSystemError,
  int? statusCode,
  bool retriable = false,
}) {
  return StreamChatNetworkError(
    errorCode,
    statusCode: statusCode,
    data: retriable
        ? null
        : createDefaultErrorResponse(
            code: errorCode.code,
            message: errorCode.message,
            statusCode: statusCode ?? 500,
          ),
  );
}
