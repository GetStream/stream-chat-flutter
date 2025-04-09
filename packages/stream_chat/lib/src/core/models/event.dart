import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/util/serializer.dart';
import 'package:stream_chat/stream_chat.dart';

part 'event.g.dart';

/// The class that contains the information about an event
@JsonSerializable(includeIfNull: false)
class Event {
  /// Constructor used for json serialization
  Event({
    this.type = 'local.event',
    this.cid,
    this.connectionId,
    DateTime? createdAt,
    this.me,
    this.user,
    this.message,
    this.poll,
    this.pollVote,
    this.totalUnreadCount,
    this.unreadChannels,
    this.reaction,
    this.online,
    this.channel,
    this.member,
    this.channelId,
    this.channelType,
    this.channelLastMessageAt,
    this.parentId,
    this.hardDelete,
    this.aiState,
    this.aiMessage,
    this.messageId,
    this.thread,
    this.unreadThreadMessages,
    this.unreadThreads,
    this.lastReadAt,
    this.unreadMessages,
    this.lastReadMessageId,
    this.draft,
    this.extraData = const {},
    this.isLocal = true,
  }) : createdAt = createdAt?.toUtc() ?? DateTime.now().toUtc();

  /// Create a new instance from a json
  factory Event.fromJson(Map<String, dynamic> json) =>
      _$EventFromJson(Serializer.moveToExtraDataFromRoot(
        json,
        topLevelFields,
      ));

  /// The type of the event
  /// [EventType] contains some predefined constant types
  final String type;

  /// The channel cid to which the event belongs
  final String? cid;

  /// The channel id to which the event belongs
  final String? channelId;

  /// The channel type to which the event belongs
  final String? channelType;

  /// The dateTime at which the last message was sent in the channel.
  final DateTime? channelLastMessageAt;

  /// The connection id in which the event has been sent
  final String? connectionId;

  /// The date of creation of the event
  final DateTime createdAt;

  /// User object of the health check user
  final OwnUser? me;

  /// User object of the current user
  final User? user;

  /// The message sent with the event
  final Message? message;

  /// The poll sent with the event
  final Poll? poll;

  /// The poll vote sent with the event
  final PollVote? pollVote;

  /// The channel sent with the event
  final ChannelModel? channel;

  /// The member sent with the event
  final Member? member;

  /// The reaction sent with the event
  final Reaction? reaction;

  /// The number of unread messages for current user
  final int? totalUnreadCount;

  /// User total unread channels
  final int? unreadChannels;

  /// Online status
  final bool? online;

  /// The id of the parent message of a thread
  final String? parentId;

  /// True if the event is generated by this client
  @JsonKey(defaultValue: false)
  final bool isLocal;

  /// This is true if the message has been hard deleted
  final bool? hardDelete;

  /// The current state of the AI assistant.
  @JsonKey(unknownEnumValue: AITypingState.idle)
  final AITypingState? aiState;

  /// Additional message from the AI assistant.
  final String? aiMessage;

  /// The message id to which the event belongs.
  final String? messageId;

  /// The thread object sent with the event.
  final Thread? thread;

  /// The number of unread thread messages.
  final int? unreadThreadMessages;

  /// The number of unread threads.
  final int? unreadThreads;

  /// Create date of the last read message (notification.mark_unread)
  final DateTime? lastReadAt;

  /// The number of unread messages (notification.mark_unread)
  final int? unreadMessages;

  /// The id of the last read message (notification.mark_read)
  final String? lastReadMessageId;

  /// The draft message sent with the event.
  final DraftMessage? draft;

  /// Map of custom channel extraData
  final Map<String, Object?> extraData;

