// ignore_for_file: lines_longer_than_80_chars
import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/info_tile.dart';
import 'package:stream_chat_flutter/src/message_widget.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/swipeable.dart';
import 'package:stream_chat_flutter/src/system_message.dart';
import 'package:stream_chat_flutter/src/theme/themes.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Widget builder for message
/// [defaultMessageWidget] is the default [MessageWidget] configuration
/// Use [defaultMessageWidget.copyWith] to easily customize it
typedef MessageBuilder = Widget Function(
  BuildContext,
  MessageDetails,
  List<Message>,
  MessageWidget defaultMessageWidget,
);

/// Widget builder for parent message
/// [defaultMessageWidget] is the default [MessageWidget] configuration
/// Use [defaultMessageWidget.copyWith] to easily customize it
typedef ParentMessageBuilder = Widget Function(
  BuildContext,
  Message?,
  MessageWidget defaultMessageWidget,
);

/// Widget builder for system message
typedef SystemMessageBuilder = Widget Function(
  BuildContext,
  Message,
);

/// Widget builder for thread
typedef ThreadBuilder = Widget Function(BuildContext context, Message? parent);

/// Callback for thread taps
typedef ThreadTapCallback = void Function(Message, Widget?);

/// Callback on message swiped
typedef OnMessageSwiped = void Function(Message);

/// Callback on message tapped
typedef OnMessageTap = void Function(Message);

/// Callback on reply tapped
typedef ReplyTapCallback = void Function(Message);

/// Class for message details
class MessageDetails {
  /// Constructor for creating [MessageDetails]
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

/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/message_listview.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/message_listview_paint.png)
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
/// Make sure to have a [StreamChannel] ancestor in order to
/// provide the information about the channels.
/// The widget uses a [ListView.custom] to render the list of channels.
///
/// The widget components render the ui based on the first
/// ancestor of type [StreamChatTheme].
/// Modify it to change the widget appearance.
class MessageListView extends StatefulWidget {
  /// Instantiate a new MessageListView
  const MessageListView({
    Key? key,
    this.showScrollToBottom = true,
    this.messageBuilder,
    this.parentMessageBuilder,
    this.parentMessage,
    this.threadBuilder,
    this.onThreadTap,
    this.dateDividerBuilder,
    this.scrollPhysics = const ClampingScrollPhysics(),
    this.initialScrollIndex,
    this.initialAlignment,
    this.scrollController,
    this.itemPositionListener,
    this.onMessageSwiped,
    this.highlightInitialMessage = false,
    this.messageHighlightColor,
    this.showConnectionStateTile = false,
    this.headerBuilder,
    this.footerBuilder,
    this.loadingBuilder,
    this.emptyBuilder,
    this.systemMessageBuilder,
    this.messageListBuilder,
    this.errorBuilder,
    this.messageFilter,
    this.onMessageTap,
    this.onSystemMessageTap,
    this.pinPermissions = const [],
    this.showFloatingDateDivider = true,
    this.threadSeparatorBuilder,
    this.messageListController,
    this.reverse = true,
    this.paginationLimit = 20,
  }) : super(key: key);

  /// Function used to build a custom message widget
  final MessageBuilder? messageBuilder;

  /// Whether the view scrolls in the reading direction.
  ///
  /// Defaults to true.
  ///
  /// See [ScrollView.reverse].
  final bool reverse;

  /// Limit used during pagination
  final int paginationLimit;

  /// Function used to build a custom system message widget
  final SystemMessageBuilder? systemMessageBuilder;

  /// Function used to build a custom parent message widget
  final ParentMessageBuilder? parentMessageBuilder;

  /// Function used to build a custom thread widget
  final ThreadBuilder? threadBuilder;

  /// Function called when tapping on a thread
  /// By default it calls [Navigator.push] using the widget
  /// built using [threadBuilder]
  final ThreadTapCallback? onThreadTap;

  /// If true will show a scroll to bottom message when there are new
  /// messages and the scroll offset is not zero
  final bool showScrollToBottom;

  /// Parent message in case of a thread
  final Message? parentMessage;

  /// Builder used to render date dividers
  final Widget Function(DateTime)? dateDividerBuilder;

  /// Index of an item to initially align within the viewport.
  final int? initialScrollIndex;

  /// Determines where the leading edge of the item at [initialScrollIndex]
  /// should be placed.
  final double? initialAlignment;

  /// Controller for jumping or scrolling to an item.
  final ItemScrollController? scrollController;

