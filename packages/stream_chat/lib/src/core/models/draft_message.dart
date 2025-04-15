import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:stream_chat/src/core/models/attachment.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/models/poll.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:stream_chat/src/core/util/serializer.dart';
import 'package:uuid/uuid.dart';

part 'draft_message.g.dart';

/// The class that contains the information about a draft message.
@JsonSerializable(includeIfNull: false)
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
    this.command,
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

  /// Optional command associated with the message.
  @JsonKey(includeToJson: false)
  final String? command;

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
    'quoted_message',
    'silent',
    'command',
    'poll_id',
    'extra_data',
  ];

  /// Serialize to json.
  Map<String, dynamic> toJson() {
    final message = removeMentionsIfNotIncluded();
    final json = Serializer.moveFromExtraDataToRoot(
      _$DraftMessageToJson(message),
    );

    // If the message contains command we should append it to the text
    // before sending it.
    if (command case final command? when command.isNotEmpty) {
      json.update('text', (text) => '/$command $text', ifAbsent: () => null);
    }

    return json;
  }

  /// Create a copy of this message with the provided values.
  DraftMessage copyWith({
    String? id,
    String? text,
    MessageType? type,
    List<Attachment>? attachments,
    String? parentId,
    bool? showInChannel,
    List<User>? mentionedUsers,
    Message? quotedMessage,
    String? quotedMessageId,
    bool? silent,
    String? command,
    Poll? poll,
    String? pollId,
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
      quotedMessage: quotedMessage ?? this.quotedMessage,
      quotedMessageId: quotedMessageId ?? this.quotedMessageId,
      silent: silent ?? this.silent,
      command: command ?? this.command,
      poll: poll ?? this.poll,
      pollId: pollId ?? this.pollId,
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
        command,
        pollId,
        extraData,
      ];
}

/// Extension on [Message] to convert it to a [DraftMessage].
extension MessageToDraftMessage on Message {
  /// Converts this [DraftMessage] to a [Message].
  ///
  /// This is useful when you want to convert a message to a draft message
  /// before sending it to the server.
  DraftMessage toDraftMessage() {
    return DraftMessage(
      id: id,
      text: text,
      type: type,
      attachments: attachments,
      parentId: parentId,
      showInChannel: showInChannel,
      mentionedUsers: mentionedUsers,
      quotedMessage: quotedMessage,
      quotedMessageId: quotedMessageId,
      silent: silent,
      command: command,
      poll: poll,
      pollId: pollId,
      extraData: extraData,
    );
  }
}

/// Extension on [DraftMessage] to convert it to a [Message].
extension DraftMessageToMessage on DraftMessage {
  /// Converts this [DraftMessage] to a [Message].
  ///
  /// This is useful when displaying a draft message in the UI as if it were a
  /// regular message.
  ///
  /// Returns a [Message] object with all relevant properties copied from
  /// this draft message.
  Message toMessage() {
    return Message(
      id: id,
      text: text,
      type: type,
      attachments: attachments,
      parentId: parentId,
      showInChannel: showInChannel,
      mentionedUsers: mentionedUsers,
      quotedMessage: quotedMessage,
      quotedMessageId: quotedMessageId,
      silent: silent,
      command: command,
      poll: poll,
      pollId: pollId,
      extraData: extraData,
    );
  }
}

extension on DraftMessage {
  /// Removes mentions from the message if they are not included in the text.
  ///
  /// This is useful for cleaning up the list of mentioned users before
  /// sending the message.
  DraftMessage removeMentionsIfNotIncluded() {
    if (mentionedUsers.isEmpty) return this;

    final messageTextToSend = text;
    if (messageTextToSend == null) return this;

    final updatedMentionedUsers = [...mentionedUsers];
    for (final user in mentionedUsers.toSet()) {
      if (messageTextToSend.contains('@${user.id}')) continue;
      if (messageTextToSend.contains('@${user.name}')) continue;

      updatedMentionedUsers.remove(user);
    }

    return copyWith(mentionedUsers: updatedMentionedUsers);
  }
}
