import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/attachment.dart';
import 'package:stream_chat/src/core/models/comparable_field.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/models/poll.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:stream_chat/src/core/util/serializer.dart';
import 'package:uuid/uuid.dart';

part 'draft_message.g.dart';

/// The class that contains the information about a draft message.
@JsonSerializable()
class DraftMessage extends Equatable {
  /// Creates a new draft message.
  DraftMessage({
    String? id,
    this.text,
    String type = MessageType.regular,
    this.attachments = const [],
    this.parentId,
    this.showInChannel,
    this.mentionedUsers = const [],
    this.quotedMessage,
    String? quotedMessageId,
    this.silent = false,
    this.poll,
    String? pollId,
    this.extraData = const {},
  })  : id = id ?? const Uuid().v4(),
        type = MessageType(type),
        _quotedMessageId = quotedMessageId,
        _pollId = pollId;

  /// Create a new instance from JSON.
  factory DraftMessage.fromJson(Map<String, dynamic> json) =>
      _$DraftMessageFromJson(
        Serializer.moveToExtraDataFromRoot(json, topLevelFields),
      );

  /// The message ID. This is either created by Stream or set client side when
  /// the message is added.
  final String id;

  /// The text of this message.
  final String? text;

  /// The message type.
  @JsonKey(
    includeIfNull: false,
    toJson: MessageType.toJson,
    fromJson: MessageType.fromJson,
  )
  final MessageType type;

  /// The list of attachments, either provided by the user or generated from a
  /// command or as a result of URL scraping.
  @JsonKey(includeIfNull: false)
  final List<Attachment> attachments;

  /// The ID of the parent message, if the message is a thread reply.
  final String? parentId;

  /// Check if this message needs to show in the channel.
  final bool? showInChannel;

  /// The list of user mentioned in the message.
  @JsonKey(toJson: User.toIds)
  final List<User> mentionedUsers;

  /// A quoted reply message.
  @JsonKey(includeToJson: false)
  final Message? quotedMessage;

  /// The ID of the quoted message, if the message is a quoted reply.
  String? get quotedMessageId => _quotedMessageId ?? quotedMessage?.id;
  final String? _quotedMessageId;

  /// If true the message is silent.
  final bool silent;

  /// The poll associated with the message.
  @JsonKey(includeToJson: false)
  final Poll? poll;

  /// The ID of the poll, if a poll is associated with the message.
  String? get pollId => _pollId ?? poll?.id;
  final String? _pollId;

  /// Message custom extraData.
  final Map<String, Object?> extraData;

  /// Known top level fields.
  ///
  /// Useful for [Serializer] methods.
  static const topLevelFields = [
    'id',
    'text',
    'type',
    'attachments',
    'parent_id',
    'show_in_channel',
    'mentioned_users',
    'quoted_message_id',
    'silent',
    'poll_id',
    'extra_data',
  ];

  /// Serialize to json.
  Map<String, dynamic> toJson() => Serializer.moveFromExtraDataToRoot(
        _$DraftMessageToJson(this),
      );

  /// Create a copy of this message with the provided values.
  DraftMessage copyWith({
    String? id,
    String? text,
    MessageType? type,
    List<Attachment>? attachments,
    String? parentId,
    bool? showInChannel,
    List<User>? mentionedUsers,
    String? quotedMessageId,
    bool? silent,
    Map<String, Object?>? extraData,
  }) {
    return DraftMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      type: type ?? this.type,
      attachments: attachments ?? this.attachments,
      parentId: parentId ?? this.parentId,
      showInChannel: showInChannel ?? this.showInChannel,
      mentionedUsers: mentionedUsers ?? this.mentionedUsers,
      quotedMessageId: quotedMessageId ?? this.quotedMessageId,
      silent: silent ?? this.silent,
      extraData: extraData ?? this.extraData,
    );
  }

  @override
  List<Object?> get props => [
        id,
        text,
        type,
        attachments,
        parentId,
        showInChannel,
        mentionedUsers,
        quotedMessageId,
        silent,
        extraData,
      ];
}
