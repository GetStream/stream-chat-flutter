import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stream_chat_flutter/src/info_tile.dart';
import 'package:stream_chat_flutter/src/message_widget.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/system_message.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../stream_chat_flutter.dart';
import 'connection_status_builder.dart';
import 'date_divider.dart';
import 'extension.dart';
import 'swipeable.dart';

typedef MessageBuilder = Widget Function(
  BuildContext,
  MessageDetails,
  List<Message>,
);
typedef ParentMessageBuilder = Widget Function(
  BuildContext,
  Message,
);
typedef ThreadBuilder = Widget Function(BuildContext context, Message parent);
typedef ThreadTapCallback = void Function(Message, Widget);

typedef OnMessageSwiped = void Function(Message);
typedef ReplyTapCallback = void Function(Message);

class MessageDetails {
  /// True if the message belongs to the current user
  bool isMyMessage;

  /// True if the user message is the same of the previous message
  bool isLastUser;

  /// True if the user message is the same of the next message
  bool isNextUser;

  /// The message
  Message message;

  /// The index of the message
  int index;

  MessageDetails(
    BuildContext context,
    this.message,
    List<Message> messages,
    this.index,
  ) {
    isMyMessage = message.user.id == StreamChat.of(context).user.id;
    isLastUser = index + 1 < messages.length &&
        message.user.id == messages[index + 1]?.user?.id;
    isNextUser =
        index - 1 >= 0 && message.user.id == messages[index - 1]?.user?.id;
  }
}

/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/message_listview.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/message_listview_paint.png)
///
/// It shows the list of messages of the current channel.
///
/// ```dart
/// class ChannelPage extends StatelessWidget {
///   const ChannelPage({
///     Key key,
///   }) : super(key: key);
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: ChannelHeader(),
///       body: Column(
///         children: <Widget>[
///           Expanded(
///             child: MessageListView(
///               threadBuilder: (_, parentMessage) {
///                 return ThreadPage(
///                   parent: parentMessage,
///                 );
///               },
///             ),
///           ),
///           MessageInput(),
///         ],
///       ),
///     );
///   }
/// }
/// ```
///
///
/// Make sure to have a [StreamChannel] ancestor in order to provide the information about the channels.
/// The widget uses a [ListView.custom] to render the list of channels.
///
/// The widget components render the ui based on the first ancestor of type [StreamChatTheme].
/// Modify it to change the widget appearance.
class MessageListView extends StatefulWidget {
  /// Instantiate a new MessageListView
  MessageListView({
    Key key,
    this.showScrollToBottom = true,
    this.messageBuilder,
    this.parentMessageBuilder,
    this.parentMessage,
    this.threadBuilder,
    this.onThreadTap,
    this.onReplyTap,
    this.dateDividerBuilder,
    this.scrollPhysics = const ClampingScrollPhysics(),
    this.initialScrollIndex,
    this.initialAlignment,
    this.scrollController,
    this.itemPositionListener,
    this.onMessageSwiped,
    this.highlightInitialMessage = false,
    this.messageHighlightColor,
    this.onShowMessage,
    this.showConnectionStateTile = false,
  }) : super(key: key);

  /// Function used to build a custom message widget
  final MessageBuilder messageBuilder;

  /// Function used to build a custom parent message widget
  final ParentMessageBuilder parentMessageBuilder;

  /// Function used to build a custom thread widget
  final ThreadBuilder threadBuilder;

  /// Function called when tapping on a thread
  /// By default it calls [Navigator.push] using the widget built using [threadBuilder]
  final ThreadTapCallback onThreadTap;

  /// If true will show a scroll to bottom message when there are new messages and the scroll offset is not zero
  final bool showScrollToBottom;

  /// Parent message in case of a thread
  final Message parentMessage;

  /// Builder used to render date dividers
  final Widget Function(DateTime) dateDividerBuilder;

  /// Index of an item to initially align within the viewport.
  final int initialScrollIndex;

  /// Determines where the leading edge of the item at [initialScrollIndex]
  /// should be placed.
  final double initialAlignment;

  /// Controller for jumping or scrolling to an item.
  final ItemScrollController scrollController;