  /// Provides a listenable iterable of [itemPositions] of items that are on
  /// screen and their locations.
  final ItemPositionsListener? itemPositionListener;

  /// The ScrollPhysics used by the ListView
  final ScrollPhysics scrollPhysics;

  /// Called when message item gets swiped
  final OnMessageSwiped? onMessageSwiped;

  /// If true the list will highlight the initialMessage if there is any.
  ///
  /// Also See [StreamChannel]
  final bool highlightInitialMessage;

  /// Color used while highlighting initial message
  final Color? messageHighlightColor;

  /// Flag for showing tile on header
  final bool showConnectionStateTile;

  /// Flag for showing the floating date divider
  final bool showFloatingDateDivider;

  /// Function called when messages are fetched
  final Widget Function(BuildContext, List<Message>)? messageListBuilder;

  /// Function used to build a header widget
  final WidgetBuilder? headerBuilder;

  /// Function used to build a footer widget
  final WidgetBuilder? footerBuilder;

  /// Function used to build a loading widget
  final WidgetBuilder? loadingBuilder;

  /// Function used to build an empty widget
  final WidgetBuilder? emptyBuilder;

  /// Callback triggered when an error occurs while performing the
  /// given request.
  /// This parameter can be used to display an error message to
  /// users in the event
  /// of a connection failure.
  final ErrorBuilder? errorBuilder;

  /// Predicate used to filter messages
  final bool Function(Message)? messageFilter;

  /// Called when any message is tapped except a system message
  /// (use [onSystemMessageTap] instead)
  final OnMessageTap? onMessageTap;

  /// Called when system message is tapped
  final OnMessageTap? onSystemMessageTap;

  /// A List of user types that have permission to pin messages
  final List<String> pinPermissions;

  /// Builder used to build the thread separator in case it's a thread view
  final WidgetBuilder? threadSeparatorBuilder;

  /// A [MessageListController] allows pagination.
  /// Use [ChannelListController.paginateData] pagination.
  final MessageListController? messageListController;

  @override
  _MessageListViewState createState() => _MessageListViewState();
}

class _MessageListViewState extends State<MessageListView> {
  ItemScrollController? _scrollController;
  void Function(Message)? _onThreadTap;
  bool _showScrollToBottom = false;
  late final ItemPositionsListener _itemPositionListener;
  late final Stream<Iterable<ItemPosition>> _itemPositionStream;
  int? _messageListLength;
  StreamChannelState? streamChannel;
  late StreamChatThemeData _streamTheme;

  int get _initialIndex {
    final initialScrollIndex = widget.initialScrollIndex;
    if (initialScrollIndex != null) return initialScrollIndex;
    if (streamChannel!.initialMessageId != null) {
      final messages = streamChannel!.channel.state!.messages;
      final totalMessages = messages.length;
      final messageIndex =
          messages.indexWhere((e) => e.id == streamChannel!.initialMessageId);
      final index = totalMessages - messageIndex;
      if (index != 0) return index - 1;
      return index;
    }
    return 0;
  }

  double get _initialAlignment {
    final initialAlignment = widget.initialAlignment;
    if (initialAlignment != null) return initialAlignment;
    return 0;
  }

  bool _isInitialMessage(String id) => streamChannel!.initialMessageId == id;

  bool get _upToDate => streamChannel!.channel.state!.isUpToDate;

  bool get _isThreadConversation => widget.parentMessage != null;

  bool _topPaginationActive = false;
  bool _bottomPaginationActive = false;

  int initialIndex = 0;
  double initialAlignment = 0;

  List<Message> messages = <Message>[];

  bool initialMessageHighlightComplete = false;

  bool _inBetweenList = false;

  late final _defaultController = MessageListController();

  MessageListController get _messageListController =>
      widget.messageListController ?? _defaultController;

