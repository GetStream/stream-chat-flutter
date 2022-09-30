// ignore_for_file: lines_longer_than_80_chars
import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stream_chat_flutter/src/message_list_view/floating_date_divider.dart';
import 'package:stream_chat_flutter/src/message_list_view/loading_indicator.dart';
import 'package:stream_chat_flutter/src/message_list_view/mlv_utils.dart';
import 'package:stream_chat_flutter/src/message_list_view/thread_separator.dart';
import 'package:stream_chat_flutter/src/message_list_view/unread_messages_separator.dart';
import 'package:stream_chat_flutter/src/misc/swipeable.dart';
import 'package:stream_chat_flutter/src/utils/utils.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Spacing Types (These are properties of a message to help inform the decision
/// of how much space / which widget to build after it)
enum SpacingType {
  /// Message is a thread
  thread,

  /// There is a >1s time diff between current and last message
  timeDiff,

  /// Next message is by a different user
  otherUser,

  /// Message is deleted
  deleted,

  /// No other conditions are valid, default spacing (This will likely be the
  /// only rule in the list provided)
  defaultSpacing,
}

/// {@template streamMessageListView}
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/message_listview.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/message_listview_paint.png)
///
/// Shows the list of messages in the current channel.
///
/// ```dart
/// class ChannelPage extends StatelessWidget {
///   const ChannelPage({
///     Key? key,
///   }) : super(key: key);
///
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: StreamChannelHeader(),
///       body: Column(
///         children: <Widget>[
///           Expanded(
///             child: StreamMessageListView(
///               threadBuilder: (_, parentMessage) {
///                 return ThreadPage(
///                   parent: parentMessage,
///                 );
///               },
///             ),
///           ),
///           StreamMessageInput(),
///         ],
///       ),
///     );
///   }
/// }
/// ```
///
/// A [StreamChannel] ancestor widget is required in order to provide the
/// information about the channels.
///
/// Uses a [ListView.custom] to render the list of channels.
///
/// The UI is rendered based on the first ancestor of type [StreamChatTheme].
/// Modify it to change the widget's appearance.
/// {@endtemplate}
class StreamMessageListView extends StatefulWidget {
  /// {@macro streamMessageListView}
  const StreamMessageListView({
    super.key,
    this.showScrollToBottom = true,
    this.scrollToBottomBuilder,
    this.messageBuilder,
    this.parentMessageBuilder,
    this.parentMessage,
    this.threadBuilder,
    this.onThreadTap,
    this.dateDividerBuilder,
    this.scrollPhysics =
        const ClampingScrollPhysics(), // we need to use ClampingScrollPhysics to avoid the list view to animate and break while loading
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
    this.showFloatingDateDivider = true,
    this.threadSeparatorBuilder,
    this.unreadMessagesSeparatorBuilder,
    this.messageListController,
    this.reverse = true,
    this.paginationLimit = 20,
    this.paginationLoadingIndicatorBuilder,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.onDrag,
    this.spacingWidgetBuilder = _defaultSpacingWidgetBuilder,
  });

  /// [ScrollViewKeyboardDismissBehavior] the defines how this [PositionedList] will
  /// dismiss the keyboard automatically.
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// {@macro messageBuilder}
  final MessageBuilder? messageBuilder;

  /// Whether the view scrolls in the reading direction.
  ///
  /// Defaults to true.
  ///
  /// See [ScrollView.reverse].
  final bool reverse;

  /// Limit used during pagination
  final int paginationLimit;

  /// {@macro systemMessageBuilder}
  final SystemMessageBuilder? systemMessageBuilder;

  /// {@macro parentMessageBuilder}
  final ParentMessageBuilder? parentMessageBuilder;

  /// {@macro threadBuilder}
  final ThreadBuilder? threadBuilder;

  /// {@macro threadTapCallback}
  ///
  /// By default it calls [Navigator.push] using the widget
  /// built using [threadBuilder]
  final ThreadTapCallback? onThreadTap;

