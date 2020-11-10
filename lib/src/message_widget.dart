import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emojis/emoji.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter/src/message_actions_modal.dart';
import 'package:stream_chat_flutter/src/message_reactions_modal.dart';
import 'package:stream_chat_flutter/src/reaction_bubble.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'image_group.dart';
import 'message_text.dart';
import 'utils.dart';

typedef AttachmentBuilder = Widget Function(BuildContext, Message, Attachment);

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

  /// If true the widget will show the reply indicator
  final bool showReplyIndicator;

  /// The function called when tapping on UserAvatar
  final void Function(User) onUserAvatarTap;

  /// The function called when tapping on a link
  final void Function(String) onLinkTap;

  /// Used in [MessageReactionsModal] and [MessageActionsModal]
  final bool showReactionPickerIndicator;

  final List<Read> readList;

  /// If true show the users username next to the timestamp of the message
  final bool showUsername;
  final bool showTimestamp;
  final bool showDeleteMessage;
  final bool showEditMessage;
  final Map<String, AttachmentBuilder> attachmentBuilders;

  /// Center user avatar with bottom of the message
  final bool translateUserAvatar;

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
    this.showReplyIndicator = true,
    this.onThreadTap,
    this.showUsername = true,
    this.showTimestamp = true,
    this.showReactions = true,
    this.showDeleteMessage = true,
    this.showEditMessage = true,
    this.onUserAvatarTap,
    this.onLinkTap,
    this.onMessageActions,
    this.editMessageInputBuilder,
    this.textBuilder,
    Map<String, AttachmentBuilder> customAttachmentBuilders,
    this.readList,
    this.padding,
    this.textPadding = const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 8.0,
    ),
    this.attachmentPadding = EdgeInsets.zero,
    this.allRead = false,
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
            );
          },
          'giphy': (context, message, attachment) {
            return GiphyAttachment(
              attachment: attachment,
              messageTheme: messageTheme.copyWith(
                messageBackgroundColor: Colors.white,
              ),
              message: message,
              size: Size(
                MediaQuery.of(context).size.width * 0.8,
                MediaQuery.of(context).size.height * 0.3,
              ),
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
  @override
  Widget build(BuildContext context) {
    var leftPadding = widget.showUserAvatar != DisplayWidget.gone
        ? widget.messageTheme.avatarTheme.constraints.maxWidth + 16.0
        : 6.0;

    final isGiphy =
        widget.message.attachments?.any((element) => element.type == 'giphy') ==
            true;

    return Portal(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (widget.showUserAvatar == DisplayWidget.show)
                          _buildUserAvatar(),
                        SizedBox(
                          width: 6,
                        ),
                        if (widget.showUserAvatar == DisplayWidget.hide)
                          SizedBox(
                            width: widget.messageTheme.avatarTheme.constraints
                                    .maxWidth +
                                8,
                          ),
                        Flexible(
                          child: PortalEntry(
                            portal: Container(
                              transform: Matrix4.translationValues(-16, 2, 0),
                              child: _buildReactionIndicator(context),
                              constraints: BoxConstraints(maxWidth: 22 * 6.0),
                            ),
                            portalAnchor: Alignment(-1.0, -1.0),
                            childAnchor: Alignment(1, -1.0),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Padding(
                                  padding: widget.showReactions
                                      ? EdgeInsets.only(
                                          top: widget.message.reactionCounts
                                                      ?.isNotEmpty ==
                                                  true
                                              ? 18
                                              : 0,
                                        )
                                      : EdgeInsets.zero,
                                  child: (widget.message.isDeleted &&
                                          widget.message.status !=
                                              MessageSendingStatus
                                                  .FAILED_DELETE)
                                      ? Transform(
                                          alignment: Alignment.center,
                                          transform: Matrix4.rotationY(
                                              widget.reverse ? pi : 0),
                                          child: DeletedMessage(
                                            messageTheme: widget.messageTheme,
                                          ),
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            ..._parseAttachments(context),
                                            if (widget.message.text
                                                    .trim()
                                                    .isNotEmpty &&
                                                !isGiphy)
                                              _buildTextBubble(context),
                                          ],
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
                    if (widget.showReplyIndicator &&
                        widget.message.replyCount > 0)
                      _buildReplyIndicator(leftPadding),
                  ],
                ),
                if ((widget.message.createdAt != null &&
                        widget.showTimestamp) ||
                    widget.showUsername ||
                    widget.readList?.isNotEmpty == true)
                  _buildBottomRow(leftPadding),
              ],
            ),
          ),
        ),
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
        _getWebsiteName(hostName.toLowerCase()) ??
        hostName.capitalize();

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (urlAttachment.imageUrl != null)
              SizedBox(
                height: 16.0,
              ),
            if (urlAttachment.imageUrl != null)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: Stack(
                  clipBehavior: Clip.antiAlias,
                  children: [
                    Center(
                      child: CachedNetworkImage(
                        imageUrl: urlAttachment.imageUrl,
                      ),
                    ),
                    Positioned(
                      left: 0.0,
                      bottom: 0.0,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                            left: 8.0,
                            right: 8.0,
                          ),
                          child: Text(
                            hostDisplayName,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF006CFF),
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16.0),
                          ),
                          color: Color(0xFFE9F2FF),
                        ),
                      ),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
              ),
            Padding(
              padding: widget.textPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (urlAttachment.title != null)
                    Text(
                      urlAttachment.title,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12.0,
                      ),
                    ),
                  if (urlAttachment.text != null)
                    Text(
                      urlAttachment.text,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => launchURL(
                context,
                urlAttachment.ogScrapeUrl,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Padding _buildBottomRow(double leftPadding) {
    return Padding(
      padding: EdgeInsets.only(
        left: leftPadding,
        top: 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(widget.reverse ? pi : 0),
            child: RichText(
              text: TextSpan(
                style: widget.messageTheme.createdAt,
                children: <TextSpan>[
                  if (widget.showUsername)
                    TextSpan(
                      text: widget.message.user.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: widget.messageTheme.createdAt.color
                              .withOpacity(1)),
                    ),
                  if (widget.message.createdAt != null && widget.showTimestamp)
                    TextSpan(
                      text: Jiffy(widget.message.createdAt.toLocal())
                          .format('  HH:mm'),
                    ),
                ],
              ),
            ),
          ),
          if (widget.showSendingIndicator == DisplayWidget.show)
            _buildSendingIndicator(),
          if (widget.readList?.isNotEmpty == true)
            SizedBox.fromSize(
              size: Size((widget.readList.length * 10.0) + 10, 17),
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(widget.reverse ? pi : 0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: _buildReadIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReadIndicator() {
    var padding = 0.0;
    return Stack(
      children: widget.readList.map((e) {
        padding += 10.0;
        return Positioned(
          left: padding - 10,
          bottom: 0,
          top: 0,
          child: Material(
            color: Colors.white,
            shape: CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: UserAvatar(
                user: e.user,
                constraints: BoxConstraints.loose(Size.fromRadius(16)),
                showOnlineStatus: false,
              ),
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
              onThreadTap: widget.onThreadTap,
              showEditMessage: widget.showEditMessage,
              showReactions: widget.showReactions,
              showReply:
                  widget.showReplyIndicator && widget.onThreadTap != null,
            ),
          );
        });
  }

  void _showMessageReactionsModalBottomSheet(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    showDialog(
        context: context,
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
                ? Colors.white.withAlpha(24)
                : Colors.black.withAlpha(24),
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
          return wrapAttachmentWidget(context, attachmentWidget,
              attachment: attachment);
        })?.toList() ??
        [];
  }

  Padding wrapAttachmentWidget(BuildContext context, Widget attachmentWidget,
      {Attachment attachment}) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 4,
      ),
      child: GestureDetector(
        onTap: () => retryMessage(context),
        onLongPress: () => onLongPress(context),
        child: Material(
          color: attachment?.type == 'giphy'
              ? Colors.white
              : _getBackgroundColor(),
          clipBehavior: Clip.hardEdge,
          shape: widget.attachmentShape ??
              widget.shape ??
              _getDefaultShape(context),
          child: Padding(
            padding: widget.attachmentPadding,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Transform(
                transform: Matrix4.rotationY(widget.reverse ? pi : 0),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    getFailedMessageWidget(
                      context,
                      padding: const EdgeInsets.all(8.0),
                    ),
                    attachmentWidget,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onLongPress(BuildContext context) {
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

  Widget _buildReplyIndicator(double leftPadding) {
    return Padding(
      padding: EdgeInsets.only(
        left: leftPadding,
      ),
      child: Transform(
        transform: Matrix4.rotationY(widget.reverse ? pi : 0),
        alignment: Alignment.center,
        child: ReplyIndicator(
          message: widget.message,
          reversed: widget.reverse,
          messageTheme: widget.messageTheme,
          onTap: widget.onThreadTap != null
              ? () {
                  widget.onThreadTap(widget.message);
                }
              : null,
        ),
      ),
    );
  }

  Widget _buildSendingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Transform(
        transform: Matrix4.rotationY(widget.reverse ? pi : 0),
        alignment: Alignment.center,
        child: SendingIndicator(
          message: widget.message,
          allRead: widget.allRead,
        ),
      ),
    );
  }

  Widget _buildUserAvatar() => Transform(
        transform: Matrix4.rotationY(widget.reverse ? pi : 0),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
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
        ),
      );

  Widget getFailedMessageWidget(
    BuildContext context, {
    EdgeInsetsGeometry padding,
  }) {
    Widget failedWidget;
    if (widget.message.status == MessageSendingStatus.FAILED) {
      failedWidget = Text(
        'MESSAGE FAILED · CLICK TO TRY AGAIN',
        style: widget.messageTheme.messageText.copyWith(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(.5)
              : Colors.black.withOpacity(.5),
          fontSize: 11,
        ),
      );
    }
    if (widget.message.status == MessageSendingStatus.FAILED_UPDATE) {
      failedWidget = Text(
        'MESSAGE UPDATE FAILED · CLICK TO TRY AGAIN',
        style: widget.messageTheme.messageText.copyWith(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(.5)
              : Colors.black.withOpacity(.5),
          fontSize: 11,
        ),
      );
    }
    if (widget.message.status == MessageSendingStatus.FAILED_DELETE) {
      failedWidget = Text(
        'MESSAGE DELETE FAILED · CLICK TO TRY AGAIN',
        style: widget.messageTheme.messageText.copyWith(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withOpacity(.5)
              : Colors.black.withOpacity(.5),
          fontSize: 11,
        ),
      );
    }

    if (failedWidget != null) {
      return Padding(
        padding: padding ?? EdgeInsets.zero,
        child: failedWidget,
      );
    }

    return SizedBox();
  }

  Widget _wrapTextInBubble({
    BuildContext context,
    Widget child,
  }) {
    return Material(
      shape: widget.shape ??
          RoundedRectangleBorder(
            side: widget.borderSide ??
                BorderSide(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white.withAlpha(24)
                      : Colors.black.withAlpha(24),
                ),
            borderRadius: widget.borderRadiusGeometry ?? BorderRadius.zero,
          ),
      color: _getBackgroundColor(),
      child: child,
    );
  }

  Widget _buildTextBubble(BuildContext context) {
    final isOnlyEmoji =
        widget.message.text.characters.every((c) => Emoji.byChar(c) != null);

    Widget child = Transform(
      transform: Matrix4.rotationY(widget.reverse ? pi : 0),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: widget.textPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                getFailedMessageWidget(context),
                widget.textBuilder != null
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
              ],
            ),
          ),
          if (widget.message.attachments
              .any((element) => element.ogScrapeUrl != null))
            _buildUrlAttachment(),
        ],
      ),
    );

    if (!isOnlyEmoji) {
      child = _wrapTextInBubble(
        context: context,
        child: child,
      );
    }
    return GestureDetector(
      onTap: () => retryMessage(context),
      onLongPress: () => onLongPress(context),
      child: child,
    );
  }

  Color _getBackgroundColor() {
    if ((widget.message.status == MessageSendingStatus.FAILED ||
        widget.message.status == MessageSendingStatus.FAILED_UPDATE ||
        widget.message.status == MessageSendingStatus.FAILED_DELETE)) {
      return Color(0xffd0021B).withOpacity(.1);
    }

    if (widget.message.attachments
        .any((element) => element.ogScrapeUrl != null)) {
      return Color(0xFFE9F2FF);
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

  String _getWebsiteName(String hostName) {
    switch (hostName) {
      case 'reddit':
        return 'Reddit';
      case 'youtube':
        return 'Youtube';
      case 'wikipedia':
        return 'Wikipedia';
      case 'twitter':
        return 'Twitter';
      case 'facebook':
        return 'Facebook';
      case 'amazon':
        return 'Amazon';
      case 'yelp':
        return 'Yelp';
      case 'imdb':
        return 'IMDB';
      case 'pinterest':
        return 'Pinterest';
      case 'tripadvisor':
        return 'TripAdvisor';
      case 'instagram':
        return 'Instagram';
      case 'walmart':
        return 'Walmart';
      case 'craigslist':
        return 'Craigslist';
      case 'ebay':
        return 'eBay';
      case 'linkedin':
        return 'LinkedIn';
      case 'google':
        return 'Google';
      case 'apple':
        return 'Apple';
      default:
        return null;
    }
  }
}