  @override
  Widget build(BuildContext context) => MessageListCore(
        paginationLimit: widget.paginationLimit,
        messageFilter: widget.messageFilter,
        loadingBuilder: widget.loadingBuilder ??
            (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
        emptyBuilder: widget.emptyBuilder ??
            (context) => Center(
                  child: Text(
                    context.translations.emptyChatMessagesText,
                    style: _streamTheme.textTheme.footnote.copyWith(
                        color: _streamTheme.colorTheme.textHighEmphasis
                            .withOpacity(.5)),
                  ),
                ),
        messageListBuilder: widget.messageListBuilder ??
            (context, list) => _buildListView(list),
        messageListController: _messageListController,
        parentMessage: widget.parentMessage,
        errorBuilder: widget.errorBuilder ??
            (BuildContext context, Object error) => Center(
                  child: Text(
                    context.translations.genericErrorText,
                    style: _streamTheme.textTheme.footnote.copyWith(
                        color: _streamTheme.colorTheme.textHighEmphasis
                            .withOpacity(.5)),
                  ),
                ),
      );

  Widget _buildListView(List<Message> data) {
    messages = data;
    final newMessagesListLength = messages.length;

    if (_messageListLength != null) {
      if (_bottomPaginationActive || (_inBetweenList && _upToDate)) {
        if (_itemPositionListener.itemPositions.value.isNotEmpty == true) {
          final first = _itemPositionListener.itemPositions.value.first;
          final diff = newMessagesListLength - _messageListLength!;
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

    final itemCount = messages.length + // total messages
            2 + // top + bottom loading indicator
            2 + // header + footer
            1 // parent message
        ;

    final child = Stack(
      alignment: Alignment.center,
      children: [
        ConnectionStatusBuilder(
          statusBuilder: (context, status) {
            var statusString = '';
            var showStatus = true;
            switch (status) {
              case ConnectionStatus.connected:
                statusString = context.translations.connectedLabel;
                showStatus = false;
                break;
              case ConnectionStatus.connecting:
                statusString = context.translations.reconnectingLabel;
                break;
              case ConnectionStatus.disconnected:
                statusString = context.translations.disconnectedLabel;
                break;
            }

            return InfoTile(
              showMessage: widget.showConnectionStateTile && showStatus,
              tileAnchor: Alignment.topCenter,
              childAnchor: Alignment.topCenter,
              message: statusString,
              child: LazyLoadScrollView(
                onPageScrollStart: () {
                  FocusScope.of(context).unfocus();
                },
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
                  key: _upToDate
                      ? null
                      : ValueKey(initialIndex + initialAlignment),
                  itemPositionsListener: _itemPositionListener,
                  initialScrollIndex: initialIndex,
                  initialAlignment: initialAlignment,
                  physics: widget.scrollPhysics,
                  itemScrollController: _scrollController,
                  reverse: widget.reverse,
                  addAutomaticKeepAlives: false,
                  itemCount: itemCount,

                  // Item Count -> 8 (1 parent, 2 header+footer, 2 top+bottom, 3 messages)
                  // eg:     |Type|         rev(|Index(item)|)     rev(|Index(separator)|)    |Index(item)|    |Index(separator)|
                  //     ParentMessage  ->        7                                             (count-1)
                  //        Separator(ThreadSeparator)          ->           6                                      (count-2)
                  //     Header         ->        6                                             (count-2)
                  //        Separator(Header -> 8??T -> 0||52)  ->           5                                      (count-3)
                  //     TopLoader      ->        5                                             (count-3)
                  //        Separator(0)                        ->           4                                      (count-4)
                  //     Message        ->        4                                             (count-4)
                  //        Separator(2||8)                     ->           3                                      (count-5)
                  //     Message        ->        3                                             (count-5)
                  //        Separator(2||8)                     ->           2                                      (count-6)
                  //     Message        ->        2                                             (count-6)
                  //        Separator(0)                        ->           1                                      (count-7)
                  //     BottomLoader   ->        1                                             (count-7)
                  //        Separator(Footer -> 8??30)          ->           0                                      (count-8)
                  //     Footer         ->        0                                             (count-8)

                  separatorBuilder: (context, i) {
                    if (i == itemCount - 2) {
                      if (widget.parentMessage == null) {
                        return const Offstage();
                      }
                      return _buildThreadSeparator();
                    }
                    if (i == itemCount - 3) {
                      if (widget.reverse
                          ? widget.headerBuilder == null
                          : widget.footerBuilder == null) {
                        if (_isThreadConversation) return const Offstage();
                        return const SizedBox(height: 52);
                      }
                      return const SizedBox(height: 8);
                    }
                    if (i == 0) {
                      if (widget.reverse
                          ? widget.footerBuilder == null
                          : widget.headerBuilder == null) {
                        return const SizedBox(height: 30);
                      }
                      return const SizedBox(height: 8);
                    }

                    if (i == 1 || i == itemCount - 4) return const Offstage();

                    late final Message message, nextMessage;
                    if (widget.reverse) {
                      message = messages[i - 1];
                      nextMessage = messages[i - 2];
                    } else {
                      message = messages[i - 2];
                      nextMessage = messages[i - 1];
                    }
                    if (!Jiffy(message.createdAt.toLocal()).isSame(
                      nextMessage.createdAt.toLocal(),
                      Units.DAY,
                    )) {
                      final divider = widget.dateDividerBuilder != null
                          ? widget.dateDividerBuilder!(
                              nextMessage.createdAt.toLocal(),
                            )
                          : DateDivider(
                              dateTime: nextMessage.createdAt.toLocal(),
                            );
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: divider,
                      );
                    }
                    final timeDiff =
                        Jiffy(nextMessage.createdAt.toLocal()).diff(
                      message.createdAt.toLocal(),
                      Units.MINUTE,
                    );

                    final isNextUserSame =
                        message.user!.id == nextMessage.user?.id;
                    final isThread = message.replyCount! > 0;
                    final isDeleted = message.isDeleted;
                    if (timeDiff >= 1 ||
                        !isNextUserSame ||
                        isThread ||
                        isDeleted) {
                      return const SizedBox(height: 8);
                    }
                    return const SizedBox(height: 2);
                  },
                  itemBuilder: (context, i) {
                    if (i == itemCount - 1) {
                      if (widget.parentMessage == null) {
                        return const Offstage();
                      }
                      return buildParentMessage(widget.parentMessage!);
                    }

                    if (i == itemCount - 2) {
                      if (widget.reverse) {
                        return widget.headerBuilder?.call(context) ??
                            const Offstage();
                      } else {
                        return widget.footerBuilder?.call(context) ??
                            const Offstage();
                      }
                    }

                    if (i == itemCount - 3) {
                      return _buildLoadingIndicator(
                        streamChannel!,
                        QueryDirection.top,
                      );
                    }

                    if (i == 1) {
                      return _buildLoadingIndicator(
                        streamChannel!,
                        QueryDirection.bottom,
                      );
                    }

                    if (i == 0) {
                      if (widget.reverse) {
                        return widget.footerBuilder?.call(context) ??
                            const Offstage();
                      } else {
                        return widget.headerBuilder?.call(context) ??
                            const Offstage();
                      }
                    }

                    const bottomMessageIndex = 2; // 1 -> loader // 0 -> footer

                    final message = messages[i - 2];
                    Widget messageWidget;

                    if (i == bottomMessageIndex) {
                      messageWidget = _buildBottomMessage(
                        context,
                        message,
                        messages,
                        streamChannel!,
                        i - 2,
                      );
                    } else {
                      messageWidget = buildMessage(message, messages, i - 2);
                    }
                    return messageWidget;
                  },
                ),
              ),
            );
          },
        ),
        if (widget.showScrollToBottom) _buildScrollToBottom(),
        if (widget.showFloatingDateDivider)
          _buildFloatingDateDivider(itemCount),
      ],
    );

    final backgroundColor = MessageListViewTheme.of(context).backgroundColor;

    if (backgroundColor != null) {
      return ColoredBox(
        color: backgroundColor,
        child: child,
      );
    }

    return child;
  }

  Widget _buildThreadSeparator() {
    if (widget.threadSeparatorBuilder != null) {
      return widget.threadSeparatorBuilder!.call(context);
    }

    final replyCount = widget.parentMessage!.replyCount!;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: _streamTheme.colorTheme.bgGradient,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          context.translations.threadSeparatorText(replyCount),
          textAlign: TextAlign.center,
          style: ChannelHeaderTheme.of(context).subtitleStyle,
        ),
      ),
    );
  }

  Positioned _buildFloatingDateDivider(int itemCount) => Positioned(
        top: 20,
        left: 0,
        right: 0,
        child: BetterStreamBuilder<Iterable<ItemPosition>>(
          initialData: _itemPositionListener.itemPositions.value,
          stream: _itemPositionStream,
          comparator: (a, b) {
            if (a == null || b == null) {
              return false;
            }
            if (widget.reverse) {
              final aTop = _getTopElementIndex(a);
              final bTop = _getTopElementIndex(b);
              return aTop == bTop;
            } else {
              final aBottom = _getBottomElementIndex(a);
              final bBottom = _getBottomElementIndex(b);
              return aBottom == bBottom;
            }
          },
          builder: (context, values) {
            if (values.isEmpty || messages.isEmpty) {
              return const Offstage();
            }

            int? index;
            if (widget.reverse) {
              index = _getTopElementIndex(values);
            } else {
              index = _getBottomElementIndex(values);
            }

            if (index == null) return const Offstage();

            if (index <= 2 || index >= itemCount - 3) {
              if (widget.reverse) {
                index = itemCount - 4;
              } else {
                index = 2;
              }
            }

            final message = messages[index - 2];
            return widget.dateDividerBuilder != null
                ? widget.dateDividerBuilder!(message.createdAt.toLocal())
                : DateDivider(dateTime: message.createdAt.toLocal());
          },
        ),
      );

  Future<void> _paginateData(
    StreamChannelState? channel,
    QueryDirection direction,
  ) =>
      _messageListController.paginateData!(direction: direction);

  int? _getTopElementIndex(Iterable<ItemPosition> values) {
    final inView = values.where((position) => position.itemLeadingEdge < 1);
    if (inView.isEmpty) return null;
    return inView
        .reduce((max, position) =>
            position.itemLeadingEdge > max.itemLeadingEdge ? position : max)
        .index;
  }

  int? _getBottomElementIndex(Iterable<ItemPosition> values) {
    final inView = values.where((position) => position.itemLeadingEdge < 1);
    if (inView.isEmpty) return null;
    return inView
        .reduce((min, position) =>
            position.itemLeadingEdge < min.itemLeadingEdge ? position : min)
        .index;
  }

  Widget _buildScrollToBottom() => StreamBuilder<Tuple2<bool, int>>(
        stream: Rx.combineLatest2(
          streamChannel!.channel.state!.isUpToDateStream.distinct(),
          streamChannel!.channel.state!.unreadCountStream.distinct(),
          (bool isUpToDate, int unreadCount) => Tuple2(isUpToDate, unreadCount),
        ),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return const Offstage();
          } else if (!snapshot.hasData) {
            return const Offstage();
          }
          final isUpToDate = snapshot.data!.item1;
          final showScrollToBottom = !isUpToDate || _showScrollToBottom;
          if (!showScrollToBottom) {
            return const Offstage();
          }
          final unreadCount = snapshot.data!.item2;
          final showUnreadCount = unreadCount > 0 &&
              streamChannel!.channel.state!.members.any((e) =>
                  e.userId ==
                  streamChannel!.channel.client.state.currentUser!.id);
          return Positioned(
            bottom: 8,
            right: 8,
            width: 40,
            height: 40,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                FloatingActionButton(
                  backgroundColor: _streamTheme.colorTheme.barsBg,
                  onPressed: () {
                    if (unreadCount > 0) {
                      streamChannel!.channel.markRead();
                    }
                    if (!_upToDate) {
                      _bottomPaginationActive = false;
                      _topPaginationActive = false;
                      streamChannel!.reloadChannel();
                    } else {
                      setState(() => _showScrollToBottom = false);
                      _scrollController!.scrollTo(
                        index: 0,
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: widget.reverse
                      ? StreamSvgIcon.down(
                          color: _streamTheme.colorTheme.textHighEmphasis,
                        )
                      : StreamSvgIcon.up(
                          color: _streamTheme.colorTheme.textHighEmphasis,
                        ),
                ),
                if (showUnreadCount)
                  Positioned(
                    width: 20,
                    height: 20,
                    left: 10,
                    top: -10,
                    child: CircleAvatar(
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Text(
                          '$unreadCount',
                          style: const TextStyle(
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

  Widget _buildLoadingIndicator(
    StreamChannelState streamChannel,
    QueryDirection direction,
  ) =>
      _LoadingIndicator(
        direction: direction,
        streamTheme: _streamTheme,
        streamChannel: streamChannel,
        isThreadConversation: _isThreadConversation,
      );

  Widget _buildBottomMessage(
    BuildContext context,
    Message message,
    List<Message> messages,
    StreamChannelState streamChannel,
    int index,
  ) {
    final messageWidget = buildMessage(message, messages, index);

    return VisibilityDetector(
      key: ValueKey<String>('BOTTOM-MESSAGE-${message.id}'),
      onVisibilityChanged: (visibility) {
        final isVisible = visibility.visibleBounds != Rect.zero;
        if (isVisible) {
          final channel = streamChannel.channel;
          if (_upToDate &&
              channel.config?.readEvents == true &&
              channel.state!.unreadCount > 0) {
            streamChannel.channel.markRead();
          }
        }
        if (mounted) {
          if (_showScrollToBottom == isVisible) {
            setState(() => _showScrollToBottom = !isVisible);
          }
        }
      },
      child: messageWidget,
    );
  }

  Widget buildParentMessage(
    Message message,
  ) {
    final isMyMessage =
        message.user!.id == StreamChat.of(context).currentUser!.id;
    final isOnlyEmoji = message.text?.isOnlyEmoji ?? false;
    final currentUser = StreamChat.of(context).currentUser;
    final members = StreamChannel.of(context).channel.state?.members ?? [];
    final currentUserMember =
        members.firstWhereOrNull((e) => e.user!.id == currentUser!.id);

    final defaultMessageWidget = MessageWidget(
      showReplyMessage: false,
      showResendMessage: false,
      showThreadReplyMessage: false,
      showCopyMessage: false,
      showDeleteMessage: false,
      showEditMessage: false,
      message: message,
      reverse: isMyMessage,
      showUsername: !isMyMessage,
      padding: const EdgeInsets.all(8),
      showSendingIndicator: false,
      borderRadiusGeometry: BorderRadius.only(
        topLeft: const Radius.circular(16),
        bottomLeft:
            isMyMessage ? const Radius.circular(16) : const Radius.circular(2),
        topRight: const Radius.circular(16),
        bottomRight:
            isMyMessage ? const Radius.circular(2) : const Radius.circular(16),
      ),
      textPadding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: isOnlyEmoji ? 0 : 16.0,
      ),
      borderSide: isMyMessage || isOnlyEmoji ? BorderSide.none : null,
      showUserAvatar: isMyMessage ? DisplayWidget.gone : DisplayWidget.show,
      messageTheme: isMyMessage
          ? _streamTheme.ownMessageTheme
          : _streamTheme.otherMessageTheme,
      onReturnAction: (action) {
        switch (action) {
          case ReturnActionType.none:
            break;
          case ReturnActionType.reply:
            FocusScope.of(context).unfocus();
            widget.onMessageSwiped?.call(message);
            break;
        }
      },
      onMessageTap: (message) {
        if (widget.onMessageTap != null) {
          widget.onMessageTap!(message);
        }
        FocusScope.of(context).unfocus();
      },
      showPinButton: currentUserMember != null &&
          widget.pinPermissions.contains(currentUserMember.role),
    );

    if (widget.parentMessageBuilder != null) {
      return widget.parentMessageBuilder!.call(
        context,
        widget.parentMessage,
        defaultMessageWidget,
      );
    }

    return defaultMessageWidget;
  }

  Widget buildMessage(
    Message message,
    List<Message> messages,
    int index,
  ) {
    if ((message.type == 'system' || message.type == 'error') &&
        message.text?.isNotEmpty == true) {
      return widget.systemMessageBuilder?.call(context, message) ??
          SystemMessage(
            key: ValueKey<String>('MESSAGE-${message.id}'),
            message: message,
            onMessageTap: (message) {
              if (widget.onSystemMessageTap != null) {
                widget.onSystemMessageTap!(message);
              }
              FocusScope.of(context).unfocus();
            },
          );
    }

    final userId = StreamChat.of(context).currentUser!.id;
    final isMyMessage = message.user!.id == userId;
    final nextMessage = index - 1 >= 0 ? messages[index - 1] : null;
    final isNextUserSame =
        nextMessage != null && message.user!.id == nextMessage.user!.id;

    num timeDiff = 0;
    if (nextMessage != null) {
      timeDiff = Jiffy(nextMessage.createdAt.toLocal()).diff(
        message.createdAt.toLocal(),
        Units.MINUTE,
      );
    }

    final channel = streamChannel!.channel;
    final readList = channel.state?.read.where((read) {
          if (read.user.id == userId) return false;
          return read.lastRead.isAfter(message.createdAt) ||
              read.lastRead.isAtSameMomentAs(message.createdAt);
        }).toList() ??
        [];

    final allRead = readList.length >= (channel.memberCount ?? 0) - 1;
    final hasFileAttachment =
        message.attachments.any((it) => it.type == 'file') == true;

    final isThreadMessage =
        message.parentId != null && message.showInChannel == true;

    final hasReplies = message.replyCount! > 0;

    final attachmentBorderRadius = hasFileAttachment ? 12.0 : 14.0;

    final showTimeStamp = (!isThreadMessage || _isThreadConversation) &&
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
    final isOnlyEmoji = message.text?.isOnlyEmoji ?? false;

    final hasUrlAttachment =
        message.attachments.any((it) => it.titleLink != null) == true;

    final borderSide =
        isOnlyEmoji || hasUrlAttachment || (isMyMessage && !hasFileAttachment)
            ? BorderSide.none
            : null;

    final currentUser = StreamChat.of(context).currentUser;
    final members = StreamChannel.of(context).channel.state?.members ?? [];
    final currentUserMember =
        members.firstWhereOrNull((e) => e.user!.id == currentUser!.id);

    Widget messageWidget = MessageWidget(
      key: ValueKey<String>('MESSAGE-${message.id}'),
      message: message,
      reverse: isMyMessage,
      showReactions: !message.isDeleted,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      showInChannelIndicator: showInChannelIndicator,
      showThreadReplyIndicator: showThreadReplyIndicator,
      showUsername: showUsername,
      showTimestamp: showTimeStamp,
      showSendingIndicator: showSendingIndicator,
      showUserAvatar: showUserAvatar,
      onQuotedMessageTap: (quotedMessageId) async {
        // ignore: prefer_function_declarations_over_variables
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
          await streamChannel!.loadChannelAtMessage(quotedMessageId).then((_) {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
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
      attachmentBorderRadiusGeometry: BorderRadius.only(
        topLeft: Radius.circular(attachmentBorderRadius),
        bottomLeft: isMyMessage
            ? Radius.circular(attachmentBorderRadius)
            : Radius.circular(
                (timeDiff >= 1 || !isNextUserSame) &&
                        !(hasReplies || isThreadMessage || hasFileAttachment)
                    ? 0
                    : attachmentBorderRadius,
              ),
        topRight: Radius.circular(attachmentBorderRadius),
        bottomRight: isMyMessage
            ? Radius.circular(
                (timeDiff >= 1 || !isNextUserSame) &&
                        !(hasReplies || isThreadMessage || hasFileAttachment)
                    ? 0
                    : attachmentBorderRadius,
              )
            : Radius.circular(attachmentBorderRadius),
      ),
      attachmentPadding: EdgeInsets.all(hasFileAttachment ? 4 : 2),
      borderRadiusGeometry: BorderRadius.only(
        topLeft: const Radius.circular(16),
        bottomLeft: isMyMessage
            ? const Radius.circular(16)
            : Radius.circular(
                (timeDiff >= 1 || !isNextUserSame) &&
                        !(hasReplies || isThreadMessage)
                    ? 0
                    : 16,
              ),
        topRight: const Radius.circular(16),
        bottomRight: isMyMessage
            ? Radius.circular(
                (timeDiff >= 1 || !isNextUserSame) &&
                        !(hasReplies || isThreadMessage)
                    ? 0
                    : 16,
              )
            : const Radius.circular(16),
      ),
      textPadding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: isOnlyEmoji ? 0 : 16.0,
      ),
      messageTheme: isMyMessage
          ? _streamTheme.ownMessageTheme
          : _streamTheme.otherMessageTheme,
      readList: readList,
      allRead: allRead,
      onReturnAction: (action) {
        switch (action) {
          case ReturnActionType.none:
            break;
          case ReturnActionType.reply:
            FocusScope.of(context).unfocus();
            widget.onMessageSwiped?.call(message);
            break;
        }
      },
      onMessageTap: (message) {
        if (widget.onMessageTap != null) {
          widget.onMessageTap!(message);
        }
        FocusScope.of(context).unfocus();
      },
      showPinButton: currentUserMember != null &&
          widget.pinPermissions.contains(currentUserMember.role),
    );

    if (widget.messageBuilder != null) {
      messageWidget = widget.messageBuilder!(
        context,
        MessageDetails(
          userId,
          message,
          messages,
          index,
        ),
        messages,
        messageWidget as MessageWidget,
      );
    }

    var child = messageWidget;
    if (!message.isDeleted &&
        !message.isSystem &&
        !message.isEphemeral &&
        widget.onMessageSwiped != null) {
      child = Container(
        decoration: const BoxDecoration(),
        clipBehavior: Clip.hardEdge,
        child: Swipeable(
          onSwipeEnd: () {
            FocusScope.of(context).unfocus();
            widget.onMessageSwiped?.call(message);
          },
          backgroundIcon: StreamSvgIcon.reply(
            color: _streamTheme.colorTheme.accentPrimary,
          ),
          child: child,
        ),
      );
    }

    if (!initialMessageHighlightComplete &&
        widget.highlightInitialMessage &&
        _isInitialMessage(message.id)) {
      final colorTheme = _streamTheme.colorTheme;
      final highlightColor =
          widget.messageHighlightColor ?? colorTheme.highlight;
      child = TweenAnimationBuilder<Color?>(
        tween: ColorTween(
          begin: highlightColor,
          end: colorTheme.barsBg.withOpacity(0),
        ),
        duration: const Duration(seconds: 3),
        onEnd: () => initialMessageHighlightComplete = true,
        builder: (_, color, child) => Container(
          color: color,
          child: child,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: child,
        ),
      );
    }
    return child;
  }

  StreamSubscription? _messageNewListener;

  @override
  void initState() {
    _scrollController = widget.scrollController ?? ItemScrollController();
    _itemPositionListener =
        widget.itemPositionListener ?? ItemPositionsListener.create();
    _itemPositionStream =
        _valueListenableToStreamAdapter(_itemPositionListener.itemPositions);

    _getOnThreadTap();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final newStreamChannel = StreamChannel.of(context);
    _streamTheme = StreamChatTheme.of(context);

    if (newStreamChannel != streamChannel) {
      streamChannel = newStreamChannel;
      _messageNewListener?.cancel();
      initialIndex = _initialIndex;
      initialAlignment = _initialAlignment;

      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        _scrollController?.jumpTo(
          index: initialIndex,
          alignment: initialAlignment,
        );
      });

      _messageNewListener =
          streamChannel!.channel.on(EventType.messageNew).listen((event) {
        if (_upToDate) {
          _bottomPaginationActive = false;
          _topPaginationActive = false;
        }
        if (event.message!.user!.id ==
            streamChannel!.channel.client.state.currentUser!.id) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            _scrollController?.jumpTo(
              index: 0,
            );
          });
        }
      });

      if (_isThreadConversation) {
        streamChannel!.getReplies(widget.parentMessage!.id);
      }
    }

    super.didChangeDependencies();
  }

  void _getOnThreadTap() {
    if (widget.onThreadTap != null) {
      _onThreadTap = (Message message) {
        widget.onThreadTap!(
            message,
            widget.threadBuilder != null
                ? widget.threadBuilder!(context, message)
                : null);
      };
    } else if (widget.threadBuilder != null) {
      _onThreadTap = (Message message) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BetterStreamBuilder<Message>(
              stream: streamChannel!.channel.state!.messagesStream.map(
                  (messages) => messages.firstWhere((m) => m.id == message.id)),
              initialData: message,
              builder: (_, data) => StreamChannel(
                channel: streamChannel!.channel,
                child: widget.threadBuilder!(context, data),
              ),
            ),
          ),
        );
      };
    }
  }

  @override
  void dispose() {
    if (!_upToDate) {
      streamChannel!.reloadChannel();
    }
    _messageNewListener?.cancel();
    super.dispose();
  }
}

