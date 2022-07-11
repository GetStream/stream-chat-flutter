import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template messageDetails}
/// Class for message details
/// {@endtemplate}
// ignore: prefer-match-file-name
class MessageDetails {
  /// {@macro messageDetails}
  MessageDetails(
    String currentUserId,
    this.message,
    List<Message> messages,
    this.index,
  ) {
    isMyMessage = message.user?.id == currentUserId;
    isLastUser = index + 1 < messages.length &&
        message.user?.id == messages[index + 1].user?.id;
    isNextUser =
        index - 1 >= 0 && message.user!.id == messages[index - 1].user?.id;
  }

  /// True if the message belongs to the current user
  late final bool isMyMessage;

  /// True if the user message is the same of the previous message
  late final bool isLastUser;

  /// True if the user message is the same of the next message
  late final bool isNextUser;

  /// The message
  final Message message;

  /// The index of the message
  final int index;
}