  /// If true will show a scroll to bottom message when there are new
  /// messages and the scroll offset is not zero
  final bool showScrollToBottom;

  /// Function used to build a custom scroll to bottom widget
  ///
  /// Provides the current unread messages count and a reference
  /// to the function that is executed on tap of this widget by default
  ///
  /// As an example:
  /// ```
  /// MessageListView(
  ///   scrollToBottomBuilder: (unreadCount, defaultTapAction) {
  ///     return InkWell(
  ///       onTap: () => defaultTapAction(unreadCount),
  ///       child: Text('Scroll To Bottom'),
  ///     );
  ///   },
  /// ),
  /// ```
  final Widget Function(
    int unreadCount,
    Future<void> Function(int) scrollToBottomDefaultTapAction,
  )? scrollToBottomBuilder;

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
  final ScrollPhysics? scrollPhysics;

  /// {@macro onMessageSwiped}
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
  ///
  /// This parameter can be used to display an error message to
  /// users in the event of a connection failure.
  final ErrorBuilder? errorBuilder;

  /// Predicate used to filter messages
  final bool Function(Message)? messageFilter;

  /// Called when any message is tapped except a system message
  /// (use [onSystemMessageTap] instead)
  final OnMessageTap? onMessageTap;

  /// Called when system message is tapped
  final OnMessageTap? onSystemMessageTap;

  /// Builder used to build the thread separator in case it's a thread view
  final Function(BuildContext context, Message parentMessage)?
      threadSeparatorBuilder;

  /// Builder used to build the unread message separator
  final Widget Function(BuildContext context, int unreadCount)?
      unreadMessagesSeparatorBuilder;

  /// A [MessageListController] allows pagination.
  ///
  /// Use [ChannelListController.paginateData] pagination.
  final MessageListController? messageListController;

  /// Builder used to build the loading indicator shown while paginating.
  final WidgetBuilder? paginationLoadingIndicatorBuilder;

  /// {@macro spacingWidgetBuilder}
  final SpacingWidgetBuilder spacingWidgetBuilder;

  static Widget _defaultSpacingWidgetBuilder(
    BuildContext context,
    List<SpacingType> spacingTypes,
  ) {
    if (!spacingTypes.contains(SpacingType.defaultSpacing)) {
      return const SizedBox(height: 8);
    }
    return const SizedBox(height: 2);
  }

  @override
  _StreamMessageListViewState createState() => _StreamMessageListViewState();
}

class _StreamMessageListViewState extends State<StreamMessageListView> {
  ItemScrollController? _scrollController;
  void Function(Message)? _onThreadTap;
  final ValueNotifier<bool> _showScrollToBottom = ValueNotifier(false);
  late final ItemPositionsListener _itemPositionListener;
  int? _messageListLength;
  StreamChannelState? streamChannel;
  late StreamChatThemeData _streamTheme;
  late List<String> _userPermissions;
  late int unreadCount;

  double get _initialAlignment {
    final initialAlignment = widget.initialAlignment;
    if (initialAlignment != null) return initialAlignment;
    return initialIndex == 0 ? 0 : 0.1;
  }

  bool get _upToDate => streamChannel!.channel.state!.isUpToDate;

  bool get _isThreadConversation => widget.parentMessage != null;

  bool _bottomPaginationActive = false;

  int initialIndex = 0;
  double initialAlignment = 0;

  List<Message> messages = <Message>[];

  Map<String, int> messagesIndex = {};

  bool initialMessageHighlightComplete = false;

  bool _inBetweenList = false;

  late final _defaultController = MessageListController();

  MessageListController get _messageListController =>
      widget.messageListController ?? _defaultController;

  StreamSubscription? _messageNewListener;

  Read? _userRead;
  Message? _oldestUnreadMessage;

