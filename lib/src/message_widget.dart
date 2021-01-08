import 'dart:math';
import 'dart:ui';

import 'package:emojis/emoji.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter/src/message_actions_modal.dart';
import 'package:stream_chat_flutter/src/message_reactions_modal.dart';
import 'package:stream_chat_flutter/src/quoted_message_widget.dart';
import 'package:stream_chat_flutter/src/reaction_bubble.dart';
import 'package:stream_chat_flutter/src/url_attachment.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'extension.dart';
import 'image_group.dart';
import 'message_text.dart';

typedef AttachmentBuilder = Widget Function(BuildContext, Message, Attachment);
typedef OnQuotedMessageTap = void Function(String);

/// The display behaviour of a widget
enum DisplayWidget {
  /// Hides the widget replacing its space with a spacer
  hide,

  /// Hides the widget not replacing its space
  gone,

  /// Shows the widget normally
  show,
}

/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/message_widget.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/message_widget_paint.png)
///
/// It shows a message with reactions, replies and user avatar.
///
/// Usually you don't use this widget as it's the default message widget used by [MessageListView].
///
/// The widget components render the ui based on the first ancestor of type [StreamChatTheme].
/// Modify it to change the widget appearance.
class MessageWidget extends StatefulWidget {
  /// Function called on mention tap
  final void Function(User) onMentionTap;

  /// The function called when tapping on replies
  final void Function(Message) onThreadTap;
  final void Function(Message) onReplyTap;
  final Widget Function(BuildContext, Message) editMessageInputBuilder;
  final Widget Function(BuildContext, Message) textBuilder;

  /// Function called on long press
  final void Function(BuildContext, Message) onMessageActions;

  /// The message
  final Message message;

  /// The message theme
  final MessageTheme messageTheme;

  /// If true the widget will be mirrored
  final bool reverse;

  /// The shape of the message text
  final ShapeBorder shape;

  /// The shape of an attachment
  final ShapeBorder attachmentShape;

  /// The borderside of the message text
  final BorderSide borderSide;

  /// The borderside of an attachment
  final BorderSide attachmentBorderSide;

  /// The border radius of the message text
  final BorderRadiusGeometry borderRadiusGeometry;

  /// The border radius of an attachment
  final BorderRadiusGeometry attachmentBorderRadiusGeometry;

  /// The padding of the widget
  final EdgeInsetsGeometry padding;

  /// The internal padding of the message text
  final EdgeInsetsGeometry textPadding;

  /// The internal padding of an attachment
  final EdgeInsetsGeometry attachmentPadding;

  /// It controls the display behaviour of the user avatar
  final DisplayWidget showUserAvatar;

  /// It controls the display behaviour of the sending indicator
  final DisplayWidget showSendingIndicator;

  /// If true the widget will show the reactions
  final bool showReactions;

  final bool allRead;

  /// If true the widget will show the thread reply indicator
  final bool showThreadReplyIndicator;

  /// If true the widget will show the reply indicator
  final bool showReplyIndicator;

  /// If true the widget will show the show in channel indicator
  final bool showInChannelIndicator;

  /// The function called when tapping on UserAvatar
  final void Function(User) onUserAvatarTap;

  /// The function called when tapping on a link
  final void Function(String) onLinkTap;

  /// Used in [MessageReactionsModal] and [MessageActionsModal]
  final bool showReactionPickerIndicator;

  /// If true the widget will show the resendMessage indicator
  final bool showResendMessage;

  final List<Read> readList;

  final ShowMessageCallback onShowMessage;

  /// If true show the users username next to the timestamp of the message
  final bool showUsername;
  final bool showTimestamp;
  final bool showDeleteMessage;
  final bool showEditMessage;
  final Map<String, AttachmentBuilder> attachmentBuilders;

  /// Center user avatar with bottom of the message
  final bool translateUserAvatar;

  /// Function called when quotedMessage is tapped
  final OnQuotedMessageTap onQuotedMessageTap;

