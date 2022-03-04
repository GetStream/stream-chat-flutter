import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/message_widget/message_widget_content_components.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class MessageWidgetContent extends StatelessWidget {
  const MessageWidgetContent({
    Key? key,
    required this.reverse,
    required this.isPinned,
    required this.showPinHighlight,
    required this.showBottomRow,
    required this.message,
    required this.showUserAvatar,
    required this.avatarWidth,
    required this.showReactions,
    required this.messageTheme,
    required this.shouldShowReactions,
    required this.streamChatTheme,
    required this.isFailedState,
    required this.hasQuotedMessage,
    required this.hasUrlAttachments,
    required this.hasNonUrlAttachments,
    required this.isOnlyEmoji,
    required this.isGiphy,
    required this.attachmentBuilders,
    required this.attachmentPadding,
    required this.textPadding,
    required this.showReactionPickerIndicator,
    required this.translateUserAvatar,
    required this.bottomRowPadding,
    required this.showInChannel,
    required this.streamChat,
    required this.showSendingIndicator,
    required this.showThreadReplyIndicator,
    required this.showTimeStamp,
    required this.showUsername,
    required this.messageWidget,
    this.onUserAvatarTap,
    this.borderRadiusGeometry,
    this.borderSide,
    this.shape,
    this.onQuotedMessageTap,
    this.onMentionTap,
    this.onLinkTap,
    this.textBuilder,
    this.bottomRowBuilder,
    this.onThreadTap,
    this.deletedBottomRowBuilder,
  }) : super(key: key);

  final bool reverse;
  final bool isPinned;
  final bool showPinHighlight;
  final bool showBottomRow;
  final Message message;

  /// It controls the display behaviour of the user avatar
  final DisplayWidget showUserAvatar;
  final double avatarWidth;
  final bool showReactions;

  /// The message theme
  final MessageThemeData messageTheme;

  final bool shouldShowReactions;

  /// The function called when tapping on UserAvatar
  final void Function(User)? onUserAvatarTap;
  final StreamChatThemeData streamChatTheme;
  final bool isFailedState;

  /// The border radius of the message text
  final BorderRadiusGeometry? borderRadiusGeometry;

  /// The borderside of the message text
  final BorderSide? borderSide;

  /// The shape of the message text
  final ShapeBorder? shape;
  final bool hasQuotedMessage;
  final bool hasUrlAttachments;
  final bool hasNonUrlAttachments;
  final bool isOnlyEmoji;
  final bool isGiphy;

  /// Builder for respective attachment types
  final Map<String, AttachmentBuilder> attachmentBuilders;

  /// The internal padding of an attachment
  final EdgeInsetsGeometry attachmentPadding;

  /// The internal padding of the message text
  final EdgeInsets textPadding;

  /// Function called when quotedMessage is tapped
  final OnQuotedMessageTap? onQuotedMessageTap;

  /// Function called on mention tap
  final void Function(User)? onMentionTap;

  /// The function called when tapping on a link
  final void Function(String)? onLinkTap;

  /// Widget builder for building text
  final Widget Function(BuildContext, Message)? textBuilder;
  final bool showReactionPickerIndicator;
  final bool translateUserAvatar;
  final double bottomRowPadding;

  /// Widget builder for building a bottom row below the message
  final Widget Function(BuildContext, Message)? bottomRowBuilder;
  final bool showInChannel;
  final StreamChatState streamChat;
  final bool showSendingIndicator;
  final bool showThreadReplyIndicator;
  final bool showTimeStamp;
  final bool showUsername;

  /// The function called when tapping on threads
  final void Function(Message)? onThreadTap;

  /// Widget builder for building a bottom row below a deleted message
  final Widget Function(BuildContext, Message)? deletedBottomRowBuilder;

  final MessageWidget messageWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          reverse ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: reverse
              ? AlignmentDirectional.bottomEnd
              : AlignmentDirectional.bottomStart,
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: isPinned && showPinHighlight ? 8.0 : 0.0,
              ),
              child: Column(
                crossAxisAlignment:
                    reverse ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (message.pinned &&
                      message.pinnedBy != null &&
                      showPinHighlight)
                    PinnedMessage(
                      pinnedBy: message.pinnedBy!,
                      currentUser: streamChat.currentUser!,
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!reverse &&
                          showUserAvatar == DisplayWidget.show &&
                          message.user != null) ...[
                        UserAvatarTransform(
                          translateUserAvatar: translateUserAvatar,
                          messageTheme: messageTheme,
                          message: message,
                        ),
                        const SizedBox(width: 4),
                      ],
                      if (showUserAvatar == DisplayWidget.hide)
                        SizedBox(width: avatarWidth + 4),
                      Flexible(
                        child: PortalEntry(
                          visible: showReactions,
                          portal: showReactions
                              ? ReactionIndicator(
                                  message: message,
                                  messageTheme: messageTheme,
                                  ownId: streamChat.currentUser!.id,
                                  reverse: reverse,
                                  shouldShowReactions: shouldShowReactions,
                                  onTap: () =>
                                      _showMessageReactionsModalBottomSheet(
                                    context,
                                  ),
                                )
                              : null,
                          portalAnchor: Alignment(
                            reverse ? 1 : -1,
                            -1,
                          ),
                          childAnchor: Alignment(
                            reverse ? -1 : 1,
                            -1,
                          ),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Padding(
                                padding: showReactions
                                    ? EdgeInsets.only(
                                        top: message.reactionCounts
                                                    ?.isNotEmpty ==
                                                true
                                            ? 18
                                            : 0,
                                      )
                                    : EdgeInsets.zero,
                                child: (message.isDeleted && !isFailedState)
                                    ? Container(
                                        // ignore: lines_longer_than_80_chars
                                        margin: EdgeInsets.symmetric(
                                          horizontal:
                                              // ignore: lines_longer_than_80_chars
                                              showUserAvatar ==
                                                      // ignore: lines_longer_than_80_chars
                                                      DisplayWidget.gone
                                                  ? 0
                                                  : 4.0,
                                        ),
                                        child: DeletedMessage(
                                          borderRadiusGeometry:
                                              borderRadiusGeometry,
                                          borderSide: borderSide,
                                          shape: shape,
                                          messageTheme: messageTheme,
                                        ),
                                      )
                                    : QuotedMessageCard(
                                        message: message,
                                        isFailedState: isFailedState,
                                        showUserAvatar: showUserAvatar,
                                        messageTheme: messageTheme,
                                        hasQuotedMessage: hasQuotedMessage,
                                        hasUrlAttachments: hasUrlAttachments,
                                        hasNonUrlAttachments:
                                            hasNonUrlAttachments,
                                        isOnlyEmoji: isOnlyEmoji,
                                        isGiphy: isGiphy,
                                        attachmentBuilders: attachmentBuilders,
                                        attachmentPadding: attachmentPadding,
                                        textPadding: textPadding,
                                        reverse: reverse,
                                        onQuotedMessageTap: onQuotedMessageTap,
                                        onMentionTap: onMentionTap,
                                        onLinkTap: onLinkTap,
                                        textBuilder: textBuilder,
                                        borderRadiusGeometry:
                                            borderRadiusGeometry,
                                        borderSide: borderSide,
                                        shape: shape,
                                      ),
                              ),
                              if (showReactionPickerIndicator)
                                Positioned(
                                  right: reverse ? null : 4,
                                  left: reverse ? 4 : null,
                                  top: -8,
                                  child: CustomPaint(
                                    painter: ReactionBubblePainter(
                                      streamChatTheme.colorTheme.barsBg,
                                      Colors.transparent,
                                      Colors.transparent,
                                      tailCirclesSpace: 1,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      if (reverse &&
                          showUserAvatar == DisplayWidget.show &&
                          message.user != null) ...[
                        UserAvatarTransform(
                          translateUserAvatar: translateUserAvatar,
                          messageTheme: messageTheme,
                          message: message,
                        ),
                        const SizedBox(width: 4),
                      ],
                    ],
                  ),
                  if (showBottomRow)
                    SizedBox(
                      height: context.textScaleFactor * 18.0,
                    ),
                ],
              ),
            ),
            if (showBottomRow)
              Padding(
                padding: EdgeInsets.only(
                  left: !reverse ? bottomRowPadding : 0,
                  right: reverse ? bottomRowPadding : 0,
                  bottom: isPinned && showPinHighlight ? 6.0 : 0.0,
                ),
                child: bottomRowBuilder?.call(
                      context,
                      message,
                    ) ??
                    BottomRow(
                      message: message,
                      reverse: reverse,
                      messageTheme: messageTheme,
                      hasUrlAttachments: hasUrlAttachments,
                      isOnlyEmoji: isOnlyEmoji,
                      isDeleted: message.isDeleted,
                      isGiphy: isGiphy,
                      showInChannel: showInChannel,
                      showSendingIndicator: showSendingIndicator,
                      showThreadReplyIndicator: showThreadReplyIndicator,
                      showTimeStamp: showTimeStamp,
                      showUsername: showUsername,
                      streamChatTheme: streamChatTheme,
                      onThreadTap: onThreadTap,
                      deletedBottomRowBuilder: deletedBottomRowBuilder,
                      streamChat: streamChat,
                      hasNonUrlAttachments: hasNonUrlAttachments,
                    ),
              ),
            if (isFailedState)
              Positioned(
                right: reverse ? 0 : null,
                left: reverse ? null : 0,
                bottom: showBottomRow ? 18 : -2,
                child: StreamSvgIcon.error(size: 20),
              ),
          ],
        ),
      ],
    );
  }

  void _showMessageReactionsModalBottomSheet(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    showDialog(
      useRootNavigator: false,
      context: context,
      barrierColor: streamChatTheme.colorTheme.overlay,
      builder: (context) => StreamChannel(
        channel: channel,
        child: MessageReactionsModal(
          messageWidget: messageWidget.copyWith(
            key: const Key('MessageWidget'),
            message: message.copyWith(
              text: (message.text?.length ?? 0) > 200
                  ? '${message.text!.substring(0, 200)}...'
                  : message.text,
            ),
            showReactions: false,
            showUsername: false,
            showTimestamp: false,
            translateUserAvatar: false,
            showSendingIndicator: false,
            padding: const EdgeInsets.all(0),
            showReactionPickerIndicator:
                showReactions && (message.status == MessageSendingStatus.sent),
            showPinHighlight: false,
            showUserAvatar:
                message.user!.id == channel.client.state.currentUser!.id
                    ? DisplayWidget.gone
                    : DisplayWidget.show,
          ),
          onUserAvatarTap: onUserAvatarTap,
          messageTheme: messageTheme,
          reverse: reverse,
          message: message,
          showReactions: showReactions,
        ),
      ),
    );
  }
}
