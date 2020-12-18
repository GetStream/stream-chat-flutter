import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/lazy_load_scroll_view.dart';
import 'package:stream_chat_flutter/src/message_widget.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/system_message.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../stream_chat_flutter.dart';
import 'date_divider.dart';
import 'stream_channel.dart';

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
    this.dateDividerBuilder,
    this.scrollPhysics = const AlwaysScrollableScrollPhysics(),
    this.initialScrollIndex,
    this.initialAlignment,
    this.scrollController,
    this.itemPositionListener,
    this.highlightInitialMessage = false,
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

  /// If true the list will highlight the initialMessage if there is any.
  ///
  /// Also See [StreamChannel]
  final bool highlightInitialMessage;

  @override
  _MessageListViewState createState() => _MessageListViewState();
}

class _MessageListViewState extends State<MessageListView> {
  ItemScrollController _scrollController;
  bool _bottomWasVisible = false;
  Function _onThreadTap;
  bool _showScrollToBottom = false;
  ItemPositionsListener _itemPositionListener;
  int _messageListLength;

  int get _initialIndex {
    if (widget.initialScrollIndex != null) return widget.initialScrollIndex;
    final streamChannel = StreamChannel.of(context);
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
    final streamChannel = StreamChannel.of(context);
    return streamChannel.initialMessageId == id;
  }

  bool get _upToDate => StreamChannel.of(context).channel.state.isUpToDate;

  bool _topPaginationActive = false;
  bool _bottomPaginationActive = false;

  int initialIndex;
  double initialAlignment;

  List<Message> messages = <Message>[];

  bool initialMessageHighlightComplete = false;