  /// Provides a listenable iterable of [itemPositions] of items that are on
  /// screen and their locations.
  final ItemPositionsListener itemPositionListener;

  /// The ScrollPhysics used by the ListView
  final ScrollPhysics scrollPhysics;

  /// Called when message item gets swiped
  final OnMessageSwiped onMessageSwiped;

  ///
  final ReplyTapCallback onReplyTap;

  /// If true the list will highlight the initialMessage if there is any.
  ///
  /// Also See [StreamChannel]
  final bool highlightInitialMessage;

  /// Color used while highlighting initial message
  final Color messageHighlightColor;

  final ShowMessageCallback onShowMessage;

  final bool showConnectionStateTile;

  @override
  _MessageListViewState createState() => _MessageListViewState();
}

class _MessageListViewState extends State<MessageListView> {
  ItemScrollController _scrollController;
  Function _onThreadTap;
  bool _showScrollToBottom = false;
  ItemPositionsListener _itemPositionListener;
  int _messageListLength;
  StreamChannelState streamChannel;

  int get _initialIndex {
    if (widget.initialScrollIndex != null) return widget.initialScrollIndex;
    if (streamChannel.initialMessageId != null) {
      final messages = streamChannel.channel.state.messages;
      final totalMessages = messages.length;
      final messageIndex = messages.indexWhere((e) {
        return e.id == streamChannel.initialMessageId;
      });
      final index = totalMessages - messageIndex;
      if (index != 0) return index - 1;
      return index;
    }
    return 0;
  }

  double get _initialAlignment {
    if (widget.initialAlignment != null) return widget.initialAlignment;
    return 0;
  }

  bool _isInitialMessage(String id) {
    return streamChannel.initialMessageId == id;
  }

  bool get _upToDate => streamChannel.channel.state.isUpToDate;

  bool get _isThreadConversation => widget.parentMessage != null;

  bool _topPaginationActive = false;
  bool _bottomPaginationActive = false;

  int initialIndex;
  double initialAlignment;

  List<Message> messages = <Message>[];

  bool initialMessageHighlightComplete = false;

  bool _inBetweenList = false;

  final MessageListController _messageListController = MessageListController();

  final Map<String, VideoPackage> videoPackages = {};

  @override
  Widget build(BuildContext context) {
    return MessageListCore(
      loadingBuilder: (context) {
        return Center(
          child: const CircularProgressIndicator(),
        );
      },
      emptyBuilder: (context) {
        return Center(
          child: Text(
            'No chats here yet...',
            style: StreamChatTheme.of(context).textTheme.footnote.copyWith(
                color: StreamChatTheme.of(context)
                    .colorTheme
                    .black
                    .withOpacity(.5)),
          ),
        );
      },
      messageListBuilder: (context, list) {
        return _buildListView(list);
      },
      messageListController: _messageListController,
      parentMessage: widget.parentMessage,
      showScrollToBottom: widget.showScrollToBottom,
      errorWidgetBuilder: (BuildContext context, Object error) {
        return Center(
          child: Text(
            'Something went wrong',
            style: StreamChatTheme.of(context).textTheme.footnote.copyWith(
                color: StreamChatTheme.of(context)
                    .colorTheme
                    .black
                    .withOpacity(.5)),
          ),
        );
      },
    );
  }