  ///
  MessageWidget({
    Key key,
    @required this.message,
    @required this.messageTheme,
    this.reverse = false,
    this.translateUserAvatar = true,
    this.shape,
    this.attachmentShape,
    this.borderSide,
    this.attachmentBorderSide,
    this.borderRadiusGeometry,
    this.attachmentBorderRadiusGeometry,
    this.onMentionTap,
    this.showReactionPickerIndicator = false,
    this.showUserAvatar = DisplayWidget.show,
    this.showSendingIndicator = DisplayWidget.show,
    this.showThreadReplyIndicator = true,
    this.showInChannelIndicator = true,
    this.showReplyIndicator = true,
    this.onReplyTap,
    this.onThreadTap,
    this.showUsername = true,
    this.showTimestamp = true,
    this.showReactions = true,
    this.showDeleteMessage = true,
    this.showEditMessage = true,
    this.onUserAvatarTap,
    this.onLinkTap,
    this.onMessageActions,
    this.onShowMessage,
    this.editMessageInputBuilder,
    this.textBuilder,
    Map<String, AttachmentBuilder> customAttachmentBuilders,
    this.showResendMessage = true,
    this.readList,
    this.padding,
    this.textPadding = const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 8.0,
    ),
    this.attachmentPadding = EdgeInsets.zero,
    this.allRead = false,
    this.onQuotedMessageTap,
  })  : attachmentBuilders = {
          'image': (context, message, attachment) {
            return ImageAttachment(
              attachment: attachment,
              message: message,
              messageTheme: messageTheme,
              size: Size(
                MediaQuery.of(context).size.width * 0.8,
                MediaQuery.of(context).size.height * 0.3,
              ),
              onShowMessage: onShowMessage,
            );
          },
          'video': (context, message, attachment) {
            return VideoAttachment(
              attachment: attachment,
              messageTheme: messageTheme,
              size: Size(
                MediaQuery.of(context).size.width * 0.8,
                MediaQuery.of(context).size.height * 0.3,
              ),
              message: message,
              onShowMessage: onShowMessage,
            );
          },
          'giphy': (context, message, attachment) {
            return GiphyAttachment(
              attachment: attachment,
              messageTheme: messageTheme,
              message: message,
              size: Size(
                MediaQuery.of(context).size.width * 0.8,
                MediaQuery.of(context).size.height * 0.3,
              ),
              onShowMessage: onShowMessage,
            );
          },
          'file': (context, message, attachment) {
            return FileAttachment(
              attachment: attachment,
              size: Size(
                MediaQuery.of(context).size.width * 0.8,
                MediaQuery.of(context).size.height * 0.3,
              ),
            );
          },
        }..addAll(customAttachmentBuilders ?? {}),
        super(key: key);

  @override
  _MessageWidgetState createState() => _MessageWidgetState();
}

class _MessageWidgetState extends State<MessageWidget> {
  bool get showThreadReplyIndicator =>
      widget.showThreadReplyIndicator && widget.message.replyCount > 0;

  bool get showUsername => widget.showUsername;

  bool get showTimeStamp =>
      widget.message.createdAt != null && widget.showTimestamp;

  bool get isMessageRead => widget.readList?.isNotEmpty == true;

  bool get showInChannel =>
      widget.showInChannelIndicator && widget.message?.showInChannel == true;

  bool get hasQuotedMessage => widget.message?.quotedMessage != null;

  bool get isSendFailed => widget.message.status == MessageSendingStatus.FAILED;

  bool get isUpdateFailed =>
      widget.message.status == MessageSendingStatus.FAILED_UPDATE;

  bool get isDeleteFailed =>
      widget.message.status == MessageSendingStatus.FAILED_DELETE;

  bool get isFailedState => isSendFailed || isUpdateFailed || isDeleteFailed;

  bool get isGiphy =>
      widget.message.attachments?.any((element) => element.type == 'giphy') ==
      true;

  bool get showBottomRow =>
      showThreadReplyIndicator ||
      showUsername ||
      showTimeStamp ||
      showInChannel;

