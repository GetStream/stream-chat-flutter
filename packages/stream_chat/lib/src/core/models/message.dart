import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/attachment.dart';
import 'package:stream_chat/src/core/models/reaction.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:stream_chat/src/core/util/serializer.dart';
import 'package:uuid/uuid.dart';

part 'message.g.dart';

class _PinExpires {
  const _PinExpires();
}

const _pinExpires = _PinExpires();

/// Enum defining the status of a sending message
enum MessageSendingStatus {
  /// Message is being sent
  sending,

  /// Message is being updated
  updating,

  /// Message is being deleted
  deleting,

  /// Message failed to send
  failed,

  /// Message failed to updated
  // ignore: constant_identifier_names
  failed_update,

  /// Message failed to delete
  // ignore: constant_identifier_names
  failed_delete,

  /// Message correctly sent
  sent,
}

/// The class that contains the information about a message
@JsonSerializable()
class Message extends Equatable {
  /// Constructor used for json serialization
  Message({
    String? id,
    this.text,
    this.type = 'regular',
    this.attachments = const [],
    this.mentionedUsers = const [],
    this.silent = false,
    this.shadowed = false,
    this.reactionCounts,
    this.reactionScores,
    this.latestReactions,
    this.ownReactions,
    this.parentId,
    this.quotedMessage,
    String? quotedMessageId,
    this.replyCount = 0,
    this.threadParticipants,
    this.showInChannel,
    this.command,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.user,
    this.pinned = false,
    this.pinnedAt,
    DateTime? pinExpires,
    this.pinnedBy,
    this.extraData = const {},
    this.deletedAt,
    this.status = MessageSendingStatus.sending,
    this.i18n,
  })  : id = id ?? const Uuid().v4(),
        pinExpires = pinExpires?.toUtc(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        _quotedMessageId = quotedMessageId;

  /// Create a new instance from a json
  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(
        Serializer.moveToExtraDataFromRoot(json, topLevelFields),
      ).copyWith(
        status: MessageSendingStatus.sent,
      );

  /// The message ID. This is either created by Stream or set client side when
  /// the message is added.
  final String id;

  /// The text of this message
  final String? text;

  /// The status of a sending message
  @JsonKey(ignore: true)
  final MessageSendingStatus status;

  /// The message type
  @JsonKey(
    includeIfNull: false,
    toJson: Serializer.readOnly,
  )
  final String type;

  /// The list of attachments, either provided by the user or generated from a
  /// command or as a result of URL scraping.
  @JsonKey(includeIfNull: false)
  final List<Attachment> attachments;

  /// The list of user mentioned in the message
  @JsonKey(toJson: User.toIds)
  final List<User> mentionedUsers;

  /// A map describing the count of number of every reaction
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final Map<String, int>? reactionCounts;

  /// A map describing the count of score of every reaction
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final Map<String, int>? reactionScores;

  /// The latest reactions to the message created by any user.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final List<Reaction>? latestReactions;

  /// The reactions added to the message by the current user.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final List<Reaction>? ownReactions;

  /// The ID of the parent message, if the message is a thread reply.
  final String? parentId;

  /// A quoted reply message
  @JsonKey(toJson: Serializer.readOnly)
  final Message? quotedMessage;

  final String? _quotedMessageId;

  /// The ID of the quoted message, if the message is a quoted reply.
  String? get quotedMessageId => _quotedMessageId ?? quotedMessage?.id;

  /// Reserved field indicating the number of replies for this message.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final int? replyCount;

  /// Reserved field indicating the thread participants for this message.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final List<User>? threadParticipants;

  /// Check if this message needs to show in the channel.
  final bool? showInChannel;

  /// If true the message is silent
  final bool silent;

  /// If true the message is shadowed
  @JsonKey(
    includeIfNull: false,
    toJson: Serializer.readOnly,
  )
  final bool shadowed;

  /// A used command name.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final String? command;

  /// Reserved field indicating when the message was created.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final DateTime createdAt;

  /// Reserved field indicating when the message was updated last time.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final DateTime updatedAt;

  /// User who sent the message
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final User? user;

  /// If true the message is pinned
  final bool pinned;

  /// Reserved field indicating when the message was pinned
  @JsonKey(toJson: Serializer.readOnly)
  final DateTime? pinnedAt;

  /// Reserved field indicating when the message will expire
  ///
  /// if `null` message has no expiry
  final DateTime? pinExpires;

  /// Reserved field indicating who pinned the message
  @JsonKey(toJson: Serializer.readOnly)
  final User? pinnedBy;

  /// Message custom extraData
  @JsonKey(includeIfNull: false)
  final Map<String, Object?> extraData;

  /// True if the message is a system info
  bool get isSystem => type == 'system';

  /// True if the message has been deleted
  bool get isDeleted => type == 'deleted';

  /// True if the message is ephemeral
  bool get isEphemeral => type == 'ephemeral';

  /// Reserved field indicating when the message was deleted.
  @JsonKey(includeIfNull: false, toJson: Serializer.readOnly)
  final DateTime? deletedAt;

  /// A Map of translations.
  @JsonKey(includeIfNull: false)
  final Map<String, String>? i18n;

  /// Known top level fields.
  /// Useful for [Serializer] methods.
  static const topLevelFields = [
    'id',
    'text',
    'type',
    'silent',
    'attachments',
    'latest_reactions',
    'shadowed',
    'own_reactions',
    'mentioned_users',
    'reaction_counts',
    'reaction_scores',
    'silent',
    'parent_id',
    'quoted_message',
    'quoted_message_id',
    'reply_count',
    'thread_participants',
    'show_in_channel',
    'command',
    'created_at',
    'updated_at',
    'deleted_at',
    'user',
    'pinned',
    'pinned_at',
    'pin_expires',
    'pinned_by',
    'i18n',
  ];

  /// Serialize to json
  Map<String, dynamic> toJson() => Serializer.moveFromExtraDataToRoot(
        _$MessageToJson(this),
      );

  /// Creates a copy of [Message] with specified attributes overridden.
  Message copyWith({
    String? id,
    String? text,
    String? type,
    List<Attachment>? attachments,
    List<User>? mentionedUsers,
    Map<String, int>? reactionCounts,
    Map<String, int>? reactionScores,
    List<Reaction>? latestReactions,
    List<Reaction>? ownReactions,
    String? parentId,
    Message? quotedMessage,
    String? quotedMessageId,
    int? replyCount,
    List<User>? threadParticipants,
    bool? showInChannel,
    bool? shadowed,
    bool? silent,
    String? command,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    User? user,
    bool? pinned,
    DateTime? pinnedAt,
    Object? pinExpires = _pinExpires,
    User? pinnedBy,
    Map<String, Object?>? extraData,
    MessageSendingStatus? status,
    Map<String, String>? i18n,
  }) {
    assert(() {
      if (pinExpires is! DateTime &&
          pinExpires != null &&
          pinExpires is! _PinExpires) {
        throw ArgumentError('`pinExpires` can only be set as DateTime or null');
      }
      return true;
    }(), 'Validate type for pinExpires');
    return Message(
      id: id ?? this.id,
      text: text ?? this.text,
      type: type ?? this.type,
      attachments: attachments ?? this.attachments,
      mentionedUsers: mentionedUsers ?? this.mentionedUsers,
      reactionCounts: reactionCounts ?? this.reactionCounts,
      reactionScores: reactionScores ?? this.reactionScores,
      latestReactions: latestReactions ?? this.latestReactions,
      ownReactions: ownReactions ?? this.ownReactions,
      parentId: parentId ?? this.parentId,
      quotedMessage: quotedMessage ?? this.quotedMessage,
      quotedMessageId: quotedMessageId ?? _quotedMessageId,
      replyCount: replyCount ?? this.replyCount,
      threadParticipants: threadParticipants ?? this.threadParticipants,
      showInChannel: showInChannel ?? this.showInChannel,
      command: command ?? this.command,
      createdAt: createdAt ?? this.createdAt,
      silent: silent ?? this.silent,
      extraData: extraData ?? this.extraData,
      user: user ?? this.user,
      shadowed: shadowed ?? this.shadowed,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      status: status ?? this.status,
      pinned: pinned ?? this.pinned,
      pinnedAt: pinnedAt ?? this.pinnedAt,
      pinnedBy: pinnedBy ?? this.pinnedBy,
      pinExpires:
          pinExpires == _pinExpires ? this.pinExpires : pinExpires as DateTime?,
      i18n: i18n ?? this.i18n,
    );
  }

  /// Returns a new [Message] that is a combination of this message and the
  /// given [other] message.
  Message merge(Message other) => copyWith(
        id: other.id,
        text: other.text,
        type: other.type,
        attachments: other.attachments,
        mentionedUsers: other.mentionedUsers,
        reactionCounts: other.reactionCounts,
        reactionScores: other.reactionScores,
        latestReactions: other.latestReactions,
        ownReactions: other.ownReactions,
        parentId: other.parentId,
        quotedMessage: other.quotedMessage,
        quotedMessageId: other.quotedMessageId,
        replyCount: other.replyCount,
        threadParticipants: other.threadParticipants,
        showInChannel: other.showInChannel,
        command: other.command,
        createdAt: other.createdAt,
        silent: other.silent,
        extraData: other.extraData,
        user: other.user,
        shadowed: other.shadowed,
        updatedAt: other.updatedAt,
        deletedAt: other.deletedAt,
        status: other.status,
        pinned: other.pinned,
        pinnedAt: other.pinnedAt,
        pinExpires: other.pinExpires,
        pinnedBy: other.pinnedBy,
        i18n: other.i18n,
      );

  @override
  List<Object?> get props => [
        id,
        text,
        type,
        attachments,
        mentionedUsers,
        reactionCounts,
        reactionScores,
        latestReactions,
        ownReactions,
        parentId,
        quotedMessage,
        quotedMessageId,
        replyCount,
        threadParticipants,
        showInChannel,
        shadowed,
        silent,
        command,
        createdAt,
        updatedAt,
        deletedAt,
        user,
        pinned,
        pinnedAt,
        pinExpires,
        pinnedBy,
        extraData,
        status,
        i18n,
      ];
}
