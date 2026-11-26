import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'user.dart';

part 'message_mark.g.dart';

/// The kind of fact a [MessageMark] records about a message.
///
/// Besides [played], any type the channel allows in [ChannelConfig.markTypes]
/// can be used.
///
/// See also:
///
///  * [MessageMark], which records one mark of this type on a message.
///  * [StreamChatClient.sendMessageMark], which puts a mark on a message.
///  * [Channel.markMessage], which marks a message once.
extension type const MessageMarkType(String _) implements String {
  /// A recipient played one of the message's attachments.
  static const played = MessageMarkType('played');
}

/// A mark one user put on one message, such as [MessageMarkType.played].
///
/// A user marks a message at most once per type, and a mark is never removed.
///
/// See also:
///
///  * [Message.markGroups], which groups the marks on the current user's
///    messages by type.
///  * [Message.ownMarks], which lists the current user's marks on a message.
///  * [StreamChatClient.queryMessageMarks], which lists the marks on a message.
@JsonSerializable()
final class MessageMark extends Equatable {
  /// Creates a new [MessageMark].
  const MessageMark({
    required this.type,
    required this.messageId,
    required this.userId,
    this.user,
    required this.createdAt,
  });

  /// Creates a new [MessageMark] from [json].
  factory MessageMark.fromJson(Map<String, dynamic> json) => _$MessageMarkFromJson(json);

  /// The type of the mark.
  final MessageMarkType type;

  /// The ID of the marked message.
  final String messageId;

  /// The ID of the user who marked the message.
  final String userId;

  /// The user who marked the message.
  ///
  /// Only set on marks returned by [StreamChatClient.queryMessageMarks].
  final User? user;

  /// When the message was marked.
  final DateTime createdAt;

  /// Serializes this mark to json.
  Map<String, dynamic> toJson() => _$MessageMarkToJson(this);

  @override
  List<Object?> get props => [type, messageId, userId, user, createdAt];
}