  /// Known top level fields.
  /// Useful for [Serializer] methods.
  static final topLevelFields = [
    'type',
    'cid',
    'connection_id',
    'created_at',
    'me',
    'user',
    'message',
    'poll',
    'poll_vote',
    'total_unread_count',
    'unread_channels',
    'reaction',
    'online',
    'channel',
    'member',
    'channel_id',
    'channel_type',
    'channel_last_message_at',
    'parent_id',
    'hard_delete',
    'is_local',
    'ai_state',
    'ai_message',
    'message_id',
    'thread',
    'unread_thread_messages',
    'unread_threads',
    'last_read_at',
    'unread_messages',
    'last_read_message_id',
    'draft',
  ];

  /// Serialize to json
  Map<String, dynamic> toJson() => Serializer.moveFromExtraDataToRoot(
        _$EventToJson(this),
      );

  /// Creates a copy of [Event] with specified attributes overridden.
  Event copyWith({
    String? type,
    String? cid,
    String? channelId,
    String? channelType,
    DateTime? channelLastMessageAt,
    String? connectionId,
    DateTime? createdAt,
    OwnUser? me,
    User? user,
    Message? message,
    Poll? poll,
    PollVote? pollVote,
    ChannelModel? channel,
    Member? member,
    Reaction? reaction,
    int? totalUnreadCount,
    int? unreadChannels,
    bool? online,
    String? parentId,
    bool? hardDelete,
    AITypingState? aiState,
    String? aiMessage,
    String? messageId,
    Thread? thread,
    int? unreadThreadMessages,
    int? unreadThreads,
    DateTime? lastReadAt,
    int? unreadMessages,
    String? lastReadMessageId,
    DraftMessage? draft,
    Map<String, Object?>? extraData,
  }) =>
      Event(
        type: type ?? this.type,
        cid: cid ?? this.cid,
        connectionId: connectionId ?? this.connectionId,
        createdAt: createdAt ?? this.createdAt,
        me: me ?? this.me,
        user: user ?? this.user,
        message: message ?? this.message,
        poll: poll ?? this.poll,
        pollVote: pollVote ?? this.pollVote,
        totalUnreadCount: totalUnreadCount ?? this.totalUnreadCount,
        unreadChannels: unreadChannels ?? this.unreadChannels,
        reaction: reaction ?? this.reaction,
        online: online ?? this.online,
        channel: channel ?? this.channel,
        member: member ?? this.member,
        channelId: channelId ?? this.channelId,
        channelType: channelType ?? this.channelType,
        channelLastMessageAt: channelLastMessageAt ?? this.channelLastMessageAt,
        parentId: parentId ?? this.parentId,
        hardDelete: hardDelete ?? this.hardDelete,
        aiState: aiState ?? this.aiState,
        aiMessage: aiMessage ?? this.aiMessage,
        messageId: messageId ?? this.messageId,
        thread: thread ?? this.thread,
        unreadThreadMessages: unreadThreadMessages ?? this.unreadThreadMessages,
        unreadThreads: unreadThreads ?? this.unreadThreads,
        lastReadAt: lastReadAt ?? this.lastReadAt,
        unreadMessages: unreadMessages ?? this.unreadMessages,
        lastReadMessageId: lastReadMessageId ?? this.lastReadMessageId,
        draft: draft ?? this.draft,
        isLocal: isLocal,
        extraData: extraData ?? this.extraData,
      );
}

/// {@template aiState}
/// The current typing state of the AI assistant.
///
/// This is used to determine the state of the AI assistant when it's generating
/// a response for the provided query.
/// {@endtemplate}
enum AITypingState {
  /// The AI assistant is idle.
  @JsonValue('AI_STATE_IDLE')
  idle,

  /// The AI assistant is in an error state.
  @JsonValue('AI_STATE_ERROR')
  error,

  /// The AI assistant is checking external sources.
  @JsonValue('AI_STATE_CHECKING_SOURCES')
  checkingSources,

  /// The AI assistant is thinking.
  @JsonValue('AI_STATE_THINKING')
  thinking,

  /// The AI assistant is generating a response.
  @JsonValue('AI_STATE_GENERATING')
  generating,
}