  @override
  void initState() {
    super.initState();

    _scrollController = widget.scrollController ?? ItemScrollController();
    _itemPositionListener =
        widget.itemPositionListener ?? ItemPositionsListener.create();
    _itemPositionListener.itemPositions
        .addListener(_handleItemPositionsChanged);

    _getOnThreadTap();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newStreamChannel = StreamChannel.of(context);
    _streamTheme = StreamChatTheme.of(context);
    _userPermissions = newStreamChannel.channel.ownCapabilities;

    if (newStreamChannel != streamChannel) {
      streamChannel = newStreamChannel;

      _userRead = streamChannel?.channel.state!.read.firstWhereOrNull(
        (it) =>
            it.user.id == streamChannel?.channel.client.state.currentUser?.id,
      );
      _messageNewListener?.cancel();
      unreadCount = streamChannel?.channel.state?.unreadCount ?? 0;
      initialIndex = getInitialIndex(
        widget.initialScrollIndex,
        streamChannel!,
        widget.messageFilter,
        _userRead,
      );

      initialAlignment = _initialAlignment;

      if (_scrollController?.isAttached == true) {
        _scrollController?.jumpTo(
          index: initialIndex,
          alignment: initialAlignment,
        );
      }

      _messageNewListener =
          streamChannel!.channel.on(EventType.messageNew).listen((event) {
        if (_upToDate) {
          _bottomPaginationActive = false;
        }
        if (event.message?.parentId == widget.parentMessage?.id &&
            event.message!.user!.id ==
                streamChannel!.channel.client.state.currentUser!.id) {
          setState(() => unreadCount = 0);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollController?.jumpTo(
              index: 0,
            );
          });
        }
      });

      if (_isThreadConversation) {
        streamChannel!.getReplies(widget.parentMessage!.id);
      }