class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator({
    Key? key,
    required this.streamTheme,
    required this.isThreadConversation,
    required this.direction,
    required this.streamChannel,
  }) : super(key: key);

  final StreamChatThemeData streamTheme;
  final bool isThreadConversation;
  final QueryDirection direction;
  final StreamChannelState streamChannel;

  @override
  Widget build(BuildContext context) {
    final stream = direction == QueryDirection.top
        ? streamChannel.queryTopMessages
        : streamChannel.queryBottomMessages;
    return BetterStreamBuilder<bool>(
      key: Key('LOADING-INDICATOR $direction'),
      stream: stream,
      initialData: false,
      errorBuilder: (context, error) => Container(
        color: streamTheme.colorTheme.accentError.withOpacity(.2),
        child: Center(
          child: Text(context.translations.loadingMessagesError),
        ),
      ),
      builder: (context, data) {
        if (!data) return const Offstage();
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

Stream<T> _valueListenableToStreamAdapter<T>(ValueListenable<T> listenable) {
  // ignore: close_sinks
  late StreamController<T> _controller;

  void listener() {
    _controller.add(listenable.value);
  }

  void start() {
    listenable.addListener(listener);
  }

  void end() {
    listenable.removeListener(listener);
  }

  _controller = StreamController<T>(
    onListen: start,
    onPause: end,
    onResume: start,
    onCancel: end,
  );

  return _controller.stream;
}