  Widget _buildListView(List<Message> data) {
    messages = data;
    final newMessagesListLength = messages.length;

    if (_messageListLength != null) {
      if (_bottomPaginationActive || (_inBetweenList && _upToDate)) {
        if (_itemPositionListener.itemPositions.value?.isNotEmpty == true) {
          final first = _itemPositionListener.itemPositions.value.first;
          final diff = newMessagesListLength - _messageListLength;
          if (diff > 0) {
            initialIndex = first.index + diff;
            initialAlignment = first.itemLeadingEdge;
          }
        }
      } else if (!_topPaginationActive && _upToDate) {
        // Reset the index in-case we send any new message
        initialIndex = 0;
        initialAlignment = 0;
      }
    }

    _messageListLength = newMessagesListLength;

    return Stack(
      alignment: Alignment.center,
      children: [
        ConnectionStatusBuilder(
          statusBuilder: (context, status) {
            var statusString = '';
            var showStatus = true;
            switch (status) {
              case ConnectionStatus.connected:
                statusString = 'Connected';
                showStatus = false;
                break;
              case ConnectionStatus.connecting:
                statusString = 'Reconnecting...';
                break;
              case ConnectionStatus.disconnected:
                statusString = 'Disconnected';
                break;
            }

            return InfoTile(
              showMessage: widget.showConnectionStateTile ? showStatus : false,
              tileAnchor: Alignment.topCenter,
              childAnchor: Alignment.topCenter,
              message: statusString,
              child: LazyLoadScrollView(
                onStartOfPage: () async {
                  _inBetweenList = false;
                  if (!_upToDate) {
                    _topPaginationActive = false;
                    _bottomPaginationActive = true;
                    return _paginateData(
                      streamChannel,
                      QueryDirection.bottom,
                    );
                  }
                },
                onEndOfPage: () async {
                  _inBetweenList = false;
                  _topPaginationActive = true;
                  _bottomPaginationActive = false;
                  return _paginateData(
                    streamChannel,
                    QueryDirection.top,
                  );
                },
                onInBetweenOfPage: () {
                  _inBetweenList = true;
                },
                child: ScrollablePositionedList.separated(
                  key: ValueKey(initialIndex + initialAlignment),
                  itemPositionsListener: _itemPositionListener,
                  addAutomaticKeepAlives: true,
                  initialScrollIndex: initialIndex ?? 0,
                  initialAlignment: initialAlignment ?? 0,
                  physics: widget.scrollPhysics,
                  itemScrollController: _scrollController,
                  reverse: true,
                  itemCount:
                      messages.length + 2 + (_isThreadConversation ? 1 : 0),
                  separatorBuilder: (context, i) {
                    if (i == messages.length) return Offstage();
                    if (i == 0) return SizedBox(height: 30);
                    if (i == messages.length + 1) {
                      final replyCount = widget.parentMessage.replyCount;
                      return Container(
                        decoration: BoxDecoration(
                          gradient:
                              StreamChatTheme.of(context).colorTheme.bgGradient,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '$replyCount ${replyCount == 1 ? 'Reply' : 'Replies'}',
                            textAlign: TextAlign.center,
                            style: StreamChatTheme.of(context)
                                .channelTheme
                                .channelHeaderTheme
                                .lastMessageAt,
                          ),
                        ),
                      );
                    }

                    final message = messages[i];
                    final nextMessage = messages[i - 1];
                    if (!Jiffy(message.createdAt.toLocal()).isSame(
                      nextMessage.createdAt.toLocal(),
                      Units.DAY,
                    )) {
                      final divider = widget.dateDividerBuilder != null
                          ? widget.dateDividerBuilder(
                              nextMessage.createdAt.toLocal(),
                            )
                          : DateDivider(
                              dateTime: nextMessage.createdAt.toLocal(),
                            );
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: divider,
                      );
                    }
                    final timeDiff =
                        Jiffy(nextMessage.createdAt.toLocal()).diff(
                      message.createdAt.toLocal(),
                      Units.MINUTE,
                    );

                    final isNextUserSame =
                        message.user.id == nextMessage.user?.id;
                    final isThread = message.replyCount > 0;
                    final isDeleted = message.isDeleted;
                    if (timeDiff >= 1 ||
                        !isNextUserSame ||
                        isThread ||
                        isDeleted) {
                      return SizedBox(height: 8);
                    }
                    return SizedBox(height: 2);
                  },
                  itemBuilder: (context, i) {
                    if (i == messages.length + 2) {
                      if (widget.parentMessageBuilder != null) {
                        return widget.parentMessageBuilder(
                          context,
                          widget.parentMessage,
                        );
                      } else {
                        return buildParentMessage(widget.parentMessage);
                      }
                    }
                    if (i == messages.length + 1) {
                      return _buildLoadingIndicator(
                        streamChannel,
                        QueryDirection.top,
                      );
                    }
                    if (i == 0) {
                      return _buildLoadingIndicator(
                        streamChannel,
                        QueryDirection.bottom,
                      );
                    }
                    final message = messages[i - 1];

                    Widget messageWidget;

                    if (i == 1) {
                      messageWidget = _buildBottomMessage(
                        context,
                        message,
                        messages,
                        streamChannel,
                      );
                    } else if (i == messages.length - 1) {
                      messageWidget = _buildTopMessage(
                        context,
                        message,
                        messages,
                        streamChannel,
                      );
                    } else {
                      if (widget.messageBuilder != null) {
                        messageWidget = Builder(
                          key: ValueKey<String>('MESSAGE-${message.id}'),
                          builder: (context) => widget.messageBuilder(
                              context,
                              MessageDetails(
                                context,
                                message,
                                messages,
                                i,
                              ),
                              messages),
                        );
                      } else {
                        messageWidget = buildMessage(message, messages, i);
                      }
                    }
                    return messageWidget;
                  },
                ),
              ),
            );
          },
        ),
        if (widget.showScrollToBottom) _buildScrollToBottom(),
        Positioned(
          top: 20.0,
          child: ValueListenableBuilder<Iterable<ItemPosition>>(
            valueListenable: _itemPositionListener.itemPositions,
            builder: (context, values, _) {
              final items = _itemPositionListener.itemPositions?.value;
              if (items.isEmpty || messages.isEmpty) {
                return SizedBox();
              }

              var index = _getTopElement(values).index;

              if (index > messages.length) {
                return SizedBox();
              }

              if (index == messages.length) {
                index = max(index - 1, 0);
              }

              return widget.dateDividerBuilder != null
                  ? widget.dateDividerBuilder(
                      messages[index].createdAt.toLocal(),
                    )
                  : DateDivider(
                      dateTime: messages[index].createdAt.toLocal(),
                    );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _paginateData(
      StreamChannelState channel, QueryDirection direction) {
    return _messageListController.paginateData(direction: direction);
  }

  ItemPosition _getTopElement(Iterable<ItemPosition> values) {
    return values
        .where((ItemPosition position) => position.itemLeadingEdge < 0.9)
        .reduce((ItemPosition max, ItemPosition position) =>
            position.itemLeadingEdge > max.itemLeadingEdge ? position : max);
  }

  Widget _buildScrollToBottom() {
    return StreamBuilder<Tuple2<bool, int>>(
      stream: Rx.combineLatest2(
        streamChannel.channel.state.isUpToDateStream,
        streamChannel.channel.state.unreadCountStream,
        (bool isUpToDate, int unreadCount) => Tuple2(isUpToDate, unreadCount),
      ),
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          return Offstage();
        } else if (!snapshot.hasData) {
          return Offstage();
        }
        final isUpToDate = snapshot.data.item1;
        final showScrollToBottom = !isUpToDate || _showScrollToBottom;
        if (!showScrollToBottom) {
          return Offstage();
        }
        final unreadCount = snapshot.data.item2;
        final showUnreadCount = unreadCount > 0 &&
            streamChannel.channel.state.members.any(
                (e) => e.userId == streamChannel.channel.client.state.user.id);
        return Positioned(
          bottom: 8,
          right: 8,
          width: 40,
          height: 40,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              FloatingActionButton(
                backgroundColor: StreamChatTheme.of(context).colorTheme.white,
                child: StreamSvgIcon.down(
                  color: StreamChatTheme.of(context).colorTheme.black,
                ),
                onPressed: () {
                  if (unreadCount > 0) {
                    streamChannel.channel.markRead();
                  }
                  if (!_upToDate) {
                    _bottomPaginationActive = false;
                    _topPaginationActive = false;
                    streamChannel.reloadChannel();
                  } else {
                    setState(() => _showScrollToBottom = false);
                    _scrollController.scrollTo(
                      index: 0,
                      duration: Duration(seconds: 1),
                      curve: Curves.easeInOut,
                    );
                  }
                },
              ),
              if (showUnreadCount)
                Positioned(
                  width: 20,
                  height: 20,
                  left: 10,
                  top: -10,
                  child: CircleAvatar(
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        '$unreadCount',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator(
    StreamChannelState streamChannel,
    QueryDirection direction,
  ) {
    final stream = direction == QueryDirection.top
        ? streamChannel.queryTopMessages
        : streamChannel.queryBottomMessages;
    return StreamBuilder<bool>(
      key: Key('LOADING-INDICATOR'),
      stream: stream,
      initialData: false,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container(
            color: StreamChatTheme.of(context)
                .colorTheme
                .accentRed
                .withOpacity(.2),
            child: Center(
              child: Text('Error loading messages'),
            ),
          );
        }
        if (!snapshot.data) {
          if (!_isThreadConversation && direction == QueryDirection.top) {
            return Container(
              height: 52,
              width: double.infinity,
            );
          }
          return Offstage();
        }
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: const CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget _buildTopMessage(
    BuildContext context,
    Message message,
    List<Message> messages,
    StreamChannelState streamChannel,
  ) {
    Widget messageWidget;
    if (widget.messageBuilder != null) {
      messageWidget = Builder(
        key: ValueKey<String>('TOP-MESSAGE'),
        builder: (_) => widget.messageBuilder(
          context,
          MessageDetails(
            context,
            message,
            messages,
            messages.length - 1,
          ),
          messages,
        ),
      );
    } else {
      messageWidget = buildMessage(message, messages, messages.length - 1);
    }
    return messageWidget;
  }

  Widget _buildBottomMessage(
    BuildContext context,
    Message message,
    List<Message> messages,
    StreamChannelState streamChannel,
  ) {
    Widget messageWidget;
    if (widget.messageBuilder != null) {
      messageWidget = Builder(
        key: ValueKey<String>('BOTTOM-MESSAGE'),
        builder: (_) => widget.messageBuilder(
          context,
          MessageDetails(
            context,
            message,
            messages,
            0,
          ),
          messages,
        ),
      );
    } else {
      messageWidget = buildMessage(message, messages, 0);
    }

    return VisibilityDetector(
      key: ValueKey<String>('BOTTOM-MESSAGE'),
      onVisibilityChanged: (visibility) {
        final isVisible = visibility.visibleBounds != Rect.zero;
        if (isVisible) {
          final channel = streamChannel.channel;
          if (_upToDate &&
              channel.config?.readEvents == true &&
              channel.state.unreadCount > 0) {
            streamChannel.channel.markRead();
          }
        }
        if (mounted) {
          setState(() => _showScrollToBottom = !isVisible);
        }
      },
      child: messageWidget,
    );
  }

  Widget buildParentMessage(
    Message message,
  ) {
    final isMyMessage = message.user.id == StreamChat.of(context).user.id;
    final isOnlyEmoji = message.text.isOnlyEmoji;

    return MessageWidget(
      showThreadReplyIndicator: false,
      showInChannelIndicator: false,
      showReplyMessage: false,
      showResendMessage: false,
      showThreadReplyMessage: false,
      showCopyMessage: false,
      showDeleteMessage: false,
      showEditMessage: false,
      message: message,
      reverse: isMyMessage,
      showUsername: !isMyMessage,
      padding: const EdgeInsets.all(8.0),
      showSendingIndicator: false,
      onThreadTap: _onThreadTap,
      borderRadiusGeometry: BorderRadius.only(
        topLeft: Radius.circular(16),
        bottomLeft: Radius.circular(2),
        topRight: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      textPadding: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: isOnlyEmoji ? 0 : 16.0,
      ),
      borderSide: isMyMessage || isOnlyEmoji ? BorderSide.none : null,
      showUserAvatar: isMyMessage ? DisplayWidget.gone : DisplayWidget.show,
      messageTheme: isMyMessage
          ? StreamChatTheme.of(context).ownMessageTheme
          : StreamChatTheme.of(context).otherMessageTheme,
      onShowMessage: widget.onShowMessage,
      onReturnAction: (action) {
        switch (action) {
          case ReturnActionType.none:
            break;
          case ReturnActionType.reply:
            FocusScope.of(context).unfocus();
            widget.onMessageSwiped(message);
            break;
        }
      },
      videoPackages: videoPackages,
    );
  }

  Widget buildMessage(
    Message message,
    List<Message> messages,
    int index,
  ) {
    if (message.type == 'system' && message.text?.isNotEmpty == true) {
      return SystemMessage(
        key: ValueKey<String>('MESSAGE-${message.id}'),
        message: message,
      );
    }

    final userId = StreamChat.of(context).user.id;
    final isMyMessage = message.user.id == userId;
    final nextMessage = index - 2 >= 0 ? messages[index - 2] : null;
    final isNextUserSame =
        nextMessage != null && message.user.id == nextMessage.user.id;

    num timeDiff = 0;
    if (nextMessage != null) {
      timeDiff = Jiffy(nextMessage.createdAt.toLocal()).diff(
        message.createdAt.toLocal(),
        Units.MINUTE,
      );
    }

    final channel = streamChannel.channel;
    final readList = channel.state?.read?.where((read) {
          if (read.user.id == userId) return false;
          return (read.lastRead.isAfter(message.createdAt) ||
              read.lastRead.isAtSameMomentAs(message.createdAt));
        })?.toList() ??
        [];

    final allRead = readList.length >= (channel.memberCount ?? 0) - 1;
    final hasFileAttachment =
        message.attachments?.any((it) => it.type == 'file') == true;

    final isThreadMessage =
        message?.parentId != null && message?.showInChannel == true;

    final hasReplies = message.replyCount > 0;

    final attachmentBorderRadius = hasFileAttachment ? 12.0 : 14.0;

    final showTimeStamp = message.createdAt != null &&
        (!isThreadMessage || _isThreadConversation) &&
        !hasReplies &&
        (timeDiff >= 1 || !isNextUserSame);

    final showUsername = !isMyMessage &&
        (!isThreadMessage || _isThreadConversation) &&
        !hasReplies &&
        (timeDiff >= 1 || !isNextUserSame);

    final showUserAvatar = isMyMessage
        ? DisplayWidget.gone
        : (timeDiff >= 1 || !isNextUserSame)
            ? DisplayWidget.show
            : DisplayWidget.hide;

    final showSendingIndicator =
        isMyMessage && (index == 0 || timeDiff >= 1 || !isNextUserSame);

    final showInChannelIndicator = !_isThreadConversation && isThreadMessage;
    final showThreadReplyIndicator = !_isThreadConversation && hasReplies;
    final isOnlyEmoji = message.text.isOnlyEmoji;

    final hasUrlAttachment =
        message.attachments?.any((it) => it.ogScrapeUrl != null) == true;

    final borderSide =
        isOnlyEmoji || hasUrlAttachment || (isMyMessage && !hasFileAttachment)
            ? BorderSide.none
            : null;

    Widget child = MessageWidget(
      key: ValueKey<String>('MESSAGE-${message.id}'),
      message: message,
      reverse: isMyMessage,
      showReactions: !message.isDeleted,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      showInChannelIndicator: showInChannelIndicator,
      showThreadReplyIndicator: showThreadReplyIndicator,
      showUsername: showUsername,
      showTimestamp: showTimeStamp,
      showSendingIndicator: showSendingIndicator,
      showUserAvatar: showUserAvatar,
      onQuotedMessageTap: (quotedMessageId) async {
        final scrollToIndex = () {
          final index = messages.indexWhere((m) => m.id == quotedMessageId);
          _scrollController?.scrollTo(
            index: index,
            duration: const Duration(milliseconds: 350),
          );
        };
        if (messages.map((e) => e.id).contains(quotedMessageId)) {
          scrollToIndex();
        } else {
          await streamChannel.loadChannelAtMessage(quotedMessageId).then((_) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (messages.map((e) => e.id).contains(quotedMessageId)) {
                scrollToIndex();
              }
            });
          });
        }
      },
      showEditMessage: isMyMessage,
      showDeleteMessage: isMyMessage,
      showThreadReplyMessage: !isThreadMessage,
      showFlagButton: !isMyMessage,
      borderSide: borderSide,
      onThreadTap: _onThreadTap,
      onReplyTap: widget.onReplyTap,
      attachmentBorderRadiusGeometry: BorderRadius.only(
        topLeft: Radius.circular(attachmentBorderRadius),
        bottomLeft: Radius.circular(
          (timeDiff >= 1 || !isNextUserSame) &&
                  !(hasReplies || isThreadMessage || hasFileAttachment)
              ? 0
              : attachmentBorderRadius,
        ),
        topRight: Radius.circular(attachmentBorderRadius),
        bottomRight: Radius.circular(attachmentBorderRadius),
      ),
      attachmentPadding: EdgeInsets.all(hasFileAttachment ? 4 : 2),
      borderRadiusGeometry: BorderRadius.only(
        topLeft: Radius.circular(16),
        bottomLeft: Radius.circular(
          (timeDiff >= 1 || !isNextUserSame) && !(hasReplies || isThreadMessage)
              ? 0
              : 16,
        ),
        topRight: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      textPadding: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: isOnlyEmoji ? 0 : 16.0,
      ),
      messageTheme: isMyMessage
          ? StreamChatTheme.of(context).ownMessageTheme
          : StreamChatTheme.of(context).otherMessageTheme,
      readList: readList,
      allRead: allRead,
      onShowMessage: widget.onShowMessage,
      onReturnAction: (action) {
        switch (action) {
          case ReturnActionType.none:
            break;
          case ReturnActionType.reply:
            FocusScope.of(context).unfocus();
            widget.onMessageSwiped(message);
            break;
        }
      },
      videoPackages: videoPackages,
    );

    if (!message.isDeleted && !message.isSystem && !message.isEphemeral) {
      child = Swipeable(
        onSwipeEnd: () {
          FocusScope.of(context).unfocus();
          widget.onMessageSwiped(message);
        },
        backgroundIcon: StreamSvgIcon.reply(
          color: StreamChatTheme.of(context).colorTheme.accentBlue,
        ),
        child: child,
      );
    }

    if (!initialMessageHighlightComplete &&
        widget.highlightInitialMessage &&
        _isInitialMessage(message.id)) {
      final colorTheme = StreamChatTheme.of(context).colorTheme;
      final highlightColor =
          widget.messageHighlightColor ?? colorTheme.highlight;
      child = TweenAnimationBuilder<Color>(
        tween: ColorTween(
          begin: highlightColor,
          end: colorTheme.white.withOpacity(0),
        ),
        duration: const Duration(seconds: 3),
        child: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: child,
        ),
        onEnd: () => initialMessageHighlightComplete = true,
        builder: (_, color, child) {
          return Container(
            color: color,
            child: child,
          );
        },
      );
    }
    return child;
  }

  StreamSubscription _messageNewListener;

  @override
  void initState() {
    _scrollController = widget.scrollController ?? ItemScrollController();
    _itemPositionListener =
        widget.itemPositionListener ?? ItemPositionsListener.create();

    streamChannel = StreamChannel.of(context);

    initialIndex = _initialIndex;
    initialAlignment = _initialAlignment;

    _messageNewListener =
        streamChannel.channel.on(EventType.messageNew).listen((event) {
      if (_upToDate) {
        _bottomPaginationActive = false;
        _topPaginationActive = false;
      }
      if (event.message.user.id == streamChannel.channel.client.state.user.id) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController?.jumpTo(
            index: 0,
          );
        });
      }
    });

    if (_isThreadConversation) {
      streamChannel.getReplies(widget.parentMessage.id);
    }

    _getOnThreadTap();
    super.initState();
  }

  void _getOnThreadTap() {
    if (widget.onThreadTap != null) {
      _onThreadTap = (Message message) {
        widget.onThreadTap(
            message,
            widget.threadBuilder != null
                ? widget.threadBuilder(context, message)
                : null);
      };
    } else if (widget.threadBuilder != null) {
      _onThreadTap = (Message message) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) {
            return StreamBuilder<Message>(
                stream: streamChannel.channel.state.messagesStream.map(
                    (messages) =>
                        messages.firstWhere((m) => m.id == message.id)),
                initialData: message,
                builder: (_, snapshot) {
                  return StreamChannel(
                    channel: streamChannel.channel,
                    child: widget.threadBuilder(context, snapshot.data),
                  );
                });
          }),
        );
      };
    }
  }

  @override
  void dispose() {
    if (!_upToDate) {
      streamChannel.reloadChannel();
    }
    _messageNewListener?.cancel();
    videoPackages.values.forEach((e) => e.dispose());
    super.dispose();
  }
}