  @override
  Widget build(BuildContext context) {
    final avatarWidth = widget.messageTheme.avatarTheme.constraints.maxWidth;
    var leftPadding =
        widget.showUserAvatar != DisplayWidget.gone ? avatarWidth + 8.5 : 4.5;

    final isOnlyEmoji =
        widget.message.text.characters.every((c) => Emoji.byChar(c) != null);

    final hasFiles =
        widget.message.attachments?.any((element) => element.type == 'file') ==
            true;

    return Material(
      type: MaterialType.transparency,
      child: Portal(
        child: InkWell(
          onLongPress: widget.message.isDeleted && !isFailedState
              ? null
              : () => onLongPress(context),
          child: Padding(
            padding: widget.padding ?? EdgeInsets.all(8),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(widget.reverse ? pi : 0),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: 0.75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Stack(
                      clipBehavior: Clip.none,
                      alignment: AlignmentDirectional.bottomStart,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                if (widget.showUserAvatar ==
                                    DisplayWidget.show) ...[
                                  _buildUserAvatar(),
                                  SizedBox(width: 4),
                                ],
                                if (widget.showUserAvatar == DisplayWidget.hide)
                                  SizedBox(width: avatarWidth + 4),
                                Flexible(
                                  child: PortalEntry(
                                    portal: Container(
                                      transform:
                                          Matrix4.translationValues(-16, 2, 0),
                                      child: _buildReactionIndicator(context),
                                      constraints:
                                          BoxConstraints(maxWidth: 22 * 6.0),
                                    ),
                                    portalAnchor: Alignment(-1.0, -1.0),
                                    childAnchor: Alignment(1, -1.0),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Padding(
                                          padding: widget.showReactions
                                              ? EdgeInsets.only(
                                                  top: widget
                                                              .message
                                                              .reactionCounts
                                                              ?.isNotEmpty ==
                                                          true
                                                      ? 18
                                                      : 0,
                                                )
                                              : EdgeInsets.zero,
                                          child: (widget.message.isDeleted &&
                                                  !isFailedState)
                                              ? Transform(
                                                  alignment: Alignment.center,
                                                  transform: Matrix4.rotationY(
                                                      widget.reverse ? pi : 0),
                                                  child: DeletedMessage(
                                                    reverse: widget.reverse,
                                                    borderRadiusGeometry: widget
                                                        .borderRadiusGeometry,
                                                    borderSide:
                                                        widget.borderSide,
                                                    shape: widget.shape,
                                                    messageTheme:
                                                        widget.messageTheme,
                                                  ),
                                                )
                                              : Card(
                                                  clipBehavior: Clip.antiAlias,
                                                  elevation: 0.0,
                                                  shape: widget.shape ??
                                                      RoundedRectangleBorder(
                                                        side: isOnlyEmoji &&
                                                                !(showThreadReplyIndicator ||
                                                                    showInChannel)
                                                            ? BorderSide.none
                                                            : widget.borderSide ??
                                                                BorderSide(
                                                                  color: widget
                                                                      .messageTheme
                                                                      .messageBorderColor,
                                                                ),
                                                        borderRadius: widget
                                                                .borderRadiusGeometry ??
                                                            BorderRadius.zero,
                                                      ),
                                                  color: _getBackgroundColor(),
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        hasFiles ? 2.0 : 0.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        if (hasQuotedMessage)
                                                          _buildQuotedMessage(),
                                                        ..._parseAttachments(
                                                            context),
                                                        if (widget.message.text
                                                                .trim()
                                                                .isNotEmpty &&
                                                            !isGiphy)
                                                          _buildTextBubble(
                                                              context),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                        ),
                                        if (widget.showReactionPickerIndicator)
                                          Positioned(
                                            right: 0,
                                            top: -6,
                                            child: Transform(
                                              transform: Matrix4.rotationY(
                                                  widget.reverse ? pi : 0),
                                              child: CustomPaint(
                                                painter: ReactionBubblePainter(
                                                  widget.messageTheme
                                                      .reactionsBackgroundColor,
                                                  widget.messageTheme
                                                      .reactionsBorderColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (showBottomRow) SizedBox(height: 20.0),
                          ],
                        ),
                        if (showBottomRow) _buildBottomRow(leftPadding),
                        if (isFailedState)
                          Positioned(
                            left: widget.reverse ? -3 : null,
                            right: widget.reverse ? null : -9,
                            bottom: showBottomRow ? 20 : 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: StreamSvgIcon.error(size: 20),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuotedMessage() {
    final isMyMessage =
        widget.message.user.id == StreamChat.of(context).user.id;
    return QuotedMessageWidget(
      onTap: () {
        if (widget.onQuotedMessageTap != null) {
          widget.onQuotedMessageTap(widget.message.quotedMessageId);
        }
      },
      message: widget.message.quotedMessage,
      messageTheme: isMyMessage
          ? StreamChatTheme.of(context).otherMessageTheme
          : StreamChatTheme.of(context).ownMessageTheme,
      reverse: widget.reverse,
    );
  }

  Widget _buildBottomRow(double leftPadding) {
    final deleted = widget.message.isDeleted;
    var children = <Widget>[];
    if (deleted) {
      children.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamSvgIcon.eye(
              color:
                  StreamChatTheme.of(context).colorTheme.black.withOpacity(0.5),
              size: 16.0,
            ),
            SizedBox(width: 8.0),
            Text(
              'Only visible to you',
              style: StreamChatTheme.of(context).textTheme.footnote.copyWith(
                  color: StreamChatTheme.of(context)
                      .colorTheme
                      .black
                      .withOpacity(0.5)),
            ),
          ],
        ),
      );
    } else if (showInChannel) {
      final onThreadTap = () async {
        try {
          final channel = StreamChannel.of(context);
          final message = await channel.getMessage(widget.message.parentId);
          return widget.onThreadTap(message);
        } catch (e, stk) {
          print(e);
          print(stk);
          return null;
        }
      };
      children.add(
        InkWell(
          onTap: widget.onThreadTap != null ? onThreadTap : null,
          child: Text('Thread Reply', style: widget.messageTheme?.replies),
        ),
      );
    } else {
      final showSendingIndicator =
          widget.showSendingIndicator == DisplayWidget.show;
      final threadParticipants = widget.message.threadParticipants;
      final showThreadParticipants = threadParticipants?.isNotEmpty == true;
      final replyCount = widget.message.replyCount;
      final msg = replyCount != 0
          ? '$replyCount ${replyCount > 1 ? 'Thread Replies' : 'Thread Reply'}'
          : 'Thread Reply';

      final onThreadTap = () async {
        var message = widget.message;
        return widget.onThreadTap(message);
      };

      children.addAll([
        if (showSendingIndicator) _buildSendingIndicator(),
        if (showThreadReplyIndicator) ...[
          if (showThreadParticipants)
            SizedBox.fromSize(
              size: Size((threadParticipants.length * 8.0) + 10, 16),
              child: _buildThreadParticipantsIndicator(),
            ),
          InkWell(
            onTap: widget.onThreadTap != null ? onThreadTap : null,
            child: Text(msg, style: widget.messageTheme?.replies),
          ),
        ],
        if (showUsername)
          Text(
            widget.message.user.name,
            style: widget.messageTheme.replies.copyWith(
              color: widget.messageTheme.createdAt.color,
            ),
          ),
        if (showTimeStamp)
          Text(
            Jiffy(widget.message.createdAt.toLocal()).jm,
            style: widget.messageTheme.createdAt,
          ),
      ]);
    }
    if (widget.reverse) children = children.reversed.toList();

    return Padding(
      padding: EdgeInsets.only(left: leftPadding),
      child: Flex(
        direction: Axis.horizontal,
        clipBehavior: Clip.none,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!deleted && (showThreadReplyIndicator || showInChannel))
            Container(
              margin: EdgeInsets.only(
                bottom: widget.messageTheme.replies.fontSize / 2,
              ),
              child: CustomPaint(
                size: const Size(16, 32),
                painter: _ThreadReplyPainter(
                  context: context,
                  color: widget.messageTheme.messageBorderColor,
                ),
              ),
            ),
          ...children.map(
            (child) => Transform(
              transform: Matrix4.rotationY(widget.reverse ? pi : 0),
              alignment: Alignment.center,
              child: Container(
                height: 16,
                child: Center(
                  child: child,
                ),
              ),
            ),
          ),
        ].insertBetween(const SizedBox(width: 8.0)),
      ),
    );
  }

  Widget _buildUrlAttachment() {
    var urlAttachment = widget.message.attachments
        .firstWhere((element) => element.ogScrapeUrl != null);

    var host = Uri.parse(urlAttachment.ogScrapeUrl).host;
    var splitList = host.split('.');
    var hostName = splitList.length == 3 ? splitList[1] : splitList[0];
    var hostDisplayName = urlAttachment.authorName?.capitalize() ??
        getWebsiteName(hostName.toLowerCase()) ??
        hostName.capitalize();

    return UrlAttachment(
      urlAttachment: urlAttachment,
      hostDisplayName: hostDisplayName,
      textPadding: widget.textPadding,
    );
  }

  Widget _buildThreadParticipantsIndicator() {
    var padding = 0.0;
    return Stack(
      children: widget.message.threadParticipants.map((user) {
        padding += 10.0;
        return Positioned(
          left: padding - 10,
          bottom: 0,
          top: 0,
          child: Material(
            color: Colors.white,
            clipBehavior: Clip.antiAlias,
            shape: CircleBorder(),
            child: UserAvatar(
              user: user,
              constraints: BoxConstraints.loose(Size.fromRadius(8)),
              showOnlineStatus: false,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildReactionIndicator(
    BuildContext context,
  ) {
    final ownId = StreamChat.of(context).user.id;
    final reactionsMap = <String, Reaction>{};
    widget.message.latestReactions?.forEach((element) {
      if (!reactionsMap.containsKey(element.type) || element.user.id == ownId) {
        reactionsMap[element.type] = element;
      }
    });
    final reactionsList = reactionsMap.values.toList()
      ..sort((a, b) => a.user.id == ownId ? 1 : -1);

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: (widget.showReactions &&
              (widget.message.reactionCounts?.isNotEmpty == true) &&
              !widget.message.isDeleted)
          ? GestureDetector(
              onTap: () => _showMessageReactionsModalBottomSheet(context),
              child: ReactionBubble(
                key: ValueKey('${widget.message.id}.reactions'),
                reverse: widget.reverse,
                flipTail: widget.reverse,
                backgroundColor: widget.messageTheme.reactionsBackgroundColor,
                borderColor: widget.messageTheme.reactionsBorderColor,
                reactions: reactionsList,
              ),
            )
          : SizedBox(),
    );
  }

  void _showMessageActionModalBottomSheet(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    showDialog(
        context: context,
        barrierColor: StreamChatTheme.of(context).colorTheme.overlay,
        builder: (context) {
          return StreamChannel(
            channel: channel,
            child: MessageActionsModal(
              showUserAvatar:
                  widget.message.user.id == channel.client.state.user.id
                      ? DisplayWidget.gone
                      : DisplayWidget.show,
              messageTheme: widget.messageTheme,
              messageShape: widget.shape ?? _getDefaultShape(context),
              reverse: widget.reverse,
              showDeleteMessage: widget.showDeleteMessage,
              message: widget.message,
              editMessageInputBuilder: widget.editMessageInputBuilder,
              onReplyTap: widget.onReplyTap,
              onThreadReplyTap: widget.onThreadTap,
              showResendMessage:
                  widget.showResendMessage && (isSendFailed || isUpdateFailed),
              showCopyMessage: !isFailedState &&
                  widget.message.text?.trim()?.isNotEmpty == true,
              showEditMessage: widget.showEditMessage &&
                  !isDeleteFailed &&
                  widget.message.attachments
                          ?.any((element) => element.type == 'giphy') !=
                      true,
              showReactions: widget.showReactions,
              showReply: widget.showReplyIndicator &&
                  !isFailedState &&
                  widget.onReplyTap != null,
              showThreadReply:
                  widget.showThreadReplyIndicator && widget.onThreadTap != null,
            ),
          );
        });
  }

  void _showMessageReactionsModalBottomSheet(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    showDialog(
        context: context,
        barrierColor: StreamChatTheme.of(context).colorTheme.overlay,
        builder: (context) {
          return StreamChannel(
            channel: channel,
            child: MessageReactionsModal(
              showUserAvatar:
                  widget.message.user.id == channel.client.state.user.id
                      ? DisplayWidget.gone
                      : DisplayWidget.show,
              onUserAvatarTap: widget.onUserAvatarTap,
              messageTheme: widget.messageTheme,
              messageShape: widget.shape ?? _getDefaultShape(context),
              reverse: widget.reverse,
              message: widget.message,
              editMessageInputBuilder: widget.editMessageInputBuilder,
              onThreadTap: widget.onThreadTap,
              showReactions: widget.showReactions,
            ),
          );
        });
  }

  ShapeBorder _getDefaultShape(BuildContext context) {
    return RoundedRectangleBorder(
      side: widget.attachmentBorderSide ??
          widget.borderSide ??
          BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? StreamChatTheme.of(context).colorTheme.white.withAlpha(24)
                : StreamChatTheme.of(context).colorTheme.black.withAlpha(24),
          ),
      borderRadius: widget.attachmentBorderRadiusGeometry ??
          widget.borderRadiusGeometry ??
          BorderRadius.zero,
    );
  }

  List<Widget> _parseAttachments(BuildContext context) {
    final images = widget.message.attachments
            ?.where((element) =>
                element.type == 'image' && element.ogScrapeUrl == null)
            ?.toList() ??
        [];

    if (images.length > 1) {
      return [
        wrapAttachmentWidget(
          context,
          Material(
            color: widget.messageTheme.messageBackgroundColor,
            child: ImageGroup(
              size: Size(
                MediaQuery.of(context).size.width * 0.8,
                MediaQuery.of(context).size.height * 0.3,
              ),
              images: images,
              message: widget.message,
              onShowMessage: widget.onShowMessage,
            ),
          ),
        ),
      ];
    }

    return widget.message.attachments
            ?.where((element) => element.ogScrapeUrl == null)
            ?.map((attachment) {
          final attachmentBuilder = widget.attachmentBuilders[attachment.type];

          if (attachmentBuilder == null) {
            return SizedBox();
          }

          final attachmentWidget = attachmentBuilder(
            context,
            widget.message,
            attachment,
          );
          return wrapAttachmentWidget(
            context,
            attachmentWidget,
            attachment: attachment,
          );
        })?.toList() ??
        [];
  }

  Widget wrapAttachmentWidget(
    BuildContext context,
    Widget attachmentWidget, {
    Attachment attachment,
  }) {
    final attachmentShape =
        widget.attachmentShape ?? widget.shape ?? _getDefaultShape(context);
    return Material(
      color: _getBackgroundColor(),
      clipBehavior: Clip.antiAlias,
      shape: attachmentShape,
      child: Padding(
        padding: widget.attachmentPadding,
        child: Material(
          clipBehavior: Clip.hardEdge,
          shape: attachmentShape,
          type: MaterialType.transparency,
          child: Transform(
            transform: Matrix4.rotationY(widget.reverse ? pi : 0),
            alignment: Alignment.center,
            child: attachmentWidget,
          ),
        ),
      ),
    );
  }

  void onLongPress(BuildContext context) {
    print(
        'widget.message.attachment[0].toJson(): ${widget.message.attachments[0].imageUrl}');
    if (widget.message.isEphemeral ||
        widget.message.status == MessageSendingStatus.SENDING) {
      return;
    }

    if (widget.onMessageActions != null) {
      widget.onMessageActions(context, widget.message);
    } else {
      _showMessageActionModalBottomSheet(context);
    }
    return;
  }

  Widget _buildSendingIndicator() {
    final style = widget.messageTheme.createdAt;
    Widget child = SendingIndicator(
      message: widget.message,
      isMessageRead: isMessageRead,
      size: style.fontSize,
    );
    if (isMessageRead) {
      child = Row(
        children: [
          if (StreamChannel.of(context).channel.memberCount > 2)
            Text(
              widget.readList.length.toString(),
              style: style.copyWith(
                color: StreamChatTheme.of(context).colorTheme.accentBlue,
              ),
            ),
          SizedBox(width: 2),
          child,
        ],
      );
    }
    return child;
  }

  Widget _buildUserAvatar() => Transform(
        transform: Matrix4.rotationY(widget.reverse ? pi : 0),
        alignment: Alignment.center,
        child: Transform.translate(
          offset: Offset(
            0,
            widget.translateUserAvatar
                ? widget.messageTheme.avatarTheme.constraints.maxHeight / 2
                : 0,
          ),
          child: UserAvatar(
            user: widget.message.user,
            onTap: widget.onUserAvatarTap,
            constraints: widget.messageTheme.avatarTheme.constraints,
            showOnlineStatus: false,
          ),
        ),
      );

  Widget _buildTextBubble(BuildContext context) {
    return Transform(
      transform: Matrix4.rotationY(widget.reverse ? pi : 0),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: widget.textPadding,
            child: widget.textBuilder != null
                ? widget.textBuilder(context, widget.message)
                : MessageText(
                    onLinkTap: widget.onLinkTap,
                    message: widget.message,
                    onMentionTap: widget.onMentionTap,
                    messageTheme: isOnlyEmoji
                        ? widget.messageTheme.copyWith(
                            messageText:
                                widget.messageTheme.messageText.copyWith(
                            fontSize: 40,
                          ))
                        : widget.messageTheme,
                  ),
          ),
          if (widget.message.attachments
                      ?.any((element) => element.ogScrapeUrl != null) ==
                  true &&
              !hasQuotedMessage)
            _buildUrlAttachment(),
        ],
      ),
    );
  }

  bool get isOnlyEmoji =>
      widget.message.text.characters.isNotEmpty &&
      widget.message.text.characters.every((c) => Emoji.byChar(c) != null);

  Color _getBackgroundColor() {
    if (hasQuotedMessage) {
      return widget.messageTheme.messageBackgroundColor;
    }

    if (widget.message.attachments
            ?.any((element) => element.ogScrapeUrl != null) ==
        true) {
      return StreamChatTheme.of(context).colorTheme.blueAlice;
    }

    if (isOnlyEmoji) {
      return Colors.transparent;
    }

    if (isGiphy) {
      return Colors.transparent;
    }

    return widget.messageTheme.messageBackgroundColor;
  }

  void retryMessage(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    if (widget.message.status == MessageSendingStatus.FAILED) {
      channel.sendMessage(widget.message);
      return;
    }
    if (widget.message.status == MessageSendingStatus.FAILED_UPDATE) {
      StreamChat.of(context).client.updateMessage(
            widget.message,
            channel.cid,
          );
      return;
    }

    if (widget.message.status == MessageSendingStatus.FAILED_DELETE) {
      StreamChat.of(context).client.deleteMessage(
            widget.message,
            channel.cid,
          );
      return;
    }
  }
}

class _ThreadReplyPainter extends CustomPainter {
  final Color color;
  final BuildContext context;

  const _ThreadReplyPainter({this.context, @required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color ?? StreamChatTheme.of(context).colorTheme.greyGainsboro
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(0, size.height * 0.38, 0, size.height * 0.50)
      ..quadraticBezierTo(
        0,
        size.height,
        size.width,
        size.height,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
