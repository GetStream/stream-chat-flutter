import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_input/quoted_message_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template quotedMessage}
/// A quoted message in a chat.
///
/// Used in [QuotedMessageCard]. Should not be used elsewhere.
/// {@endtemplate}
class QuotedMessage extends StatefulWidget {
  /// {@macro quotedMessage}
  const QuotedMessage({
    super.key,
    required this.message,
    required this.reverse,
    required this.hasNonUrlAttachments,
    this.onQuotedMessageTap,
  });

  /// {@macro message}
  final Message message;

  /// {@macro onQuotedMessageTap}
  final OnQuotedMessageTap? onQuotedMessageTap;

  /// {@macro reverse}
  final bool reverse;

  /// {@macro hasNonUrlAttachments}
  final bool hasNonUrlAttachments;

  @override
  State<QuotedMessage> createState() => _QuotedMessageState();
}

class _QuotedMessageState extends State<QuotedMessage> {
  late StreamChatState _streamChat;
  late StreamChatThemeData _streamChatTheme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _streamChatTheme = StreamChatTheme.of(context);
    _streamChat = StreamChat.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final isMyMessage = widget.message.user?.id == _streamChat.currentUser?.id;
    final onTap = widget.message.quotedMessage?.isDeleted != true &&
            widget.onQuotedMessageTap != null
        ? () => widget.onQuotedMessageTap!(widget.message.quotedMessageId)
        : null;
    final chatThemeData = _streamChatTheme;
    return StreamQuotedMessageWidget(
      onTap: onTap,
      message: widget.message.quotedMessage!,
      messageTheme: isMyMessage
          ? chatThemeData.otherMessageTheme
          : chatThemeData.ownMessageTheme,
      reverse: widget.reverse,
      padding: EdgeInsets.only(
        right: 8,
        left: 8,
        top: 8,
        bottom: widget.hasNonUrlAttachments ? 8 : 0,
      ),
      composing: false,
    );
  }
}
