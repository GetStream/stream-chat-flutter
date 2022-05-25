import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_widget/sending_indicator_wrapper.dart';
import 'package:stream_chat_flutter/src/message_widget/thread_painter.dart';
import 'package:stream_chat_flutter/src/message_widget/thread_participants.dart';
import 'package:stream_chat_flutter/src/message_widget/username.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template bottomRow}
/// The bottom row of a [StreamMessageWidget].
///
/// Used in [MessageWidgetContent]. Should not be used elsewhere.
/// {@endtemplate}
class BottomRow extends StatelessWidget {
  /// {@macro bottomRow}
  const BottomRow({
    super.key,
    required this.isDeleted,
    required this.message,
    required this.showThreadReplyIndicator,
    required this.showInChannel,
    required this.showTimeStamp,
    required this.showUsername,
    required this.reverse,
    required this.showSendingIndicator,
    required this.hasUrlAttachments,
    required this.isGiphy,
    required this.isOnlyEmoji,
    required this.messageTheme,
    required this.streamChatTheme,
    required this.hasNonUrlAttachments,
    required this.streamChat,
    this.deletedBottomRowBuilder,
    this.onThreadTap,
  });

  /// {@macro messageIsDeleted}
  final bool isDeleted;

  /// {@macro deletedBottomRowBuilder}
  final Widget Function(BuildContext, Message)? deletedBottomRowBuilder;

  /// {@macro message}
  final Message message;

  /// {@macro showThreadReplyIndicator}
  final bool showThreadReplyIndicator;

  /// {@macro showInChannelIndicator}
  final bool showInChannel;

  /// {@macro showTimestamp}
  final bool showTimeStamp;

  /// {@macro showUsername}
  final bool showUsername;

  /// {@macro reverse}
  final bool reverse;

  /// {@macro showSendingIndicator}
  final bool showSendingIndicator;

  /// {@macro hasUrlAttachments}
  final bool hasUrlAttachments;

  /// {@macro isGiphy}
  final bool isGiphy;

  /// {@macro isOnlyEmoji}
  final bool isOnlyEmoji;

  /// {@macro hasNonUrlAttachments}
  final bool hasNonUrlAttachments;

  /// {@macro messageTheme}
  final StreamMessageThemeData messageTheme;

  /// {@macro onThreadTap}
  final void Function(Message)? onThreadTap;

  /// {@macro streamChatThemeData}
  final StreamChatThemeData streamChatTheme;

  /// {@macro streamChat}
  final StreamChatState streamChat;

  @override
  Widget build(BuildContext context) {
    if (isDeleted) {
      return deletedBottomRowBuilder?.call(
            context,
            message,
          ) ??
          const Offstage();
    }

    final children = <Widget>[];

    final threadParticipants = message.threadParticipants?.take(2);
    final showThreadParticipants = threadParticipants?.isNotEmpty == true;
    final replyCount = message.replyCount;

    var msg = context.translations.threadReplyLabel;
    if (showThreadReplyIndicator && replyCount! > 1) {
      msg = context.translations.threadReplyCountText(replyCount);
    }

    // ignore: prefer_function_declarations_over_variables
    final _onThreadTap = () async {
      try {
        var _message = message;
        if (showInChannel) {
          final channel = StreamChannel.of(context);
          _message = await channel.getMessage(message.parentId!);
        }
        return onThreadTap!(_message);
      } catch (e, stk) {
        print(e);
        print(stk);
        // ignore: avoid_returning_null_for_void
        return null;
      }
    };

    const usernameKey = Key('username');

    children.addAll([
      if (showUsername)
        Username(
          key: usernameKey,
          message: message,
          messageTheme: messageTheme,
        ),
      if (showTimeStamp)
        Text(
          Jiffy(message.createdAt.toLocal()).jm,
          style: messageTheme.createdAtStyle,
        ),
      if (showSendingIndicator)
        SendingIndicatorWrapper(
          messageTheme: messageTheme,
          message: message,
          hasNonUrlAttachments: hasNonUrlAttachments,
          streamChat: streamChat,
          streamChatTheme: streamChatTheme,
        ),
    ]);

    final showThreadTail = !(hasUrlAttachments || isGiphy || isOnlyEmoji) &&
        (showThreadReplyIndicator || showInChannel);

    final threadIndicatorWidgets = <Widget>[
      if (showThreadTail)
        Container(
          margin: EdgeInsets.only(
            bottom: context.textScaleFactor *
                ((messageTheme.repliesStyle?.fontSize ?? 1) / 2),
          ),
          child: CustomPaint(
            size: const Size(16, 32) * context.textScaleFactor,
            painter: ThreadReplyPainter(
              context: context,
              color: messageTheme.messageBorderColor,
              reverse: reverse,
            ),
          ),
        ),
      if (showInChannel || showThreadReplyIndicator) ...[
        if (showThreadParticipants)
          SizedBox.fromSize(
            size: Size((threadParticipants!.length * 8.0) + 8, 16),
            child: ThreadParticipants(
              streamChatTheme: streamChatTheme,
              threadParticipants: threadParticipants,
            ),
          ),
        InkWell(
          onTap: _onThreadTap,
          child: Text(msg, style: messageTheme.repliesStyle),
        ),
      ],
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment:
          reverse ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (showThreadTail && !reverse) ...threadIndicatorWidgets,
        ...children.map(
          (child) {
            Widget mappedChild = SizedBox(
              height: context.textScaleFactor * 14,
              child: child,
            );
            if (child.key == usernameKey) {
              mappedChild = Flexible(child: mappedChild);
            }
            return mappedChild;
          },
        ),
        if (showThreadTail && reverse) ...threadIndicatorWidgets.reversed,
      ].insertBetween(const SizedBox(width: 8)),
    );
  }
}