      unreadCount = streamChannel?.channel.state?.unreadCount ?? 0;
    }
  }

  @override
  void dispose() {
    if (!_upToDate) {
      streamChannel!.reloadChannel();
    }
    _messageNewListener?.cancel();
    _itemPositionListener.itemPositions
        .removeListener(_handleItemPositionsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Portal(
      labels: const [kPortalMessageListViewLabel],
      child: MessageListCore(
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
                          .withOpacity(0.5),
                    ),
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
                          .withOpacity(0.5),
                    ),
                  ),
                ),
      ),
    );
  }

  Widget _buildListView(List<Message> data) {
    messages = data;

    if (_userRead != null &&
        messages.isNotEmpty &&
        messages.first.createdAt.isAfter(_userRead!.lastRead) &&
        messages.last.createdAt.isBefore(_userRead!.lastRead)) {
      _oldestUnreadMessage = messages.lastWhereOrNull(
        (it) =>
            it.user?.id !=
                streamChannel?.channel.client.state.currentUser?.id &&
            it.createdAt.compareTo(_userRead!.lastRead) > 0,
      );
    }

    for (var index = 0; index < messages.length; index++) {
      messagesIndex[messages[index].id] = index;
    }
    final newMessagesListLength = messages.length;

    if (_messageListLength != null) {
      if (_bottomPaginationActive || (_inBetweenList && _upToDate)) {
        if (_itemPositionListener.itemPositions.value.isNotEmpty) {
          final first = _itemPositionListener.itemPositions.value.first;
          final diff = newMessagesListLength - _messageListLength!;
          if (diff > 0) {
            if (messages[0].user?.id !=
                streamChannel!.channel.client.state.currentUser?.id) {
              initialIndex = first.index + diff;
              initialAlignment = first.itemLeadingEdge;
            }
          }
        }
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
        StreamConnectionStatusBuilder(
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

            return StreamInfoTile(
              showMessage: widget.showConnectionStateTile && showStatus,
              tileAnchor: Alignment.topCenter,
              childAnchor: Alignment.topCenter,
              message: statusString,
              child: LazyLoadScrollView(
                onStartOfPage: () async {
                  _inBetweenList = false;
                  if (!_upToDate) {
                    _bottomPaginationActive = true;
                    return _paginateData(
                      streamChannel,
                      QueryDirection.bottom,
                    );
                  }
                },
                onEndOfPage: () async {
                  _inBetweenList = false;
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
                  key: (initialIndex != 0 && initialAlignment != 0)
                      ? ValueKey('$initialIndex-$initialAlignment')
                      : null,
                  keyboardDismissBehavior: widget.keyboardDismissBehavior,
                  itemPositionsListener: _itemPositionListener,
                  initialScrollIndex: initialIndex,
                  initialAlignment: initialAlignment,
                  physics: widget.scrollPhysics,
                  itemScrollController: _scrollController,
                  reverse: widget.reverse,
                  itemCount: itemCount,
                  findChildIndexCallback: (Key key) {
                    final indexedKey = key as IndexedKey;
                    final valueKey = indexedKey.key as ValueKey<String>?;
                    if (valueKey != null) {
                      final index = messagesIndex[valueKey.value];
                      if (index != null) {
                        return ((index + 2) * 2) - 1;
                      }
                    }
                    return null;
                  },

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

                      if (widget.threadSeparatorBuilder != null) {
                        return widget.threadSeparatorBuilder!
                            .call(context, widget.parentMessage!);
                      }

                      return ThreadSeparator(
                        parentMessage: widget.parentMessage,
                      );
                    }
                    if (i == itemCount - 3) {
                      if (widget.reverse
                          ? widget.headerBuilder == null
                          : widget.footerBuilder == null) {
                        if (messages.isNotEmpty) {
                          return _buildDateDivider(messages.last);
                        }
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

                    Widget separator;

                    final isThread = message.replyCount! > 0;

                    if (!Jiffy(message.createdAt.toLocal()).isSame(
                      nextMessage.createdAt.toLocal(),
                      Units.DAY,
                    )) {
                      separator = _buildDateDivider(nextMessage);
                    } else {
                      final timeDiff =
                          Jiffy(nextMessage.createdAt.toLocal()).diff(
                        message.createdAt.toLocal(),
                        Units.MINUTE,
                      );

                      final isNextUserSame =
                          message.user!.id == nextMessage.user?.id;
                      final isDeleted = message.isDeleted;
                      final hasTimeDiff = timeDiff >= 1;

                      final spacingRules = [
                        if (hasTimeDiff) SpacingType.timeDiff,
                        if (!isNextUserSame) SpacingType.otherUser,
                        if (isThread) SpacingType.thread,
                        if (isDeleted) SpacingType.deleted,
                      ];

                      if (spacingRules.isEmpty) {
                        spacingRules.add(SpacingType.defaultSpacing);
                      }

                      separator = widget.spacingWidgetBuilder.call(
                        context,
                        spacingRules,
                      );
                    }

                    if (!isThread &&
                        unreadCount > 0 &&
                        _oldestUnreadMessage?.id == nextMessage.id) {
                      final unreadMessagesSeparator =
                          _buildUnreadMessagesSeparator(unreadCount);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          separator,
                          unreadMessagesSeparator,
                        ],
                      );
                    }
                    return separator;
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

                    final indicatorBuilder =
                        widget.paginationLoadingIndicatorBuilder;

                    if (i == itemCount - 3) {
                      return LoadingIndicator(
                        direction: QueryDirection.top,
                        streamTheme: _streamTheme,
                        streamChannelState: streamChannel!,
                        isThreadConversation: _isThreadConversation,
                        indicatorBuilder: indicatorBuilder,
                      );
                    }

                    if (i == 1) {
                      return LoadingIndicator(
                        direction: QueryDirection.bottom,
                        streamTheme: _streamTheme,
                        streamChannelState: streamChannel!,
                        isThreadConversation: _isThreadConversation,
                        indicatorBuilder: indicatorBuilder,
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
                    return KeyedSubtree(
                      key: ValueKey(message.id),
                      child: messageWidget,
                    );
                  },
                ),
              ),
            );
          },
        ),
        if (widget.showScrollToBottom)
          BetterStreamBuilder<bool>(
            stream: streamChannel!.channel.state!.isUpToDateStream,
            initialData: streamChannel!.channel.state!.isUpToDate,
            builder: (context, snapshot) => ValueListenableBuilder<bool>(
              valueListenable: _showScrollToBottom,
              child: _buildScrollToBottom(),
              builder: (context, value, child) {
                if (!snapshot || value) {
                  return child!;
                }
                return const Offstage();
              },
            ),
          ),
        if (widget.showFloatingDateDivider)
          FloatingDateDivider(
            itemCount: itemCount,
            reverse: widget.reverse,
            itemPositionListener: _itemPositionListener,
            messages: messages,
            dateDividerBuilder: widget.dateDividerBuilder,
            isThreadConversation: _isThreadConversation,
          ),
      ],
    );

    final backgroundColor =
        StreamMessageListViewTheme.of(context).backgroundColor;
    final backgroundImage =
        StreamMessageListViewTheme.of(context).backgroundImage;

    if (backgroundColor != null || backgroundImage != null) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          image: backgroundImage,
        ),
        child: child,
      );
    }

    return child;
  }

  Widget _buildUnreadMessagesSeparator(int unreadCount) {
    final unreadMessagesSeparator =
        widget.unreadMessagesSeparatorBuilder?.call(context, unreadCount) ??
            UnreadMessagesSeparator(unreadCount: unreadCount);
    return unreadMessagesSeparator;
  }

  Future<void> _paginateData(
    StreamChannelState? channel,
    QueryDirection direction,
  ) =>
      _messageListController.paginateData!(direction: direction);

  Future<void> scrollToBottomDefaultTapAction(int unreadCount) async {
    this.unreadCount = unreadCount;
    if (unreadCount > 0) {
      streamChannel!.channel.markRead();
    }

    final index = unreadCount > 0 ? unreadCount + 1 : 0;

    if (!_upToDate) {
      _bottomPaginationActive = false;
      initialAlignment = 0;
      initialIndex = 0;
      await streamChannel!.reloadChannel();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController!.jumpTo(index: index);
      });
    } else {
      _scrollController!.scrollTo(
        index: index,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  Widget _buildDateDivider(Message message) {
    final divider = widget.dateDividerBuilder != null
        ? widget.dateDividerBuilder!(
            message.createdAt.toLocal(),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: StreamDateDivider(
              dateTime: message.createdAt.toLocal(),
            ),
          );
    return divider;
  }

  Widget _buildBottomMessage(
    BuildContext context,
    Message message,
    List<Message> messages,
    StreamChannelState streamChannel,
    int index,
  ) {
    final messageWidget = buildMessage(message, messages, index);
    return messageWidget;
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

    final defaultMessageWidget = StreamMessageWidget(
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
      onMessageTap: (message) {
        widget.onMessageTap?.call(message);
        FocusScope.of(context).unfocus();
      },
      showPinButton: currentUserMember != null &&
          _userPermissions.contains(PermissionType.pinMessage),
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

  Widget _buildScrollToBottom() {
    return StreamBuilder<int>(
      stream: streamChannel!.channel.state!.unreadCountStream,
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          return const Offstage();
        } else if (!snapshot.hasData) {
          return const Offstage();
        }
        final unreadCount = snapshot.data!;
        if (widget.scrollToBottomBuilder != null) {
          return widget.scrollToBottomBuilder!(
            unreadCount,
            scrollToBottomDefaultTapAction,
          );
        }
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
                onPressed: () async {
                  if (unreadCount > 0) {
                    streamChannel!.channel.markRead();
                  }
                  if (!_upToDate) {
                    _bottomPaginationActive = false;
                    initialAlignment = 0;
                    initialIndex = 0;
                    await streamChannel!.reloadChannel();

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollController!.jumpTo(index: 0);
                    });
                  } else {
                    _showScrollToBottom.value = false;
                    _scrollController!.jumpTo(
                      index: 0,
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
                  left: 0,
                  right: 0,
                  top: -10,
                  child: Center(
                    child: Material(
                      borderRadius: BorderRadius.circular(8),
                      color:
                          StreamChatTheme.of(context).colorTheme.accentPrimary,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 5,
                          right: 5,
                          top: 2,
                          bottom: 2,
                        ),
                        child: Text(
                          '${unreadCount > 99 ? '99+' : unreadCount}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white,
                          ),
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

  Widget buildMessage(Message message, List<Message> messages, int index) {
    if ((message.type == 'system' || message.type == 'error') &&
        message.text?.isNotEmpty == true) {
      return widget.systemMessageBuilder?.call(context, message) ??
          StreamSystemMessage(
            message: message,
            onMessageTap: (message) {
              widget.onSystemMessageTap?.call(message);
              FocusScope.of(context).unfocus();
            },
          );
    }

    final userId = StreamChat.of(context).currentUser!.id;
    final isMyMessage = message.user?.id == userId;
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

    final hasFileAttachment =
        message.attachments.any((it) => it.type == 'file');

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
        message.attachments.any((it) => it.ogScrapeUrl != null);

    final borderSide =
        isOnlyEmoji || hasUrlAttachment || (isMyMessage && !hasFileAttachment)
            ? BorderSide.none
            : null;

    final currentUser = StreamChat.of(context).currentUser;
    final members = StreamChannel.of(context).channel.state?.members ?? [];
    final currentUserMember =
        members.firstWhereOrNull((e) => e.user!.id == currentUser!.id);

    Widget messageWidget = StreamMessageWidget(
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
        if (messages.map((e) => e.id).contains(quotedMessageId)) {
          final index = messages.indexWhere((m) => m.id == quotedMessageId);
          _scrollController?.scrollTo(
            index: index + 2, // +2 to account for loader and footer
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            alignment: 0.1,
          );
        } else {
          await streamChannel!
              .loadChannelAtMessage(quotedMessageId)
              .then((_) async {
            initialIndex = 21; // 19 + 2 | 19 is the index of the message
            initialAlignment = 0.1;
          });
        }
      },
      showEditMessage: isMyMessage,
      showDeleteMessage: isMyMessage,
      showThreadReplyMessage: !isThreadMessage &&
          streamChannel?.channel.ownCapabilities
                  .contains(PermissionType.sendReply) ==
              true,
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
      onMessageTap: (message) {
        widget.onMessageTap?.call(message);
        FocusScope.of(context).unfocus();
      },
      showPinButton: currentUserMember != null &&
          _userPermissions.contains(PermissionType.pinMessage),
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
        messageWidget as StreamMessageWidget,
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
        isInitialMessage(message.id, streamChannel)) {
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
        builder: (_, color, child) => ColoredBox(
          color: color!,
          child: child,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: child,
        ),
      );
    }
    return child;
  }

  void _handleItemPositionsChanged() {
    final _itemPositions = _itemPositionListener.itemPositions.value.toList();
    final _firstItemIndex =
        _itemPositions.indexWhere((element) => element.index == 1);
    var _isFirstItemVisible = false;
    if (_firstItemIndex != -1) {
      final _firstItem = _itemPositions[_firstItemIndex];
      _isFirstItemVisible =
          _firstItem.itemLeadingEdge > 0 && _firstItem.itemTrailingEdge < 1;
    }
    if (_isFirstItemVisible) {
      // most recent message is visible
      final channel = streamChannel?.channel;
      if (channel != null) {
        if (_upToDate &&
            channel.config?.readEvents == true &&
            channel.state!.unreadCount > 0) {
          streamChannel!.channel.markRead();
        }
      }
    }
    if (mounted) {
      if (_showScrollToBottom.value == _isFirstItemVisible) {
        _showScrollToBottom.value = !_isFirstItemVisible;
      }
    }
  }

  void _getOnThreadTap() {
    if (widget.onThreadTap != null) {
      _onThreadTap = (Message message) {
        final threadBuilder = widget.threadBuilder;
        widget.onThreadTap!(
          message,
          threadBuilder != null ? threadBuilder(context, message) : null,
        );
      };
    } else if (widget.threadBuilder != null) {
      _onThreadTap = (Message message) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BetterStreamBuilder<Message>(
              stream: streamChannel!.channel.state!.messagesStream.map(
                (messages) => messages.firstWhere((m) => m.id == message.id),
              ),
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
}
