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
  Reaction? reaction,
  Member? member,
  ChannelModel? channel,
  OwnUser? me,
  int? totalUnreadCount,
  int? unreadChannels,
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
    reaction: reaction,
    member: member,
    channel: channel,
    me: me,
    totalUnreadCount: totalUnreadCount,
    unreadChannels: unreadChannels,
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
/// them to `DateTime.now()`, which would break deterministic matching.
ChannelModel createDefaultChannelModel({
  String cid = 'messaging:test-channel',
  User? createdBy,
  int memberCount = 0,
  List<String>? ownCapabilities,
  ChannelConfig? config,
  DateTime? createdAt,
  DateTime? updatedAt,
  DateTime? lastMessageAt,
  Map<String, Object?> extraData = const {},
}) {
  return ChannelModel(
    cid: cid,
    createdBy: createdBy,
    memberCount: memberCount,
    ownCapabilities: ownCapabilities,
    config: config,
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

/// Creates a [QueryChannelsResponse] wrapping [channels].
QueryChannelsResponse createDefaultQueryChannelsResponse({
  List<ChannelState> channels = const [],
}) {
  return QueryChannelsResponse()
    ..duration = '10ms'
    ..channels = channels;
}

/// Creates a [GetAppSettingsResponse] with default [AppSettings].
GetAppSettingsResponse createDefaultGetAppSettingsResponse({
  AppSettings app = const AppSettings(),
}) {
  return GetAppSettingsResponse()
    ..duration = '10ms'
    ..app = app;
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