  @override
  Widget build(BuildContext context) {
    final streamChannel = StreamChannel.of(context);

    final messagesStream = widget.parentMessage != null
        ? streamChannel.channel.state.threadsStream
            .where((threads) => threads.containsKey(widget.parentMessage.id))
            .map((threads) => threads[widget.parentMessage.id])
        : streamChannel.channel.state?.messagesStream;

    return WillPopScope(
      onWillPop: () async {
        if (!_upToDate) {
          await streamChannel.reloadChannel();
        }
        return true;
      },
      child: StreamBuilder<List<Message>>(
          stream: messagesStream?.map((messages) => messages
              ?.where((e) =>
                  !e.isDeleted ||
                  (e.isDeleted &&
                      e.user.id == streamChannel.channel.client.state.user.id))
              ?.toList()),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final messageList = snapshot.data?.reversed?.toList() ?? [];

            if (messageList.isEmpty) {
              if (_upToDate) {
                return Center(
                  child: Text(
                    'No chats here yet...',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(.5),
                    ),
                  ),
                );
              }
            } else {
              messages = messageList;
            }

            final newMessagesListLength = messages.length;

            if (_messageListLength != null) {
              if (_bottomPaginationActive) {
                if (_itemPositionListener.itemPositions.value?.isNotEmpty ==
                    true) {
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
                LazyLoadScrollView(
                  onStartOfPage: () async {
                    if (!_upToDate) {
                      _topPaginationActive = false;
                      _bottomPaginationActive = true;
                      return _paginateData(
                          streamChannel, QueryDirection.bottom);
                    }
                  },
                  onEndOfPage: () async {
                    _topPaginationActive = true;
                    _bottomPaginationActive = false;
                    return _paginateData(streamChannel, QueryDirection.top);
                  },
                  child: ScrollablePositionedList.builder(
                    key: ValueKey(initialIndex + initialAlignment),
                    itemPositionsListener: _itemPositionListener,
                    addAutomaticKeepAlives: true,
                    initialScrollIndex: initialIndex ?? 0,
                    initialAlignment: initialAlignment ?? 0,
                    physics: widget.scrollPhysics,
                    itemScrollController: _scrollController,
                    reverse: true,
                    itemCount: messages.length +
                        2 +
                        (widget.parentMessage != null ? 1 : 0),
                    itemBuilder: (context, i) {
                      if (i == messages.length + 2) {
                        if (widget.parentMessageBuilder != null) {
                          return widget.parentMessageBuilder(
                            context,
                            widget.parentMessage,
                          );
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              buildParentMessage(widget.parentMessage),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 32),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    'Start of thread',
                                    textAlign: TextAlign.center,
                                  ),
                                  color: Theme.of(context)
                                      .accentColor
                                      .withAlpha(50),
                                ),
                              ),
                            ],
                          );
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
                      final nextMessage = (i - 1) > 0 ? messages[i - 2] : null;

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
                            builder: (_) => widget.messageBuilder(
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

                      if (nextMessage != null &&
                          !Jiffy(message.createdAt.toLocal()).isSame(
                              nextMessage.createdAt.toLocal(), Units.DAY)) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            messageWidget,
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: widget.dateDividerBuilder != null
                                  ? widget.dateDividerBuilder(
                                      nextMessage.createdAt.toLocal())
                                  : DateDivider(
                                      dateTime: nextMessage.createdAt.toLocal(),
                                    ),
                            ),
                          ],
                        );
                      }

                      return messageWidget;
                    },
                  ),
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
          }),
    );
  }

  Future<void> _paginateData(
      StreamChannelState channel, QueryDirection direction) {
    if (widget.parentMessage == null) {
      return channel.queryMessages(direction: direction);
    } else {
      return channel.getReplies(widget.parentMessage.id);
    }
  }

  ItemPosition _getTopElement(Iterable<ItemPosition> values) {
    return values
        .where((ItemPosition position) => position.itemLeadingEdge < 0.9)
        .reduce((ItemPosition max, ItemPosition position) =>
            position.itemLeadingEdge > max.itemLeadingEdge ? position : max);
  }

  Widget _buildScrollToBottom() {
    final streamChannel = StreamChannel.of(context);
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
                backgroundColor: Colors.white,
                child: StreamSvgIcon.down(
                  color: Colors.black,
                ),
                onPressed: () {
                  if (!_upToDate) {
                    _bottomPaginationActive = false;
                    _topPaginationActive = false;
                    streamChannel.reloadChannel();
                    streamChannel.channel.markRead();
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
              color: Color(0xffd0021B).withAlpha(26),
              child: Center(
                child: Text('Error loading messages'),
              ),
            );
          }
          if (!snapshot.data) {
            if (direction == QueryDirection.top) {
              return Container(
                height: 50,
                width: double.infinity,
              );
            }
            return Offstage();
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: const CupertinoActivityIndicator(),
            ),
          );
        });
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
        if (isVisible && !_bottomWasVisible) {
          if (streamChannel.channel.state.isUpToDate &&
              streamChannel.channel.config?.readEvents == true &&
              streamChannel.channel.state.unreadCount > 0) {
            streamChannel.channel.markRead();
          }
          _bottomWasVisible = !isVisible;
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

    return MessageWidget(
      showReplyIndicator: false,
      message: message,
      reverse: isMyMessage,
      showUsername: !isMyMessage,
      padding: EdgeInsets.only(
        top: 8.0,
        left: 8.0,
        right: 8.0,
        bottom: 16.0,
      ),
      showSendingIndicator: DisplayWidget.hide,
      onThreadTap: _onThreadTap,
      showEditMessage: false,
      showDeleteMessage: false,
      borderRadiusGeometry: BorderRadius.only(
        topLeft: Radius.circular(16),
        bottomLeft: Radius.circular(2),
        topRight: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      borderSide: isMyMessage ? BorderSide.none : null,
      showUserAvatar: isMyMessage ? DisplayWidget.gone : DisplayWidget.show,
      messageTheme: isMyMessage
          ? StreamChatTheme.of(context).ownMessageTheme
          : StreamChatTheme.of(context).otherMessageTheme,
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
    final isNextUser =
        index - 2 >= 0 && message.user.id == messages[index - 2]?.user?.id;

    final channel = StreamChannel.of(context).channel;
    final readList = channel.state?.read
            ?.where((element) => element.user.id != userId)
            ?.where((read) =>
                (read.lastRead.isAfter(message.createdAt) ||
                    read.lastRead.isAtSameMomentAs(message.createdAt)) &&
                (index == 0 ||
                    read.lastRead.isBefore(messages[index - 1].createdAt)))
            ?.toList() ??
        [];

    final allRead = readList.length >= (channel.memberCount ?? 0) - 1;

    Widget child = MessageWidget(
      key: ValueKey<String>('MESSAGE-${message.id}'),
      message: message,
      reverse: isMyMessage,
      showReactions: !message.isDeleted,
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: index == 0 ? 30 : (isNextUser ? 5 : 10),
      ),
      showUsername: !isMyMessage && !isNextUser,
      showSendingIndicator: isMyMessage &&
              (index == 0 || message.status != MessageSendingStatus.SENT)
          ? DisplayWidget.show
          : DisplayWidget.hide,
      showTimestamp: !isNextUser || readList?.isNotEmpty == true,
      showEditMessage: isMyMessage,
      showDeleteMessage: isMyMessage,
      borderSide: isMyMessage ? BorderSide.none : null,
      onThreadTap: _onThreadTap,
      attachmentBorderRadiusGeometry: BorderRadius.only(
        topLeft: Radius.circular(16),
        bottomLeft: Radius.circular(!isNextUser ? 0 : 16),
        topRight: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      attachmentPadding: const EdgeInsets.all(2),
      borderRadiusGeometry: BorderRadius.only(
        topLeft: Radius.circular(16),
        bottomLeft: Radius.circular(!isNextUser ? 0 : 16),
        topRight: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      showUserAvatar: isMyMessage
          ? DisplayWidget.gone
          : (isNextUser ? DisplayWidget.hide : DisplayWidget.show),
      messageTheme: isMyMessage
          ? StreamChatTheme.of(context).ownMessageTheme
          : StreamChatTheme.of(context).otherMessageTheme,
      readList: readList,
      allRead: allRead,
    );

    if (!initialMessageHighlightComplete &&
        widget.highlightInitialMessage &&
        _isInitialMessage(message.id)) {
      final accentColor = Theme.of(context).accentColor;
      child = TweenAnimationBuilder<Color>(
        tween: ColorTween(
          begin: accentColor.withOpacity(0.7),
          end: Colors.transparent,
        ),
        duration: const Duration(seconds: 2),
        child: child,
        onEnd: () {
          initialMessageHighlightComplete = true;
        },
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

    final streamChannel = StreamChannel.of(context);

    initialIndex = _initialIndex;
    initialAlignment = _initialAlignment;

    _messageNewListener =
        streamChannel.channel.on(EventType.messageNew).listen((event) {
      if (event.message.user.id == streamChannel.channel.client.state.user.id) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.jumpTo(
            index: 0,
          );
        });
      }
    });

    if (widget.parentMessage != null) {
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
                stream: StreamChannel.of(context)
                    .channel
                    .state
                    .messagesStream
                    .map((messages) =>
                        messages.firstWhere((m) => m.id == message.id)),
                initialData: message,
                builder: (_, snapshot) {
                  return StreamChannel(
                    channel: StreamChannel.of(context).channel,
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
    _messageNewListener?.cancel();
    super.dispose();
  }
}
